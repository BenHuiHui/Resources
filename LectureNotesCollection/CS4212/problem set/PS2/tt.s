	.section	__TEXT,__text,regular,pure_instructions
	.globl	_gcd
	.align	4, 0x90
_gcd:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, -8(%ebp)
	movl	-4(%ebp), %eax
	addl	$8, %esp
	popl	%ebp
	ret

	.globl	_start
	.align	4, 0x90
_start:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, -8(%ebp)
	movl	-4(%ebp), %eax
	addl	$8, %esp
	popl	%ebp
	ret


.subsections_via_symbols
