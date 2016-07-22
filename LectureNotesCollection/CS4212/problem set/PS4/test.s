.text
fmin:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $28,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl $4,-28(%ebp)
		 movl -28(%ebp),%eax
		 addl $1,%eax
		 pushl %eax
		 movl $0,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl -28(%ebp),%eax
		 addl $2,%eax
		 pushl %eax
		 movl $1,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl -28(%ebp),%eax
		 addl $3,%eax
		 pushl %eax
		 movl $2,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl -28(%ebp),%eax
		 addl $4,%eax
		 pushl %eax
		 movl $3,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl -28(%ebp),%eax
		 addl $45,%eax
		 pushl %eax
		 movl $4,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl -28(%ebp),%eax
		 addl $6,%eax
		 pushl %eax
		 movl $5,%eax
		 lea -24(%ebp),%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl $0,-28(%ebp)
		 movl $100,min1
		 jmp L2
L1:
		 leal -24(%ebp),%edx
		 movl -28(%ebp),%eax
		 movl (%edx,%eax,4),%eax
		 cmpl %eax,min1
		 jle L0
		 leal -24(%ebp),%edx
		 movl -28(%ebp),%eax
		 movl (%edx,%eax,4),%eax
		 pushl %eax
		 popl %eax
		 movl %eax,min1
L0:
		 movl -28(%ebp),%eax
		 addl $1,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,-28(%ebp)
L2:
		 movl -28(%ebp),%eax
		 cmpl $6,%eax
		 jl L1
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
		 call fmin
		 addl $0,%esp
		 popl %edx
		 popl %ecx
		 movl $12,i
		 movl i,%eax
		 addl $1,%eax
		 pushl %eax
		 movl $0,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl i,%eax
		 addl $2,%eax
		 pushl %eax
		 movl $1,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl i,%eax
		 addl $3,%eax
		 pushl %eax
		 movl $2,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl i,%eax
		 addl $4,%eax
		 pushl %eax
		 movl $3,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl i,%eax
		 addl $45,%eax
		 pushl %eax
		 movl $4,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl i,%eax
		 addl $6,%eax
		 pushl %eax
		 movl $5,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 popl %eax
		 movl %eax,(%ebx)
		 movl $100,min2
		 movl $0,i
		 jmp L5
L4:
		 leal a,%edx
		 movl i,%eax
		 movl (%edx,%eax,4),%eax
		 cmpl %eax,min2
		 jle L3
		 leal a,%edx
		 movl i,%eax
		 movl (%edx,%eax,4),%eax
		 pushl %eax
		 popl %eax
		 movl %eax,min2
L3:
		 movl i,%eax
		 addl $1,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,i
L5:
		 movl i,%eax
		 cmpl $6,%eax
		 jl L4
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

i:		 .long 0
min1:		 .long 0
min2:		 .long 0

		 .globl __var_name_area
__var_name_area:

i_name:	 .asciz "i"
min1_name:	 .asciz "min1"
min2_name:	 .asciz "min2"

		 .globl __var_ptr_area
__var_ptr_area:

i_ptr:	 .long i_name
min1_ptr:	 .long min1_name
min2_ptr:	 .long min2_name

__end_var_ptr_area:	 .long 0

		 .globl __arr_area
__arr_area:

a:		 .space 24

		 .globl __arr_name_area
__arr_name_area:

a_aname:	 .asciz "a"

		 .globl __arr_ptr_area
__arr_ptr_area:

a_aptr:	 .long a_aname

__end_arr_ptr_area:	 .long 0


		 .globl __arr_size_area
__arr_size_area:

a_asize:		 .long 6