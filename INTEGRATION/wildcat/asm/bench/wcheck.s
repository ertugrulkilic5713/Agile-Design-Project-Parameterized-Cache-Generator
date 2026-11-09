# wcheck: on-board correctness check for stores.
# Fills REGION bytes of RAM with (address + pass), reads everything back and
# compares. On success the pass counter goes to the LEDs and the next pass
# starts (with different values, so stale lines would be caught).
# On the first mismatch all LEDs light up and the CPU halts.
#
# With REGION > cache capacity, write-back must evict dirty lines and
# write them to memory; a bug there shows as a failure here.
# NOTE: ScratchPadMem in LittleCat must be at least REGION bytes large.

    li      x4, 0xf0010000      # LED device
    li      x5, 0               # pass counter
    li      x6, 8192            # REGION in bytes  <-- change per run
pass:
    li      x7, 0
fill:
    add     x8, x7, x5          # value = address + pass
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

