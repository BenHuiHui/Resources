.text
		 .globl _entry
_entry:
		 pushl %ebp
		 movl %esp,%ebp
		 movl $0,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 movl $4,(%ebx)
		 movl $1,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 movl $5,(%ebx)
		 movl $2,%eax
		 lea a,%ebx
		 imull $4,%eax
		 addl %eax,%ebx
		 movl $6,(%ebx)
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:


		 .globl __var_name_area
__var_name_area:


		 .globl __var_ptr_area
__var_ptr_area:


__end_var_ptr_area:	 .long 0

		 .globl __arr_area
__arr_area:

a:		 .space 12

		 .globl __arr_name_area
__arr_name_area:

a_aname:	 .asciz "a"

		 .globl __arr_ptr_area
__arr_ptr_area:

a_aptr:	 .long a_aname

__end_arr_ptr_area:	 .long 0


		 .globl __arr_size_area
__arr_size_area:

a_asize:		 .long 3