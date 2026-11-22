package cache

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class TreePLRUCacheSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "SetAssociativeCache with tree PLRU"

  it should "parse plru without changing the default policy" in {
    assert(ReplacementPolicy.parse("plru") == TreePLRU)
    assert(CacheConfig().replacementPolicy == RoundRobin)
  }

  for (sets <- Seq(1, 2); policy <- Seq(WriteBack, WriteThrough)) {
    it should s"fill invalid ways and protect a read hit with $sets sets and $policy" in {
      val cfg = CacheConfig(capacityBytes = 4 * sets * 16, numWays = 4,
        replacementPolicy = TreePLRU, writePolicy = policy)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1)
        val ref = new RefCache(cfg)
        val base = 0x100L
        val stride = cfg.numSets * cfg.lineBytes
        def read(line: Int): Unit = {
          val addr = base + line * stride
          val expectedHit = ref.access(addr)
          assert(h.read(addr).data == h.expectedWord(addr))
          assert(h.hits.last == expectedHit)
        }
        // Lowest-invalid-way allocation puts these lines in ways 0,1,2,3.
        for (way <- 0 until 4) read(way)
        assert(h.fetches.size == 4)
        assert(ref.access(base))
        assert(h.read(base, respStall = 3).cycles == 5)
        assert(h.hits.last)
        // Touching way 0 changes the next victim from way 0 to way 2.
        read(4)
        assert(!h.hits.last)
        for (line <- Seq(0, 1, 3, 4)) {
          read(line)
          assert(h.hits.last)
        }
        assert(h.fetches.size == 5)
        read(2)
        assert(!h.hits.last)
      }
    }
  }

  for (policy <- Seq(WriteBack, WriteThrough)) {
    it should s"protect a store hit under $policy" in {
      val cfg = CacheConfig(capacityBytes = 64, numWays = 4,
        replacementPolicy = TreePLRU, writePolicy = policy)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1)
        val base = 0x100L
        for (way <- 0 until 4) h.read(base + way * cfg.lineBytes)
        val old = h.expectedWord(base)
        dut.io.cpu.req.bits.addr.poke(base.U)
        dut.io.cpu.req.bits.write.poke(true.B)
        dut.io.cpu.req.bits.wdata.poke("h12345678".U)
        dut.io.cpu.req.bits.wmask.poke(3.U)
        dut.io.cpu.req.valid.poke(true.B)
        dut.io.cpu.req.ready.expect(true.B)
        dut.clock.step()
        dut.io.cpu.req.valid.poke(false.B)
        dut.io.stat.hit.expect(true.B)
        dut.clock.step()
        if (policy == WriteThrough) {
          // The tree was touched in compare, before this memory-side wait.
          dut.io.mm.req_write.valid.expect(true.B)
          dut.clock.step(3)
          dut.io.mm.req_write.valid.expect(true.B)
          dut.io.mm.req_write.ready.poke(true.B)
          dut.clock.step()
          dut.io.cpu.resp.valid.expect(true.B)
          dut.clock.step()
          dut.io.mm.req_write.ready.poke(false.B)
        }
        dut.io.cpu.req.bits.write.poke(false.B)
        // Way 2 is clean and must be evicted instead of the stored-to way 0.
        h.read(base + 4 * cfg.lineBytes)
        assert(!h.hits.last)
        assert(h.read(base).data == ((old & ~BigInt(0xffff)) | BigInt(0x5678)))
        assert(h.hits.last)
        h.read(base + 2 * cfg.lineBytes)
        assert(!h.hits.last)
      }
    }
  }

  it should "bypass tree state in a one-way cache" in {
    val cfg = CacheConfig(capacityBytes = 32, replacementPolicy = TreePLRU)
    test(new SetAssociativeCache(cfg)) { dut =>
      val h = new CacheHarness(dut, cfg, memLatency = 1)
      h.read(0x100)
      assert(h.read(0x100).cycles == 2)
      h.read(0x120)
      h.read(0x100)
      assert(!h.hits.last)
    }
  }
}
