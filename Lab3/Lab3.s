    .data
inBuffer: .space 64
outBuffer: .space 64
inBufferPtr: .quad 0
outBufferPtr: .quad 0

    .text
    .global inImage /* Done */
	.global getInt /* Done */
	.global getText
	.global getChar
	.global getInPos
	.global setInPos
	.global outImage
	.global putInt
	.global putText /* Done */
	.global putChar
	.global getOutPos /* Done */
	.global setOutPos

inImage:
    leaq inBuffer, %rdi
    movq $64, %rsi
    movq stdin, %rdx
    call fgets
    leaq inBufferPtr, %rax
    movq $0, (%rax)
    ret

getInt:
    push %r12
    push %r13
    leaq inBuffer, %rax
    movq inBufferPtr, %r12
    leaq (%rax, %r12, 4), %rdi
    movq $0, %rax
    movq $0, %r13
lBlankCheck:
    cmpb $' ', (%rdi)
    jne lSignPlus
    incq %rdi
    jmp lBlankCheck
lSignPlus:
    cmpb $'+', (%rdi)
    jne lSignMinus
    incq %rdi
    jmp lNumber
lSignMinus:
    cmpb $'-', (%rdi)
    jne lNumber
    movq $1, %r13
    incq %rdi
lNumber:
    cmpb $'0', (%rdi)
    jl  lNAN
    cmpb $'9', (%rdi)
    jg lNAN
    movzbq (%rdi), %r12
    subq $'0', %r12
    imulq $10, %rax
    addq %r12, %rax
    incq %rdi
    jmp lNumber
lNAN:
    cmpq $1, %r13
    jne lEnd
    negq %rax
lEnd:
    pop %r12
    pop %r13
    ret

getText: # RSI: Antal tecken, RDI: Buffert
    push %rbx
    movq $0, %rbx
getTextLoop:
    cmpq $0, %rsi
    je returnGetText
    call getChar
    movq %rax, (%rdi)
    incq %rbx
    cmpq $0, %rax
    je returnGetText
    decq %rsi
    incq %rdi
    jmp getTextLoop
returnGetText:
    movq %rbx, %rax
    pop %rbx
    ret

getCharje:
    call inImage
getChar:
    push %rbx
    movq inBufferPtr, %rbx
    leaq inBuffer, %rdx
    cmpq $0, %rbx
    je getCharje
    movq (%rdx, %rbx), %rax
    decq (%rbx)
    pop %rbx
    ret

getInPos:
    movq inBufferPtr, %rax
    ret

setInPos:
    cmpq  $0, %rdi
    jle Inposle
    cmpq $63, %rdi
    jge Inposge
    movq %rdi, inBufferPtr
    ret
Inposle:
    movq $0, inBufferPtr
    ret
Inposge:
    movq $63, inBufferPtr
    ret

outImage:
    movq $0, %rsi
    movq $outBuffer, %rdi
    call printf
    movq $0, outBufferPtr
    ret

putInt:
    pushq %rbx
    pushq $0
    movq $10, %rcx
putIntLoop:
    movq %rdi, %rax
    cqto
    divq %rcx # rax: rax//10, rdx: rax % 10
    addq $'0', %rdx
    movq %rdx, %rbx
    pushq %rbx
    cmpq $0, %rax
    je stackToBuffPutInt
    jmp putIntLoop
stackToBuffPutInt:
    cmpq $0, %rdi
    jl putIntNeg
    jmp IntToBuff
putIntNeg:
    movq $'-', %rdi
    call putChar
IntToBuff:
    popq %rdi
    cmpq $0, %rdi
    je retPutInt
    call putChar
    jmp IntToBuff
retPutInt:
    popq %rbx
    ret

putText:
    pushq %rbx
    movq outBufferPtr, %rax
    leaq outBuffer, %rdx
    movq $0, %rbx
Loop:
    movzbq (%rdi, %rbx), %rcx
    movq %rcx, (%rdx, %rax)
    cmpq $0, %rcx
    je return
    incq %rax
    cmpq $65, %rax
    incq %rbx
    je overflow
    jmp Loop
overflow:
    call outImage
return:
    movq %rax, outBufferPtr
    popq %rbx
    ret

putChar:
    movq outBufferPtr, %rax
    cmpq $64, outBufferPtr
    jge overflowChar
    leaq outBuffer, %rdx
    movq %rdi, (%rdx, %rax)
    incq %rax
    movq %rax, outBufferPtr
    jmp returnPutChar
overflowChar:
    call outImage
returnPutChar:
    ret

getOutPos:
    movq outBufferPtr, %rax
    ret

setOutPos:
    cmpq  $0, %rdi
    jle Outposle
    cmpq $63, %rdi
    jge Outposge
    movq %rdi, outBufferPtr
    ret
Outposle:
    movq $0, outBufferPtr
    ret
Outposge:
    movq $63, outBufferPtr
    ret
