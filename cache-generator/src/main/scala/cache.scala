package cache

import chisel3._
import chisel3.util._

/** Blocking, set-associative cache with write-back and write allocation.
  * CPU stores must be word-aligned and replace a full word.
  */
class SetAssociativeCache(cfg: CacheConfig) extends Module {
  import CacheState._

  val io = IO(new CacheIO(cfg))

  // ---------------------------------------------------------------- storage
  val validBits = RegInit(VecInit(Seq.fill(cfg.numSets)(VecInit(Seq.fill(cfg.numWays)(false.B)))))
  val dirtyBits = RegInit(VecInit(Seq.fill(cfg.numSets)(VecInit(Seq.fill(cfg.numWays)(false.B)))))
  val tagMem = Seq.fill(cfg.numWays)(SyncReadMem(cfg.numSets, UInt(cfg.tagBits.W)))
  val dataMem = Seq.fill(cfg.numWays)(SyncReadMem(cfg.numSets, UInt(cfg.lineBits.W)))
  val nextVictim = RegInit(VecInit(Seq.fill(cfg.numSets)(0.U(cfg.wayBits.W))))
  val victimWay = Reg(UInt(cfg.wayBits.W))

  // ---------------------------------------------------------------- state
  val state = RegInit(sIdle)
  val addrReg = Reg(UInt(cfg.addrWidth.W)) // latched request address
  val isWriteReg = Reg(Bool())
  val writeDataReg = Reg(UInt(cfg.wordBits.W))
  val respData = Reg(UInt(cfg.wordBits.W)) // word returned in RESPOND
  val evictAddr = Reg(UInt(cfg.addrWidth.W))
  val evictLine = Reg(UInt(cfg.lineBits.W))
  val refillBuf = Reg(Vec(cfg.beatsPerLine, UInt(cfg.beatBits.W)))
  val beatCntWidth = math.max(1, log2Ceil(cfg.beatsPerLine))
  val beatCnt = RegInit(0.U(beatCntWidth.W))

  val reqIdx = cfg.indexOf(addrReg)
  val reqTag = cfg.tagOf(addrReg)
  val reqWord = cfg.wordIdxOf(addrReg)

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
  io.memWriteResp.ready := false.B

  io.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.req.bits.addr)
  val tagsRd = VecInit(tagMem.map(_.read(readIdx, io.req.fire)))
  val linesRd = VecInit(dataMem.map(_.read(readIdx, io.req.fire)))
  val setValid = if (cfg.numSets == 1) validBits(0) else validBits(reqIdx)
  val setDirty = if (cfg.numSets == 1) dirtyBits(0) else dirtyBits(reqIdx)
  val replacement = if (cfg.numSets == 1) nextVictim(0) else nextVictim(reqIdx)
  def wayBit(bits: Vec[Bool], way: UInt): Bool =
    if (cfg.numWays == 1) bits(0) else bits(way)

  val hits = VecInit((0 until cfg.numWays).map(w => setValid(w) && tagsRd(w) === reqTag))
  val hit = hits.asUInt.orR
  val hitWay = if (cfg.numWays == 1) 0.U else PriorityEncoder(hits)
  val invalid = VecInit(setValid.map(v => !v))
  val invalidWay = if (cfg.numWays == 1) 0.U else PriorityEncoder(invalid)
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

  def replaceWord(line: UInt, wordIdx: UInt, data: UInt): UInt = {
    val words = WireInit(line.asTypeOf(Vec(cfg.wordsPerLine, UInt(cfg.wordBits.W))))
    if (cfg.wordsPerLine == 1) words(0) := data
    else words(wordIdx) := data
    words.asUInt
  }

  // ---------------------------------------------------------------- FSM
  switch(state) {
    is(sIdle) {
      when(io.req.fire) {
        addrReg := io.req.bits.addr
        isWriteReg := io.req.bits.isWrite
        writeDataReg := io.req.bits.writeData
        state := sCompare
      }
    }

    is(sCompare) {
      when(hit) {
        val hitData = Mux(isWriteReg, 0.U, selectWord(lineRd, reqWord))
        io.resp.valid := true.B
        io.resp.bits.data := hitData
        when(isWriteReg) {
          dataWriteEnable := true.B
          dataWriteWay := hitWay
          dataWriteLine := replaceWord(lineRd, reqWord, writeDataReg)
          wayBit(setDirty, hitWay) := true.B
        }
        when(io.resp.fire) {
          state := sIdle
        }.otherwise {
          respData := hitData
          state := sRespond
        }
      }.otherwise {
        victimWay := selectedVictim
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
        state := sRefillReq
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
          val installedLine = Mux(isWriteReg, replaceWord(newLine, reqWord, writeDataReg), newLine)

          dataWriteEnable := true.B
          dataWriteLine := installedLine
          for (w <- 0 until cfg.numWays) {
            when(victimWay === w.U) { tagMem(w).write(reqIdx, reqTag) }
          }
          replacement := (if (cfg.numWays == 1) 0.U else
            Mux(victimWay === (cfg.numWays - 1).U, 0.U, victimWay + 1.U))
          wayBit(setValid, victimWay) := true.B
          wayBit(setDirty, victimWay) := isWriteReg

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
    numWays = if (args.nonEmpty) args(0).toInt else 1
  )
  emitVerilog(if (cfg.numWays == 1) new DirectMappedReadCache(cfg) else new SetAssociativeCache(cfg),
    Array("--target-dir", if (args.length > 1) args(1) else "generated"))
}
