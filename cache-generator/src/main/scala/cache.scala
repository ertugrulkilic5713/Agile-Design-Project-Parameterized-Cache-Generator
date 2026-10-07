package cache

import chisel3._
import chisel3.util._

class DirectMappedReadCache(cfg: CacheConfig) extends Module {
  import CacheState._

  val io = IO(new CacheIO(cfg))

  // ---------------------------------------------------------------- storage
  val validBits = RegInit(VecInit(Seq.fill(cfg.numLines)(false.B)))
  val tagMem = SyncReadMem(cfg.numLines, UInt(cfg.tagBits.W))
  val dataMem = SyncReadMem(cfg.numLines, UInt(cfg.lineBits.W))

  // ---------------------------------------------------------------- state
  val state = RegInit(sIdle)
  val addrReg = Reg(UInt(cfg.addrWidth.W)) // latched request address
  val respData = Reg(UInt(cfg.wordBits.W)) // word returned in RESPOND
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

  io.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.req.bits.addr)
  val tagRd = tagMem.read(readIdx, io.req.fire)
  val lineRd = dataMem.read(readIdx, io.req.fire)

  def selectWord(line: UInt, wordIdx: UInt): UInt =
    line.asTypeOf(Vec(cfg.wordsPerLine, UInt(cfg.wordBits.W)))(wordIdx)

  // ---------------------------------------------------------------- FSM
  switch(state) {
    is(sIdle) {
      when(io.req.valid) {
        addrReg := io.req.bits.addr
        state := sCompare
      }
    }

    is(sCompare) {
      val hit = validBits(reqIdx) && (tagRd === reqTag)
      when(hit) {
        respData := selectWord(lineRd, reqWord)
        state := sRespond
      }.otherwise {
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

          dataMem.write(reqIdx, newLine)
          tagMem.write(reqIdx, reqTag)
          validBits(reqIdx) := true.B

          respData := selectWord(newLine, reqWord)
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