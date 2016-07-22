 .file "test1.c"
 .text
 .p2align 4,,15
.globl _f
 .def _f; .scl 2; .type 32; .endef
_f:
 pushl %ebp
 movl %esp, %ebp
 subl $12, %esp         # room to save callee saved registers
 movl 24(%ebp), %eax    # eax = e
 movl 20(%ebp), %ecx    # ecx = d
 movl %edi, 8(%esp)     # save edi
 movl 28(%ebp), %edi    # edi = f
 movl %ebx, (%esp)      # save ebx
 movl %eax, %edx        # edx = eax
 sarl $31, %edx         # sign extend
 leal (%eax,%ecx), %ebx # ebx = eax+ecx (e+d)
 idivl %edi             # eax /= edi    (e/f)
 movl %ecx, %edx        # edx = ecx     (d)
 addl 32(%ebp), %ebx    # ebx += g      (g+d+e)
 movl %esi, 4(%esp)     # save esi
 movl 12(%ebp), %esi    # esi = b
 addl 8(%ebp), %esi     # esi += a      (b+a)
 subl %eax, %edx        # edx -= eax    (d-e/f)
 movl %edx, %eax        # eax = edx     (d-e/f)
 imull %edi, %eax       # eax *= edi    ((d-e/f)*f)
 movl 8(%esp), %edi     # restore edi
 leal (%ebx,%eax), %eax # eax = ebx+eax (e+d+g+(d-e/f)*f)
 movl (%esp), %ebx      # restore ebx
 imull 36(%ebp), %eax   # eax *= h      (e+d+g+(d-e/f)*f)*h
 movl %eax, %edx        # edx = eax
 sarl $31, %edx         # sign extend
 idivl 40(%ebp)         # eax /= i      (e+d+g+(d-e/f)*f)*h/i
 movl %eax, %edx        # edx *= eax    
 sarl $31, %edx         # sign extend
 idivl 8(%ebp)          # eax /= a      (e+d+g+(d-e/f)*f)*h/i/a
 movl %eax, %edx        # edx = eax
 sarl $31, %edx         # sign extend
 idivl 12(%ebp)         # eax /= b      (e+d+g+(d-e/f)*f)*h/i/a/b
 movl %eax, %edx        # edx = eax
 sarl $31, %edx         # sign extend
 idivl 16(%ebp)         # eax /= c      (e+d+g+(d-e/f)*f)*h/i/a/b/c
 movl %eax, %edx        # edx = eax
 sarl $31, %edx         # sign extend
 idivl %ecx             # eax /= ecx    (e+d+g+(d-e/f)*f)*h/i/a/b/c/d
 movl %esi, %edx        # edx = esi
 subl 16(%ebp), %edx    # edx -= c      (a+b-c)
 imull %esi, %ed        # edx *= esi    (a+b)*(a+b-c)
 movl 4(%esp), %esi     # restore esi
 movl %ebp, %esp        
 popl %ebp
 addl %edx, %eax        #  (a+b)*(a+b-c)+(e+d+g+(d-e/f)*f)*h/i/a/b/c/d  
 ret
