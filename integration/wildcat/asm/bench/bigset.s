# bigset: sequential read over REGION > cache capacity, forever.
# Every pass re-fetches every line (capacity misses): expect 1 miss + (wordsPerLine-1) hits
# per line, i.e. 75% with 16-byte lines, independent of how many passes run.
# Grow CAPACITY past REGION and it goes to ~100%.
    li      x4, 0xf0010000      # LED device
    li      x5, 0               # pass counter
    li      x6, 8192            # REGION in bytes (> 4 KiB cache)
pass:
    li      x7, 0
sweep:
    lw      x8, 0(x7)
    addi    x7, x7, 4
    bne     x7, x6, sweep
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       pass