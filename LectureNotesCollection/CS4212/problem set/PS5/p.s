
# This code is an illustration of how a compiler could generate
# pseudo-concurrent code. It assumes that the compiler would be
# obtained from the comp_stmt.pro toy compiler, where expressions
# are (naively) translated into simulated stack-machine operations.
# This compiler would be changed to allow a simple threading construct
# and would insert context-switch calls at random positions in the
# sequential bodies of the threads.

# The threading infrastructure assumes only 2 threads, though the system
# could be easily extended to support any (fixed) number of threads).
# For detailed explanations on how the code is expected to work, read
# the PS5 handout

# The following is the toy program from which the 
# AL code below is expected to be generated

#  i = 0 ; j = 0 ; a = 0 ;
#  { % thread 0
#    while i < 10 do {
#      a = a + 1 ;
#      i = i + 1 ;
#    } 
#  } || { % thread 1
#    while j < 10 do {
#      a = a - 1 ;
#      j = j + 1 ;
#    }
#  }
#  
#  The above code has a race condition on variable a, which,
#  in a truly non-deterministic execution of the two threads,
#  should end up with random values between -10 and 10.

		 .text
		 .globl _entry
_entry:                 # initial sequential segment
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $0
		 popl %eax
		 movl %eax,i    # i = 0
		 pushl %eax
		 popl %eax
		 pushl $0
		 popl %eax
		 movl %eax,j    # j = 0
		 pushl %eax
		 popl %eax
		 pushl $0
		 popl %eax
		 movl %eax,a    # a = 0
		 pushl %eax
		 popl %eax
		 
		 # intialize the thread system
         call init_threads
         
         # second thread begins at L6
         movl $L6,%eax
         call set_second_thread
         
         # from this point on, we have two threads
         # and any call to cosw will switch to the other
         # thread
         
         # code of first thread
		 jmp L2
L3:
		 pushl a
		 call cosw  # randomly inserted context switch
		 pushl $1
		 popl %ebx
		 popl %eax
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,a
		 pushl %eax
		 popl %eax
		 pushl i
		 call cosw  # randomly inserted context switch
		 pushl $1
		 popl %ebx
		 call cosw  # randomly inserted context switch
		 popl %eax
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,i
		 call cosw  # randomly inserted context switch
		 pushl %eax
		 popl %eax
L2:
		 pushl i
		 pushl $10
		 popl %eax
		 call cosw  # randomly inserted context switch
		 popl %ebx
		 cmpl %eax,%ebx
		 jge L0
		 pushl $1
		 jmp L1
L0:
		 pushl $0
L1:
		 popl %eax
		 cmpl $0,%eax
		 jne L3
		 jmp join  # end of first thread
		           # jump to the join point
		 
L7:      # second thread begins here
		 pushl a
		 pushl $1
		 popl %ebx
		 call cosw  # randomly inserted context switch
		 popl %eax
		 subl %ebx,%eax
		 pushl %eax
		 call cosw  # randomly inserted context switch
		 popl %eax
		 movl %eax,a
		 pushl %eax
		 popl %eax
         call cosw  # randomly inserted context switch
		 pushl j
		 pushl $1
		 popl %ebx
		 call cosw  # randomly inserted context switch
		 popl %eax
		 call cosw  # randomly inserted context switch
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,j
		 pushl %eax
		 popl %eax
L6:
		 pushl j
		 pushl $10
		 call cosw  # randomly inserted context switch
		 popl %eax
		 popl %ebx
		 cmpl %eax,%ebx
		 jge L4
		 call cosw  # randomly inserted context switch
		 pushl $1
		 jmp L5
L4:
		 pushl $0
L5:
		 popl %eax
		 call cosw
		 cmpl $0,%eax
		 jne L7
		 
join:    # join point, both threads will arrive here at different points
         call single_thread
         # single thread at this point, normal return from procedure
		 movl %ebp,%esp
		 popl %ebp
		 ret

        
        .data
		 .globl __var_area
__var_area:

i:		 .long 0
a:		 .long 0
j:		 .long 0

		 .globl __var_ptr_area
__var_ptr_area:

i_ptr:	 .long i_name
a_ptr:	 .long a_name
j_ptr:	 .long j_name

__end_var_ptr_area:	 .long 0


		 .globl __var_name_area
__var_name_area:

i_name:	 .asciz "i"
a_name:	 .asciz "a"
j_name:	 .asciz "j"

         
