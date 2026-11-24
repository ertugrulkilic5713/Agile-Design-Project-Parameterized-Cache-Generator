Cache visualizer workload datasets
===================================

Files are plain text with exactly one request per line:

    OP ADDRESS DATA MASK

Examples:
    R 0x00000000 0x12345678 0xF
    W 0x00000004 0xAABBCCDD 0x3

Fields:
- OP: R = READ, W = WRITE
- ADDRESS: 32-bit byte address, hexadecimal
- DATA: 32-bit write data (also populated for reads; ignore for READ)
- MASK: 4-bit byte-enable mask, hexadecimal (0xF enables all four bytes)

There are six workload families, each at 64, 128, 256, 512, 1024, and 2048 requests:
- sequential: contiguous 4-byte reads
- strided: one access every 64 bytes
- random: deterministic pseudo-random addresses, mostly reads
- hot_set: strong temporal locality with an occasional larger-region access
- conflict: repeated addresses 4 KiB apart to probe possible index conflicts
- mixed_rw: recurring working set with a read/write mix

Important:
- These files contain request inputs only. They do not encode expected cache hit/miss
  results because those depend on CacheConfig, replacement policy, and cache state.
- The conflict pattern is geometry-dependent. A 4 KiB separation may or may not map
  to the same set for a particular cache configuration.
- All files use the same simple line format so your C++ parser can stream requests.
- The random datasets are reproducible; the generator seed is 0xCACE2026.

Suggested parser:
  read OP, ADDRESS, DATA, MASK
  parse the numeric fields as hexadecimal
  map R/W to Data::Operation::READ/WRITE
