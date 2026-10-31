package cache

import chisel3._
import chisel3.util._

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

  val numLines = capacityBytes / lineBytes
  val wordsPerLine = lineBytes / wordBytes
  val beatsPerLine = lineBytes / memBeatBytes

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
