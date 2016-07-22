
		 .text
		 .globl _start
_start:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $1
		 pushl $2
		 pushl $3
		 popl %eax
		 movl %eax,z
		 popl %eax
		 movl %eax,y
		 popl %eax
		 movl %eax,x
		 pushl y
		 pushl z
		 pushl x
		 popl %eax
		 movl %eax,z
		 popl %eax
		 movl %eax,y
		 popl %eax
		 movl %eax,x
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

z:		 .long 0
y:		 .long 0
x:		 .long 0

		 .globl __var_name_area
__var_name_area:

z_name:	 .asciz "z"
y_name:	 .asciz "y"
x_name:	 .asciz "x"

		 .globl __var_ptr_area
__var_ptr_area:

z_ptr:	 .long z_name
y_ptr:	 .long y_name
x_ptr:	 .long x_name

__end_var_ptr_area:	 .long 0
