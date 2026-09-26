.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    xorl %eax, %eax               # i = 0

.loop:
    cmpl %ecx, %eax               # flags from i - size
    jae .done                     # i >= size (unsigned): leave the loop

    movss (%rdi,%rax,4), %xmm0    # xmm0 = a[i]
    mulss (%rsi,%rax,4), %xmm0    # xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx,%rax,4)    # c[i] = xmm0

    incl %eax                    # i++
    jmp .loop

.done:
    ret

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
