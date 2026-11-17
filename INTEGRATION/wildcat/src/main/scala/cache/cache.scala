package cache
import chisel3._
import chisel3.util._
import chisel3.util.random.LFSR

class SetAssociativeCache(cfg: CacheConfig) extends Module {
  import CacheState._

  val io = IO(new CacheIO(cfg))

  // ---------------------------------------------------------------- storage
  val validBits = RegInit(VecInit(Seq.fill(cfg.numSets)(VecInit(Seq.fill(cfg.numWays)(false.B)))))
  val dirtyBits = RegInit(VecInit(Seq.fill(cfg.numSets)(VecInit(Seq.fill(cfg.numWays)(false.B)))))
  val tagMem = Seq.fill(cfg.numWays)(SyncReadMem(cfg.numSets, UInt(cfg.tagBits.W)))
  val dataMem = Seq.fill(cfg.numWays)(SyncReadMem(cfg.numSets, UInt(cfg.lineBits.W)))
  val nextVictim = if (cfg.numWays > 1 && cfg.replacementPolicy == RoundRobin)
    Some(RegInit(VecInit(Seq.fill(cfg.numSets)(0.U(cfg.wayBits.W))))) else None
  val victimWay = Reg(UInt(cfg.wayBits.W))

  // ---------------------------------------------------------------- state
  val state = RegInit(sIdle)
  val addrReg = Reg(UInt(cfg.addrWidth.W)) // latched request address
  val respData = Reg(UInt(cfg.wordBits.W)) // word returned in RESPOND
  val refillBuf = Reg(Vec(cfg.beatsPerLine, UInt(cfg.beatBits.W)))
  val beatCntWidth = math.max(1, log2Ceil(cfg.beatsPerLine))
  val beatCnt = RegInit(0.U(beatCntWidth.W))

  val writeReg = Reg(Bool())
  val wdataReg = Reg(UInt(cfg.wordBits.W))
  val wmaskReg = Reg(UInt(cfg.wordBytes.W))

  val evictAddr_wb = Reg(UInt(cfg.addrWidth.W)) // evicted address line (whole 4x32 block address).
  val evictLine_wb = Reg(UInt(cfg.lineBits.W)) // the evicted data in bits (whole 4x32 block data).

  val reqIdx = cfg.indexOf(addrReg)
  val reqTag = cfg.tagOf(addrReg)
  val reqWord = cfg.wordIdxOf(addrReg)

