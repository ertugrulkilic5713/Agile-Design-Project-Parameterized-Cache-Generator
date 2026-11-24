# Parameterized Cache Generator

A reusable, parameterized cache written in Chisel for the DTU **02201 Agile Hardware Design** project. The generator supports direct-mapped, set-associative, and fully associative configurations, two write policies, and three replacement policies. A Wildcat RISC-V integration provides a complete system for running programs and measuring cache behavior over UART.

The cache lives in `cache-generator/`; Wildcat depends directly on that project through SBT. There is one shared cache implementation.

## Commands

### Prerequisites

- **Java 17 and SBT 1.10.7** for the Scala/Chisel builds and tests. Both projects use Scala 2.13.16, Chisel 6.7.0, and ChiselTest 6.0.0.
- **Python 3** for the telemetry decoder tests; **pyserial** to read a connected board.
- **RISC-V binutils** to assemble programs for Wildcat. The Makefile defaults to `riscv64-elf-` on macOS and `riscv64-unknown-elf-` elsewhere. Override with `CROSS=...` if needed.
- **Vivado** for the Nexys A7 FPGA flow; **OpenOCD** to program the board. The optional ASIC flow requires **LibreLane**, its PDK, and SRAM macro files.

Commands below state their working directory. Hardware generation, synthesis, and programming are separate steps.

### Run tests

From `cache-generator/`, run all standalone cache tests:

```sh
sbt -batch test
```

Run a specific suite when working on a policy:

```sh
sbt -batch "testOnly cache.SetAssociativeCacheSpec"
sbt -batch "testOnly cache.TreePLRULogicSpec cache.TreePLRUCacheSpec"
```

From `integration/wildcat/`, run the self-contained integration suites used by CI:

```sh
sbt -batch "testOnly adapter.* memory.DelayedMemSpec device.* wildcat.RegisterFileTest wildcat.DataMemoryStallTest wildcat.CachedProgramSpec"
```

From the repository root, test the UART frame decoder:

```sh
python3 -m unittest discover -s integration/UART_TB -v
```

[CI](.github/workflows/test.yml) runs these checks on pushes and pull requests. Cache tests cover replacement, masked stores, backpressure, and write completion ordering. Integration tests cover the adapter, memory latency, telemetry, and a ThreeCats program that stores, evicts, and reloads under both write policies.

SBT does not automatically run a dependency project's tests, so run both Scala projects. Wildcat's broader `make test` target also clones and builds an external RISC-V test suite; it is separate from the self-contained checks above.

### Generate a standalone cache

From `cache-generator/`:

```sh
# Direct-mapped, round-robin defaults
sbt -batch "runMain cache.GenerateCache"

# Four-way cache with tree pseudo-LRU
sbt -batch "runMain cache.GenerateCache 4 generated plru"

# Four-way cache with reproducible random replacement
sbt -batch "runMain cache.GenerateCache 4 generated random 7"
```

Argument order:

```text
[ways] [output-directory] [rr|plru|random] [seed]
```

Defaults are `1 generated rr 1`. This entry point uses **1 KiB capacity, 4-byte lines, 32-bit addresses, 4-byte words/beats, and write-back**. Change `GenerateCache` in [cache.scala](cache-generator/src/main/scala/cache.scala) or instantiate `SetAssociativeCache` with your own `CacheConfig` to change those values.

One way emits `generated/DirectMappedReadCache.sv`; multiple ways emit `generated/SetAssociativeCache.sv`. The output directory is relative to `cache-generator/` unless an absolute path is supplied.

Optional synthesis statistics for the default one-way output, with Yosys installed:

```sh
yosys -p 'read_verilog -sv generated/DirectMappedReadCache.sv; synth -top DirectMappedReadCache; stat'
```

### Build a Wildcat program and generate the system

From `integration/wildcat/`:

```sh
# Assemble and link a benchmark into a.out
make APP=asm/bench/wcheck.s app

# Run the ELF program in the instruction-set simulator
make PROGRAM=a.out run

# Generate LittleCat with a four-way write-back cache
make APP=asm/bench/wcheck.s POLICY=wb WAYS=4 REPLACEMENT=plru hw-asic

# Generate a write-through system with added memory latency
make APP=asm/bench/wcheck.s POLICY=wt WAYS=2 REPLACEMENT=random SEED=7 MEMLATENCY=3 hw-asic
```

`hw-asic` generates the LittleCat RTL used by the FPGA synthesis target too. It first builds `APP`, then writes `generated/LittleCat.sv` by default. `make dump` disassembles `a.out`.

