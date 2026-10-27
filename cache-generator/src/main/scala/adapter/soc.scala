// The following files are derived from t-crest/soc-comm
// (https://github.com/t-crest/soc-comm), licensed under BSD-2-Clause:
//   - src/main/scala/.../PipeCon.scala
//   - src/main/scala/.../PipeConDevice.scala
// Modified for Chisel 6.7.0 / Scala 2.13.

package soc

import chisel3._
/**
 * A simple IO interface, as seen from the slave.
 * ack is used for acknowledgement in the following clock cycle, or later. (like OCPcore in Patmos).
 * Can be used to stall the CPU.
 *
 * @param addrWidth width of the address part
 */
class PipeConIO(private val addrWidth: Int) extends Bundle {
  val address = Input(UInt(addrWidth.W))
  val rd = Input(Bool())
  val wr = Input(Bool())
  val rdData = Output(UInt(32.W))
  val wrData = Input(UInt(32.W))
  val wrMask = Input(UInt(4.W))
  val ack = Output(Bool())
}

object PipeConIO {
  def apply(addrWidth: Int): PipeConIO = new PipeConIO(addrWidth)
}

/**
  * Just a CPU interface, without any additional connection.
  *
  */
abstract class PipeConDevice(addrWidth: Int) extends Module {

  val cpuPort = IO(new PipeConIO(addrWidth))

  // CHANGED TO NOT COMPILE THEN RUN
  require(addrWidth >= 2, "Address width needs some size for byte addresses")
}


