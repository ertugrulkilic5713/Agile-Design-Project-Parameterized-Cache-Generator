package adapter

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import cache.{CacheConfig, WriteBack, WriteThrough}

import scala.collection.mutable.{ArrayBuffer, Map}

case class ObservedWrite(addr: Long, data: BigInt, mask: BigInt)

class PipeConMemory(dut: CacheAdapter, responseDelay: Int = 0) {
  val reads = ArrayBuffer[Long]()
  val writes = ArrayBuffer[ObservedWrite]()
  private val words = Map[Long, BigInt]()
  private var pending: Option[(Boolean, Long, BigInt, BigInt, Int)] = None

  dut.cpuPort.rd.poke(false.B)
  dut.cpuPort.wr.poke(false.B)
  dut.cpuPort.address.poke(0.U)
  dut.cpuPort.wrData.poke(0.U)
  dut.cpuPort.wrMask.poke(0.U)
  dut.mem_port.ack.poke(false.B)
  dut.mem_port.rdData.poke(0.U)

  private def initialWord(addr: Long): BigInt = BigInt(addr ^ 0x5a5a1234L) & BigInt("ffffffff", 16)
  def word(addr: Long): BigInt = words.getOrElse(addr, initialWord(addr))

  private def merge(old: BigInt, data: BigInt, mask: BigInt): BigInt =
    (0 until 4).foldLeft(old) { (result, byte) =>
      if (((mask >> byte) & 1) == 0) result
      else (result & ~(BigInt(0xff) << (8 * byte))) | (((data >> (8 * byte)) & 0xff) << (8 * byte))
    }

  private def driveMemory(): Unit = {
    dut.mem_port.ack.poke(false.B)
    pending match {
      case None if dut.mem_port.rd.peekBoolean() || dut.mem_port.wr.peekBoolean() =>
        pending = Some((
          dut.mem_port.wr.peekBoolean(),
          dut.mem_port.address.peekInt().toLong,
          dut.mem_port.wrData.peekInt(),
          dut.mem_port.wrMask.peekInt(),
          responseDelay
        ))
      case Some((wr, addr, data, mask, delay)) if delay > 0 =>
        pending = Some((wr, addr, data, mask, delay - 1))
      case Some((wr, addr, data, mask, _)) =>
        if (wr) {
          words(addr) = merge(word(addr), data, mask)
          writes += ObservedWrite(addr, data, mask)
        } else {
          dut.mem_port.rdData.poke(word(addr).U)
          reads += addr
        }
        dut.mem_port.ack.poke(true.B)
        pending = None
      case _ =>
    }
  }

  def access(addr: Long, write: Boolean = false, data: BigInt = 0, mask: BigInt = 15,
      maxCycles: Int = 300): BigInt = {
    dut.cpuPort.address.poke(addr.U)
    dut.cpuPort.wrData.poke(data.U)
    dut.cpuPort.wrMask.poke(mask.U)
    dut.cpuPort.rd.poke((!write).B)
    dut.cpuPort.wr.poke(write.B)

    var result: Option[BigInt] = None
    var cycles = 0
    while (result.isEmpty) {
      require(cycles < maxCycles, s"adapter timed out for address 0x${addr.toHexString}")
      driveMemory()
      if (dut.cpuPort.ack.peekBoolean()) result = Some(dut.cpuPort.rdData.peekInt())
      dut.clock.step()
      cycles += 1
    }
    dut.cpuPort.rd.poke(false.B)
    dut.cpuPort.wr.poke(false.B)
    dut.mem_port.ack.poke(false.B)
    dut.clock.step()
    result.get
  }
}

class CacheAdapterSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "CacheAdapter"

  it should "refill a line on a read miss and serve later hits without memory traffic" in {
    val cfg = CacheConfig(capacityBytes = 64, writePolicy = WriteBack)
    test(new CacheAdapter(cfg)) { dut =>
      val mem = new PipeConMemory(dut, responseDelay = 2)
      val a = 0x100L
      assert(mem.access(a + 4) == mem.word(a + 4))
      assert(mem.reads.toSeq == Seq(a, a + 4, a + 8, a + 12))
      assert(mem.access(a + 8) == mem.word(a + 8))
      assert(mem.reads.size == 4)
    }
  }

  it should "write back every dirty beat before refilling a conflicting line" in {
    val cfg = CacheConfig(capacityBytes = 64, writePolicy = WriteBack)
    test(new CacheAdapter(cfg)) { dut =>
      val mem = new PipeConMemory(dut, responseDelay = 1)
      val a = 0x100L
      val b = a + cfg.capacityBytes
      val stored = BigInt("cafebabe", 16)
      mem.access(a + 4, write = true, data = stored)
      assert(mem.writes.isEmpty)
      mem.access(b)
      assert(mem.writes.map(_.addr).toSeq == Seq(a, a + 4, a + 8, a + 12))
      assert(mem.writes.forall(_.mask == 15))
      assert(mem.word(a + 4) == stored)
      assert(mem.access(a + 4) == stored)
    }
  }

  it should "write through masked hits and misses without allocating a write miss" in {
    val cfg = CacheConfig(capacityBytes = 64, writePolicy = WriteThrough)
    test(new CacheAdapter(cfg)) { dut =>
      val mem = new PipeConMemory(dut, responseDelay = 2)
      val a = 0x180L
      val before = mem.word(a)
      mem.access(a, write = true, data = BigInt("11223344", 16), mask = 3)
      assert(mem.reads.isEmpty)
      assert(mem.writes.toSeq == Seq(ObservedWrite(a, BigInt("11223344", 16), 3)))
      val firstExpected = (before & BigInt("ffff0000", 16)) | BigInt("00003344", 16)
      assert(mem.word(a) == firstExpected)

      assert(mem.access(a) == firstExpected)
      assert(mem.reads.size == cfg.beatsPerLine)
      mem.access(a, write = true, data = BigInt("aabbccdd", 16), mask = 12)
      val finalExpected = BigInt("aabb3344", 16)
      assert(mem.word(a) == finalExpected)
      assert(mem.access(a) == finalExpected)
      assert(mem.reads.size == cfg.beatsPerLine)
    }
  }
}
