.text
fmin:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $28,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl $9,-24(%ebp)
		 movl $7,-20(%ebp)
		 movl $4,-16(%ebp)
		 movl $6,-12(%ebp)
		 movl $8,-8(%ebp)
		 movl $10,-4(%ebp)
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
		 movl %eax,min1
L0:
		 movl -28(%ebp),%eax
		 addl $1,%eax
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

         pushl $2
         leal i,%ebx
         popl %esi
         imull $4,%esi
         add %esi,%ebx
         movl $5,(%ebx)

         mov $2, %eax
         mov $1, %ebx
         cmp %eax,%ebx
         jle LE
         mov $1,%eax
         jmp ELE
LE:
         mov $2,%eax
ELE:

		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

i:		 .long 0
a:		 .long 0
b:		 .long 0
c:		 .long 0
d:		 .long 0
e:		 .long 0
f:		 .long 0
min1:		 .long 0
min2:		 .long 0

		 .globl __var_name_area
__var_name_area:

i_name:	 .asciz "i"
a_name:	 .asciz "a"
b_name:	 .asciz "b"
c_name:	 .asciz "c"
d_name:	 .asciz "d"
e_name:	 .asciz "e"
f_name:	 .asciz "f"
min1_name:	 .asciz "min1"
min2_name:	 .asciz "min2"

		 .globl __var_ptr_area
__var_ptr_area:

i_ptr:	 .long i_name
a_ptr:	 .long a_name
b_ptr:	 .long b_name
c_ptr:	 .long c_name
d_ptr:	 .long d_name
e_ptr:	 .long e_name
f_ptr:	 .long f_name
min1_ptr:	 .long min1_name
min2_ptr:	 .long min2_name

__end_var_ptr_area:	 .long 0
