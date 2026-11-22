package device

import chisel3._
import chisel3.util._
import cache.CacheState

class PerfCounters(nStates: Int) extends Module {
  val io = IO(new Bundle {
    val hit = Input(Bool()); val miss = Input(Bool())
    val writeback_wb = Input(Bool()); val write_wt = Input(Bool())
    val state = Input(UInt(log2Ceil(nStates).W))
    val reqStart = Input(Bool()); val reqIsWrite = Input(Bool()); val ack = Input(Bool())
    val words = Output(Vec(8 + nStates, UInt(32.W)))
  })
  def counter(inc: Bool, by: UInt = 1.U): UInt = {
    val r = RegInit(0.U(32.W)); when(inc) { r := r + by }; r
  }
  val hits = counter(io.hit)
  val misses = counter(io.miss)
  val wbs = counter(io.writeback_wb)
  val wts = counter(io.write_wt)
  val stores = counter(io.reqStart && io.reqIsWrite)

  // latency of each request, binned by whether it missed
  val busy = RegInit(false.B)
  val lat = RegInit(0.U(16.W))
  val missed = RegInit(false.B)
  when(io.reqStart) { busy := true.B; lat := 1.U; missed := false.B }
    .elsewhen(busy) { lat := lat + 1.U }
  when(io.miss) { missed := true.B }
  when(io.ack) { busy := false.B }
  val hitCycles = counter(io.ack && !missed, lat)
  val missCycles = counter(io.ack && missed, lat)
  val cycles = counter(true.B) // total elapsed

  // cycles spent in each cache state
  val stateCycles = VecInit((0 until nStates).map(s => counter(io.state === s.U)))

  io.words := VecInit(Seq(hits, misses, wbs, wts, stores, hitCycles, missCycles, cycles) ++ stateCycles)
}