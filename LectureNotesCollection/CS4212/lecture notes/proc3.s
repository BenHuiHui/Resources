.text
facttc:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $4,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl 8(%ebp),%eax
		 cmpl $0,%eax
		 je L0
		 pushl %ecx
		 pushl %edx
		 movl 12(%ebp),%eax
		 imull 8(%ebp),%eax
		 pushl %eax
		 movl 8(%ebp),%eax
		 subl $1,%eax
		 pushl %eax
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,-4(%ebp)
		 jmp L1
L0:
		 movl 12(%ebp),%eax
		 movl %eax,-4(%ebp)
L1:
		 movl -4(%ebp),%eax
		 popl %edi
		 popl %esi
		 popl %ebx
		 movl %ebp,%esp
		 popl %ebp
		 ret
fibtc:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $4,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl 8(%ebp),%eax
		 cmpl $0,%eax
		 je L2
		 pushl %ecx
		 pushl %edx
		 pushl 12(%ebp)
		 movl 12(%ebp),%eax
		 addl 16(%ebp),%eax
		 pushl %eax
		 movl 8(%ebp),%eax
		 subl $1,%eax
		 pushl %eax
		 call fibtc
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,-4(%ebp)
		 jmp L3
L2:
		 movl 16(%ebp),%eax
		 movl %eax,-4(%ebp)
L3:
		 popl %edi
		 popl %esi
		 popl %ebx
		 movl %ebp,%esp
		 popl %ebp
		 ret
f:
		 pushl %ebp
		 movl %esp,%ebp
		 subl $12,%esp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl 8(%ebp),%eax
		 addl 12(%ebp),%eax
		 movl %eax,-4(%ebp)
		 movl 8(%ebp),%eax
		 addl 16(%ebp),%eax
		 movl %eax,-8(%ebp)
		 movl 12(%ebp),%eax
		 addl 16(%ebp),%eax
		 movl %eax,-12(%ebp)
		 movl $0,%eax
		 cmpl -4(%ebp),%eax
		 movl $0,%eax
		 setl %al
		 movl -4(%ebp),%edx
		 cmpl $100,%edx
		 movl $0,%edx
		 setl %dl
		 andl %edx,%eax
		 movl $0,%edx
		 cmpl -8(%ebp),%edx
		 movl $0,%edx
		 setl %dl
		 andl %edx,%eax
		 movl -8(%ebp),%edx
		 cmpl $100,%edx
		 movl $0,%edx
		 setl %dl
		 andl %edx,%eax
		 movl $0,%edx
		 cmpl -12(%ebp),%edx
		 movl $0,%edx
		 setl %dl
		 andl %edx,%eax
		 movl -12(%ebp),%edx
		 cmpl $100,%edx
		 movl $0,%edx
		 setl %dl
		 andl %edx,%eax
		 cmpl $0,%eax
		 jne L4
		 movl $1,-4(%ebp)
		 jmp L5
L4:
		 pushl %ecx
		 pushl %edx
		 pushl -12(%ebp)
		 pushl -8(%ebp)
		 pushl -4(%ebp)
		 call f
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 pushl %ecx
		 pushl %edx
		 movl 12(%ebp),%eax
		 subl 16(%ebp),%eax
		 pushl %eax
		 movl 8(%ebp),%eax
		 subl 16(%ebp),%eax
		 pushl %eax
		 movl 8(%ebp),%eax
		 subl 12(%ebp),%eax
		 pushl %eax
		 call f
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 addl %eax,%edx
		 movl %edx,-4(%ebp)
L5:
		 movl -4(%ebp),%eax
		 popl %edi
		 popl %esi
		 popl %ebx
		 movl %ebp,%esp
		 popl %ebp
		 ret
g:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl %ebx
		 pushl %esi
		 pushl %edi
		 movl a,%eax
		 addl $1,%eax
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
		 movl $5,b
		 movl $3,c
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl b
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl c
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 imull %eax,%edx
		 movl %edx,a
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 movl b,%eax
		 addl c,%eax
		 pushl %eax
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,c
		 pushl %ecx
		 pushl %edx
		 pushl $0
		 pushl $1
		 pushl $3
		 call fibtc
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%ecx
		 pushl %ecx
		 pushl %edx
		 pushl $0
		 pushl $1
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl $3
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 pushl %eax
		 call fibtc
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 movl %eax,b
		 pushl %ecx
		 pushl %edx
		 pushl $0
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl $10
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%ecx
		 pushl %ecx
		 pushl %edx
		 pushl $2
		 pushl $10
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 shrl $31,%edx
		 idivl %ecx
		 pushl %eax
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl $2
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl $2
		 call facttc
		 addl $8,%esp
		 popl %edx
		 popl %ecx
		 imull %eax,%edx
		 addl b,%edx
		 pushl %edx
		 call fibtc
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,d
		 pushl %ecx
		 pushl %edx
		 pushl $0
		 pushl $1
		 pushl $6
		 call fibtc
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,e
		 pushl %ecx
		 pushl %edx
		 pushl $30
		 pushl $20
		 pushl $10
		 call f
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,%edx
		 pushl %ecx
		 pushl %edx
		 pushl $1
		 pushl $1
		 pushl $1
		 call f
		 addl $12,%esp
		 popl %edx
		 popl %ecx
		 imull %eax,%edx
		 movl %edx,ff
		 pushl %ecx
		 pushl %edx
		 call g
		 addl $0,%esp
		 popl %edx
		 popl %ecx
		 movl %eax,gg
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .data
		 .globl __var_area
__var_area:

gg:		 .long 0
ff:		 .long 0
e:		 .long 0
d:		 .long 0
c:		 .long 0
b:		 .long 0
a:		 .long 0

		 .globl __var_name_area
__var_name_area:

gg_name:	 .asciz "gg"
ff_name:	 .asciz "ff"
e_name:	 .asciz "e"
d_name:	 .asciz "d"
c_name:	 .asciz "c"
b_name:	 .asciz "b"
a_name:	 .asciz "a"

		 .globl __var_ptr_area
__var_ptr_area:

gg_ptr:	 .long gg_name
ff_ptr:	 .long ff_name
e_ptr:	 .long e_name
d_ptr:	 .long d_name
c_ptr:	 .long c_name
b_ptr:	 .long b_name
a_ptr:	 .long a_name

__end_var_ptr_area:	 .long 0
