package memory

import chisel3._
import chisel3.util._
import soc._

/*
* ScratchPadMem behind an parameterized induced latency. Ack comes latency+1 cycles after the request.
* Latency of 0 implies default scratchpad behavior, i.e. ack comes 1 cycle after the request.
* Models a slow main memory (MM) to exhibit realistic behavior of cache.
*/
class DelayedMem(latency: Int, nrBytes: Int) extends PipeConDevice(32) {
    require(latency >= 0, "latency must be non-negative")
    require(nrBytes > 0 && isPow2(nrBytes), "nrBytes must be positive and power of 2")

    val dmem = Module(new ScratchPadMem(Array.fill(16)(0), nrBytes))

    val busy = RegInit(false.B)
    val counter = RegInit(0.U(log2Ceil(latency + 2).W))
    val dataReg = Reg(UInt(32.W))

    // Forward the request to the real memory only when a new one arrives.
    val accept = !busy && (cpuPort.rd || cpuPort.wr)
    dmem.cpuPort.address := cpuPort.address
    dmem.cpuPort.wrData := cpuPort.wrData
    dmem.cpuPort.wrMask := cpuPort.wrMask
    dmem.cpuPort.rd := cpuPort.rd && accept
    dmem.cpuPort.wr := cpuPort.wr && accept
    when(dmem.cpuPort.ack) { dataReg := dmem.cpuPort.rdData } // Store the data from the memory when it is ready, to be returned after the latency.

    when(accept) {
        busy := true.B
        counter := latency.U
    }.elsewhen(busy) {
        when(counter === 0.U) {
            busy := false.B
        }.otherwise {
            counter := counter - 1.U // busy is still true here.
        }
    }

    cpuPort.ack := busy && (counter === 0.U) // as soon as counter reaches 0, we can acknowledge the request, and return the data from the memory, then busy will be set to false in the next cycle.
    // At zero added latency, the synchronous memory result is ready with ack;
    // dataReg captures that result only at the following edge.
    cpuPort.rdData := (if (latency == 0) dmem.cpuPort.rdData else dataReg)
}
