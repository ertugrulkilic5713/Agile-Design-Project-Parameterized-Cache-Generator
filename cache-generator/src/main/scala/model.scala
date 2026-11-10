package cache

import chisel3._
import chisel3.util._

sealed trait WritePolicy
case object WriteThrough extends WritePolicy
case object WriteBack extends WritePolicy

case class CacheConfig(
    capacityBytes: Int = 4096, // total data capacity
    addrWidth: Int = 32,
    lineBytes: Int = 16, // one cache line (block)
    wordBytes: Int = 4, // width of the CPU-side response
    memBeatBytes: Int = 4, // width of the memory-side data bus
    writePolicy: WritePolicy = WriteBack
) {
  require(isPow2(capacityBytes), "capacityBytes must be a power of two")
  require(isPow2(lineBytes), "lineBytes must be a power of two")
  require(isPow2(wordBytes), "wordBytes must be a power of two")
  require(isPow2(memBeatBytes), "memBeatBytes must be a power of two")
  require(lineBytes >= wordBytes, "a line must hold at least one word")
  require(lineBytes >= memBeatBytes, "a line must hold at least one memory beat")
  require(capacityBytes >= 2 * lineBytes, "need at least two lines")
  require(writePolicy != WriteThrough || memBeatBytes == wordBytes,
    "write-through currently requires memBeatBytes == wordBytes")

  val isWriteBack = writePolicy == WriteBack
  val isWriteThrough = writePolicy == WriteThrough

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
  def wordBaseOf(a: UInt): UInt =
    if (byteOffsetBits == 0) a else Cat(a(addrWidth - 1, byteOffsetBits), 0.U(byteOffsetBits.W))
}

/** CPU request. writeMask selects the bytes updated by a store. */
class CacheReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
  val isWrite = Bool()
  val writeData = UInt(cfg.wordBits.W)
  val writeMask = UInt(cfg.wordBytes.W)
}

class CacheResp(cfg: CacheConfig) extends Bundle {
  // Reads return the requested word; stores acknowledge completion with zero.
  val data = UInt(cfg.wordBits.W)
}

/** Memory read request: block-aligned line address. */
class MemReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
}

/** Memory write request: block-aligned evict address, accepted before its data. */
class MemWriteReq(cfg: CacheConfig) extends Bundle {
  val addr = UInt(cfg.addrWidth.W)
}

/** Exactly beatsPerLine beats per request, starting at the lowest line address. */
class MemWriteData(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.beatBits.W)
  val mask = UInt(cfg.memBeatBytes.W)
}

/** Memory response: one beat of the line, delivered in order. */
class MemResp(cfg: CacheConfig) extends Bundle {
  val data = UInt(cfg.beatBits.W)
}

/** Completion after all write beats have been accepted and the write is done.
  * A valid completion carries ack = true.
  */
class MemWriteResp(cfg: CacheConfig) extends Bundle {
  val ack = Bool()
}

class CacheIO(cfg: CacheConfig) extends Bundle {
  val req = Flipped(Decoupled(new CacheReq(cfg)))
  val resp = Decoupled(new CacheResp(cfg))
  val memReq = Decoupled(new MemReq(cfg))
  val memResp = Flipped(Decoupled(new MemResp(cfg)))
  val memWriteReq = Decoupled(new MemWriteReq(cfg))
  val memWriteData = Decoupled(new MemWriteData(cfg))
  val memWriteResp = Flipped(Decoupled(new MemWriteResp(cfg)))
  val stat = Output(new CacheStats)
}

class CacheStats extends Bundle {
  val hit = Bool()
  val miss = Bool()
  val writeback = Bool()
  val writeThrough = Bool()
}

object CacheState extends ChiselEnum {
  val sIdle, sCompare, sWritebackReq, sWritebackSend, sWritebackWait,
      sWriteThroughReq, sWriteThroughSend, sWriteThroughWait,
      sRefillReq, sRefillWait, sRespond = Value
}