| Make variable | Default | Meaning |
| --- | --- | --- |
| `APP` | `asm/play.s` | Assembly program to build |
| `POLICY` | `wb` | `wb` (write-back) or `wt` (write-through); `CACHE` is an alias when `POLICY` is unset |
| `CAPACITY` | `4096` | Total cache data capacity in bytes |
| `LINESIZE` | `16` | Bytes per cache line |
| `WAYS` | `1` | Ways per set |
| `REPLACEMENT` | `rr` | `rr`, `plru`, or `random` |
| `SEED` | `1` | Nonzero random replacement seed |
| `MEMLATENCY` | `0` | Extra delay per backing-memory transaction |
| `MEMBYTES` | `16384` | Backing data-memory size in bytes |
| `OUTDIR` | `generated` | RTL output directory |

For an already built program, invoke the generator directly:

```sh
sbt -batch "runMain wildcat.pipeline.LittleCat a.out wb 4096 16 4 plru 1 0 16384 generated"
```

```text
program [wb|wt] [capacity] [line-size] [ways] [rr|plru|random] [seed] [memory-latency] [memory-bytes] [output-directory]
```

### Read telemetry

From the repository root, with pyserial installed:

```sh
python3 integration/UART_TB/stats.py --port /dev/ttyUSB1 --csv results.csv

# Record a timed experiment and attach its configuration to every CSV row
python3 integration/UART_TB/stats.py --port /dev/ttyUSB1 --csv results.csv --seconds 30 --tag wb-4way-plru
```

Replace the port with the board's serial device. The reader uses **115200 baud** and reports interval hit rate, hit/miss latency, average memory access time (AMAT), and controller-state occupancy.

## Overall architecture

![Cache generator and Wildcat system architecture](images/cache-architecture.drawio.svg)

The reusable cache exposes decoupled request/response channels. In LittleCat, `CacheAdapter` translates the CPU's PipeCon requests into those channels and converts cache memory transactions back into individual PipeCon transfers. Instruction fetches use a separate ROM; memory-mapped I/O bypasses the data cache. Cache events feed performance counters and the UART transmitter.

## Cache configuration

The public configuration and interfaces are defined in [model.scala](cache-generator/src/main/scala/model.scala). For example, from a Chisel module:

```scala
import cache._
import chisel3._

val cache = Module(new SetAssociativeCache(CacheConfig(
  capacityBytes = 4096,
  lineBytes = 16,
  numWays = 4,
  writePolicy = WriteBack,
  replacementPolicy = TreePLRU
)))
```

| `CacheConfig` field | Default | Purpose |
| --- | --- | --- |
| `capacityBytes` | `4096` | Data capacity, excluding tags and metadata |
| `addrWidth` | `32` | Address width in bits |
| `lineBytes` | `16` | Bytes per line |
| `wordBytes` | `4` | CPU word width in bytes |
| `memBeatBytes` | `4` | Memory transfer width in bytes |
| `writePolicy` | `WriteBack` | Store and allocation behavior |
| `numWays` | `1` | Associativity |
| `replacementPolicy` | `RoundRobin` | Victim-selection policy |
| `lfsrSeed` | `1` | Seed for random replacement |

These are the **library defaults**; the standalone CLI uses the smaller geometry described above.

Geometry follows:

```text
numLines     = capacityBytes / lineBytes
numSets      = numLines / numWays
wordsPerLine = lineBytes / wordBytes
beatsPerLine = lineBytes / memBeatBytes
address      = [ tag | set index | line offset ]
```

Capacity, line size, word size, beat size, and associativity must be powers of two. A line must hold at least one word and one beat, and capacity must hold at least two lines. Ways cannot exceed the total number of lines. `numWays = 1` is direct-mapped; `numWays = numLines` is fully associative, with no set-index bits. Increasing associativity keeps total data capacity fixed.

Write-through requires `memBeatBytes == wordBytes`. The Wildcat adapter additionally requires 32-bit addresses and 4-byte words/beats. `MEMLATENCY` must be nonnegative and `MEMBYTES` a positive power of two.

`DirectMappedReadCache` is a compatibility entry point for one-way configurations. Despite its historical name, it uses the shared implementation and supports stores.

## Behavior and design choices

### Blocking controller and synchronous storage

The cache accepts one CPU request at a time. Each way has synchronous tag and data memories; valid and dirty bits are registers. A request starts the memory lookup, then the controller compares tags in `sCompare`. Read hits and write-back store hits can respond in that state. If the CPU stalls the response, the result is held in `sRespond`.

This organization keeps miss handling sequential: select a victim, complete any dirty write-back, refill the entire line, and respond. There are no overlapping misses or early responses before a refill completes. Store hits and refills share one data-memory write port per way.

### Write policies

