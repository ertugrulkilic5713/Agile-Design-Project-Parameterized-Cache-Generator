package cache

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import scala.collection.mutable.ArrayBuffer
import scala.util.Random

/** Software reference of a direct-mapped cache. It only tracks tags, so it can
  * predict whether an access should hit or miss.
  */
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

/** Test harness: plays the CPU (issues reads) and the memory (answers line
  * fetches with a configurable latency). Memory content is a deterministic
  * function of the byte address, so the expected value of any read is known.
  */
class CacheHarness(dut: DirectMappedReadCache, val cfg: CacheConfig, memLatency: Int) {

  /** Base address of every line fetch the cache issued, in order. */
  val fetches = ArrayBuffer[Long]()

  // Memory model state
  private var busy = false
  private var base = 0L
  private var delay = 0
  private var beat = 0

  // Idle values on all inputs.
  dut.io.req.valid.poke(false.B)
  dut.io.req.bits.addr.poke(0.U)
  dut.io.resp.ready.poke(true.B)
  dut.io.memReq.ready.poke(true.B)
  dut.io.memResp.valid.poke(false.B)
  dut.io.memResp.bits.data.poke(0.U)

  // ---------------------------------------------------------------- memory contents
  def memByte(addr: Long): Int = (((addr * 31) + 7) ^ (addr >> 8)).toInt & 0xff

  private def bytesToBig(start: Long, n: Int): BigInt =
    (0 until n).foldLeft(BigInt(0))((acc, i) => acc | (BigInt(memByte(start + i)) << (8 * i)))

  /** The word the CPU should get back for a (word-aligned) address. */
  def expectedWord(addr: Long): BigInt =
    bytesToBig(addr & ~(cfg.wordBytes - 1L), cfg.wordBytes)

  // ---------------------------------------------------------------- memory model
  /** Drive memory-side inputs for the current cycle. */
  private def memDrive(): Unit = {
    dut.io.memReq.ready.poke((!busy).B)
    val respValid = busy && delay == 0
    dut.io.memResp.valid.poke(respValid.B)
    if (respValid) {
      val data = bytesToBig(base + beat.toLong * cfg.memBeatBytes, cfg.memBeatBytes)
      dut.io.memResp.bits.data.poke(data.U)
    }
  }

  /** Advance the memory model by one cycle, after inputs are driven. */
  private def memUpdate(): Unit = {
    if (!busy) {
      if (dut.io.memReq.valid.peekBoolean()) { // request fires: ready is high when idle
        busy = true
        base = dut.io.memReq.bits.addr.peekInt().toLong
        delay = memLatency
        beat = 0
        fetches += base
      }
    } else if (delay > 0) {
      delay -= 1
    } else if (dut.io.memResp.ready.peekBoolean()) { // beat fires
      beat += 1
      if (beat == cfg.beatsPerLine) busy = false
    }
  }

  // ---------------------------------------------------------------- CPU side
  /** Issue one read and wait for the response.
    *
    * @param respStall number of cycles the CPU keeps resp.ready low after
    *                  resp.valid goes high (checks the cache holds its output).
    * @return the data, and the number of cycles the cache was busy with this
    *         request (accept cycle and response cycle both counted).
    */
  def read(addr: Long, respStall: Int = 0, maxCycles: Int = 500): ReadResult = {
    dut.io.req.valid.poke(true.B)
    dut.io.req.bits.addr.poke(addr.U)

    var accepted = false
    var cycles = 0
    var stalled = 0
    var seen: Option[BigInt] = None
    var result: Option[BigInt] = None

    while (result.isEmpty) {
      require(cycles < maxCycles, s"timeout waiting for the response to address 0x${addr.toHexString}")
      memDrive()

      val reqFire = !accepted && dut.io.req.ready.peekBoolean()

      val respValid = accepted && dut.io.resp.valid.peekBoolean()
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

      if (accepted || reqFire) cycles += 1
      if (reqFire) {
        accepted = true
        // The cache must have captured the address: drop it right after accept.
        dut.io.req.valid.poke(false.B)
        dut.io.req.bits.addr.poke(0.U)
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

  def withCache(c: CacheConfig, latency: Int = memLatency)(body: CacheHarness => Unit): Unit =
    test(new DirectMappedReadCache(c)) { dut => body(new CacheHarness(dut, c, latency)) }

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

  // ------------------------------------------------------------------ randomized, several geometries
  val configs = Seq(
    "default (4 KiB, 16 B lines, 4 B beats)" -> CacheConfig(),
    "one beat per line (wide memory bus)" -> CacheConfig(memBeatBytes = 16),
    "long lines (8 beats)" -> CacheConfig(lineBytes = 32),
    "tiny cache (4 lines, many conflicts)" -> CacheConfig(capacityBytes = 64),
    "8-byte words" -> CacheConfig(wordBytes = 8, memBeatBytes = 8)
  )

  for ((name, c) <- configs) {
    it should s"match a reference model on random reads: $name" in {
      withCache(c, latency = 1) { h =>
        val rnd = new Random(42)
        val ref = new RefCache(c)
        val span = c.capacityBytes * 4 // addresses reach 4x the cache size, so conflicts happen
        for (i <- 0 until 30) {
          val addr = (rnd.nextInt(span / c.wordBytes) * c.wordBytes).toLong
          val before = h.fetches.size
          val r = h.read(addr, respStall = rnd.nextInt(3))
          val hit = ref.access(addr)
          assert(r.data == h.expectedWord(addr), s"read #$i of 0x${addr.toHexString}: wrong data")
          val newFetches = h.fetches.size - before
          assert(newFetches == (if (hit) 0 else 1), s"read #$i of 0x${addr.toHexString}: expected hit=$hit")
        }
      }
    }
  }
}