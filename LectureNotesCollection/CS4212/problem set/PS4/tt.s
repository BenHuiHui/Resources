  .globl _entry
_entry:

# entering
  pushl %ebp
  movl %esp,%ebp

  leal arr+2,%eax
  
# clean up
END:  
  movl %ebp,%esp
  popl %ebp
  ret

  .data
arr: .space 5 * 4,0
