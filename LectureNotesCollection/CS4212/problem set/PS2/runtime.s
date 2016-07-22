	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.align	4, 0x90
_main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	call	L1$pb
L1$pb:
	popl	%eax
	movl	%eax, -8(%ebp)
	call	_start
	movl	%esp, %ecx
	movl	%eax, 4(%ecx)
	movl	-8(%ebp), %eax
	leal	L_.str-L1$pb(%eax), %eax
	movl	%eax, (%ecx)
	call	_printf
	movl	-4(%ebp), %eax
	addl	$24, %esp
	popl	%ebp
	ret

	.section	__TEXT,__cstring,cstring_literals
L_.str:
	.asciz	 "Result = %d\n"


.subsections_via_symbols
