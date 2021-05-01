    .data
inBuffer: .space 64
outBuffer: .space 64
inBufferPtr: .quad 0
outBufferPtr: .quad 0
printString: .asciz "%s\n"

    .text
    .global inImage
	.global getInt
	.global getText
	.global getChar
	.global getInPos
	.global setInPos
	.global outImage
	.global putInt
	.global putText
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
    ret

increaseInBufferPtr:
    pushq %r12
    leaq inBuffer, %rax
    movq inBufferPtr, %r12
    incq %r12
    movq (%rax, %r12), %rdi
    cmpq $0, %rdi
    je inBufferEnd
    movq %r12, inBufferPtr
returnIncreaseInBufferPtr:
    popq %r12
    ret
inBufferEnd:
    call inImage
    jmp returnIncreaseInBufferPtr

getInt:
    push %r12
    push %r13
    push %r14
    leaq inBuffer, %rax
    movq inBufferPtr, %r12
    leaq (%rax, %r12), %rdi
    movq $0, %rax
    movq $0, %r13
lBlankCheck:
    cmpb $' ', (%rdi)
    jne lSignPlus
    incq %rdi
    incq %r12
    jmp lBlankCheck
lSignPlus:
    cmpb $'+', (%rdi)
    jne lSignMinus
    incq %rdi
    incq %r12
    jmp lNumber
lSignMinus:
    cmpb $'-', (%rdi)
    jne lNumber
    movq $1, %r13
    incq %rdi
    incq %r12
lNumber:
    cmpb $'0', (%rdi)
    jl  lNAN
    cmpb $'9', (%rdi)
    jg lNAN
    movzbq (%rdi), %r14
    subq $'0', %r14
    imulq $10, %rax
    addq %r14, %rax
    incq %rdi
    incq %r12
    jmp lNumber
lNAN:
    incq %r12
    incq %rdi
    cmpq $1, %r13
    jne lEnd
    negq %rax
lEnd:
    movq %r12, inBufferPtr
    cmpq $0, (%rdi)
    je callInImage
retGetInt:
    pop %r14
    pop %r13
    pop %r12
    ret
callInImage:
    pushq %rax
    call inImage
    popq %rax
    jmp retGetInt


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
    cmpq $0, (%rdx, %rbx) # här blir rax > Jeff Bezoz
    je getCharje
    movq (%rdx, %rbx), %rax
    incq %rbx
    movq %rbx, inBufferPtr
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
    movq $outBuffer, %rsi
    movq $printString, %rdi 
    xor %rax, %rax
    call printf
    movq $0, outBufferPtr
    ret

# outImage:
#    movq $'\n', %rdi
#    call putChar 
#    xor %rax, %rax 
#    leaq outBuffer, %rdi # Move buffert containing string to rdi. 
#    movq outBufferPtr, %rsi # Set number of characters to print. ( = next pos) 
#    call printf 
#    leaq outBuffer, %rdi # Move buffert containing string to rdi. 
#    xor %rax, %rax # Temp position pointer for outBuf.
#    ret

putInt:
    pushq $0
    movq $10, %rcx
    cmpq $0, %rdi
    jl putIntNeg
putIntNegRet:
    movq %rdi, %rax
putIntLoop:
    cqto
    divq %rcx # rax: rax//10, rdx: rax % 10
    addq $'0', %rdx
    pushq %rdx
    cmpq $0, %rax
    je IntToBuff
    jmp putIntLoop
putIntNeg:
    pushq %rdi
    movq $'-', %rdi
    call putChar
    popq %rdi
    negq %rdi
    jmp putIntNegRet
IntToBuff:
    popq %rdi
    cmpq $0, %rdi
    je retPutInt
    call putChar
    jmp IntToBuff
retPutInt:
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
