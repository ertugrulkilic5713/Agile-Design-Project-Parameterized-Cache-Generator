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
  require(cfg.addrWidth == 32)

  val cache = Module(new DirectMappedReadCache(cfg))
  val mem_port = IO(Flipped(new PipeConIO(32)))

  // ----- CPU -----
  val cpuIdle :: cpuWaitForResp :: cpuWriteWait :: Nil = Enum(3)
  val cpu_state = RegInit(cpuIdle)
  val addr_reg = Reg(UInt(32.W))
  val req_sent = RegInit(false.B) // cache accepted the request

  cache.io.req.valid := false.B
  cache.io.req.bits.addr := Mux(cpu_state === cpuIdle, cpuPort.address, addr_reg)
  cache.io.resp.ready := false.B

  cpuPort.rdData := cache.io.resp.bits.data
  cpuPort.ack := false.B

  // ----- Mem -----
  val memIdle :: memRead :: memSend :: Nil = Enum(3)
  val mem_state = RegInit(memIdle)
  val base_reg = Reg(UInt(32.W))
  val hit_count = RegInit(0.U(log2Ceil(cfg.beatsPerLine).max(1).W))
  val data_reg = Reg(UInt(32.W))

  cache.io.memReq.ready := false.B
  cache.io.memResp.valid := false.B
  cache.io.memResp.bits.data := data_reg

  mem_port.rd := false.B
  mem_port.wr := false.B
  mem_port.address := 0.U
  mem_port.wrData := 0.U
  mem_port.wrMask := 0.U

  // ----- CPU FSM -----
  switch(cpu_state) {
    is(cpuIdle) {
      when(cpuPort.rd) {
        addr_reg := cpuPort.address
        cache.io.req.valid := true.B
        cpu_state := cpuWaitForResp
        req_sent := cache.io.req.ready // retry next cycle if not accepted
      }.elsewhen(cpuPort.wr) {
        // write-through
        mem_port.wr := true.B
        mem_port.address := cpuPort.address
        mem_port.wrData := cpuPort.wrData
        mem_port.wrMask := cpuPort.wrMask
        when(mem_port.ack) {
          cpuPort.ack := true.B
        }.otherwise {
          cpu_state := cpuWriteWait
        }
      }
    }
    is(cpuWaitForResp) {
      when(!req_sent) {
        cache.io.req.valid := true.B
        when(cache.io.req.ready) {
          req_sent := true.B
        }
      }
      cache.io.resp.ready := true.B
      when(cache.io.resp.valid) {
        cpuPort.ack := true.B
        req_sent := false.B
        cpu_state := cpuIdle
      }
    }
    is(cpuWriteWait) {
      when(mem_port.ack) {
        cpuPort.ack := true.B
        cpu_state := cpuIdle
      }
    }
  }

  // ----- Memory FSM -----
  // refills mem
  val last_beat = hit_count === (cfg.beatsPerLine - 1).U
  switch(mem_state) {
    is(memIdle) {
      cache.io.memReq.ready := true.B
      when(cache.io.memReq.valid) {
        base_reg := cache.io.memReq.bits.addr
        hit_count := 0.U
        mem_port.rd := true.B
        mem_port.address := cache.io.memReq.bits.addr
        mem_state := memRead
      }
    }
    is(memRead) {
      when(mem_port.ack) {
        data_reg := mem_port.rdData
        mem_state := memSend
      }
    }
    is(memSend) {
      cache.io.memResp.valid := true.B
      when(cache.io.memResp.ready) {
        when(last_beat) {
          mem_state := memIdle
        }.otherwise {
          val next = hit_count + 1.U
          hit_count := next
          mem_port.rd := true.B
          mem_port.address := base_reg + (next << log2Ceil(cfg.memBeatBytes))
          mem_state := memRead
        }
      }
    }
  }
}

