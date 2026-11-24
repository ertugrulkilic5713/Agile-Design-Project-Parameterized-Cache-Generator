# stride: read one word every STRIDE bytes over REGION, forever.
# STRIDE == lineBytes -> no spatial locality: first pass 0% hits, later passes 100% if
# REGION fits. Compare with sweep.s on the same config to isolate the line-size benefit.
    li      x4, 0xf0010000
    li      x5, 0
    li      x6, 2048            # REGION
    li      x10, 16             # STRIDE (= lineBytes)
pass:
    li      x7, 0
loop:
    lw      x8, 0(x7)
    add     x7, x7, x10
    bne     x7, x6, loop
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       pass