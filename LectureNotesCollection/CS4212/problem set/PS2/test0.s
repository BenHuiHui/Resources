		 .section .text
		 .globl _start
_start:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $1
		 popl %eax
		 movl %eax,x
		 pushl %eax
		 popl %eax
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .comm x,4,4
