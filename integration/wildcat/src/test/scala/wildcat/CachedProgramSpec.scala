package wildcat

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import chiseltest._
import adapter.CacheAdapter
import cache._
import memory.{DelayedMem, InstructionROM}
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.pipeline.ThreeCats

class CachedProgramTop(cfg: CacheConfig, latency: Int) extends Module {
  val io = IO(new Bundle {
    val registers = Output(Vec(32, UInt(32.W)))
    val stop = Output(Bool())
    val writebacks = Output(UInt(32.W))
  })
  val cpu = Module(new ThreeCats())
  val imem = Module(new InstructionROM(Array(
    0x12300093, // addi x1, x0, 0x123
    0x00102023, // sw x1, 0(x0)
    0x02002103, // lw x2, 32(x0): fill the other way of set zero
    0x04002103, // lw x2, 64(x0): evict the stored line
    0x00002183, // lw x3, 0(x0): reload from backing memory
    0x00018513, // addi x10, x3, 0
    0x00000073  // ecall
  )))
  val adapter = Module(new CacheAdapter(cfg))
  val memory = Module(new DelayedMem(latency, 256))
  cpu.io.imem <> imem.cpuPort
  adapter.cpuPort <> cpu.io.dmem
  memory.cpuPort <> adapter.mem_port

  val writebacks = RegInit(0.U(32.W))
  when(adapter.debug_writeback) { writebacks := writebacks + 1.U }
  io.writebacks := writebacks
  io.registers := DontCare
  BoringUtils.bore(cpu.debugRegs, Seq(io.registers))
  io.stop := DontCare
  BoringUtils.bore(cpu.stop, Seq(io.stop))
}

class CachedProgramSpec extends AnyFlatSpec with ChiselScalatestTester {
  for (policy <- Seq(WriteBack, WriteThrough);
       replacement <- Seq(RoundRobin, TreePLRU);
       latency <- Seq(0, 3)) {
    it should s"store, evict and reload through ThreeCats with $policy, $replacement and latency $latency" in {
      val cfg = CacheConfig(capacityBytes = 64, numWays = 2,
        writePolicy = policy, replacementPolicy = replacement)
      test(new CachedProgramTop(cfg, latency)) { dut =>
        var cycles = 0
        while (!dut.io.stop.peekBoolean() && cycles < 1000) {
          dut.clock.step()
          cycles += 1
        }
        assert(dut.io.stop.peekBoolean(), "program did not reach ecall")
        dut.io.registers(10).expect(0x123.U)
        if (policy == WriteBack) assert(dut.io.writebacks.peekInt() >= 1)
        else dut.io.writebacks.expect(0.U)
      }
    }
  }
}
