package device

import chisel3._
import chisel3.util._
import chisel.lib.uart._

// This module acts as a HW telemetry reporter. It periodically takes a snapshow of the cache's performance counters
// hits and misses, and transmits them over a serial cable using to a host using UART.

// Every periodCycles cycles, sends a 9-byte frame.
//
class StatsUART(frequency: Int, baudRate: Int, periodCycles: Int) extends Module {
  val io = IO(new Bundle {
    val hits = Input(UInt(32.W))
    val misses = Input(UInt(32.W))
    val txd = Output(UInt(1.W))
  })


  val tx = Module(new BufferedTx(frequency, baudRate))
  io.txd := tx.io.txd

  val timer = RegInit(0.U(log2Ceil(periodCycles).W))
  val frame = Reg(Vec(9, UInt(8.W)))
  val idx = RegInit(0.U(4.W))
  val sending = RegInit(false.B)

  tx.io.channel.valid := false.B
  tx.io.channel.bits := frame(idx)

  when(!sending) {
    timer := timer + 1.U
    when(timer === (periodCycles - 1).U) {
      timer := 0.U
      frame(0) := 0xAA.U
      for (i <- 0 until 4) {
        frame(i + 1) := io.hits(8*i + 7, 8*i)
        frame(i + 5) := io.misses(8*i + 7, 8*i)
      }
      idx := 0.U
      sending := true.B
    }
  }.otherwise {
    tx.io.channel.valid := true.B
    when(tx.io.channel.ready) {
      idx := idx + 1.U
      when(idx === 8.U) { sending := false.B }
    }
  }

}
