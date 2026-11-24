package wildcat.pipeline

import chisel3._
import chisel3.util._

import memory._
import soc._
import cache._
import adapter._

import device._

class LittleCat(file: String, cfg: CacheConfig = CacheConfig(), frequency: Int = 100000000, baudRate: Int = 115200, mmlatency: Int = 0, nrBytes: Int = 16384) extends Module {
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

  // val dmem = Module(new ScratchPadMem(Array.fill(16)(0), 16384))
  val dmem = Module(new DelayedMem(mmlatency, nrBytes))
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

  val perf = Module(new PerfCounters(CacheState.all.length))
  perf.io.hit := cacheAdapter.debug_hit
  perf.io.miss := cacheAdapter.debug_miss
  perf.io.writeback := cacheAdapter.debug_writeback
  perf.io.writeThrough := cacheAdapter.debug_write_through
  perf.io.state := cacheAdapter.debug_state
  val reqBusy = RegInit(false.B)
  perf.io.reqStart := !reqBusy && (cacheAdapter.cpuPort.rd || cacheAdapter.cpuPort.wr)
  perf.io.reqIsWrite := cacheAdapter.cpuPort.wr
  perf.io.ack := cacheAdapter.cpuPort.ack
  when(perf.io.reqStart) { reqBusy := true.B }
  when(cacheAdapter.cpuPort.ack) { reqBusy := false.B }

  // SW0 down: LED0-14 = software counter.  SW0 up: LED0-7 = hits, LED8-14 = misses.
  val stats = Cat(missCount(6,0), hitCount(7,0))
  io.out := Cat(heartbeat(26), Mux(io.in(0), stats, ioDevice.io.out(14, 0)))

  val statsUART = Module(new StatsUART(frequency, baudRate, frequency / 10, perf.io.words.length))
  // statsUART.io.hits := hitCount
  // statsUART.io.misses := missCount
  statsUART.io.words := perf.io.words
  io.tx := statsUART.io.txd
}

object LittleCat extends App {
  val file = if (args.length > 0) args(0) else "a.out"
  val policy = if (args.length > 1) args(1) else "wb"
  val capacity = if (args.length > 2) args(2).toInt else 4096
  val linesize = if (args.length > 3) args(3).toInt else 16

  val ways = if (args.length > 4) args(4).toInt else 1

  val seed = if (args.length > 6) BigInt(args(6)) else BigInt(1)
  val mmlatency = if (args.length > 7) args(7).toInt else 0
  val mmBytes = if (args.length > 8) args(8).toInt else 16384

  val targetDir = if (args.length > 9) args(9) else "generated"

  val cfg = CacheConfig(
    writePolicy = policy match {
      case "wt" => WriteThrough
      case "wb" => WriteBack
      case other => throw new IllegalArgumentException(s"unknown cache policy '$other', use either wt or wb.")
    },
    capacityBytes = capacity,
    lineBytes = linesize,
    numWays = ways,
    replacementPolicy = if (args.length > 5) ReplacementPolicy.parse(args(5)) else RoundRobin,
    lfsrSeed = seed
  )

  println(s"LittleCat: Program=$file | cache=$policy | capacity=$capacity | linesize=$linesize | ways=$ways | replacement=${cfg.replacementPolicy}")
  println(s"-------------------------------CACHE CONFIG----------------------------------")
  println(s"# LINES = ${capacity/linesize}")
  println(s"# SETS = ${cfg.numSets}, WAYS = ${cfg.numWays}")
  println(s"DATA BLOCKS PER LINE = ${cfg.beatsPerLine}")
  println(s"DATA BLOCKS SIZE = 8*${linesize} = ${8*linesize} Bits")
  println(s"------------------------------ADDRESS----------------------------------------")
  println(s"For a address width of 32 bits: [TAG | INDEX | WORDIDX | BYTEOFFSET]")
  println(s"TAG BIT = ${cfg.tagBits}")
  println(s"INDEX BIT = ${cfg.indexBits}")
  println(s"BYTEOFFSET + WORDIDX = ${log2Ceil(linesize)}")
  println(s"-------------------------------DATA & OVERHEAD-------------------------------")
  val replacementBits = if (cfg.numWays == 1) 0 else cfg.replacementPolicy match {
    case RoundRobin => cfg.numSets * cfg.wayBits
    case RandomReplacement => math.max(16, cfg.wayBits + 1)
    case TreePLRU => cfg.numSets * (cfg.numWays - 1)
  }
  val overheadBits = cfg.numLines * (cfg.tagBits + 2) + replacementBits
  val totalBits = cfg.capacityBytes * 8 + overheadBits
  println(s"TOTAL DATA = ${8*capacity} Bits")
  println(s"TOTAL OVERHEAD = $overheadBits Bits (includes $replacementBits replacement bits)")
  println(s"--------------------------------DATA + OVERHEAD------------------------------")
  println(s"TOTAL BITS = $totalBits Bits")
  println(s"TOTAL BYTES = ${(totalBits + 7)/8} Bytes")
  emitVerilog(new LittleCat(file, cfg, mmlatency = mmlatency, nrBytes = mmBytes), Array("--target-dir", targetDir))
}
