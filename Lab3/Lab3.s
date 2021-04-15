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
    leaq inBuffer, %rax
    movq $inBufferPtr, %r10
    leaq (%rax, %r10, 4), %rdi
    movq $0, %rax
    movq $11, %r11
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
    movq $1, %r11
    incq %rdi
lNumber:
    cmpb $'0', (%rdi)
    jl  lNAN
    cmpb $'9', (%rdi)
    jg lNAN
    movzbq (%rdi), %r10
    subq $'0', %r10
    imulq $10, %rax
    addq %r10, %rax
    incq %rdi
    jmp lNumber
lNAN:
    cmpq $1, %r11
    jne lEnd
    negq %rax
lEnd:
    ret

getText:
ret

getChar:
ret

getInPos:
ret

setInPos:
ret

outImage:
    movq $0, %rsi
    movq outBuffer, %rdi
    call printf
    movq $0, outBufferPtr
    ret

putInt:
ret

putText:
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
    ret

putChar:
ret

getOutPos:
    movq $outBufferPtr, %rax
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
