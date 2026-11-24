package memory

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class DelayedMemSpec extends AnyFlatSpec with ChiselScalatestTester {
  for (latency <- Seq(0, 1, 4)) {
    it should s"return current data and preserve masked writes with latency $latency" in {
      test(new DelayedMem(latency, 256)) { dut =>
        dut.cpuPort.rd.poke(false.B)
        dut.cpuPort.wr.poke(false.B)
        dut.cpuPort.address.poke(0.U)
        dut.cpuPort.wrData.poke(0.U)
        dut.cpuPort.wrMask.poke(0.U)

        def access(addr: Int, write: Boolean = false, data: BigInt = 0, mask: Int = 15): BigInt = {
          dut.cpuPort.address.poke(addr.U)
          dut.cpuPort.wrData.poke(data.U)
          dut.cpuPort.wrMask.poke(mask.U)
          dut.cpuPort.rd.poke((!write).B)
          dut.cpuPort.wr.poke(write.B)
          dut.clock.step()
          for (_ <- 0 until latency) {
            dut.cpuPort.ack.expect(false.B)
            dut.clock.step()
          }
          dut.cpuPort.ack.expect(true.B)
          val result = dut.cpuPort.rdData.peekInt()
          dut.clock.step()
          dut.cpuPort.rd.poke(false.B)
          dut.cpuPort.wr.poke(false.B)
          dut.clock.step()
          dut.cpuPort.ack.expect(false.B)
          result
        }

        access(0, write = true, data = BigInt("12345678", 16))
        access(4, write = true, data = BigInt("aabbccdd", 16))
        assert(access(0) == BigInt("12345678", 16))
        assert(access(4) == BigInt("aabbccdd", 16))
        access(0, write = true, data = BigInt("0000eeff", 16), mask = 3)
        assert(access(0) == BigInt("1234eeff", 16))
      }
    }
  }
}
