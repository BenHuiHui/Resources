.text
gcd:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 jmp L3
L2:
		 movl 8(%ebp),%eax
		 cmpl 12(%ebp),%eax
		 jl L0
		 movl 8(%ebp),%eax
		 subl 12(%ebp),%eax
		 movl %eax,8(%ebp)
		 jmp L1
L0:
		 movl 12(%ebp),%eax
		 subl 8(%ebp),%eax
		 movl %eax,12(%ebp)
L1:
L3:
		 movl 8(%ebp),%eax
		 cmpl 12(%ebp),%eax
		 jne L2
		 movl 8(%ebp),%eax
		 popl %edi
		 popl %esi
		 popl %ebx
		 movl %ebp,%esp
		 popl %ebp
		 ret
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 movl $1,a
		 pushl %ecx
		 pushl %edx
		 pushl $240
		 pushl $144
		 call gcd
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,a
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

a:		 .long 0

		 .globl __var_name_area
__var_name_area:

a_name:	 .asciz "a"

		 .globl __var_ptr_area
__var_ptr_area:

a_ptr:	 .long a_name

__end_var_ptr_area:	 .long 0
