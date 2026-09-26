.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  movswl %di, %edi              # sign-extend %di from 16-bit argument to 32 bits
  movswl %si, %esi              # sign-extend %si from 16-bit argument to 32 bits
  movswl %dx, %edx              # sign-extend %dx from 16-bit argument to 32 bits
  movswl %cx, %ecx              # sign-extend %cx from 16-bit argument to 32 bits

  cmpl %esi, %edi              # v1 - v2
  jl .v1_less                  # if v1 < v2, jump to v1_less
  movl %edi, %r8d              # first = v1
  movl %esi, %r9d              # second = v2
  jmp .third                   #jump to third

.v1_less:
  movl %esi, %r8d              # first = v2
  movl %edi, %r9d              # second = v1

.third:
  cmpl %r8d, %edx              # v3 - first
  jg .v3_first                 # if v3 > firs, jump to v3_first
  cmpl %r9d, %edx              # v3 - second
  jg .v3_second                # if v3 > second, jump to v3_second
  jmp .fourth                  # jump fourth

.v3_first:
  movl %r8d, %r9d              # %r9d = first
  movl %edx, %r8d              # %r8d = v3
  jmp .fourth                  # jump to fourth

.v3_second:
  movl %edx, %r9d              # %r9d = v3

.fourth:
  cmpl %r8d, %ecx              # v4 - first
  jg .v4_first                 # if v4 > first, v4_first
  cmpl %r9d, %ecx              # v4 - second
  jg .v4_second                # if v4 > second, jump to v4_second 
  jmp .done                    # jump  to done

.v4_first:
  movl %r8d, %r9d              # %r9d = first
  movl %ecx, %r8d              # %r8d = v4
  jmp .done                    # jump to done

.v4_second:
  movl %ecx, %r9d              # second = v4

.done:
  movl %r9d, %eax              # return second
  ret                          # return %rax

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
