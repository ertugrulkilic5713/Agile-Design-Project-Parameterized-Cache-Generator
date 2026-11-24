package cache

import chisel3._
import chisel3.util._
import chisel3.util.random.LFSR

/** Blocking, set-associative cache with selectable write-back or write-through policy.
  * Write-back stores allocate on a miss. Write-through stores do not.
  */
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
  private val plru = if (cfg.numWays > 1 && cfg.replacementPolicy == TreePLRU)
    Some(new TreePLRULogic(cfg.numWays)) else None
  val plruState = plru.map(tree => RegInit(VecInit(Seq.fill(cfg.numSets)(0.U(tree.stateBits.W)))))
  val victimWay = Reg(UInt(cfg.wayBits.W))

  // ---------------------------------------------------------------- state
  val state = RegInit(sIdle)
  val addrReg = Reg(UInt(cfg.addrWidth.W)) // latched request address
  val isWriteReg = Reg(Bool())
  val writeDataReg = Reg(UInt(cfg.wordBits.W))
  val writeMaskReg = Reg(UInt(cfg.wordBytes.W))
  val respData = Reg(UInt(cfg.wordBits.W)) // word returned in RESPOND
  val evictAddr = Reg(UInt(cfg.addrWidth.W))
  val evictLine = Reg(UInt(cfg.lineBits.W))
  val refillBuf = Reg(Vec(cfg.beatsPerLine, UInt(cfg.beatBits.W)))
  val beatCntWidth = math.max(1, log2Ceil(cfg.beatsPerLine))
  val beatCnt = RegInit(0.U(beatCntWidth.W))

  val reqIdx = cfg.indexOf(addrReg)
  val reqTag = cfg.tagOf(addrReg)
  val reqWord = cfg.wordIdxOf(addrReg)

  def touchPlru(way: UInt): Unit = plru.foreach { tree =>
    val sets = plruState.get
    val bits = if (cfg.numSets == 1) sets(0) else sets(reqIdx)
    bits := tree.touch(bits, way)
  }

  // ---------------------------------------------------------------- defaults
  io.req.ready := false.B
  io.resp.valid := false.B
  io.resp.bits.data := respData
  io.memReq.valid := false.B
  io.memReq.bits.addr := cfg.lineBaseOf(addrReg)
  io.memResp.ready := false.B

  io.memWriteReq.valid := false.B
  io.memWriteReq.bits.addr := evictAddr
  io.memWriteData.valid := false.B
  val evictBeats = evictLine.asTypeOf(Vec(cfg.beatsPerLine, UInt(cfg.beatBits.W)))
  io.memWriteData.bits.data := (if (cfg.beatsPerLine == 1) evictBeats(0) else evictBeats(beatCnt))
  io.memWriteData.bits.mask := Fill(cfg.memBeatBytes, 1.U(1.W))
  io.memWriteResp.ready := false.B

  io.stat.hit := false.B
  io.stat.miss := false.B
  io.stat.writeback := false.B
  io.stat.writeThrough := false.B
  io.stat.state := state.asUInt

  // init for cache visualizer
  io.stat.way := 0.U
  io.stat.evict := false.B
  io.stat.evictDirty := false.B
  io.stat.evictAddr := 0.U

  io.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.req.bits.addr)
  val tagsRd = VecInit(tagMem.map(_.read(readIdx, io.req.fire)))
  val linesRd = VecInit(dataMem.map(_.read(readIdx, io.req.fire)))
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
    case TreePLRU =>
      val sets = plruState.get
      plru.get.victim(if (cfg.numSets == 1) sets(0) else sets(reqIdx))
    case RandomReplacement =>
      val evict = state === sCompare && !hit && !invalid.asUInt.orR &&
        (!isWriteReg || cfg.isWriteBack.B)
      LFSR(cfg.randomBits, increment = evict, seed = Some(cfg.lfsrSeed))(cfg.wayBits - 1, 0)
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

  def selectWord(line: UInt, wordIdx: UInt): UInt =
    line.asTypeOf(Vec(cfg.wordsPerLine, UInt(cfg.wordBits.W)))(wordIdx)

  def mergeWord(old: UInt, data: UInt, mask: UInt): UInt =
    VecInit((0 until cfg.wordBytes).map { i =>
      Mux(mask(i), data(8 * i + 7, 8 * i), old(8 * i + 7, 8 * i))
    }).asUInt

  def replaceWord(line: UInt, wordIdx: UInt, data: UInt, mask: UInt): UInt = {
    val source = line.asTypeOf(Vec(cfg.wordsPerLine, UInt(cfg.wordBits.W)))
    val words = WireInit(source)
    if (cfg.wordsPerLine == 1) words(0) := mergeWord(source(0), data, mask)
    else words(wordIdx) := mergeWord(source(wordIdx), data, mask)
    words.asUInt
  }

  // ---------------------------------------------------------------- FSM
  switch(state) {
    is(sIdle) {
      when(io.req.fire) {
        addrReg := io.req.bits.addr
        isWriteReg := io.req.bits.isWrite
        writeDataReg := io.req.bits.writeData
        writeMaskReg := io.req.bits.writeMask
        state := sCompare
      }
    }

    is(sCompare) {
      io.stat.hit := hit
      io.stat.miss := !hit

      // for cache visualizer
      io.stat.way := Mux(hit, hitWay, selectedVictim)

      io.stat.evict := !hit && wayBit(setValid, selectedVictim)

      io.stat.evictDirty :=
        !hit &&
        wayBit(setValid, selectedVictim) &&
        wayBit(setDirty, selectedVictim)

      io.stat.evictAddr :=
        (if (cfg.indexBits == 0)
          Cat(tagRd, 0.U(cfg.offsetBits.W))
        else
          Cat(tagRd, reqIdx, 0.U(cfg.offsetBits.W)))


      when(hit) {
        touchPlru(hitWay)
        val hitData = Mux(isWriteReg, 0.U, selectWord(lineRd, reqWord))
        io.resp.valid := (if (cfg.isWriteThrough) !isWriteReg else true.B)
        io.resp.bits.data := hitData
        when(isWriteReg) {
          dataWriteEnable := true.B
          dataWriteWay := hitWay
          dataWriteLine := replaceWord(lineRd, reqWord, writeDataReg, writeMaskReg)
          if (cfg.isWriteBack) wayBit(setDirty, hitWay) := true.B
        }
        if (cfg.isWriteThrough) {
          when(isWriteReg) {
            state := sWriteThroughReq
          }.otherwise {
            when(io.resp.fire) { state := sIdle }.otherwise {
              respData := hitData
              state := sRespond
            }
          }
        } else {
          when(io.resp.fire) { state := sIdle }.otherwise {
            respData := hitData
            state := sRespond
          }
        }
      }.otherwise {
        victimWay := selectedVictim
        if (cfg.isWriteThrough) {
          when(isWriteReg) { state := sWriteThroughReq }
            .otherwise { state := sRefillReq }
        } else {
          when(wayBit(setValid, selectedVictim) && wayBit(setDirty, selectedVictim)) {
            // Capture synchronous RAM outputs now; they need not remain valid.
            evictAddr := (if (cfg.indexBits == 0) Cat(tagRd, 0.U(cfg.offsetBits.W))
              else Cat(tagRd, reqIdx, 0.U(cfg.offsetBits.W)))
            evictLine := lineRd
            state := sWritebackReq
          }.otherwise {
            state := sRefillReq
          }
        }
      }
    }

    is(sWritebackReq) {
      io.memWriteReq.valid := true.B
      when(io.memWriteReq.fire) {
        beatCnt := 0.U
        state := sWritebackSend
      }
    }

    is(sWritebackSend) {
      io.memWriteData.valid := true.B
      when(io.memWriteData.fire) {
        when(beatCnt === (cfg.beatsPerLine - 1).U) {
          state := sWritebackWait
        }.otherwise {
          beatCnt := beatCnt + 1.U
        }
      }
    }

    is(sWritebackWait) {
      io.memWriteResp.ready := true.B
      when(io.memWriteResp.fire) {
        assert(io.memWriteResp.bits.ack, "writeback completion must acknowledge success")
        wayBit(setDirty, victimWay) := false.B
        io.stat.writeback := true.B
        state := sRefillReq
      }
    }

    is(sWriteThroughReq) {
      io.memWriteReq.valid := true.B
      io.memWriteReq.bits.addr := cfg.wordBaseOf(addrReg)
      when(io.memWriteReq.fire) { state := sWriteThroughSend }
    }

    is(sWriteThroughSend) {
      io.memWriteData.valid := true.B
      io.memWriteData.bits.data := writeDataReg
      io.memWriteData.bits.mask := writeMaskReg
      when(io.memWriteData.fire) { state := sWriteThroughWait }
    }

    is(sWriteThroughWait) {
      io.memWriteResp.ready := true.B
      when(io.memWriteResp.fire) {
        assert(io.memWriteResp.bits.ack, "write-through completion must acknowledge success")
        io.stat.writeThrough := true.B
        respData := 0.U
        state := sRespond
      }
    }

    is(sRefillReq) {
      io.memReq.valid := true.B
      when(io.memReq.fire) {
        beatCnt := 0.U
        state := sRefillWait
      }
    }

    is(sRefillWait) {
      io.memResp.ready := true.B
      when(io.memResp.fire) {
        if (cfg.beatsPerLine == 1) {
          refillBuf(0) := io.memResp.bits.data
        } else {
          refillBuf(beatCnt) := io.memResp.bits.data
        }
        beatCnt := beatCnt + 1.U

        when(beatCnt === (cfg.beatsPerLine - 1).U) {
          val beats = WireInit(refillBuf)
          if (cfg.beatsPerLine == 1) {
            beats(0) := io.memResp.bits.data
          } else {
            beats(beatCnt) := io.memResp.bits.data
          }
          val newLine = beats.asUInt
          val installedLine = Mux(isWriteReg,
            replaceWord(newLine, reqWord, writeDataReg, writeMaskReg), newLine)

          dataWriteEnable := true.B
          dataWriteLine := installedLine
          for (w <- 0 until cfg.numWays) {
            when(victimWay === w.U) { tagMem(w).write(reqIdx, reqTag) }
          }
          wayBit(setValid, victimWay) := true.B
          wayBit(setDirty, victimWay) := isWriteReg && cfg.isWriteBack.B
          nextVictim.foreach { next =>
            val replacement = if (cfg.numSets == 1) next(0) else next(reqIdx)
            replacement := Mux(victimWay === (cfg.numWays - 1).U, 0.U, victimWay + 1.U)
          }
          touchPlru(victimWay)

          respData := Mux(isWriteReg, 0.U, selectWord(newLine, reqWord))
          state := sRespond
        }
      }
    }

    is(sRespond) {
      io.resp.valid := true.B
      when(io.resp.ready) {
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
    numWays = if (args.nonEmpty) args(0).toInt else 1,
    replacementPolicy = if (args.length > 2) ReplacementPolicy.parse(args(2)) else RoundRobin,
    lfsrSeed = if (args.length > 3) BigInt(args(3)) else 1
  )
  val targetDir = if (args.length > 1) args(1) else "generated"
  emitVerilog(if (cfg.numWays == 1) new DirectMappedReadCache(cfg) else new SetAssociativeCache(cfg),
    Array("--target-dir", targetDir))
}
