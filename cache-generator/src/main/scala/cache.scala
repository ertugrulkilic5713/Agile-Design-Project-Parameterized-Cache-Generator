package cache

import chisel3._
import chisel3.util._

/** Blocking, direct-mapped cache with selectable write-back or write-through policy.
  * Write-back stores allocate on a miss. Write-through stores do not.
  */
class DirectMappedReadCache(cfg: CacheConfig) extends Module {
  import CacheState._

  val io = IO(new CacheIO(cfg))

  // ---------------------------------------------------------------- storage
  val validBits = RegInit(VecInit(Seq.fill(cfg.numLines)(false.B)))
  val dirtyBits = RegInit(VecInit(Seq.fill(cfg.numLines)(false.B)))
  val tagMem = SyncReadMem(cfg.numLines, UInt(cfg.tagBits.W))
  val dataMem = SyncReadMem(cfg.numLines, UInt(cfg.lineBits.W))

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

  io.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.req.bits.addr)
  val tagRd = tagMem.read(readIdx, io.req.fire)
  val lineRd = dataMem.read(readIdx, io.req.fire)

  // Store hits and refills share one physical memory write port.
  val dataWriteEnable = WireDefault(false.B)
  val dataWriteLine = WireDefault(0.U(cfg.lineBits.W))
  when(dataWriteEnable) {
    dataMem.write(reqIdx, dataWriteLine)
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
      val hit = validBits(reqIdx) && (tagRd === reqTag)
      io.stat.hit := hit
      io.stat.miss := !hit
      when(hit) {
        val hitData = Mux(isWriteReg, 0.U, selectWord(lineRd, reqWord))
        io.resp.valid := (if (cfg.isWriteThrough) !isWriteReg else true.B)
        io.resp.bits.data := hitData
        when(isWriteReg) {
          dataWriteEnable := true.B
          dataWriteLine := replaceWord(lineRd, reqWord, writeDataReg, writeMaskReg)
          if (cfg.isWriteBack) dirtyBits(reqIdx) := true.B
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
        if (cfg.isWriteThrough) {
          when(isWriteReg) { state := sWriteThroughReq }
            .otherwise { state := sRefillReq }
        } else {
          when(validBits(reqIdx) && dirtyBits(reqIdx)) {
            // Capture synchronous RAM outputs now; they need not remain valid.
            evictAddr := Cat(tagRd, reqIdx, 0.U(cfg.offsetBits.W))
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
        dirtyBits(reqIdx) := false.B
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
          tagMem.write(reqIdx, reqTag)
          validBits(reqIdx) := true.B
          dirtyBits(reqIdx) := isWriteReg && cfg.isWriteBack.B

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

object GenerateCache extends App {
  val cfg = CacheConfig(
    capacityBytes = 1024,
    addrWidth = 32,
    lineBytes = 4,
    wordBytes = 4,
    memBeatBytes = 4
  )
  emitVerilog(new DirectMappedReadCache(cfg),Array("--target-dir", "generated"))
}
