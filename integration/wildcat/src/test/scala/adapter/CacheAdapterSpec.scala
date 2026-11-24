package adapter

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import cache._

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

  for (ways <- Seq(1, 2, 4); replacement <- Seq(RoundRobin, TreePLRU, RandomReplacement)) {
    it should s"refill a line on a read miss and serve later hits without memory traffic ($ways ways, $replacement)" in {
      val cfg = CacheConfig(capacityBytes = 128, numWays = ways, writePolicy = WriteBack, replacementPolicy = replacement)
      test(new CacheAdapter(cfg)) { dut =>
        val mem = new PipeConMemory(dut, responseDelay = 2)
        val a = 0x100L
        assert(mem.access(a + 4) == mem.word(a + 4))
        assert(mem.reads.toSeq == Seq(a, a + 4, a + 8, a + 12))
        assert(mem.access(a + 8) == mem.word(a + 8))
        assert(mem.reads.size == 4)
      }
    }

    it should s"write back every dirty beat before refilling a conflicting line ($ways ways, $replacement)" in {
      val cfg = CacheConfig(capacityBytes = 128, numWays = ways, writePolicy = WriteBack, replacementPolicy = replacement)
      test(new CacheAdapter(cfg)) { dut =>
        val mem = new PipeConMemory(dut, responseDelay = 1)
        val a = 0x100L
        val b = a + ways * cfg.capacityBytes
        val stored = BigInt("cafebabe", 16)
        mem.access(a + 4, write = true, data = stored)
        assert(mem.writes.isEmpty)
        for (w <- 1 until ways)
          mem.access(a + w * cfg.capacityBytes + 4, write = true, data = stored + w)
        assert(mem.writes.isEmpty)
        mem.access(b)
        val victimWay = if (replacement == RandomReplacement && ways > 1) 1 else 0
        val victim = a + victimWay * cfg.capacityBytes
        assert(mem.writes.map(_.addr).toSeq == Seq(victim, victim + 4, victim + 8, victim + 12))
        assert(mem.writes.forall(_.mask == 15))
        assert(mem.word(victim + 4) == stored + victimWay)
        assert(mem.access(victim + 4) == stored + victimWay)
      }
    }

    it should s"write through masked hits and misses without allocating a write miss ($ways ways, $replacement)" in {
      val cfg = CacheConfig(capacityBytes = 128, numWays = ways, writePolicy = WriteThrough, replacementPolicy = replacement)
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
  for (ways <- Seq(2, 4); sets <- Seq(1, 2)) {
    it should s"complete all memory writes before refilling while evicting all $ways dirty ways with $sets sets" in {
      val cfg = CacheConfig(capacityBytes = ways * sets * 16, numWays = ways, writePolicy = WriteBack)
      test(new CacheAdapter(cfg)) { dut =>
        val mem = new PipeConMemory(dut, responseDelay = 3)
        val a = 0x110L
        val stride = cfg.numSets * cfg.lineBytes
        for (w <- 0 until ways) {
          mem.access(a + w * stride + 4, write = true,
            data = BigInt(0xaabb0000L + w), mask = 3)
        }
        assert(mem.writes.isEmpty)
        for (w <- 0 until ways) {
          mem.access(a + (ways + w) * stride)
          assert(mem.writes.takeRight(cfg.beatsPerLine).map(_.addr).toSeq ==
            (0 until cfg.beatsPerLine).map(i => a + w * stride + i * cfg.memBeatBytes))
          assert(mem.writes.forall(_.mask == 15))
          assert((mem.word(a + w * stride + 4) & 0xffff) == w)
          for (other <- w + 1 until ways) {
            val before = mem.reads.size
            assert((mem.access(a + other * stride + 4) & 0xffff) == other)
            assert(mem.reads.size == before)
          }
        }
        assert(mem.writes.size == ways * cfg.beatsPerLine)
        for (w <- 0 until ways) assert((mem.access(a + w * stride + 4) & 0xffff) == w)
      }
    }
  }

}
