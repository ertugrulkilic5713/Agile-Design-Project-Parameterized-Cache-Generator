package wildcat.pipeline

import chisel3._
import chisel3.util._

import memory._
import soc._
import cache._
import adapter._

import device._

class LittleCat(file: String, frequency: Int = 100000000, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val out = Output(UInt(16.W))   // 16 LEDs
    val in = Input(UInt(2.W))
    val rx = Input(UInt(1.W))
    val tx = Output(UInt(1.W))
    val rxConf = Input(UInt(1.W))
    val txConf = Output(UInt(1.W))
  })
  io.txConf := 0.U

  // ---- test program, baked into the ROM ----
  // t0 = 0xF0010000 (LED device); loop: t1++, write t1 to LEDs,
  // do 4 loads through the cache, busy-wait ~2M iterations, repeat.
  // val program = Array(
  //   0xF00102B7, // lui  t0, 0xF0010 // loads memory-mapped address of the LED device (0xF0010000) into reg t0.
  //   0x00000313, // addi t1, x0, 0 // addi t1, x0, 0: initializes t1 to 0. This will act as the SW counter.
  //   0x00130313, // loop: addi t1, t1, 1 // adds 1 to the counter.
  //   0x0062A023, // sw   t1, 0(t0) // stores the value of the counter t1 into the LED memory address t0. This instantly updates the physical LEDs on board.
  //   0x00002383, // lw   t2, 0(x0) // following 4 lw instructions read data from MM addresses 0, 4, 16, and 32, dumping the result into reg t2. 
  //   0x00402383, // lw   t2, 4(x0) // The program does not care about the data; this is designed purely to trigger mix of cache misses and cache hits to test adapter.
  //   0x01002383, // lw   t2, 16(x0) 
  //   0x02002383, // lw   t2, 32(x0)
  //   0x00200E37, // lui  t3, 0x200 // sets up delay. 0x200 << 12 = 0x00200000 = 2.097.152 in decimal stored in reg t3.
  //   0xFFFE0E13, // delay: addi t3, t3, -1 // subtracts 1 from reg t3.
  //   0xFE0E1EE3, // bne  t3, x0, delay // it checks if t3 == x0 (hardcoded to 0). If t3 != 0, CPU decremants t3 again in delay.
  //   0xFDDFF06F  // jal  x0, loop // jump back unconditionally to very top of program loop.
  // )
  //

  val (program, start) = wildcat.Util.getCode(file)

  val cpu = Module(new ThreeCats())

  val imem = Module(new InstructionROM(program))
  cpu.io.imem <> imem.cpuPort

  // ---- data memory behind the cache ----
  val cacheAdapter = Module(new CacheAdapter(CacheConfig()))
  val csMem = cpu.io.dmem.address(31, 28) === 0.U
  cacheAdapter.cpuPort.address := cpu.io.dmem.address
  cacheAdapter.cpuPort.wrData := cpu.io.dmem.wrData
  cacheAdapter.cpuPort.wrMask := cpu.io.dmem.wrMask
  cacheAdapter.cpuPort.rd := csMem && cpu.io.dmem.rd
  cacheAdapter.cpuPort.wr := csMem && cpu.io.dmem.wr

  val dmem = Module(new ScratchPadMem(Array.fill(16)(0), 4096))
  dmem.cpuPort <> cacheAdapter.mem_port

  // ---- LED device at 0xF0010000 ----
  class IODevice() extends PipeConDevice(32) {
    val io = IO(new Bundle {
      val out = Output(UInt(16.W))
      val in = Input(UInt(2.W))
    })
    val outReg = RegInit(0.U(16.W))
    when(cpuPort.wr) { outReg := cpuPort.wrData(15, 0) }
    cpuPort.rdData := RegNext(RegNext(io.in))
    cpuPort.ack := RegNext(cpuPort.rd || cpuPort.wr, false.B)
    io.out := outReg
  }
  val memAddressReg = RegEnable(cpu.io.dmem.address, 0.U, cpu.io.dmem.rd)
  val csIO = cpu.io.dmem.address(31, 28) === 0xf.U
  val csIOReg = memAddressReg(31, 28) === 0xf.U
  val csIODev = csIO && cpu.io.dmem.address(19, 16) === 1.U
  val muxIODev = csIOReg && memAddressReg(19, 16) === 1.U

  val ioDevice = Module(new IODevice())
  ioDevice.io.in := io.in
  ioDevice.cpuPort <> cpu.io.dmem
  ioDevice.cpuPort.rd := csIODev && cpu.io.dmem.rd
  ioDevice.cpuPort.wr := csIODev && cpu.io.dmem.wr

  cpu.io.dmem.rdData := cacheAdapter.cpuPort.rdData
  when(muxIODev) { cpu.io.dmem.rdData := ioDevice.cpuPort.rdData }
  cpu.io.dmem.ack := cacheAdapter.cpuPort.ack || ioDevice.cpuPort.ack


  val heartbeat = RegInit(0.U(27.W))
  heartbeat := heartbeat + 1.U

  val hitCount = RegInit(0.U(32.W))
  val missCount = RegInit(0.U(32.W))
  when(cacheAdapter.debug_hit) { hitCount := hitCount + 1.U }
  when(cacheAdapter.debug_miss) { missCount := missCount + 1.U }

  // SW0 down: LED0-14 = software counter.  SW0 up: LED0-7 = hits, LED8-14 = misses.
  val stats = Cat(missCount(6,0), hitCount(7,0))
  io.out := Cat(heartbeat(26), Mux(io.in(0), stats, ioDevice.io.out(14, 0)))

  val statsUART = Module(new StatsUART(frequency, baudRate, frequency / 10))
  statsUART.io.hits := hitCount
  statsUART.io.misses := missCount
  io.tx := statsUART.io.txd


  // ---- LEDs: LED15 = heartbeat (proves the clock works), LED0..14 = software counter ----
  // val heartbeat = RegInit(0.U(27.W))
  // heartbeat := heartbeat + 1.U
  // io.out := Cat(heartbeat(26), ioDevice.io.out(14, 0))
}

object LittleCat extends App {
  val file = if (args.length > 0) args(0) else "a.out"
  emitVerilog(new LittleCat(file), Array("--target-dir", "generated"))
}
