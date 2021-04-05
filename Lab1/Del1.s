.data
numbers:
    .word   2, 3, 8, 3, 9, 12, 0
sum:
    .word   0

.text
.global main
main:
    ldr r1, =numbers
    mov r0, #0
again:
    ldr r2, [r1]
    cmp r2, #0
    beq finish
    add r0, r0, r2
    add r1, r1, #4
    bal again
finish:
    ldr r1, =sum
    str r0, [r1]
halt:
    bal halt
.end
