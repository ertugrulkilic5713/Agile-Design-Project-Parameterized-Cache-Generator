# Sweep: read REGION bytes sequentially, forever. LEDs show pass count.
    li      x4, 0xf0010000      # LED device
    li      x5, 0               # pass counter
    li      x6, 1024            # REGION in bytes  <-- change for other runs
pass:
    li      x7, 0               # address
sweep:
    lw      x8, 0(x7)
    addi    x7, x7, 4
    bne     x7, x6, sweep
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       pass
