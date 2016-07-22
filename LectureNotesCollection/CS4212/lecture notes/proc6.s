.text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $16,%esp
		 movl $1,a
		 movl a,%eax
		 addl $1,%eax
		 movl %eax,-4(%ebp)
		 movl a,%eax
		 addl -4(%ebp),%eax
		 movl %eax,-8(%ebp)
		 movl $2,%eax
		 imull a,%eax
		 addl $3,%eax
		 movl %eax,-12(%ebp)
		 movl -12(%ebp),%eax
		 subl $1,%eax
		 movl %eax,-16(%ebp)
		 movl $2,%eax
		 imull -16(%ebp),%eax
		 movl %eax,-4(%ebp)
		 movl -4(%ebp),%eax
		 addl -8(%ebp),%eax
		 movl %eax,-12(%ebp)
		 movl -12(%ebp),%eax
		 addl $1,%eax
		 movl %eax,-16(%ebp)
		 movl $2,%eax
		 imull -16(%ebp),%eax
		 movl %eax,-8(%ebp)
		 movl -4(%ebp),%eax
		 addl -8(%ebp),%eax
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
