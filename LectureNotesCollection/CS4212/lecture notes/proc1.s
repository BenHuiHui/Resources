.text
fact:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $4,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl 8(%ebp),%eax
		 cmpl $0,%eax
		 je L0
		 pushl %ecx
		 pushl %edx
		 movl 8(%ebp),%eax
		 subl $1,%eax
		 pushl %eax
		 call fact
		 addl $4,%esp
		 popl %edx
		 popl %ecx
		 imull 8(%ebp),%eax
		 movl %eax,-4(%ebp)
		 jmp L1
L0:
		 movl $1,-4(%ebp)
L1:
		 movl -4(%ebp),%eax
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
		 pushl %ecx
		 pushl %edx
		 pushl $5
		 call fact
		 addl $4,%esp
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
