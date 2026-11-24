# On-board correctness check for stores. A cache larger than REGION will not
# exercise dirty eviction, so keep REGION above the configured cache capacity.

    li      x4, 0xf0010000
    li      x5, 0
    li      x6, 8192
pass:
    li      x7, 0
fill:
    add     x8, x7, x5
    sw      x8, 0(x7)
    addi    x7, x7, 4
    bne     x7, x6, fill

    li      x7, 0
check:
    lw      x8, 0(x7)
    add     x9, x7, x5
    bne     x8, x9, fail
    addi    x7, x7, 4
    bne     x7, x6, check

    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       pass

fail:
    li      x9, 0x7fff
    sw      x9, 0(x4)
halt:
    j       halt
