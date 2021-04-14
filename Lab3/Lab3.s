    .data
inBuffer: .space 64
outBuffer: .space 64
inBufferPtr: .quad 0
outBufferPtr: .quad 0

    .text
    .global inImage /* Done */
	.global getInt
	.global getText
	.global getChar
	.global getInPos
	.global setInPos
	.global outImage
	.global putInt
	.global putText /*Done */
	.global putChar
	.global getOutPos
	.global setOutPos

inImage:
    leaq inBuffer, %rdi
    movq $64, %rsi
    movq stdin, %rdx
    call fgets
    leaq inBufferPtr, %rax
    movq $0, (%rax)
    leaq inBuffer, %r10
newCharLoop:
    addq $4, %r10
    cmpq $0, (%r10)
    je returnInImage
    incq (%rax) 
    jmp newCharLoop
returnInImage:
    incq (%rax)
    ret

getInt:
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
ret

putInt:
ret

putText:
    leaq outBufferPtr, %rax
    leaq outBuffer, %rdx
    movq $0, %rbx
Loop:
    movq (%rdi, %rbx), %rcx
    movq %rcx, (%rdx, %rax)
    cmpq $0, %rcx
    je return
    incq (%rax)
    cmpq $65, %rax
    je overflow
    jmp Loop
overflow:
    call outImage
return:
    ret

putChar:
ret

getOutPos:
ret

setOutPos:
ret
