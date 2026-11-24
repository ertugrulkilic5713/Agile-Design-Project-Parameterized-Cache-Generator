package device

import chisel3._
import chiseltest._
import cache.CacheState
import org.scalatest.flatspec.AnyFlatSpec

class TelemetrySpec extends AnyFlatSpec with ChiselScalatestTester {
  it should "count requests and cycles using all canonical cache states" in {
    test(new PerfCounters(CacheState.all.length)) { dut =>
      dut.io.reqStart.poke(true.B)
      dut.io.reqIsWrite.poke(true.B)
      dut.io.ack.poke(false.B)
      dut.io.hit.poke(true.B)
      dut.io.miss.poke(false.B)
      dut.io.writeback.poke(false.B)
      dut.io.writeThrough.poke(false.B)
      dut.io.state.poke(CacheState.sCompare.litValue.U)
      dut.clock.step()
      dut.io.reqStart.poke(false.B)
      dut.io.hit.poke(false.B)
      dut.io.ack.poke(true.B)
      dut.clock.step()
      dut.io.ack.poke(false.B)
      dut.io.reqStart.poke(true.B)
      dut.io.reqIsWrite.poke(false.B)
      dut.io.miss.poke(true.B)
      dut.io.state.poke(CacheState.sRefillReq.litValue.U)
      dut.clock.step()
      dut.io.reqStart.poke(false.B)
      dut.io.miss.poke(false.B)
      dut.io.writeback.poke(true.B)
      dut.io.state.poke(CacheState.sWritebackWait.litValue.U)
      dut.clock.step()
      dut.io.writeback.poke(false.B)
      dut.io.ack.poke(true.B)
      dut.io.state.poke(CacheState.sRespond.litValue.U)
      dut.clock.step()

      assert(dut.io.words.length == 19)
      for ((expected, i) <- Seq(1, 1, 1, 0, 1, 1, 2, 5).zipWithIndex)
        dut.io.words(i).expect(expected.U)
      dut.io.words(8 + CacheState.sCompare.litValue.toInt).expect(2.U)
      dut.io.words(8 + CacheState.sWritebackWait.litValue.toInt).expect(1.U)
      assert((8 until 19).map(i => dut.io.words(i).peekInt()).sum == 5)
    }
  }

  it should "transmit all 19 telemetry words in little-endian order" in {
    val nWords = 8 + CacheState.all.length
    test(new StatsUART(frequency = 80, baudRate = 10, periodCycles = 32, nWords = nWords)) { dut =>
      dut.clock.setTimeout(20000)
      val words = (0 until nWords).map(i => BigInt("12345600", 16) + i)
      for ((word, i) <- words.zipWithIndex) dut.io.words(i).poke(word.U)
      val expected = Seq(0xaa) ++ words.flatMap(w => (0 until 4).map(i => ((w >> (8 * i)) & 255).toInt))
      val received = expected.map { _ =>
        var waited = 0
        while (dut.io.txd.peekInt() != 0 && waited < 1000) {
          dut.clock.step()
          waited += 1
        }
        assert(waited < 1000, "UART did not start the next byte")
        dut.clock.step(4)
        dut.io.txd.expect(0.U)
        val byte = (0 until 8).foldLeft(0) { (value, bit) =>
          dut.clock.step(8)
          value | (dut.io.txd.peekInt().toInt << bit)
        }
        dut.clock.step(8)
        dut.io.txd.expect(1.U)
        dut.clock.step(8)
        dut.io.txd.expect(1.U)
        dut.clock.step(4)
        byte
      }
      assert(received == expected)
    }
  }
}
