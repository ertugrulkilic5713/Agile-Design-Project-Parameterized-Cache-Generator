package cache

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import scala.util.Random

class SetAssociativeCacheSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "SetAssociativeCache"

  it should "validate ways and derive geometry from sets" in {
    for (ways <- Seq(0, -1, 3, 16)) {
      intercept[IllegalArgumentException] { CacheConfig(capacityBytes = 64, numWays = ways) }
    }
    val cfg = CacheConfig(capacityBytes = 64, numWays = 4)
    assert(cfg.numLines == 4 && cfg.numSets == 1 && cfg.indexBits == 0)
    assert(cfg.tagBits == cfg.addrWidth - cfg.offsetBits)
  }

  it should "reject associative configurations through the legacy entry point" in {
    intercept[IllegalArgumentException] {
      test(new DirectMappedReadCache(CacheConfig(capacityBytes = 64, numWays = 2))) { _ => () }
    }
  }

  for (ways <- Seq(2, 4)) {
    it should s"fill all $ways ways and rotate victims independently per set without updating on hits" in {
      val cfg = CacheConfig(capacityBytes = ways * 32, numWays = ways)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1)
        val stride = cfg.numSets * cfg.lineBytes
        val a = 0x100L
        for (w <- 0 until ways; set <- 0 until cfg.numSets) h.read(a + w * stride + set * cfg.lineBytes)
        assert(h.fetches.size == cfg.numLines)
        for (w <- 0 until ways) {
          assert(h.read(a + w * stride).cycles == 3)
          assert(h.hits.last)
        }
        // Two complete rounds must evict ways in order, even after a hit in the next victim.
        for (w <- 0 until 2 * ways) {
          val victim = a + w * stride
          h.read(victim)
          assert(h.hits.last)
          val incoming = a + (w + ways) * stride
          h.read(incoming)
          assert(!h.hits.last)
          assert(h.fetches.last == incoming)
        }
        val before = h.fetches.size
        for (w <- 0 until ways) h.read(a + w * stride + cfg.lineBytes)
        assert(h.fetches.size == before)
        // Advance only set zero, then verify set one still chooses its own way zero.
        h.read(a + 3 * ways * stride)
        h.read(a + ways * stride + cfg.lineBytes)
        h.read(a + stride + cfg.lineBytes)
        assert(h.hits.last)
        h.read(a + cfg.lineBytes)
        assert(!h.hits.last)
      }
    }

  }

  for ((cfg, i) <- Seq(
    CacheConfig(capacityBytes = 32, numWays = 2),
    CacheConfig(capacityBytes = 16, lineBytes = 4, numWays = 4),
    CacheConfig(capacityBytes = 64, wordBytes = 8, memBeatBytes = 4, numWays = 2),
    CacheConfig(capacityBytes = 64, memBeatBytes = 8, numWays = 4),
    CacheConfig(capacityBytes = 128, numWays = 8)
  ).zipWithIndex) {
    it should s"match the reference with stalled responses for geometry $i" in {
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1)
        val ref = new RefCache(cfg)
        val random = new Random(1234 + i)
        for (_ <- 0 until 60) {
          val addr = 0x100L + random.nextInt(4 * cfg.numLines * cfg.wordsPerLine) * cfg.wordBytes
          val expectedHit = ref.access(addr)
          assert(h.read(addr, respStall = random.nextInt(3)).data == h.expectedWord(addr))
          assert(h.hits.last == expectedHit)
        }
      }
    }
  }
}
