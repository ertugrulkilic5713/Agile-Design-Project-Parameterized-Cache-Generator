package device

import chisel3._
import chisel3.util._
import chisel.lib.uart._

// This module acts as a HW telemetry reporter. It periodically takes a snapshow of the cache's performance counters
// hits and misses, and transmits them over a serial cable using to a host using UART.

// Every periodCycles cycles, sends a 1 + 4 * nWords byte frame.
//
class StatsUART(frequency: Int, baudRate: Int, periodCycles: Int, nWords: Int) extends Module {
  val io = IO(new Bundle {
    val words = Input(Vec(nWords, UInt(32.W)))
    val txd = Output(UInt(1.W))
  })

  val frameLen = 1 + 4 * nWords

  val tx = Module(new BufferedTx(frequency, baudRate))
  io.txd := tx.io.txd

  val timer = RegInit(0.U(log2Ceil(periodCycles).W))
  val frame = Reg(Vec(frameLen, UInt(8.W)))
  val idx = RegInit(0.U(log2Ceil(frameLen + 1).W))
  val sending = RegInit(false.B)

  tx.io.channel.valid := false.B
  tx.io.channel.bits := frame(idx)

  when(!sending) {
    timer := timer + 1.U
    when(timer === (periodCycles - 1).U) {
      timer := 0.U
      frame(0) := 0xAA.U
      for (w <- 0 until nWords; i <- 0 until 4) {
        frame(1 + 4 * w + i) := io.words(w)(8*i + 7, 8*i)
      }
      idx := 0.U
      sending := true.B
    }
  }.otherwise {
    tx.io.channel.valid := true.B
    when(tx.io.channel.ready) {
      idx := idx + 1.U
      when(idx === (frameLen - 1).U) {
        sending := false.B
      }
    }
  }

}
