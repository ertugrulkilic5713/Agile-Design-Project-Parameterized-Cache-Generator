# Parameterized Cache Generator

This branch contains a reusable, parameterized direct-mapped cache written in Chisel.
The cache supports elaboration-time selection of write-back or write-through policy,
byte-masked stores, configurable line and bus widths, and decoupled CPU and memory
interfaces.

## Tests and continuous integration

Run the standalone cache suite from the repository root:

```bash
cd cache-generator
sbt -batch test
```

Integration code, system-level tests, and CI are maintained on the `testing`
branch so consumers of this branch can take the cache module independently.

<p align="center">
  <img src="images/FSM/CH_CONTROLLER_FSM_V1.drawio.svg" width="600" alt="Cache Controller High-Level FSM Diagram."
</p>

<p align="center">
  <img src="images/ASM/CH_CONTROLLER_ASM_V1.drawio.svg" width="600" alt="Cache Controller High-Level ASM Diagram."
</p>
