.text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 movl $0,s
		 movl $0,i
L2:
		 movl i,%eax
		 cmpl $10,%eax
		 jge L3
		 movl s,%eax
		 addl i,%eax
		 movl %eax,s
		 movl s,%eax
		 cmpl $30,%eax
		 jle L1
		 jmp L0
L1:
		 movl s,%eax
		 imull i,%eax
		 movl %eax,s
L0:
		 movl i,%eax
		 addl $1,%eax
		 movl %eax,i
		 jmp L2
L3:
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

s:		 .long 0
i:		 .long 0

		 .globl __var_name_area
__var_name_area:

s_name:	 .asciz "s"
i_name:	 .asciz "i"

		 .globl __var_ptr_area
__var_ptr_area:

s_ptr:	 .long s_name
i_ptr:	 .long i_name

__end_var_ptr_area:	 .long 0
