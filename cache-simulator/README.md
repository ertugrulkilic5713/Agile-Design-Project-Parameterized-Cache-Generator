# Visualizer
Interactive UI that shows what happens internally with the cache.

# Build
```bash
make         # Debug build
make debug   # Debug build
make release # Release build
make run     # Build and run
make clean   # Remove build artifacts
```

# UART Communication
Cache visualizer is entirely dependent on information/trace files
delivered via UART from fpga hardware.

## Parser

### Hardware -> Software
Parser needs a standard to read trace files from fpga.
Uart will reply in binary, but that will be converted to human readble
csv files.

**These are examples and aren't final**
`configuration.csv`
```csv
cache_size, addr_width, line_bytes, word_bytes, mem_beat_bytes, associativity, replacement, write_policy
4096, 32, 16, 4, 4, 4, LRU, WriteBack
```

`cache_memory.csv`
```csv
way, valid, dirty, <policy>, tag, w[0]..w[n]
..., ..., ..., ..., ..., ...
```

`requests.csv`
```csv
id, op, addr, wrdata, rdata, hit, tag, offset, evict, write_back?
..., ..., ..., ..., ..., ..., ..., ...
```

From there, simulator can digest the trace file and show a visualized version of
the memory and each request. 

### Software -> Hardware
To expand testability and useability, the visualizer can also run tests based on 
files. Similiar parsing tecniques will be used - configuration.csv & cache_memory.csv & requests.csv -
to see what is happening internally. Here UART will only return `request_results.csv`
that just shows the data from read, writes, evictions, and hits.

## Notes
Where UART is needed in `*.scala`
```scala
if (enableVisualizer) {
    // everything here compiled out
}
```
To ensure that this visualizer doesnt add additional bloat, can 
flag to not compile said information in scala. 


