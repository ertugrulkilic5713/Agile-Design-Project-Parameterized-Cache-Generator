package wildcat.pipeline

import chisel3._
import chisel3.util._

import memory._
import soc._
import cache._
import adapter._

import device._

class LittleCat(file: String, cfg: CacheConfig = CacheConfig(), frequency: Int = 100000000, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val out = Output(UInt(16.W))   // 16 LEDs
    val in = Input(UInt(2.W))
    val rx = Input(UInt(1.W))
    val tx = Output(UInt(1.W))
    val rxConf = Input(UInt(1.W))
    val txConf = Output(UInt(1.W))
  })
  io.txConf := 0.U

  val (program, start) = wildcat.Util.getCode(file)

  val cpu = Module(new ThreeCats())

  val imem = Module(new InstructionROM(program))
  cpu.io.imem <> imem.cpuPort

  // ---- data memory behind the cache ----
  val cacheAdapter = Module(new CacheAdapter(cfg))
  val csMem = cpu.io.dmem.address(31, 28) === 0.U
  cacheAdapter.cpuPort.address := cpu.io.dmem.address
  cacheAdapter.cpuPort.wrData := cpu.io.dmem.wrData
  cacheAdapter.cpuPort.wrMask := cpu.io.dmem.wrMask
  cacheAdapter.cpuPort.rd := csMem && cpu.io.dmem.rd
  cacheAdapter.cpuPort.wr := csMem && cpu.io.dmem.wr

  val dmem = Module(new ScratchPadMem(Array.fill(16)(0), 16384))
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
}

object LittleCat extends App {
  val file = if (args.length > 0) args(0) else "a.out"
  val policy = if (args.length > 1) args(1) else "wb"
  val capacity = if (args.length > 2) args(2).toInt else 4096
  val linesize = if (args.length > 3) args(3).toInt else 16

  val cfg = CacheConfig(
    writePolicy = policy match {
      case "wt" => WriteThrough
      case "wb" => WriteBack
      case other => throw new IllegalArgumentException(s"uknown cache policy '$other', use either wt or wb.")
    },
    capacityBytes = capacity,
    lineBytes = linesize  
  )
  println(s"LittleCat: Program=$file | cache=$policy | capacity=$capacity | linesize=$linesize")
  println(s"-------------------------------CACHE CONFIG----------------------------------")
  println(s"# LINES = ${capacity/linesize}")
  println(s"DATA BLOCKS PER LINE = ${cfg.beatsPerLine}")
  println(s"DATA BLOCKS SIZE = 8*${linesize} = ${8*linesize} Bits")
  println(s"------------------------------ADDRESS----------------------------------------")
  println(s"For a address width of 32 bits: [TAG | INDEX | BYTEOFFSET | WORDIDX]")
  println(s"TAG BIT = ${32 - log2Ceil(capacity)}")
  println(s"INDEX BIT = ${log2Ceil(capacity) - log2Ceil(linesize)}")
  println(s"BYTEOFFSET + WORDIDX = ${log2Ceil(linesize)}")
  println(s"-------------------------------DATA & OVERHEAD-------------------------------")
  println(s"TOTAL DATA = ${8*capacity} Bits")
  println(s"TOTAL OVERHEAD = ${(capacity/linesize)*(34 - log2Ceil(capacity))} Bits")
  println(s"--------------------------------DATA + OVERHEAD------------------------------")
  println(s"TOTAL BITS = ${8*capacity + (capacity/linesize)*(34 - log2Ceil(capacity))} Bits")
  println(s"TOTAL BYTES = ${(8*capacity + (capacity/linesize)*(34 - log2Ceil(capacity)))/8} Bytes")
  emitVerilog(new LittleCat(file, cfg), Array("--target-dir", "generated"))
}
