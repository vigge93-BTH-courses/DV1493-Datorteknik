.data
numbers:
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0

.text
.global main
factorial:
    STMDB sp!, {lr, r4}
    cmp r0, #1
    beq return
    mov r4, r0
    sub r0, r0, #1
    bl factorial
    mul r5, r4, r0
    mov r0, r5
return:
    LDMIA sp!, {pc, r4}


main:
    STMDB sp!, {lr}
    ldr r2, =numbers
loop:
    ldr r0, [r2]
    cmp r0, #0
    beq finish
    bl factorial
    mov r1, r0
    MOV r0, #1
    SWI 0x6b
    add r2, r2, #4
    bal loop
finish:
    LDMIA sp!, {pc}