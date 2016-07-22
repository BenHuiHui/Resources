.text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 movl $2,a
		 movl $4,b
L3:
		 movl a,%eax
		 cmpl b,%eax
		 jge L4
L1:
		 movl a,%eax
		 cmpl $10,%eax
		 jge L2
		 movl a,%eax
		 cmpl $100,%eax
		 jge L0
		 jmp L4
L0:
		 movl a,%eax
		 addl $1,%eax
		 movl %eax,a
		 movl a,%eax
		 addl $1,%eax
		 movl %eax,b
		jmp L1
L2:
		 movl a,%eax
		 addl $3,%eax
		 movl %eax,a
		 movl b,%eax
		 addl $2,%eax
		 movl %eax,b
		jmp L3
L4:
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

b:		 .long 0
a:		 .long 0

		 .globl __var_name_area
__var_name_area:

b_name:	 .asciz "b"
a_name:	 .asciz "a"

		 .globl __var_ptr_area
__var_ptr_area:

b_ptr:	 .long b_name
a_ptr:	 .long a_name

__end_var_ptr_area:	 .long 0
