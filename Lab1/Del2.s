.data
test:
    .word 1
    .word 3
    .word 5
    .word 7
    .word 9
    .word 8
    .word 6
    .word 4
    .word 2
    .word 0
textA: .asciz "Lab1 , Assignment  2\n"
textB: .asciz "The max is %d\n"
textC: .asciz "Done\n"

.text
.global main

/*******************************************************************
Function  finding  maximum  value  in a zero  terminated  integer  array
*******************************************************************/
findMax:
    /* Add  code to find  maximum  value  element  here! */
    STMDB sp!, {lr} /* PUSH */
    /* Any  registers  altered  by the  function  beside r0 -r3 must be  preserved  */
    LDR r1, [ r0 ] /* Load the initial value of the array */
again:
    LDR r2, [r0]
    CMP r2, #0
    BEQ finish
    CMP r2, r1
    BLE less
    MOV r1, r2
less:
    ADD r0, r0, #4
    BAL again
finish:
    MOV r0, r1
    LDMIA sp!, {pc} /* POP */

/**********************main  function**********************/
main:
    STMDB sp!, {lr} /* PUSH */
    LDR r0, =test
    BL findMax
    MOV r1, r0
    LDMIA sp!, {pc} /* POP */
.end