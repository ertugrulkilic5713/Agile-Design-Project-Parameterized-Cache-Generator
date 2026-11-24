# conflict3: cycle through three addresses that map to the same set, forever.
# In a 2-way set this is the pathological case for FIFO/round-robin: the line evicted
# is always the one needed next -> ~0% hits. Random replacement breaks the pattern
# (~30-35% hits, seed dependent). 4 ways hold all three -> ~100%.
# Needs MM >= 12 KiB (default 16 KiB is fine).
    li      x4, 0xf0010000      # LED device
    li      x5, 0               # loop counter
    li      x7, 0x1000
    li      x8, 0x2000
loop:
    lw      x9, 0(x0)           # 0x0000
    lw      x9, 0(x7)           # 0x1000
    lw      x9, 0(x8)           # 0x2000
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       loop