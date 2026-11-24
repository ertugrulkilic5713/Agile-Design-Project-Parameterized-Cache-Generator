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

  it should "validate random seeds and parse all replacement policies" in {
    assert(ReplacementPolicy.parse("random") == RandomReplacement)
    for (seed <- Seq(BigInt(0), BigInt(-1), BigInt(1) << 16)) {
      intercept[IllegalArgumentException] { CacheConfig(lfsrSeed = seed) }
    }
    assert(CacheConfig(lfsrSeed = 65535).lfsrSeed == 65535)
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
          assert(h.read(a + w * stride).cycles == 2)
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
        assert(h.writebacks.isEmpty)
      }
    }

    it should s"write back every dirty way of a $ways-way set with stalls and preserve its neighbors" in {
      val cfg = CacheConfig(capacityBytes = ways * 32, numWays = ways)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 2, writeReqStall = 2,
          writeBeatStall = 2, writeAckLatency = 3, readReqStall = 2, readBeatStall = 1)
        val a = 0x110L // nonzero set index
        val stride = cfg.numSets * cfg.lineBytes
        for (w <- 0 until ways; word <- 0 until cfg.wordsPerLine) {
          h.write(a + w * stride + word * cfg.wordBytes, BigInt(0x12340000L + w * 256 + word),
            mask = if (word == 1) 5 else 15, respStall = 2)
        }
        assert(h.writebacks.isEmpty)
        for (w <- 0 until ways) {
          val victim = a + w * stride
          h.read(a + (ways + w) * stride, respStall = 3)
          assert(h.writebacks.last == MemoryWrite(victim,
            (0 until cfg.beatsPerLine).map(i => h.expectedBeat(victim + i * cfg.memBeatBytes))))
          for (remaining <- w + 1 until ways) {
            val addr = a + remaining * stride + 4
            assert(h.read(addr).data == h.expectedWord(addr))
            assert(h.hits.last)
          }
        }
        assert(h.writebacks.size == ways)
        val events = h.memoryEvents.toSeq
        for (w <- 0 until ways) {
          val done = events.indexOf(("writeDone", a + w * stride))
          assert(done >= 0 && events(done + 1) == (("readReq", a + (ways + w) * stride)))
        }
      }
    }
  }

  for (policy <- Seq(WriteBack, WriteThrough)) {
    it should s"preserve allocation policy and masked hits for $policy" in {
      val cfg = CacheConfig(capacityBytes = 64, numWays = 2, writePolicy = policy)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1, writeAckLatency = 2)
        val a = 0x100L
        val stride = cfg.numSets * cfg.lineBytes
        h.read(a)
        h.read(a + stride)
        h.write(a + stride + 4, BigInt("aabbccdd", 16), mask = 5, respStall = 3)
        assert(h.read(a + stride + 4).data == h.expectedWord(a + stride + 4))
        val before = h.fetches.size
        h.write(a + 2 * stride, BigInt("deadbeef", 16), mask = 3)
        if (cfg.isWriteThrough) {
          assert(h.fetches.size == before)
          assert(h.read(a).cycles == 2)
          h.read(a + 2 * stride)
        } else assert(h.fetches.size == before + 1)
        // Allocation evicts way zero; the masked data in way one survives.
        assert(h.read(a + stride + 4).data == h.expectedWord(a + stride + 4))
        assert(h.hits.last)
        assert(h.read(a + 2 * stride).data == h.expectedWord(a + 2 * stride))
        assert(h.hits.last)
        if (cfg.isWriteThrough) {
          assert(h.writebacks.size == 2)
          assert(h.backingWord(a + 2 * stride) == h.expectedWord(a + 2 * stride))
        }
      }
    }
  }

  val geometries = Seq(
    CacheConfig(capacityBytes = 32, numWays = 2), // one set, multiple beats
    CacheConfig(capacityBytes = 16, lineBytes = 4, numWays = 4), // one word/beat
    CacheConfig(capacityBytes = 64, wordBytes = 8, memBeatBytes = 4, numWays = 2),
    CacheConfig(capacityBytes = 64, wordBytes = 4, memBeatBytes = 8, numWays = 4),
    CacheConfig(capacityBytes = 128, numWays = 8)
  )
  for ((base, i) <- geometries.zipWithIndex;
       replacement <- Seq(RoundRobin, TreePLRU, RandomReplacement);
       policy <- (if (base.wordBytes == base.memBeatBytes) Seq(WriteBack, WriteThrough) else Seq(WriteBack))) {
    it should s"match the reference under mixed traffic for geometry $i, $policy and $replacement" in {
      val cfg = base.copy(writePolicy = policy, replacementPolicy = replacement, lfsrSeed = 7)
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1, writeReqStall = 1,
          writeBeatStall = 1, writeAckLatency = 2, readReqStall = 1, readBeatStall = 1)
        val ref = new RefCache(cfg)
        val random = new Random(1234 + i)
        for (_ <- 0 until 100) {
          val addr = 0x100L + random.nextInt(4 * cfg.numLines * cfg.wordsPerLine) * cfg.wordBytes
          val write = random.nextBoolean()
          val expectedHit = ref.access(addr, write)
          if (write) h.write(addr, BigInt(cfg.wordBits, random),
            mask = BigInt(cfg.wordBytes, random), respStall = random.nextInt(3))
          else assert(h.read(addr, respStall = random.nextInt(3)).data == h.expectedWord(addr))
          assert(h.hits.last == expectedHit, s"incorrect hit/miss for address $addr")
        }
      }
    }
  }
  // Preserve the integration branch's standalone read-geometry regressions.
  val readGeometries = Seq(
    CacheConfig(),
    CacheConfig(memBeatBytes = 16),
    CacheConfig(lineBytes = 32),
    CacheConfig(capacityBytes = 64),
    CacheConfig(wordBytes = 8, memBeatBytes = 8)
  )
  for ((cfg, i) <- readGeometries.zipWithIndex) {
    it should s"preserve direct-mapped reads for migrated geometry $i" in {
      test(new SetAssociativeCache(cfg)) { dut =>
        val h = new CacheHarness(dut, cfg, memLatency = 1)
        val ref = new RefCache(cfg)
        val random = new Random(42)
        for (_ <- 0 until 30) {
          val addr = random.nextInt(4 * cfg.capacityBytes / cfg.wordBytes).toLong * cfg.wordBytes
          val before = h.fetches.size
          val expectedHit = ref.access(addr)
          assert(h.read(addr, respStall = random.nextInt(3)).data == h.expectedWord(addr))
          assert(h.hits.last == expectedHit)
          assert(h.fetches.size - before == (if (expectedHit) 0 else 1))
        }
      }
    }
  }

}
