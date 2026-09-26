.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movl %esi, %ecx
  shrl $1, %ecx                 # ecx = n / 2 (unsigned)
  xorl %eax, %eax               # i = 0

.loop:
  cmpl %ecx, %eax               # flags from i - n/2
  jae .done                     # i >= n/2 (unsigned): done

  movl %esi, %edx               # %esi = n
  subl %eax, %edx               # edx = n - i
  decl %edx                     # edx = n - i - 1

  movq (%rdi,%rax,8), %r8       # temp = list[i]
  movq (%rdi,%rdx,8), %r9       # r9 = list[n-i-1]
  movq %r9, (%rdi,%rax,8)       # list[i] = list[n-i-1]
  movq %r8, (%rdi,%rdx,8)       # list[n-i-1] = temp

  incl %eax                     # i++
  jmp .loop

.done:
  retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
