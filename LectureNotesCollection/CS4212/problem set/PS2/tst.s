
		 .text
		 .globl _start
_start:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $1
		 popl %eax
		 movl %eax,a
		 pushl %eax
		 popl %eax
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
