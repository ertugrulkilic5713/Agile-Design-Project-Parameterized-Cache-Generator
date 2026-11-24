# Associativity benchmark.
# Keep CAPACITY=4096, LINESIZE=32, POLICY=wb.
# Compare WAYS=1 against WAYS=2 or higher.
#
# Expected:
#   1 way:  alternating accesses continually evict each other.
#   2+ ways: both lines stay cached after their initial allocation.
#
# ScratchPadMem must cover addresses 0 through 4099.

    li      x4, 0xf0010000      # LED device
    li      x5, 0               # pass counter
    li      x6, 0               # address A
    li      x7, 4096            # address B: same set, different tag

pass:
    # Change the expected values each pass to detect stale data.
    addi    x8, x5, 1           # expected B = pass + 1
    sw      x5, 0(x6)           # A = pass
    sw      x8, 0(x7)           # B = pass + 1

    li      x9, 1024            # alternating read pairs per pass

check:
    lw      x10, 0(x6)
    bne     x10, x5, fail

    lw      x11, 0(x7)
    bne     x11, x8, fail

    addi    x9, x9, -1
    bne     x9, x0, check

    # Successful pass: update LEDs and repeat.
    addi    x5, x5, 1
    sw      x5, 0(x4)
    j       pass

fail:
    li      x12, 0x7fff
    sw      x12, 0(x4)

halt:
    j       halt