// class CacheAdapter(cfg: CacheConfig) extends PipeConDevice(32) {
//   // checking to ensure it works with Wilcat impl
//   require(cfg.memBeatByte == 4, "PipeCon is 32 bits wide")
//   require(cfg.addrWidth == 32)
//
//   val cache = Module(new DirectMappedReadCache(cfg))
//   val mem_port = IO(Flipped(new PipeCon(32)))
//
//   // ----- CPU -----
//   val cpuIdle :: CPU_WAIT_FOR_RESP :: CPU_WRITE_WAIT :: Nil = Enum(3)
//   val cpu_state = RegInit(cpuIdle)
//   val addr_reg = Reg(UInt(32.W))
//   val req_sent = RegInit(false.B) // cache accepts request for data
//
//   // inits basic cache cfg
//   cache.io.req.valid := false.B
//   cache.io.req.bits.addr := Mux(cpu_state === cpuIdle, io.address, addr_reg)
//   cache.io.resp.ready := false.B
//
//   io.rdData := cache.io.resp.bits.data // move cache data to PipeCon
//   io.ack := false.B
//
//   // ----- Mem -----
//   val memIdle :: memRead :: memSend :: Nil = Enum(3)
//   val mem_state = RegInit(memIdle)
//   val base_reg = Reg(UInt(32.W))
//   val hit_count = RegInit(0.U(log2Ceil(cfg.beatCnt)))
//   val data_reg = Reg(UInt(32.W))
//
//   // init cache 
//   cache.io.memReq.ready := false.B
//   cache.io.memResp.valid := false.B
//   cache.io.memResp.bits.data :=data_reg
//
//   // init port
//   mem_port.rd := false.B
//   mem_port.wr := false.B
//   mem_port.address := 0.U
//   mem_port.wrData := 0.U
//   mem_port.wrMask := 0.U
//
//   // FSMs
//   switch (cpu_state) {
//     is (cpuIdle) {
//       when(io.rd) { // wants to read
//         addr_reg := io.address
//         cache.io.req.valid := true.B
//         cpu_state := CPU_WAIT_FOR_RESP
//         // retry until cache ready to not lose pulse
//         req_sent := cache.io.req.ready
//       }.elsewhen(io.wr) { // wants to write
//         // write-through
//         mem_port.wr      := true.B
//         mem_port.address := io.address
//         mem_port.wrData  := io.wrData
//         mem_port.wrMask  := io.wrMask
//         when(mem_port.ack) { 
//           io.ack := true.B 
//         }.otherwise { 
//           cpu_state := CPU_WRITE_WAIT 
//         }
//       }
//     }
//     is (CPU_WAIT_FOR_RESP) {
//       // retry until accepted req
//       when (!req_sent) {
//         cache.io.req.valid := true.B
//         when (cache.io.req.ready) {
//           req_sent := true.B
//         }
//       }
//
//       cache.io.resp.ready := true.B
//       when (cache.io.resp.valid) {
//         io.ack := true.B
//         req_sent := false.B
//         cpu_state := cpuIdle
//       }
//     }
//
//     // mem ok -> io ok for send
//     is (CPU_WRITE_WAIT) {
//       when (mem_port.ack) {
//         io.ack := true.B;
//         cpu_state := cpuIdle
//       }
//     }
//   }
//
//   val last_hit = hit_count === (cfg.beatsPerLine - 1).U
//   switch (mem_state) {
//     is (memIdle) {
//       cache.io.memReq.ready := true.B
//       when (cache.io.memReq.valid) {
//         base_reg := cache.io.memReq.bits.addr
//         hit_count := 0.U // reset for next data req
//         mem_port.rd := true.B
//         mem_port.addr := cache.io.memReq.bits.addr
//         mem_state := memRead
//       }
//     }
//
//     // after aquire mem req -> read memory in data register
//     is (memRead) {
//       when (mem_port.ack) {
//         data_reg := mem_port.rdData
//         mem_state := memSend
//       }
//     }
//
//     // searches for data until found
//     is (memSend) {
//       cache.io.memResp.valid := true.B
//       when (cache.io.memResp.ready) {
//         when(last_hit) {
//           mem_state := memIdle
//         }.otherwise {
//           val next = hit_count + 1.U
//           hit_count := next
//           mem_port.rd := true.B
//           mem_port.address := base_reg + (next << log2Ceil(cfg.memBeatBytes))
//           mem_state := memRead
//         }
//       }
//     }
//   }
//
// }
