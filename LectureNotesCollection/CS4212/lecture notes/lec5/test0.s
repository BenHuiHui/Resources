
		 .text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 movl $1,i
		 jmp L14
L13:
		 movl $8,%ecx
		 movl i,%eax
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 jmp * L0(,%edx,4)
L0:
		 .long L9
		 .long L9
		 .long L12
		 .long L9
		 .long L11
		 .long L9
		 .long L10
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
		 .long L9
L12:
		 movl c1,%eax
		 addl i,%eax
		 movl %eax,c1
		 jmp L1
L11:
		 movl $2,%ecx
		 movl i,%eax
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 addl c2,%eax
		 movl %eax,c2
		 jmp L1
L10:
		 movl c3,%eax
		 addl $1,%eax
		 imull c3,%eax
		 movl %eax,c3
		 jmp L1
L9:
		 movl $0,j
		 jmp L8
L7:
		 movl j,%eax
		 jmp * L2(,%eax,4)
L2:
		 .long L6
		 .long L4
		 .long L5
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
		 .long L4
L6:
		 movl c0,%eax
		 addl $1,%eax
		 movl %eax,c0
		 jmp L3
L5:
		 movl c0,%eax
		 imull c0,%eax
		 movl %eax,c0
		 jmp L3
L4:
		 movl c0,%eax
		 addl $2,%eax
		 movl %eax,c0
L3:
		 movl j,%eax
		 addl $1,%eax
		 movl %eax,j
L8:
		 movl j,%eax
		 cmpl i,%eax
		 jl L7
L1:
		 movl i,%eax
		 addl $1,%eax
		 movl %eax,i
L14:
		 movl i,%eax
		 cmpl $100,%eax
		 jl L13
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

c1:		 .long 0
c2:		 .long 0
c3:		 .long 0
c0:		 .long 0
j:		 .long 0
i:		 .long 0

		 .globl __var_name_area
__var_name_area:

c1_name:	 .asciz "c1"
c2_name:	 .asciz "c2"
c3_name:	 .asciz "c3"
c0_name:	 .asciz "c0"
j_name:	 .asciz "j"
i_name:	 .asciz "i"

		 .globl __var_ptr_area
__var_ptr_area:

c1_ptr:	 .long c1_name
c2_ptr:	 .long c2_name
c3_ptr:	 .long c3_name
c0_ptr:	 .long c0_name
j_ptr:	 .long j_name
i_ptr:	 .long i_name

__end_var_ptr_area:	 .long 0
