package adapter

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import cache.CacheConfig

class CacheAdapterSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "CacheAdapter"

  it should "translate a CPU read miss into a memory fetch and acknowledge the CPU" in {
    // Use a tiny config for fast testing: 4-byte lines, 4-byte beats (1 beat per line)
    val cfg = CacheConfig(capacityBytes = 64, lineBytes = 4, wordBytes = 4, memBeatBytes = 4)
    
    test(new CacheAdapter(cfg)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // 1. Initialize interface
      dut.cpuPort.rd.poke(false.B)
      dut.cpuPort.wr.poke(false.B)
      dut.mem_port.ack.poke(false.B)
      dut.clock.step(1)

      // 2. CPU requests a read
      dut.cpuPort.rd.poke(true.B)
      dut.cpuPort.address.poke(0x100.U)
      
      // Wait for the adapter to realize it's a miss and ask memory for data
      var cycles = 0
      while (!dut.mem_port.rd.peekBoolean() && cycles < 10) {
        dut.clock.step(1)
        cycles += 1
      }
      assert(dut.mem_port.rd.peekBoolean(), "Adapter did not issue memory read on cache miss")

      // THIS IS THE FIX: One cycle delay so the FSM safely reaches the 'memRead' state
      dut.clock.step(1)

      // 3. Main Memory responds with data
      dut.mem_port.ack.poke(true.B)
      dut.mem_port.rdData.poke(0xDEADBEEFL.U)
      dut.clock.step(1)
      dut.mem_port.ack.poke(false.B) // Memory drops ack

      // 4. Wait for Adapter to finish cache refill and ack the CPU
      cycles = 0
      while (!dut.cpuPort.ack.peekBoolean() && cycles < 10) {
        dut.clock.step(1)
        cycles += 1
      }
      
      assert(dut.cpuPort.ack.peekBoolean(), "Adapter did not ack the CPU after memory refill")
      assert(dut.cpuPort.rdData.peekInt() == 0xDEADBEEFL, "Adapter returned wrong data to CPU")
      
      dut.cpuPort.rd.poke(false.B) // CPU drops read request
      dut.clock.step(1)
    }
  }
}
