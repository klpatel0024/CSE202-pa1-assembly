.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    leal (%rdi,%rsi), %eax       # eax = a + b
    addl %edx, %eax              # eax = a + b + c
    movl %eax, %ecx
    shrl $31, %ecx               # ecx = 1 if the sum is negative, else 0
    addl %ecx, %eax              # bias negatives so the shift rounds toward zero
    sarl $1, %eax                # eax = (a + b + c) / 2 (p)
    movl %eax, %r8d              # r8d = (a + b + c) / 2 (p)

    movl %r8d, %ecx              # ecx = (a + b + c) / 2 (p)
    subl %edi, %ecx              # ecx = p - a
    movl %r8d, %r9d              # %r9d =  (a + b + c) / 2 (p)
    subl %esi, %r9d              # %r9d = p - b
    movl %r8d, %r10d             # %r10d =  (a + b + c) / 2 (p)
    subl %edx, %r10d             # %r10d = p - c

    imull %ecx, %r8d             # %r8d = p * (p-a)
    imull %r9d, %r8d             # %r8d = p * (p-a) * (p-b)
    imull %r10d, %r8d            # %r8d = p * (p-a) * (p-b) * (p-c)
    movl %r8d, %edi              # argument for r_sqrt
    
r_sqrt:
    cmpl $0, %edi                # p * (p-a) * (p-b) * (p-c) - 0
    jl .negative                 # x < 0, jump to negative
    cmpl $2, %edi                # edi - 2
    jl .small                    # x < 2, jump to small

    pushq %rbx                   # save rbx into stack
    movl %edi, %ebx              # %ebx = x
    sarl $2, %edi                # %edi = x >> 2
    callq r_sqrt                 # %eax = r_sqrt(x >> 2)
    addl %eax, %eax              # %eax = r_sqrt(x >> 2) << 1
    leal 1(%rax), %ecx           # %ecx = %rax + 1
    movl %ecx, %edx              # edx = %rax + 1
    imull %edx, %edx             # %edx = large_cand * large_cand
    cmpl %ebx, %edx              # large^2 - x
    jg .return                   # if large^2 > x, jump to return
    movl %ecx, %eax              # %eax =  %rax + 1
.return:
    popq %rbx                    # pop rbx from stack
    ret                          # return %eax

.negative:
    movl $-1, %eax               # %eax = -1
    ret                          # return %eax 

.small:
    movl %edi, %eax              # return x
    ret                          # return eax 


# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
