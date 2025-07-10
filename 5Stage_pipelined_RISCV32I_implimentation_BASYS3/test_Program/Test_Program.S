.section .text
.globl _start

_start:
    li     t1, 10          # t1 = 10
    li     t2, 5           # t2 = 5
    add    t3, t1, t2      # t3 = 10 + 5 = 15

    sw     t3, 0x20(zero)  # store t3 at memory[0x20]
    sw     t2, 0x24(zero)  # store t2 at memory[0x24]
    sw     t1, 0x28(zero)  # store t1 at memory[0x28]

    lw     t5, 0x20(zero)  # t5 = memory[0x20] = 15
    lw     t6, 0x24(zero)  # t6 = memory[0x24] = 5

    sub    t3, t5, t6      # t3 = 15 - 5 = 10
    beq    t3, t1, match   # if t3 == t1, jump to match
    j      fail            # else go to fail

match:
    addi   t1, t1, 1       # t1 = t1 + 1 = 11
    addi   t2, t2, 2       # t2 = t2 + 2 = 7
    add    t3, t1, t2      # t3 = 11 + 7 = 18
    j      done

fail:
    li     t3, 0           # set t3 to 0

done:
    nop
    j done                # infinite loop to freeze