  // ---------------------------------------------------------------- tag/data lookup on accept
  // a.k.a. start any cache request from CPU in idle state.
  io.cpu.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.cpu.req.bits.addr)
  val tagsRd = VecInit(tagMem.map(_.read(readIdx, io.cpu.req.fire)))
  val linesRd = VecInit(dataMem.map(_.read(readIdx, io.cpu.req.fire)))
  val setValid = if (cfg.numSets == 1) validBits(0) else validBits(reqIdx)
  val setDirty = if (cfg.numSets == 1) dirtyBits(0) else dirtyBits(reqIdx)
  def wayBit(bits: Vec[Bool], way: UInt): Bool =
    if (cfg.numWays == 1) bits(0) else bits(way)

  val hits = VecInit((0 until cfg.numWays).map(w => setValid(w) && tagsRd(w) === reqTag))
  val hit = hits.asUInt.orR
  val hitWay = if (cfg.numWays == 1) 0.U else PriorityEncoder(hits)
  val invalid = VecInit(setValid.map(v => !v))
  val invalidWay = if (cfg.numWays == 1) 0.U else PriorityEncoder(invalid)
  val replacement = if (cfg.numWays == 1) 0.U else cfg.replacementPolicy match {
    case RoundRobin =>
      val next = nextVictim.get
      if (cfg.numSets == 1) next(0) else next(reqIdx)
    case RandomReplacement =>
      // Advance once per actual eviction, independent of memory/CPU stalls.
      val evict = state === sCompare && !hit && !invalid.asUInt.orR && (!writeReg || cfg.isWb.B)
      LFSR(math.max(16, cfg.wayBits + 1), increment = evict, seed = Some(BigInt(1)))(cfg.wayBits - 1, 0)
  }
  val selectedVictim = Mux(invalid.asUInt.orR, invalidWay, replacement)
  val lookupWay = Mux(hit, hitWay, selectedVictim)
  val tagRd = if (cfg.numWays == 1) tagsRd(0) else tagsRd(lookupWay)
  val lineRd = if (cfg.numWays == 1) linesRd(0) else linesRd(lookupWay)

  // Store hits and refills share one physical write port in each way.
  val dataWriteEnable = WireDefault(false.B)
  val dataWriteLine = WireDefault(0.U(cfg.lineBits.W))
  val dataWriteWay = WireDefault(victimWay)
  for (w <- 0 until cfg.numWays) {
    when(dataWriteEnable && dataWriteWay === w.U) {
      dataMem(w).write(reqIdx, dataWriteLine)
    }
  }

  // ---------------------------------------------------------------- defaults
  io.cpu.resp.valid := false.B
  io.cpu.resp.bits.data := respData

  // a.k.a cache automatically fetches BLOCK (steps of 32 bits (beat)) data provided address from MM into cache line.
  // used on cache misses.
  io.mm.req_refill.valid := false.B
  io.mm.req_refill.bits.addr := cfg.lineBaseOf(addrReg)
  io.mm.data_refill.ready := false.B

  // a.k.a. by default cache does not write anything to MM yet.
  // used for WT and WB dirties.
  io.mm.req_write.valid := false.B
  io.mm.req_write.bits.data := 0.U
  io.mm.req_write.bits.addr := 0.U
  io.mm.req_write.bits.mask := 0.U

  // a.k.a. by default cache does not log any hits or misses or uses any of the WB/WT policies (evictions).
  io.stat.hit := false.B
  io.stat.miss := false.B
  io.stat.writeback_wb := false.B
  io.stat.write_wt := false.B
  
  // ---------------------------------------------------------------- helpers
  // Divides wordsPerLine (block of 4x 32 bit words) into word chunks.
  // vec(0) = first 32, vec(1) = second 32, vec(2) = third 32, vec(3) = fourth 32.
  def toWords(line: UInt): Vec[UInt] = line.asTypeOf(Vec(cfg.wordsPerLine, UInt(cfg.wordBits.W)))

  // if only 32 bit (vec(0)) is available in the data cache block, just provide first 32 (a.k.a. vec(0)),
  // else give word indexed word vec(wordIdx).
  def selectWord(line: UInt, wordIdx: UInt): UInt =
    if (cfg.wordsPerLine == 1) toWords(line)(0) else toWords(line)(wordIdx)

  // Scala loop that runs at compile time, for i = 0, 1, 2, 3.
  // Vecinit makes a HW vector of 4x8 bytes (1x 32 word).
  // EX: old data in mem: 0xAAAA_BBBB, incoming data: 0x1111_2222
  // mask binary 4'0011 (updates lower 2 bytes, keep upper 2 bytes).
  def mergeWord(old: UInt, data: UInt, mask: UInt): UInt = {
    val bytes = VecInit((0 until cfg.wordBytes).map { i =>
      Mux(mask(i), data(8 * i + 7, 8 * i), old(8 * i + 7, 8 * i))
    })
    bytes.asUInt // flatten 4x bytes of 1 32x word back to 32bit stream.
  }

  // old - index - new - mask
  def replaceWord(line: UInt, wordIdx: UInt, data: UInt, mask: UInt): UInt = {
    val src = toWords(line) // helper to not read and write to variable at the same time.
    val words = WireInit(src)
    // if only 1x32 on cache line, replace vec(0) only with new data byte (mask) -wise.
    if (cfg.wordsPerLine == 1) {
      words(0) := mergeWord(src(0), data, mask)
    }
    // else replace wordIdx (old) with data (new) byte (mask) -wise.
    else {
      words(wordIdx) := mergeWord(src(wordIdx), data, mask)
    }
    words.asUInt
  }

  // 128 bits (4x 32 bits) cache line is evicted.
  // evictLine_wb.asTypeOf gets vec(0) = first 32, ... , vec(3) = fourth 32.
  val evictBeats_wb = evictLine_wb.asTypeOf(Vec(cfg.beatsPerLine, UInt(cfg.beatBits.W)))

  // shifts binary val 1 to the left by #memBeatBytes (=4).
  // Recall -1 flips all zeros into 1s s.t. we get only get ones for #memBeatBytes (1111).
  // basically 16 + (1 in 2C) = 1111. This will ALWAYS happen since it is parameterized now.
  val fullMask = ((BigInt(1) << cfg.memBeatBytes) - 1).U(cfg.memBeatBytes.W)
  val lastBeat = beatCnt === (cfg.beatsPerLine - 1).U

  // ---------------------------------------------------------------- FSM
  switch(state) {
    is(sIdle) {
      // if cpu is valid AND ready on the request to cache.
      when(io.cpu.req.fire) {
        addrReg := io.cpu.req.bits.addr
        writeReg := io.cpu.req.bits.write
        wdataReg := io.cpu.req.bits.wdata
        wmaskReg := io.cpu.req.bits.wmask
        // write back starts writing back at beat 0.
        beatCnt := 0.U
        state := sCompare
      }
    }

    is(sCompare) {
      // hit iff tags match and valid req.
      io.stat.hit := hit
      io.stat.miss := !hit

      // write hit.
      when(hit) {
        // Return hits immediately; latch the same response if the CPU stalls.
        when(!writeReg || cfg.isWb.B) {
          val hitData = Mux(writeReg, 0.U, selectWord(lineRd, reqWord))
          io.cpu.resp.valid := true.B
          io.cpu.resp.bits.data := hitData
          respData := hitData
          state := Mux(io.cpu.resp.ready, sIdle, sRespond)
        }
        when(writeReg) {
          // write hit: update the line in place (both policies).
          // first enable write.
          dataWriteEnable := true.B
          dataWriteWay := hitWay
          // then replace old cache line with new data.
          dataWriteLine := replaceWord(lineRd, reqWord, wdataReg, wmaskReg)
          if (cfg.isWb) {
            // after replace old cache line with new data, cache line becomes dirty.
            wayBit(setDirty, hitWay) := true.B
          }
          // if WT.
          else {
            state := sWriteThrough_wt
          }
        }
        // IF MISS:
      }.otherwise {
        victimWay := selectedVictim
        if (cfg.isWt) {
          when(writeReg) {
            // write miss in WT just goes to MM.
            state := sWriteThrough_wt
          }.otherwise {
            // read miss in WT refills cache line from MM.
            state := sRefillReq
          }
          // if WB:
        } else {
          // write back: a dirt victim must be written to MM before the refill.
          // if miss write 
          when(wayBit(setValid, selectedVictim) && wayBit(setDirty, selectedVictim)) {
            // evict victim cache line to MM.
            evictAddr_wb := (if (cfg.indexBits == 0) Cat(tagRd, 0.U(cfg.offsetBits.W))
              else Cat(tagRd, reqIdx, 0.U(cfg.offsetBits.W)))
            evictLine_wb := lineRd
            state := sWriteback_wb
          }.otherwise {
            // if not dirty, just evict and refill without writeback stage.
            state := sRefillReq
          }
        }
      }
    }
    // write cache line to MM when line is dirty-evicted (RECALL: non-dirty-lines dont have to be written back!!!).
    is(sWriteback_wb) {
      if (cfg.isWb) {
        // recreate MM line.
        io.mm.req_write.valid := true.B
        io.mm.req_write.bits.addr := evictAddr_wb + (beatCnt << log2Ceil(cfg.memBeatBytes))
        io.mm.req_write.bits.data := (if (cfg.beatsPerLine == 1) evictBeats_wb(0) else evictBeats_wb(beatCnt))
        io.mm.req_write.bits.mask := fullMask // send whole cache line.
        // if ready and valid:
        when(io.mm.req_write.fire) {
          // when we are at the last beat that is being send (final beat cleanup):
          when(lastBeat) {
            // write last beat too.
            io.stat.writeback_wb := true.B
            // but dont forget to make cache line clean again (state(MM) = state(CACHE).
            wayBit(setDirty, victimWay) := false.B
            beatCnt := 0.U // reset beatCnt (a.k.a. we are done sending).
            state := sRefillReq
          }.otherwise {
            beatCnt := beatCnt + 1.U // otherwise keep sending until final beat cleanup.
          }
        }
      }
    }

    is(sRefillReq) {
      io.mm.req_refill.valid := true.B // fetch new line from MM to cache line.
      // if MM is ready and valid:
      when(io.mm.req_refill.fire) {
        beatCnt := 0.U
        state := sRefillWait
      }
    }


    is(sRefillWait) {
      io.mm.data_refill.ready := true.B // JUST WAIT TILL MM IS DONE!
      // if data from MM is ready and valid:
      when(io.mm.data_refill.fire) {
        // 
        if (cfg.beatsPerLine == 1) {
          refillBuf(0) := io.mm.data_refill.bits.data
        } else {
          refillBuf(beatCnt) := io.mm.data_refill.bits.data
        }
        beatCnt := beatCnt + 1.U

        when(lastBeat) {
          val beats = WireInit(refillBuf)
          if (cfg.beatsPerLine == 1) {
            beats(0) := io.mm.data_refill.bits.data
          } else {
            beats(beatCnt) := io.mm.data_refill.bits.data
          }

          // new data from MM.
          val newLine = beats.asUInt

          // if writeReg == True: (write operation) the newLine is just fetched from MM and replaces whatever was there before
          // with wordidx and byte masking.
          // if writeReg == False (read operation) the newLine is just fetched from MM and put in cache line.
          val installedLine = Mux(writeReg, replaceWord(newLine, reqWord, wdataReg, wmaskReg), newLine)

          // enabel write to install the new line.
          dataWriteEnable := true.B
          // install new line in cache line.
          dataWriteLine := installedLine
          // install new tag.
          for (w <- 0 until cfg.numWays) {
            when(victimWay === w.U) { tagMem(w).write(reqIdx, reqTag) }
          }
          nextVictim.foreach { next =>
            val replacement = if (cfg.numSets == 1) next(0) else next(reqIdx)
            replacement := Mux(victimWay === (cfg.numWays - 1).U, 0.U, victimWay + 1.U)
          }
          // reset valid to 1 for the new line.
          wayBit(setValid, victimWay) := true.B
          if (cfg.isWb) {
            // if we wrote to the cache line with new line, then the line becomes dirty.
            // because replaceWord modified the line in the cache with a line from MM.
            wayBit(setDirty, victimWay) := writeReg
          }

          respData := selectWord(newLine, reqWord)
          state := sRespond
        }
      }
    }

    is(sWriteThrough_wt) {
      if (cfg.isWt) {
        io.mm.req_write.valid := true.B
        io.mm.req_write.bits.addr := cfg.wordBaseOf(addrReg)
        io.mm.req_write.bits.data := wdataReg
        io.mm.req_write.bits.mask := wmaskReg
        when(io.mm.req_write.fire) {
          io.stat.write_wt := true.B
          state := sRespond
        }
      }
    }

    is(sRespond) {
      io.cpu.resp.valid := true.B
      when(io.cpu.resp.ready) {
        state := sIdle
      }
    }
  }
}

class DirectMappedReadCache(cfg: CacheConfig) extends SetAssociativeCache(cfg) {
  require(cfg.numWays == 1, "DirectMappedReadCache requires numWays == 1; use SetAssociativeCache")
}

object GenerateCache extends App {
  val cfg = CacheConfig(
    capacityBytes = 1024,
    addrWidth = 32,
    lineBytes = 4,
    wordBytes = 4,
    memBeatBytes = 4,
    writePolicy = WriteBack,
    numWays = if (args.nonEmpty) args(0).toInt else 1,
    replacementPolicy = if (args.length > 2) ReplacementPolicy.parse(args(2)) else RoundRobin
  )
  emitVerilog(if (cfg.numWays == 1) new DirectMappedReadCache(cfg) else new SetAssociativeCache(cfg),
    Array("--target-dir", if (args.length > 1) args(1) else "generated"))
}
