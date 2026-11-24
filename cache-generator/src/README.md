# Agile-Design-Project-Parameterized-Cache-Generator

This project implements a parameterizable set-associative cache in Chisel.
Use `CacheConfig(numWays = 4)` with `SetAssociativeCache` for a four-way cache;
`numWays = 1` defaults to direct-mapped behavior. See the [repository README](../../README.md)
for geometry, replacement behavior, write policies, and Wildcat integration.

## Run the Tests

From `cache-generator/`, start the SBT console:

```bash
sbt
```

Inside the SBT console, run the tests:

```scala
test
```

To generate the Verilog/SystemVerilog, run:

```scala
runMain cache.GenerateCache 4
```

The generator accepts `[ways] [output-directory] [rr|plru|random] [seed]`,
defaulting to `1 generated rr 1`. For example,
`runMain cache.GenerateCache 4 generated plru` or
`runMain cache.GenerateCache 4 generated random 7`. One way emits `DirectMappedReadCache`; multiple ways emit

`SetAssociativeCache`. The synthesis examples below use the one-way output.

To exit the SBT console:

```scala
exit
```

## Synthesis Statistics (Optional)

Outside the SBT console, run Yosys to synthesize the generated SystemVerilog and display statistics:

```bash
yosys -p '
read_verilog -sv generated/DirectMappedReadCache.sv
hierarchy -top DirectMappedReadCache
synth -top DirectMappedReadCache
stat
'
```

Make sure the file path and top-module name match your generated design.

## Visualize the Circuit (Optional)

Outside the SBT console, export the synthesized netlist to JSON using Yosys:

```bash
yosys -p '
read_verilog -sv generated/DirectMappedReadCache.sv
hierarchy -top DirectMappedReadCache
synth -top DirectMappedReadCache
write_json cache.json
'
```

Convert the JSON netlist to an SVG image using Netlistsvg:

```bash
netlistsvg cache.json -o cache.svg
```

Open the generated circuit diagram on macOS:

```bash
open cache.svg
```

[github.com/agile-hw/hw5](https://github.com/agile-hw/hw5)
