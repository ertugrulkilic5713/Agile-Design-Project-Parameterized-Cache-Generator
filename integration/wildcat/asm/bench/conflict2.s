# conflict2: alternate between two addresses 4 KiB apart, forever.
# With a 4 KiB cache both map to set 0 (same index, different tag):
#   1 way  -> every access evicts the other line: ~0% hits (conflict misses)
#   2 ways -> both lines stay resident: ~100% hits
# Addresses are multiples of 4096, so they share a set for any numSets*lineBytes that divides 4096.
    li      x4, 0xf0010000      # LED device
    li      x5, 0               # loop counter
    li      x7, 0x1000          # second address, 4 KiB above the first
loop:
    lw      x8, 0(x0)           # address 0x0000
    lw      x8, 0(x7)           # address 0x1000
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       loop