| Policy | Store hit | Store miss | CPU store completion |
| --- | --- | --- | --- |
| Write-back (`wb`) | Merge masked bytes and mark dirty | Allocate a line, merge the store, mark dirty | Once the cache has accepted the update |
| Write-through (`wt`) | Merge masked bytes and write to memory | Write to memory without allocating | After memory acknowledges the write |

Loads allocate on misses under both policies. Stores acknowledge with response data zero. Byte masks select the bytes to update.

Write-back defers memory traffic until a dirty line is evicted. Write-through sends every store to memory and avoids allocating lines on store misses. Dirty evictions finish before the corresponding refill starts.

### Replacement policies

Invalid ways always fill first. Once a set is full:

| Policy | State | Update behavior |
| --- | --- | --- |
| Round-robin (`rr`) | One next-victim pointer per set | Advances after a refill |
| Tree pseudo-LRU (`plru`) | `numWays - 1` bits per set | Updates on hits and refills |
| Random (`random`) | One shared seeded LFSR | Advances only on full-set evictions |

Round-robin is the default and needs little state. Tree pseudo-LRU tracks recent accesses without maintaining an exact LRU ordering. Random provides a repeatable alternative for experiments. One-way configurations omit replacement hardware.

The random seed must be nonzero and fit in `max(16, wayBits + 1)` bits, where `wayBits = max(1, log2Ceil(numWays))`.

### Memory protocol

All public channels use `valid`/`ready`; a transfer occurs only when both are high.

| Channel | Direction relative to cache | Payload |
| --- | --- | --- |
| `req` | Input | Address, read/write flag, store data, byte mask |
| `resp` | Output | Read word or zero-valued store acknowledgement |
| `memReq` | Output | Line-aligned refill address |
| `memResp` | Input | Exactly `beatsPerLine` ordered data beats |
| `memWriteReq` | Output | Line-aligned write-back or word-aligned write-through address |
| `memWriteData` | Output | Data beat and byte mask |
| `memWriteResp` | Input | Explicit write completion with `ack = true` |

A write address is accepted before its data. Write-back sends a whole line; write-through sends one masked word beat. Accepting the last data beat does not complete a write: memory must return `memWriteResp` after the write finishes. The adapter waits for all PipeCon beat acknowledgements before producing that completion.

The core has no PipeCon, CPU, or UART dependency. Its `stat` output provides hit, miss, write-back, and write-through event pulses plus the controller state; integration-specific counters live outside the cache.

## Wildcat integration and measurement

[LittleCat](integration/wildcat/src/main/scala/wildcat/pipeline/LittleCat.scala) connects a ThreeCats CPU, instruction ROM, cache adapter, delayed backing memory, LED device, and UART telemetry.

- Data requests in the `0x0...` address region go through the cache.
- The LED/switch device is selected in the `0xF001....` region and bypasses the cache.
- `DelayedMem` adds `MEMLATENCY` cycles to the synchronous scratchpad timing. Zero added latency still has the scratchpad's one-cycle acknowledgement; this is a per-beat delay, not a total miss penalty.
- Switch 0 selects software LED output or cache hit/miss counts; LED 15 shows a heartbeat.

The UART transmits a snapshot about every 100 ms at the default 100 MHz system frequency. A frame is `0xAA` followed by **19 little-endian 32-bit words** (77 bytes total):

```text
hits, misses, writebacks, write-throughs, stores,
hit-latency total, miss-latency total, elapsed cycles,
sIdle, sCompare, sWritebackReq, sWritebackSend, sWritebackWait,
sWriteThroughReq, sWriteThroughSend, sWriteThroughWait,
sRefillReq, sRefillWait, sRespond
```

The [host decoder](integration/UART_TB/stats.py) computes differences between snapshots and handles 32-bit counter wraparound. Its test checks state order against the canonical cache enum. Keep the FPGA image and decoder on the same frame format when changing telemetry.

## Repository layout

| Path | Contents |
| --- | --- |
| [cache-generator/src/main/scala](cache-generator/src/main/scala) | Reusable cache, configuration, interfaces, replacement logic, RTL entry point |
| [cache-generator/src/test/scala](cache-generator/src/test/scala) | Standalone cache and replacement tests |
| [integration/wildcat](integration/wildcat) | CPU, PipeCon adapter, memory models, devices, synthesis configuration, integration tests |
| [integration/UART_TB](integration/UART_TB) | Python telemetry reader and frame-layout test |
| [images](images) | Architecture and controller diagrams |
| [.github/workflows/test.yml](.github/workflows/test.yml) | Cache, integration, and telemetry CI checks |

Develop both projects on `main` through short-lived feature branches; this layout does not require a separate long-lived integration branch.
