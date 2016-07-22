
		 .text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $0
		 popl %eax
		 movl %eax,i
		 pushl %eax
		 popl %eax
		 pushl $0
		 popl %eax
		 movl %eax,j
		 pushl %eax
		 popl %eax
		 pushl $0
		 popl %eax
		 movl %eax,a
		 pushl %eax
		 popl %eax
		 call init_threads
		 movl $L0,%eax
		 call set_second_thread
		 jmp L4
L5:
		 pushl a
		 call cosw
		 pushl $1
		 call cosw
		 popl %ebx
		 call cosw
		 popl %eax
		 call cosw
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 call cosw
		 movl %eax,a
		 pushl %eax
		 popl %eax
		 call cosw
		 pushl i
		 pushl $1
		 call cosw
		 popl %ebx
		 popl %eax
		 call cosw
		 addl %ebx,%eax
		 call cosw
		 pushl %eax
		 call cosw
		 popl %eax
		 movl %eax,i
		 pushl %eax
		 call cosw
		 popl %eax
L4:
		 call cosw
		 pushl i
		 pushl $10
		 call cosw
		 popl %eax
		 popl %ebx
		 cmpl %eax,%ebx
		 call cosw
		 jge L2
		 call cosw
		 pushl $1
		 jmp L3
L2:
		 call cosw
		 pushl $0
L3:
		 popl %eax
		 cmpl $0,%eax
		 call cosw
		 jne L5
		 call single_thread
		 jmp L1
L0:
		 call cosw
		 jmp L8
L9:
		 call cosw
		 pushl a
		 pushl $1
		 popl %ebx
		 call cosw
		 popl %eax
		 subl %ebx,%eax
		 pushl %eax
		 call cosw
		 popl %eax
		 call cosw
		 movl %eax,a
		 call cosw
		 pushl %eax
		 call cosw
		 popl %eax
		 pushl j
		 call cosw
		 pushl $1
		 call cosw
		 popl %ebx
		 call cosw
		 popl %eax
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 call cosw
		 movl %eax,j
		 call cosw
		 pushl %eax
		 call cosw
		 popl %eax
L8:
		 pushl j
		 pushl $10
		 popl %eax
		 call cosw
		 popl %ebx
		 cmpl %eax,%ebx
		 call cosw
		 jge L6
		 pushl $1
		 jmp L7
L6:
		 call cosw
		 pushl $0
L7:
		 popl %eax
		 call cosw
		 cmpl $0,%eax
		 jne L9
		 call single_thread
L1:
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

i:		 .long 0
a:		 .long 0
j:		 .long 0

		 .globl __var_name_area
__var_name_area:

i_name:	 .asciz "i"
a_name:	 .asciz "a"
j_name:	 .asciz "j"

		 .globl __var_ptr_area
__var_ptr_area:

i_ptr:	 .long i_name
a_ptr:	 .long a_name
j_ptr:	 .long j_name

__end_var_ptr_area:	 .long 0
