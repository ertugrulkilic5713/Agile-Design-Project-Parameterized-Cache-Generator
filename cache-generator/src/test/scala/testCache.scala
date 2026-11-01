package cache

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import scala.collection.mutable.{ArrayBuffer, Map}
import scala.util.Random

/** Software reference of a direct-mapped cache. It only tracks tags, so it can predict whether an access should hit or miss.*/
class RefCache(cfg: CacheConfig) {
  private val tags = Array.fill[Long](cfg.numLines)(-1L)

  /** Returns true on a hit, and updates the tag like a refill would on a miss. */
  def access(addr: Long): Boolean = {
    val index = ((addr >> cfg.offsetBits) & (cfg.numLines - 1)).toInt
    val tag = addr >> (cfg.offsetBits + cfg.indexBits)
    val hit = tags(index) == tag
    tags(index) = tag
    hit
  }
}

case class ReadResult(data: BigInt, cycles: Int)
case class MemoryWrite(addr: Long, beats: Seq[BigInt])

/** Test harness: plays the CPU (issues reads) and the memory (answers line
  * fetches and writebacks with configurable latency and stalls). Initial memory
  * is deterministic; CPU-visible expected bytes are tracked independently from
  * backing-memory bytes, which change only on completed writebacks.
  */
class CacheHarness(
    dut: DirectMappedReadCache,
    val cfg: CacheConfig,
    memLatency: Int,
    writeReqStall: Int = 0,
    writeBeatStall: Int = 0,
    writeAckLatency: Int = 0
) {

  /** Base address of every line fetch the cache issued, in order. */
  val fetches = ArrayBuffer[Long]()
  val writebacks = ArrayBuffer[MemoryWrite]()
  val memoryEvents = ArrayBuffer[(String, Long)]()
  private val backingBytes = Map[Long, Int]()
  private val expectedBytes = Map[Long, Int]()

  // Memory model state
  private var busy = false
  private var base = 0L
  private var delay = 0
  private var beat = 0
  private var writeBusy = false
  private var writeBase = 0L
  private val writeBeats = ArrayBuffer[BigInt]()
  private var writeReqDelay = writeReqStall
  private var writeBeatDelay = 0
  private var writeAckDelay = 0
  private var heldWriteAddr: Option[BigInt] = None
  private var heldWriteBeat: Option[BigInt] = None

  // Idle values on all inputs.
  dut.io.req.valid.poke(false.B)
  dut.io.req.bits.addr.poke(0.U)
  dut.io.req.bits.isWrite.poke(false.B)
  dut.io.req.bits.writeData.poke(0.U)
  dut.io.resp.ready.poke(true.B)
  dut.io.memReq.ready.poke(true.B)
  dut.io.memResp.valid.poke(false.B)
  dut.io.memResp.bits.data.poke(0.U)
  dut.io.memWriteReq.ready.poke(true.B)
  dut.io.memWriteData.ready.poke(true.B)
  dut.io.memWriteResp.valid.poke(false.B)
  dut.io.memWriteResp.bits.ack.poke(false.B)

  // ---------------------------------------------------------------- memory contents
  def memByte(addr: Long): Int = (((addr * 31) + 7) ^ (addr >> 8)).toInt & 0xff

  private def bytesToBig(start: Long, n: Int, byteAt: Long => Int): BigInt =
    (0 until n).foldLeft(BigInt(0))((acc, i) => acc | (BigInt(byteAt(start + i)) << (8 * i)))

  private def backingByte(addr: Long): Int = backingBytes.getOrElse(addr, memByte(addr))
  private def expectedByte(addr: Long): Int = expectedBytes.getOrElse(addr, memByte(addr))

  /** The word the CPU should get back for a (word-aligned) address. */
  def expectedWord(addr: Long): BigInt =
    bytesToBig(addr & ~(cfg.wordBytes - 1L), cfg.wordBytes, expectedByte)

  def backingWord(addr: Long): BigInt =
    bytesToBig(addr & ~(cfg.wordBytes - 1L), cfg.wordBytes, backingByte)

  def expectedBeat(addr: Long): BigInt = bytesToBig(addr, cfg.memBeatBytes, expectedByte)

  // ---------------------------------------------------------------- memory model
  /** Drive memory-side inputs for the current cycle. */
  private def memDrive(): Unit = {
    dut.io.memReq.ready.poke((!busy && !writeBusy).B)
    val respValid = busy && delay == 0
    dut.io.memResp.valid.poke(respValid.B)
    if (respValid) {
      val data = bytesToBig(base + beat.toLong * cfg.memBeatBytes, cfg.memBeatBytes, backingByte)
      dut.io.memResp.bits.data.poke(data.U)
    }
    dut.io.memWriteReq.ready.poke((!busy && !writeBusy && writeReqDelay == 0).B)
    dut.io.memWriteData.ready.poke(
      (writeBusy && writeBeats.size < cfg.beatsPerLine && writeBeatDelay == 0).B
    )
    dut.io.memWriteResp.valid.poke(
      (writeBusy && writeBeats.size == cfg.beatsPerLine && writeAckDelay == 0).B
    )
    dut.io.memWriteResp.bits.ack.poke(true.B)
  }

  /** Advance the memory model by one cycle, after inputs are driven. */
  private def memUpdate(): Unit = {
    val readReqFire = dut.io.memReq.valid.peekBoolean() && dut.io.memReq.ready.peekBoolean()
    val readRespFire = dut.io.memResp.valid.peekBoolean() && dut.io.memResp.ready.peekBoolean()
    val writeReqValid = dut.io.memWriteReq.valid.peekBoolean()
    val writeReqReady = dut.io.memWriteReq.ready.peekBoolean()
    val writeReqFire = writeReqValid && writeReqReady
    val writeAddr = if (writeReqValid) dut.io.memWriteReq.bits.addr.peekInt() else BigInt(0)
    val writeDataValid = dut.io.memWriteData.valid.peekBoolean()
    val writeDataReady = dut.io.memWriteData.ready.peekBoolean()
    val writeDataFire = writeDataValid && writeDataReady
    val writeData = if (writeDataValid) dut.io.memWriteData.bits.data.peekInt() else BigInt(0)
    val writeAckFire = dut.io.memWriteResp.valid.peekBoolean() && dut.io.memWriteResp.ready.peekBoolean()

    require(!(readReqFire && writeReqFire), "memory accepted two requests at once")
    if (writeBusy) {
      require(!dut.io.memReq.valid.peekBoolean(), "refill started before writeback acknowledgement")
      require(!dut.io.resp.valid.peekBoolean(), "CPU response arrived before writeback completion")
    }
    heldWriteAddr.foreach { addr =>
      require(writeReqValid && writeAddr == addr, "write address changed or valid dropped while stalled")
    }
    heldWriteBeat.foreach { data =>
      require(writeDataValid && writeData == data, "write beat changed or valid dropped while stalled")
    }
    heldWriteAddr = if (writeReqValid && !writeReqReady) Some(writeAddr) else None
    heldWriteBeat = if (writeDataValid && !writeDataReady) Some(writeData) else None
    if (writeDataValid) {
      require(writeBusy && writeBeats.size < cfg.beatsPerLine, "unexpected or extra writeback beat")
    }

    if (!busy) {
      if (readReqFire) {
        busy = true
        base = dut.io.memReq.bits.addr.peekInt().toLong
        delay = memLatency
        beat = 0
        fetches += base
        memoryEvents += (("readReq", base))
      }
    } else if (delay > 0) {
      delay -= 1
    } else if (readRespFire) {
      beat += 1
      if (beat == cfg.beatsPerLine) busy = false
    }

    if (!writeBusy) {
      if (writeReqFire) {
        writeBusy = true
        writeBase = writeAddr.toLong
        require((writeBase & (cfg.lineBytes - 1L)) == 0, "writeback address is not line-aligned")
        writeBeats.clear()
        writeBeatDelay = writeBeatStall
        memoryEvents += (("writeReq", writeBase))
      } else if (writeReqValid && writeReqDelay > 0) {
        writeReqDelay -= 1
      }
    } else if (writeBeats.size < cfg.beatsPerLine) {
      if (writeBeatDelay > 0) writeBeatDelay -= 1
      else if (writeDataFire) {
        writeBeats += writeData
        writeBeatDelay = writeBeatStall
        if (writeBeats.size == cfg.beatsPerLine) writeAckDelay = writeAckLatency
      }
    } else if (writeAckDelay > 0) {
      writeAckDelay -= 1
    } else if (writeAckFire) {
      for ((data, i) <- writeBeats.zipWithIndex; byte <- 0 until cfg.memBeatBytes) {
        backingBytes(writeBase + i.toLong * cfg.memBeatBytes + byte) =
          ((data >> (8 * byte)) & 0xff).toInt
      }
      writebacks += MemoryWrite(writeBase, writeBeats.toVector)
      memoryEvents += (("writeDone", writeBase))
      writeBusy = false
      writeReqDelay = writeReqStall
    }
  }

  // ---------------------------------------------------------------- CPU side
  /** Issue one read and wait for the response.*/
  /* 
  Counted cycle	Cache activity
    1	Accept request and initiate synchronous reads
    2	Compare tag and capture the selected word
    3	Present and transfer the response
  */

  /* 
  Counted cycle	Cache activity
    1	Accept CPU request
    2	Detect miss
    3	Memory accepts line request
    4–5	Initial memory delay
    6–9	Transfer four refill beats
    10	Transfer CPU response
  */
  def read(addr: Long, respStall: Int = 0, maxCycles: Int = 500): ReadResult = {
    access(addr, isWrite = false, writeData = BigInt(0), respStall = respStall, maxCycles = maxCycles)
  }

  /** A store completes in the cache; backing memory changes only on eviction. */
  def write(addr: Long, data: BigInt, respStall: Int = 0, maxCycles: Int = 500): ReadResult = {
    require((addr & (cfg.wordBytes - 1L)) == 0, "store must be word-aligned")
    require(data >= 0 && data < (BigInt(1) << cfg.wordBits), "store data exceeds word width")
    val result = access(addr, isWrite = true, writeData = data, respStall = respStall, maxCycles = maxCycles)
    require(result.data == 0, "store response must acknowledge completion with zero")
    for (i <- 0 until cfg.wordBytes) expectedBytes(addr + i) = ((data >> (8 * i)) & 0xff).toInt
    result
  }

  private def access(addr: Long, isWrite: Boolean, writeData: BigInt, respStall: Int, maxCycles: Int): ReadResult = {
    dut.io.req.valid.poke(true.B)
    dut.io.req.bits.addr.poke(addr.U)
    dut.io.req.bits.isWrite.poke(isWrite.B)
    dut.io.req.bits.writeData.poke(writeData.U)

    var accepted = false
    var cycles = 0
    var elapsed = 0
    var stalled = 0
    var seen: Option[BigInt] = None
    var result: Option[BigInt] = None

    while (result.isEmpty) {
      require(elapsed < maxCycles, s"timeout waiting for the response to address 0x${addr.toHexString}")
      memDrive()

      val reqFire = !accepted && dut.io.req.ready.peekBoolean()

      val respValid = accepted && dut.io.resp.valid.peekBoolean()
      require(seen.isEmpty || respValid, "resp.valid dropped before the response was accepted")
      val stall = respValid && stalled < respStall
      dut.io.resp.ready.poke((!stall).B)
      if (respValid) {
        val d = dut.io.resp.bits.data.peekInt()
        // Data must stay stable for as long as valid is high.
        require(seen.forall(_ == d), "resp.data changed while resp.valid was high")
        seen = Some(d)
        if (stall) stalled += 1 else result = Some(d)
      }

      memUpdate()
      dut.clock.step()
      elapsed += 1

      if (accepted || reqFire) cycles += 1
      if (reqFire) {
        accepted = true
        // The cache must have captured the address: drop it right after accept.
        dut.io.req.valid.poke(false.B)
        dut.io.req.bits.addr.poke(0.U)
        dut.io.req.bits.isWrite.poke(false.B)
        dut.io.req.bits.writeData.poke(0.U)
      }
    }
    dut.io.resp.ready.poke(true.B)
    ReadResult(result.get, cycles)
  }
}

class DirectMappedReadCacheSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "DirectMappedReadCache"

  val cfg = CacheConfig() // 4 KiB, 16 B lines, 4 B words, 4 B memory beats
  val memLatency = 2

  def withCache(
      c: CacheConfig,
      latency: Int = memLatency,
      writeReqStall: Int = 0,
      writeBeatStall: Int = 0,
      writeAckLatency: Int = 0
  )(body: CacheHarness => Unit): Unit =
    test(new DirectMappedReadCache(c)) { dut =>
      body(new CacheHarness(dut, c, latency, writeReqStall, writeBeatStall, writeAckLatency))
    }

  // ------------------------------------------------------------------ basics
  it should "fetch the whole line on a cold miss and return the right word" in {
    withCache(cfg) { h =>
      val r = h.read(0x10c) // last word of the line starting at 0x100
      assert(r.data == h.expectedWord(0x10c))
      // One fetch, and it is the line-aligned base address, not 0x10c.
      assert(h.fetches.toSeq == Seq(0x100L))
    }
  }

  it should "hit on a repeated access without touching memory" in {
    withCache(cfg) { h =>
      h.read(0x100)
      val r = h.read(0x100)
      assert(r.data == h.expectedWord(0x100))
      assert(h.fetches.size == 1)
    }
  }

  it should "hit on other words of a line that was already fetched (spatial locality)" in {
    withCache(cfg) { h =>
      h.read(0x100)
      for (off <- Seq(0x4L, 0x8L, 0xcL)) {
        val r = h.read(0x100 + off)
        assert(r.data == h.expectedWord(0x100 + off))
      }
      assert(h.fetches.size == 1)
    }
  }

  it should "miss again on the next line" in {
    withCache(cfg) { h =>
      h.read(0x100)
      h.read(0x110)
      assert(h.fetches.toSeq == Seq(0x100L, 0x110L))
    }
  }

  // ------------------------------------------------------------------ direct-mapped behavior
  it should "keep lines with different indices at the same time" in {
    withCache(cfg) { h =>
      h.read(0x100)
      h.read(0x110)
      h.read(0x100) // still there
      assert(h.fetches.toSeq == Seq(0x100L, 0x110L))
    }
  }

  it should "evict on a conflict: same index, different tag (conflict miss)" in {
    withCache(cfg) { h =>
      val a = 0x100L
      val b = a + cfg.capacityBytes // same index, different tag
      h.read(a)
      h.read(b) // evicts a
      val r = h.read(a) // must be fetched again
      assert(r.data == h.expectedWord(a))
      assert(h.fetches.toSeq == Seq(a, b, a))
    }
  }

  // ------------------------------------------------------------------ timing / handshake
  it should "take 3 cycles for a hit (accept, compare, respond)" in {
    withCache(cfg) { h =>
      h.read(0x100)
      assert(h.read(0x100).cycles == 3)
    }
  }

  it should "take 4 + memory latency + beats cycles for a miss" in {
    withCache(cfg) { h =>
      // accept, compare, refill-req, then latency + one cycle per beat, then respond
      val expected = 4 + memLatency + cfg.beatsPerLine
      assert(h.read(0x100).cycles == expected)
    }
  }

  it should "hold the response stable while the CPU is not ready" in {
    withCache(cfg) { h =>
      h.read(0x100)
      val r = h.read(0x104, respStall = 5)
      assert(r.data == h.expectedWord(0x104))
      assert(r.cycles == 3 + 5)
    }
  }

  // ------------------------------------------------------------------ stores / writeback
  it should "update a word on a write hit without writing through to memory" in {
    withCache(cfg) { h =>
      val addr = 0x104L
      val original = h.backingWord(addr)
      h.read(0x100)
      val result = h.write(addr, BigInt("deadbeef", 16))
      assert(result.cycles == 3)
      assert(h.backingWord(addr) == original)
      assert(h.writebacks.isEmpty)
      for (off <- 0 until cfg.lineBytes by cfg.wordBytes) {
        val a = 0x100L + off
        assert(h.read(a).data == h.expectedWord(a))
      }
      assert(h.fetches.toSeq == Seq(0x100L))
    }
  }

  it should "allocate on a write miss and preserve the other words of the fetched line" in {
    withCache(cfg) { h =>
      h.write(0x10c, BigInt("89abcdef", 16))
      for (off <- 0 until cfg.lineBytes by cfg.wordBytes) {
        val a = 0x100L + off
        assert(h.read(a).data == h.expectedWord(a))
      }
      assert(h.fetches.toSeq == Seq(0x100L))
      assert(h.writebacks.isEmpty)
    }
  }

  it should "evict clean lines without issuing a writeback" in {
    withCache(cfg) { h =>
      h.read(0x100)
      h.read(0x100L + cfg.capacityBytes)
      h.write(0x100, BigInt("12345678", 16))
      assert(h.writebacks.isEmpty)
      assert(h.read(0x100).data == h.expectedWord(0x100))
    }
  }

  it should "write a dirty evict to its old address before refilling a conflicting read" in {
    withCache(cfg) { h =>
      val a = 0x1100L
      val b = a + cfg.capacityBytes
      val stored = BigInt("cafe1234", 16)
      val original = h.backingWord(a + 4)
      h.write(a + 4, stored)
      assert(h.backingWord(a + 4) == original)
      assert(h.read(b + 8).data == h.expectedWord(b + 8))
      assert(h.writebacks.map(_.addr).toSeq == Seq(a))
      assert(h.writebacks.head.beats ==
        (0 until cfg.beatsPerLine).map(i => h.expectedBeat(a + i.toLong * cfg.memBeatBytes)))
      assert(h.backingWord(a + 4) == stored)
      assert(h.memoryEvents.toSeq == Seq(
        ("readReq", a), ("writeReq", a), ("writeDone", a), ("readReq", b)
      ))
      // Both subsequent read refills must remain clean.
      assert(h.read(a + 4).data == stored)
      assert(h.read(b).data == h.expectedWord(b))
      assert(h.writebacks.size == 1)
    }
  }

  it should "write back both dirty evicts across consecutive conflicting stores" in {
    withCache(cfg) { h =>
      val a = 0x100L
      val b = a + cfg.capacityBytes
      val c = b + cfg.capacityBytes
      val first = BigInt("10203040", 16)
      val second = BigInt("a1b2c3d4", 16)
      h.write(a, first)
      h.write(b + 12, second)
      assert(h.backingWord(a) == first)
      assert(h.read(c).data == h.expectedWord(c))
      assert(h.writebacks.map(_.addr).toSeq == Seq(a, b))
      assert(h.backingWord(b + 12) == second)
      assert(h.read(a).data == first)
      assert(h.read(b + 12).data == second)
      assert(h.writebacks.size == 2)
    }
  }

  it should "hold a store acknowledgement stable while the CPU stalls" in {
    withCache(cfg) { h =>
      h.read(0x100)
      assert(h.write(0x108, BigInt("76543210", 16), respStall = 5).cycles == 8)
      assert(h.read(0x108).data == h.expectedWord(0x108))
      assert(h.writebacks.isEmpty)
    }
  }

  it should "preserve every writeback beat under address and data stalls and delayed acknowledgement" in {
    withCache(cfg, writeReqStall = 3, writeBeatStall = 2, writeAckLatency = 4) { h =>
      val a = 0x100L
      val b = a + cfg.capacityBytes
      val words = Seq("11223344", "deadbeef", "a5a5a5a5", "01020304").map(BigInt(_, 16))
      for ((data, i) <- words.zipWithIndex) h.write(a + i.toLong * cfg.wordBytes, data)
      assert(h.read(b + 12, respStall = 3).data == h.expectedWord(b + 12))
      assert(h.writebacks.toSeq == Seq(MemoryWrite(a, words)))
      for ((data, i) <- words.zipWithIndex) assert(h.backingWord(a + i.toLong * cfg.wordBytes) == data)
      assert(h.read(a + 12).data == words.last)
    }
  }
}