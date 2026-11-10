package adapter

import chisel3._
import chisel3.util._
import cache._
import soc.{PipeConDevice, PipeConIO}

/** Bridges Wildcat's PipeCon bus to the standalone cache's decoupled interfaces. */
class CacheAdapter(cfg: CacheConfig) extends PipeConDevice(32) {
  require(cfg.memBeatBytes == 4, "PipeCon is 32 bits wide")
  require(cfg.wordBytes == 4, "Wildcat words are 32 bits wide")
  require(cfg.addrWidth == 32, "Wildcat addresses are 32 bits wide")

  val cache = Module(new DirectMappedReadCache(cfg))
  val mem_port = IO(Flipped(new PipeConIO(32)))

  val debug_cpu_state = IO(Output(UInt(2.W)))
  val debug_mem_state = IO(Output(UInt(3.W)))
  val debug_hit = IO(Output(Bool()))
  val debug_miss = IO(Output(Bool()))
  val debug_writeback = IO(Output(Bool()))
  val debug_write_through = IO(Output(Bool()))
  debug_hit := cache.io.stat.hit
  debug_miss := cache.io.stat.miss
  debug_writeback := cache.io.stat.writeback
  debug_write_through := cache.io.stat.writeThrough

  val cpuIdle :: cpuWait :: Nil = Enum(2)
  val cpuState = RegInit(cpuIdle)
  val cpuReq = Reg(new CacheReq(cfg))
  val requestAccepted = RegInit(false.B)
  val requestNow = Wire(new CacheReq(cfg))
  requestNow.addr := cpuPort.address
  requestNow.isWrite := cpuPort.wr
  requestNow.writeData := cpuPort.wrData
  requestNow.writeMask := cpuPort.wrMask

  cache.io.req.valid := false.B
  cache.io.req.bits := Mux(cpuState === cpuIdle, requestNow, cpuReq)
  cache.io.resp.ready := false.B
  cpuPort.rdData := cache.io.resp.bits.data
  cpuPort.ack := false.B

  switch(cpuState) {
    is(cpuIdle) {
      when(cpuPort.rd || cpuPort.wr) {
        cpuReq := requestNow
        cache.io.req.valid := true.B
        requestAccepted := cache.io.req.ready
        cpuState := cpuWait
      }
    }
    is(cpuWait) {
      when(!requestAccepted) {
        cache.io.req.valid := true.B
        when(cache.io.req.ready) { requestAccepted := true.B }
      }
      cache.io.resp.ready := true.B
      when(cache.io.resp.valid) {
        cpuPort.ack := true.B
        requestAccepted := false.B
        cpuState := cpuIdle
      }
    }
  }

  val memIdle :: refillWait :: refillSend :: writeData :: writeWait :: writeAck :: Nil = Enum(6)
  val memState = RegInit(memIdle)
  val base = Reg(UInt(32.W))
  val beat = RegInit(0.U(log2Ceil(cfg.beatsPerLine).max(1).W))
  val readData = Reg(UInt(32.W))
  val writeDataReg = Reg(UInt(32.W))
  val writeMaskReg = Reg(UInt(4.W))
  val writeBeats = if (cfg.isWriteBack) cfg.beatsPerLine else 1

  cache.io.memReq.ready := false.B
  cache.io.memResp.valid := false.B
  cache.io.memResp.bits.data := readData
  cache.io.memWriteReq.ready := false.B
  cache.io.memWriteData.ready := false.B
  cache.io.memWriteResp.valid := false.B
  cache.io.memWriteResp.bits.ack := true.B

  mem_port.rd := false.B
  mem_port.wr := false.B
  mem_port.address := 0.U
  mem_port.wrData := 0.U
  mem_port.wrMask := 0.U

  switch(memState) {
    is(memIdle) {
      when(cache.io.memWriteReq.valid) {
        cache.io.memWriteReq.ready := true.B
        base := cache.io.memWriteReq.bits.addr
        beat := 0.U
        memState := writeData
      }.otherwise {
        cache.io.memReq.ready := true.B
        when(cache.io.memReq.valid) {
          base := cache.io.memReq.bits.addr
          beat := 0.U
          mem_port.rd := true.B
          mem_port.address := cache.io.memReq.bits.addr
          memState := refillWait
        }
      }
    }
    is(refillWait) {
      mem_port.rd := true.B
      mem_port.address := base + (beat << log2Ceil(cfg.memBeatBytes))
      when(mem_port.ack) {
        readData := mem_port.rdData
        memState := refillSend
      }
    }
    is(refillSend) {
      cache.io.memResp.valid := true.B
      when(cache.io.memResp.ready) {
        when(beat === (cfg.beatsPerLine - 1).U) { memState := memIdle }
          .otherwise {
            beat := beat + 1.U
            memState := refillWait
          }
      }
    }
    is(writeData) {
      cache.io.memWriteData.ready := true.B
      when(cache.io.memWriteData.valid) {
        writeDataReg := cache.io.memWriteData.bits.data
        writeMaskReg := cache.io.memWriteData.bits.mask
        memState := writeWait
      }
    }
    is(writeWait) {
      mem_port.wr := true.B
      mem_port.address := base + (beat << log2Ceil(cfg.memBeatBytes))
      mem_port.wrData := writeDataReg
      mem_port.wrMask := writeMaskReg
      when(mem_port.ack) {
        when(beat === (writeBeats - 1).U) { memState := writeAck }
          .otherwise {
            beat := beat + 1.U
            memState := writeData
          }
      }
    }
    is(writeAck) {
      cache.io.memWriteResp.valid := true.B
      when(cache.io.memWriteResp.ready) { memState := memIdle }
    }
  }

  debug_cpu_state := cpuState
  debug_mem_state := memState
}
