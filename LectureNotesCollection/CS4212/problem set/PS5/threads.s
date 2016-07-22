# Pseudo-concurrency API for PS4

        .text
        
# Procedure that initializes the thread system
# In this simple version, simply saves the stack pointer into
# the thread slot for the main thread        

        .globl init_threads
init_threads:      # threads is an array of thread stack pointers
                   # the main thread is at threads[0]
        movl %esp, threads
        ret

# Procedure to set up the second thread
# Takes into %eax the address of the desired thread
# Sets up a stack for the second thread and the
#  entry in threads[1]        
# Again, we take advantage of the simplicity of our approach
#  here: we're expecting that registers do not contain anything
#  important at the point of setting up a second thread (except
#  for %eax)
        .globl set_second_thread
set_second_thread:
        movl threads+4,%ebx
        subl $4,%ebx
        movl %eax,(%ebx)   # thread address into 'ret' field of stack
        subl $32,%ebx      # space for saving registers
        movl %ebx,threads+4
        ret

# Context switch procedure. Calls to this procedure can be
# inserted _anywhere_ in the body of a thread to trigger a
# context switch. There is NO REQUIREMENR that this call 
# should be placed only between statements. The more frequent
# the calls, the finer the granularity of the concurrency

        .globl cosw
cosw:
        pushf
        push %ebp # save all registers
        push %esi
        push %edi
        push %ebx
        push %ecx
        push %edx
        push %eax
        movl curr_thread,%eax # save %esp in slot of current thread
        movl %eax,%ebx        #  i.e. threads[curr_thread] = %esp

        shll $2,%ebx        # TODO: what does it do here?
        addl $threads,%ebx

        movl %esp,(%ebx)      # toggle thread number
        xorl $1,%eax          #  i.e. curr_thread ^= 1  TODO: by changing it here may support multiple threads instead of 2
        movl %eax,curr_thread
        movl %eax,%ebx       # load %esp from thread slot
        shll $2,%ebx         #   i.e. %esp = threads[curr_thread]
        addl $threads,%ebx
        movl (%ebx),%esp

        popl %eax            # restore registers of new thread
        popl %edx
        popl %ecx
        popl %ebx
        popl %edi
        popl %esi
        popl %ebp
        popf
        ret                 # This will resume the new thread

# Procedure to join the two threads into one
# The threads will set a flag to one, and then
# wait on each other's flag so as to make sure
# that they both have completed. Once that is achieved
# the main thread will simply no longer context-switch
# into the second thread, effectively terminating it.

        .globl single_thread
single_thread:
        movl curr_thread,%eax # find flag location for current thread
        movl %eax,%ebx
        shll $2,%eax
        addl $single_flag1,%eax
        movl $1,(%eax)        # set current flag
        
        # this loop will end up being executed by second thread
        # it appears to be an infinite loop, but it only executes
        # when main thread context-switches here -- this will
        # stop happening when main thread reaches join point
        
wait_main_thread_join:  
        cmpl $0,%ebx               # check if this is the main thread 
        jz  wait_snd_thread_join   # and jump to loop of main thread
        
        call cosw                  # if second thread, context-switch
        jmp wait_main_thread_join  # to allow main thread to complete
                                   # context switch will return into
                                   # second thread only if second thread
                                   # reached join point first -- repeated
                                   # context switches will allow main
                                   # thread to complete
                                   
        # this loop will be executed only by the main thread
        # it waits for the second thread to complete by checking its
        # flag and context-switching to it to allow it to progress
        # once single_flag2 is set, main thread stops context-switching
        # effectively completing the second thread
wait_snd_thread_join:
        cmpl $1,single_flag2
        jz joined
        call cosw
        jmp wait_snd_thread_join
        
        # the two threads are joined at this point
        # and the procedure can simply return,
        # allowing sequential execution of the main program
        # from this point on
joined:
        ret
        
        .data
        .globl curr_thread
curr_thread:      # holds the id of the currently running thread
         .long 0  # either 0 or 1, toggled by the context switch procedure
         
        .globl threads
threads:            # array of two elements, holding saved stack 
                    # pointers for each thread
         .long 0    # first elem will be set by init_threads
         .long thread2_stack # second elem can be statically initialized
                             # with buffer allocated for second stack

        .globl single_flag1
        .globl single_flag2
single_flag1:       # two flags allowing the threads to synchronize
         .long 0
single_flag2:
         .long 0         

        .globl thread2_start_stack
        .globl thread2_stack         
thread2_start_stack: # buffer for stack of second thread
         .space 1000
thread2_stack:
         .long 0

