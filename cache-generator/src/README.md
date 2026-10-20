# Agile-Design-Project-Parameterized-Cache-Generator

This project implements a parameterizable set-associative cache using generic types in Chisel, a hardware design language embedded in Scala.

## Run the Tests

From the project root, start the SBT console:

```bash
sbt
```

Inside the SBT console, run the tests:

```scala
test
```

To generate the Verilog/SystemVerilog, run:

```scala
run
```

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