	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt:
	pushq %rbx
	# Increase counter
	movq GPIO, %rdi
	movq counter, %rbx
	incq %rbx
	andq $15, %rbx # modulo 16
	movq %rbx, counter
	movq $1, %rcx
	movq $4, %rsi
loop:		
	movq counter, %rdx
	andq %rcx, %rdx
	cmpq $0, %rdx
	je callLow
	call setPinHigh
	jmp callReturn
callLow:
	call setPinLow
callReturn:
	salq $1, %rcx
	decq %rsi
	cmpq $0, %rsi
	je return
	jmp loop
return:
	popq %rbx
	ret

setPinHigh: # Use formula 4
	push %rcx
	movq $0x3, %rax
	salq $4, %rax
	addq $1, %rax

	movq %rsi, %rcx
	subq $1, %rcx
	imulq $8, %rcx
	
	salq %cl, %rax
	
	orq %rax, 3(%rdi)
	pop %rcx
	ret

setPinLow: # Use formula 5
	push %rcx
	movq $0xCF, %rax

	movq %rsi, %rcx
	subq $1, %rcx
	imulq $8, %rcx
		
	salq %cl, %rax
	notq %rax
	
	andq %rax, 3(%rdi)
	pop %rcx
	ret

setup: 
	# Use formula 1 ((0x60 << 16) | (0xFFFF & 0x1000) | (!(0x9E) & 0xFF))
	movq $0x60, %rax
	salq $16, %rax
	
	movq $0xFFFF, %rbx
	andq $0x1000, %rbx

	movq $0x9E, %rcx
	notq %rcx
	andq $0xFF, %rcx
	
	orq %rbx, %rax
	orq %rcx, %rax
	movq %rax, GPIO

	# Use formula 3 Pin 0 (GPIO + (GPIO_NR/8)) | (0x3 << ((((3-GPIO_NR)*2) % 8)+8))
	movq $3, %rcx
	subq $0, %rcx
	imulq $2, %rcx
	andq $0b111, %rcx # modulo 8
	addq $8, %rcx
	movq $0x3, %rbx	
	salq %cl, %rbx
	orq %rbx, (%rax)

	# Use formula 2 Pin 1-4 (0x2 << 6) << ((4-GPIO_NR)*2)
	# 1
	movq $0x2, %rbx
	salq $6, %rbx

	movq $4, %rcx
	subq $1, %rcx
	imulq $2, %rcx

	salq %cl, %rbx
	
	orq %rbx, (%rax)

	# 2
	movq $0x2, %rbx
	salq $6, %rbx

	movq $4, %rcx
	subq $2, %rcx
	imulq $2, %rcx

	salq %cl, %rbx
	
	orq %rbx, (%rax)
	
	# 3
	movq $0x2, %rbx
	salq $6, %rbx

	movq $4, %rcx
	subq $3, %rcx
	imulq $2, %rcx

	salq %cl, %rbx
	
	orq %rbx, (%rax)
	
	movq $0x2, %rbx
	salq $6, %rbx

	# 4
	movq $4, %rcx
	subq $4, %rcx
	imulq $2, %rcx

	salq %cl, %rbx
	
	orq %rbx, (%rax)
	
	ret


