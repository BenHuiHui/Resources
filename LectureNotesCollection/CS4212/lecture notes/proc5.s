.text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $20,%esp
		 movl $1,i
		 jmp L17
L16:
		 movl $0,-4(%ebp)
		 movl $0,-8(%ebp)
		 movl $0,-12(%ebp)
		 movl $0,-16(%ebp)
		 movl $8,%ecx
		 movl i,%eax
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 jmp * L0(,%edx,4)
L0:
		 .long L12
		 .long L12
		 .long L15
		 .long L12
		 .long L14
		 .long L12
		 .long L13
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
		 .long L12
L15:
		 movl -8(%ebp),%eax
		 addl i,%eax
		 movl %eax,-8(%ebp)
		 jmp L1
L14:
		 movl $2,%ecx
		 movl i,%eax
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 addl -12(%ebp),%eax
		 movl %eax,-12(%ebp)
		 jmp L1
L13:
		 movl -12(%ebp),%eax
		 cmpl -8(%ebp),%eax
		 jne L2
		 movl -16(%ebp),%eax
		 subl $1,%eax
		 imull -12(%ebp),%eax
		 movl %eax,-16(%ebp)
		 jmp L3
L2:
		 movl -16(%ebp),%eax
		 addl $1,%eax
		 imull -16(%ebp),%eax
		 movl %eax,-16(%ebp)
L3:
		 jmp L1
L12:
		 movl $0,-20(%ebp)
		 jmp L11
L10:
		 movl -20(%ebp),%eax
		 jmp * L4(,%eax,4)
L4:
		 .long L9
		 .long L7
		 .long L8
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
		 .long L7
L9:
		 movl -4(%ebp),%eax
		 cmpl $0,%eax
		 jl L6
		 movl -4(%ebp),%eax
		 addl $1,%eax
		 movl %eax,-4(%ebp)
L6:
		 jmp L5
L8:
		 movl -4(%ebp),%eax
		 imull -4(%ebp),%eax
		 movl %eax,-4(%ebp)
		 jmp L5
L7:
		 movl -4(%ebp),%eax
		 addl $2,%eax
		 movl %eax,-4(%ebp)
L5:
		 movl -20(%ebp),%eax
		 addl $1,%eax
		 movl %eax,-20(%ebp)
L11:
		 movl -20(%ebp),%eax
		 cmpl i,%eax
		 jl L10
		 movl -20(%ebp),%eax
		 movl %eax,gj
L1:
		 movl i,%eax
		 addl $1,%eax
		 movl %eax,i
		 movl -4(%ebp),%eax
		 movl %eax,gc0
		 movl -8(%ebp),%eax
		 movl %eax,gc1
		 movl -12(%ebp),%eax
		 movl %eax,gc2
		 movl -16(%ebp),%eax
		 movl %eax,gc3
L17:
		 movl i,%eax
		 cmpl $100,%eax
		 jl L16
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

gc3:		 .long 0
gc2:		 .long 0
gc1:		 .long 0
gc0:		 .long 0
gj:		 .long 0
i:		 .long 0

		 .globl __var_name_area
__var_name_area:

gc3_name:	 .asciz "gc3"
gc2_name:	 .asciz "gc2"
gc1_name:	 .asciz "gc1"
gc0_name:	 .asciz "gc0"
gj_name:	 .asciz "gj"
i_name:	 .asciz "i"

		 .globl __var_ptr_area
__var_ptr_area:

gc3_ptr:	 .long gc3_name
gc2_ptr:	 .long gc2_name
gc1_ptr:	 .long gc1_name
gc0_ptr:	 .long gc0_name
gj_ptr:	 .long gj_name
i_ptr:	 .long i_name

__end_var_ptr_area:	 .long 0
