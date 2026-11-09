package adapter

import chisel3._
import chisel3.util._
import cache._
import soc.PipeConIO
import soc.PipeConDevice

/// Usage:
/// ```
/// val cache = Module(new CacheAdapter(CacheConfig()))
/// cache.cpuPort <> cpu.io.imem
/// cache.mem_port <> memory.io.imem
/// ```
class CacheAdapter(cfg: CacheConfig) extends PipeConDevice(32) {
  // checking to ensure it works with Wildcat impl
  require(cfg.memBeatBytes == 4, "PipeCon is 32 bits wide")
  require(cfg.wordBytes == 4, "Wildcat words are 32 bits wide")
  require(cfg.addrWidth == 32)

  val cache = Module(new DirectMappedReadCache(cfg))
  val mem_port = IO(Flipped(new PipeConIO(32)))

  val debug_cpu_state = IO(Output(UInt(2.W)))
  val debug_mem_state = IO(Output(UInt(2.W)))


  // ----- debug / statistics --------------------------
  val debug_hit = IO(Output(Bool()))
  val debug_miss = IO(Output(Bool()))
  val debug_writeback_wb = IO(Output(Bool()))
  val debug_write_wt = IO(Output(Bool()))
  debug_hit := cache.io.stat.hit
  debug_miss := cache.io.stat.miss
  debug_writeback_wb := cache.io.stat.writeback_wb
  debug_write_wt := cache.io.stat.write_wt

  // ----------------- CPU SIDE -----------------
  val cpuIdle :: cpuWaitForResp :: Nil = Enum(2) // cpuWriteWait is not used anymore.
  val cpu_state = RegInit(cpuIdle)
  val req_reg = Reg(new CpuReq(cfg))
  val req_sent = RegInit(false.B) // cache accepted the request

  // request as seen on bus this cycle.
  val req_now = Wire(new CpuReq(cfg))
  req_now.addr := cpuPort.address
  req_now.write := cpuPort.wr
  req_now.wdata := cpuPort.wrData
  req_now.wmask := cpuPort.wrMask

  cache.io.cpu.req.valid := false.B
  cache.io.cpu.req.bits := Mux(cpu_state === cpuIdle, req_now, req_reg)
  cache.io.cpu.resp.ready := false.B

  cpuPort.rdData := cache.io.cpu.resp.bits.data
  cpuPort.ack := false.B


  // ----- CPU FSM -----
  switch(cpu_state) {
    is(cpuIdle) {
      when(cpuPort.rd || cpuPort.wr) {
        req_reg := req_now
        cache.io.cpu.req.valid := true.B
        req_sent := cache.io.cpu.req.ready
        cpu_state := cpuWaitForResp
      }
    }
    is(cpuWaitForResp) {
      when(!req_sent) {
        cache.io.cpu.req.valid := true.B
        when(cache.io.cpu.req.ready) {
          req_sent := true.B
        }
      }
      cache.io.cpu.resp.ready := true.B
      when(cache.io.cpu.resp.valid) {
        cpuPort.ack := true.B
        req_sent := false.B
        cpu_state := cpuIdle
      }
    }
  }

  //------------------ MM SIDE -----------------
  val memIdle :: memRead :: memSend :: memWriteWait :: Nil = Enum(4)
  val mem_state = RegInit(memIdle)
  val base_reg = Reg(UInt(32.W))
  val beat_cnt = RegInit(0.U(log2Ceil(cfg.beatsPerLine).max(1).W))
  val data_reg = Reg(UInt(32.W))

  cache.io.mm.req_refill.ready := false.B
  cache.io.mm.data_refill.valid := false.B
  cache.io.mm.data_refill.bits.data := data_reg
  cache.io.mm.req_write.ready := false.B

  mem_port.rd := false.B
  mem_port.wr := false.B
  mem_port.address := 0.U
  mem_port.wrData := 0.U
  mem_port.wrMask := 0.U

  val last_beat = beat_cnt === (cfg.beatsPerLine - 1).U

  // ----- Memory FSM -----
  switch(mem_state) {
    is(memIdle) {
      when(cache.io.mm.req_write.valid) {
        mem_port.wr := true.B
        mem_port.address := cache.io.mm.req_write.bits.addr
        mem_port.wrData := cache.io.mm.req_write.bits.data
        mem_port.wrMask := cache.io.mm.req_write.bits.mask
        mem_state := memWriteWait
      }.otherwise {
        cache.io.mm.req_refill.ready := true.B
        when(cache.io.mm.req_refill.valid) {
          base_reg := cache.io.mm.req_refill.bits.addr
          beat_cnt := 0.U
          mem_port.rd := true.B
          mem_port.address := cache.io.mm.req_refill.bits.addr
          mem_state := memRead
        }
      }
    }
    is(memWriteWait) {
      when(mem_port.ack) {
        cache.io.mm.req_write.ready := true.B // beats are done; cache moves to the next one.
        mem_state := memIdle
      }
    }
    is(memRead) {
      when(mem_port.ack) {
        data_reg := mem_port.rdData
        mem_state := memSend
      }
    }
    is(memSend) {
      cache.io.mm.data_refill.valid := true.B
      when(cache.io.mm.data_refill.ready) {
        when(last_beat) {
          mem_state := memIdle
        }.otherwise {
          val next = beat_cnt + 1.U
          beat_cnt := next
          mem_port.rd := true.B
          mem_port.address := base_reg + (next << log2Ceil(cfg.memBeatBytes))
          mem_state := memRead
        }
      }
    }
  }

  debug_cpu_state := cpu_state
  debug_mem_state := mem_state
}

