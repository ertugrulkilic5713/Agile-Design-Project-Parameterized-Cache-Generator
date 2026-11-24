# Parameterized Cache Generator

The repository has one canonical cache implementation and a Wildcat integration
that depends on it:

- `cache-generator/`: reusable Chisel cache, public interfaces, replacement logic,
  standalone hardware generator, and cache tests.
- `integration/wildcat/`: Wildcat CPU, PipeCon adapter, memory models, profiling,
  hardware configuration, and integration tests.
- `integration/UART_TB/`: host telemetry reader and frame-layout test.

Develop both projects on `main` through short-lived feature branches; a separate
long-lived integration branch is not needed for this layout.

There is no cache source copy inside Wildcat. Its SBT build references
`../../cache-generator`. Both projects use Scala 2.13.16, Chisel 6.7.0,
ChiselTest 6.0.0, and SBT 1.10.7; CI uses Java 17.

## Cache behavior and interfaces

`SetAssociativeCache(CacheConfig(...))` supports power-of-two associativity,
including a single fully associative set. Total data capacity is fixed:
`numLines = capacityBytes / lineBytes`, `numSets = numLines / numWays`.
`DirectMappedReadCache` is a compatibility entry point requiring one way.

Write-back stores allocate and dirty lines; write-through stores update hits
but do not allocate misses. Stores support byte masks and acknowledge with zero.
Requests are blocking; read and write-back store hits respond during compare.

Replacement is selected at elaboration: `RoundRobin` (default), `TreePLRU`, or
`RandomReplacement`. Invalid ways fill first. Round-robin advances on refills;
PLRU updates on hits and refills. Random replacement uses one seeded LFSR,
advancing only on full-set evictions. The seed must be nonzero and fit in
`max(16, wayBits + 1)` bits. One-way caches omit replacement hardware.

The public interface has CPU `req/resp`, memory `memReq/memResp`, and separate
`memWriteReq/memWriteData/memWriteResp` channels. Transfers occur on
`valid && ready`. Refill responses contain exactly `beatsPerLine` ordered beats.
Write-back sends a base address and a full line; write-through sends a word
address and one masked beat. Accepting write data is separate from completing
a write: memory must return `memWriteResp(ack = true)` after the write finishes.
Dirty evictions finish before refills begin. Statistics expose event pulses and
the current controller state; the cache has no PipeCon, UART, or CPU dependency.

## Verification

From `cache-generator/`:

```sh
sbt -batch test
```

From `integration/wildcat/`:

```sh
sbt -batch "testOnly adapter.* memory.DelayedMemSpec device.* wildcat.RegisterFileTest wildcat.DataMemoryStallTest wildcat.CachedProgramSpec"
```

From `integration/UART_TB/`:

```sh
python3 -m unittest discover -v
```

CI runs these suites on every push and pull request. The cache suite checks
replacement, masked reads/stores, stalls, and write completion ordering.
Integration tests cover the adapter, zero/nonzero memory latency, telemetry,
and a ThreeCats program that stores, evicts, and reloads under both write policies.
Tests requiring external RISC-V suites are not part of this self-contained job.
Dependency projects' tests are not automatically run by SBT, so both jobs matter.

## Hardware generation

From `cache-generator/`:

```sh
sbt -batch "runMain cache.GenerateCache 4 generated plru"
sbt -batch "runMain cache.GenerateCache 4 generated random 7"
```

Arguments are `[ways] [output-directory] [rr|plru|random] [seed]`, with defaults
`1 generated rr 1`. Cache geometry follows the standalone generator configuration.

From `integration/wildcat/` (requires RISC-V binutils):

```sh
make APP=asm/bench/wcheck.s POLICY=wb WAYS=4 REPLACEMENT=plru hw-asic
make APP=asm/bench/wcheck.s POLICY=wt WAYS=2 REPLACEMENT=random SEED=7 MEMLATENCY=3 hw-asic
```

Make variables also include `CAPACITY=4096`, `LINESIZE=16`,
`MEMBYTES=16384`, and `OUTDIR=generated`. `CACHE` remains an alias for the
default `POLICY`. The equivalent LittleCat arguments are:

```text
program [wb|wt] [capacity] [line-size] [ways] [rr|plru|random] [seed] [memory-latency] [memory-bytes] [output-directory]
```

For example:

```sh
sbt -batch "runMain wildcat.pipeline.LittleCat a.out wb 4096 16 4 plru 1 0 16384 generated"
```

This replaces main's previous `program policy ways output-directory` argument
order. The adapter uses the canonical split write protocol, holds PipeCon
requests until acknowledgement, and reports completion after all beats finish.
`DelayedMem` adds the configured latency to synchronous scratchpad timing.

Generated hardware is a configuration-specific artifact. Regenerate before
synthesis; old snapshots do not establish equivalence or timing closure.
The existing physical-design scripts remain board/PDK-specific.

## Telemetry

The UART sends `0xAA` followed by 19 little-endian 32-bit words (77 bytes total):
hits, misses, writebacks, write-throughs, stores, hit-latency total,
miss-latency total, elapsed cycles, then one counter per canonical state:

```text
sIdle, sCompare, sWritebackReq, sWritebackSend, sWritebackWait,
sWriteThroughReq, sWriteThroughSend, sWriteThroughWait,
sRefillReq, sRefillWait, sRespond
```

Use `python3 integration/UART_TB/stats.py --port /dev/ttyUSB1 --csv results.csv`
with pyserial installed. The decoder reports interval hit rate, latency,
AMAT, and state occupancy, handling 32-bit counter wraparound.
This frame replaces the old two-counter and seven-state formats; update the
FPGA image and reader together. The decoder test checks state order against
the canonical enum.
