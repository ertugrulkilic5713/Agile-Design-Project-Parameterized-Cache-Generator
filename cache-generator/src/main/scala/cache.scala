package cache

import chisel3._
import chisel3.util._

/** Static parameters of the cache. Everything else is derived from these. */
case class CacheConfig(
    capacityBytes: Int = 4096, // total data capacity
    addrWidth: Int = 32,
    lineBytes: Int = 16, // one cache line (block)
    wordBytes: Int = 4, // width of the CPU-side response
    memBeatBytes: Int = 4 // width of the memory-side data bus
) {
  require(isPow2(capacityBytes), "capacityBytes must be a power of two")
  require(isPow2(lineBytes), "lineBytes must be a power of two")
  require(isPow2(wordBytes), "wordBytes must be a power of two")
  require(isPow2(memBeatBytes), "memBeatBytes must be a power of two")
  require(lineBytes >= wordBytes, "a line must hold at least one word")
  require(lineBytes >= memBeatBytes, "a line must hold at least one memory beat")
  require(capacityBytes >= 2 * lineBytes, "need at least two lines")

  // Geometry
  val numLines = capacityBytes / lineBytes
  val wordsPerLine = lineBytes / wordBytes
  val beatsPerLine = lineBytes / memBeatBytes

  // Widths
  val offsetBits = log2Ceil(lineBytes)
  val indexBits = log2Ceil(numLines)
  val tagBits = addrWidth - indexBits - offsetBits
  require(tagBits > 0, "address too narrow for this capacity/line size")

  val byteOffsetBits = log2Ceil(wordBytes) // byte inside a word
  val wordIdxBits = log2Ceil(wordsPerLine) // word inside a line
  val wordBits = wordBytes * 8
  val beatBits = memBeatBytes * 8
  val lineBits = lineBytes * 8

  // Address split: | tag | index | offset |
  def tagOf(a: UInt): UInt = a(addrWidth - 1, indexBits + offsetBits)
  def indexOf(a: UInt): UInt = a(indexBits + offsetBits - 1, offsetBits)
  def wordIdxOf(a: UInt): UInt = if (wordIdxBits == 0) 0.U else a(offsetBits - 1, byteOffsetBits)
  def lineBaseOf(a: UInt): UInt = Cat(a(addrWidth - 1, offsetBits), 0.U(offsetBits.W))
}

/** CPU request: just an address, the cache is read-only. */
class CacheReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
}

class CacheResp(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.wordBits.W)
}

/** Memory read request: block-aligned line address. */
class MemReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
}

/** Memory response: one beat of the line, delivered in order. */
class MemResp(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.beatBits.W)
}

class CacheIO(cfg: CacheConfig) extends Bundle {
  val req = Flipped(Decoupled(new CacheReq(cfg)))
  val resp = Decoupled(new CacheResp(cfg))
  val memReq = Decoupled(new MemReq(cfg))
  val memResp = Flipped(Decoupled(new MemResp(cfg)))
}

object CacheState extends ChiselEnum {
  val sIdle, sCompare, sRefillReq, sRefillWait, sRespond = Value
}

class DirectMappedReadCache(cfg: CacheConfig) extends Module {
  import CacheState._

  val io = IO(new CacheIO(cfg))

  // ---------------------------------------------------------------- storage
  // Valid bits live in registers so they are cleared on reset.
  val validBits = RegInit(VecInit(Seq.fill(cfg.numLines)(false.B)))
  // Tag and data arrays: synchronous read, so data is available one cycle
  // after the read is issued. This is why the read happens in IDLE and the
  // comparison happens in COMPARE.
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

  // Array reads are issued when a request is accepted (IDLE -> COMPARE).
  io.req.ready := state === sIdle
  val readIdx = cfg.indexOf(io.req.bits.addr)
  val tagRd = tagMem.read(readIdx, io.req.fire)
  val lineRd = dataMem.read(readIdx, io.req.fire)

  // Pick one word out of a full line.
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
          // Last beat: assemble the full line (beat 0 in the LSBs),
          // using the incoming beat directly since refillBuf updates next cycle.
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