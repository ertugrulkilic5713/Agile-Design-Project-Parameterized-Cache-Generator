package cache

import chisel3._
import chisel3.util._

/** Write policy. Chosen at elaboration time.
 *  The generated HW only contains logic for the selected policy.
 *  - WT: every store goes to MM immediately, the cache is only updated on a write hit.
 *  - WB: stores only update the cache line and mark it dirty. A dirty line is written to MM if
 *  evicted.
**/
sealed trait WritePolicy
case object WriteThrough extends WritePolicy
case object WriteBack extends WritePolicy

case class CacheConfig(
    capacityBytes: Int = 4096, // total data capacity.
    addrWidth: Int = 32, // a.k.a. address size is 32 bits.total data capacity : [tag(20) | index(8) | wordidx(2) | byteoffset(2)]
    lineBytes: Int = 16, // one cache line (block) // a.k.a. 4 words of 32 bits per cache line.
    wordBytes: Int = 4, // width of the CPU-side response // one word of 32 bits at a time.
    memBeatBytes: Int = 4, // width of the memory-side data bus // one word of 32 bits at a time.
    writePolicy: WritePolicy = WriteBack
) {
  require(isPow2(capacityBytes), "capacityBytes must be a power of two")
  require(isPow2(lineBytes), "lineBytes must be a power of two")
  require(isPow2(wordBytes), "wordBytes must be a power of two")
  require(isPow2(memBeatBytes), "memBeatBytes must be a power of two")
  require(lineBytes >= wordBytes, "a line must hold at least one word")
  require(lineBytes >= memBeatBytes, "a line must hold at least one memory beat")
  require(capacityBytes >= 2 * lineBytes, "need at least two lines")

  val isWb = writePolicy == WriteBack
  val isWt = writePolicy == WriteThrough

  require(isWb || memBeatBytes == wordBytes, "WT currently requires memBeatBytes == wordBytes")

  val numLines = capacityBytes / lineBytes
  val wordsPerLine = lineBytes / wordBytes // 16/4 = 4.
  val beatsPerLine = lineBytes / memBeatBytes // 16/4 = 4.

  val offsetBits = log2Ceil(lineBytes)
  val indexBits = log2Ceil(numLines)
  val tagBits = addrWidth - indexBits - offsetBits
  require(tagBits > 0, "address too narrow for this capacity/line size")

  val byteOffsetBits = log2Ceil(wordBytes) // byte inside a word
  val wordIdxBits = log2Ceil(wordsPerLine) // word inside a line
  val wordBits = wordBytes * 8 // 4 * 8 = 32.
  val beatBits = memBeatBytes * 8 // 4 * 8 = 32.
  val lineBits = lineBytes * 8

  // Address split: | tag | index | offset |
  def tagOf(a: UInt): UInt = a(addrWidth - 1, indexBits + offsetBits)
  def indexOf(a: UInt): UInt = a(indexBits + offsetBits - 1, offsetBits)
  def wordIdxOf(a: UInt): UInt = if (wordIdxBits == 0) 0.U else a(offsetBits - 1, byteOffsetBits)
  def lineBaseOf(a: UInt): UInt = Cat(a(addrWidth - 1, offsetBits), 0.U(offsetBits.W))
  
  // Align the words in a line by making sure we start at byteoffset 00 of that particular cache line.
  def wordBaseOf(a: UInt): UInt = if (byteOffsetBits == 0) a else Cat(a(addrWidth - 1, byteOffsetBits), 0.U(byteOffsetBits.W))
}

/** CPU request: just an address, the cache is read-only. 
 * For a write, "wmask" selects the bytes of "wdata" that are stored (RISCV sb/sh/sw).
 */
class CpuReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
  val write = Bool() // load or store.
  val wdata = UInt(cfg.wordBits.W) // full word.
  val wmask = UInt(cfg.wordBytes.W) // 1111: sw, 1100: sh, 0010: sb.
}

class CpuResp(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.wordBits.W)
}

/** Refill request: line-aligned address; mm answers with beatsPerLine beats. **/
class MmRefillReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
}

/** Pne beat of a refill, delivered in address order. */
class MmBeat(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.beatBits.W)
}

/** One write beat to mm, Use by both policies:
 *  WB pushes beatsPerLine beats of a dirtly line (masked all ones).
 *  WT pushes one word with the CPUs byte mask.
 *  ready means mm has accepted (and completed) the beat.
 *  **/
class MmWriteReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
  val data = UInt(cfg.beatBits.W)
  val mask = UInt(cfg.memBeatBytes.W)
}

class CacheStats extends Bundle {
  val hit = Bool()
  val miss = Bool()
  val writeback_wb = Bool()
  val write_wt = Bool()
}

class CacheIO(cfg: CacheConfig) extends Bundle {
  val cpu = new Bundle {
    // The CPU generates memory read/write requests (adress, write data, write mask) and sends them to the cache.
    // The cache asserts ready when its controller (e.g., sIdle) is ready to accept a new command.
    val req = Flipped(Decoupled(new CpuReq(cfg))) // PRODUCER: CPU, CONSUMER: CACHE.

    // When servicing a read request (a load), the cache drives the retrieved 32-bit word (data)
    // and sets valid = true (in state sRespond). The CPU consumes the word when it is ready.
    val resp = Decoupled(new CpuResp(cfg)) // PRODUCER: CACHE, CONSUMER: CPU.
  }
  val mm = new Bundle {
    // When the cache encounters a read or write miss and needs to bring a whole line into the cache,
    // it transitions to sRefillReq.
    val req_refill = Decoupled(new MmRefillReq(cfg)) // PRODUCER: CACHE, CONSUMER: MM.
    // In state sRefillWait, MM streams the requested block data backl to the cache in beats.
    // The MM produces each MMBeat, and the cache consumes them one by one to fill its cache line.
    val data_refill = Flipped(Decoupled(new MmBeat(cfg))) // PRODUCER: MM, CONSUMER: CACHE.
    // The cache writes data out to MM. The cache produces the write command/data, and MM consumes it.
    // WT: In state sWriteThrough_wt, the cache pushes a single modified word out to MM on every store instruction.
    // WB: In state sWriteback_wb, the cache evicts an entire dirty block by pushing beatsPerLine beats back to MM.
    val req_write = Decoupled(new MmWriteReq(cfg)) // PRODUCER: CACHE, CONSUMER: MM.
  }
  val stat = Output(new CacheStats)
}

object CacheState extends ChiselEnum {
  val sIdle, sCompare, sWriteback_wb, sRefillReq, sRefillWait, sWriteThrough_wt, sRespond = Value
}
