.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  xorl %eax, %eax             # n = 0
.loop:
  movzbl (%rdi,%rax), %ecx    # eax = a[n], zero-extended from a byte
  testb  %cl, %cl             # al && al 
  je .done                    # end loop
  cmpb (%rsi,%rax), %cl       # a[n] = b[n]
  jne .done                    # end loop
  incl %eax                   # %eax = n + 1
  jmp .loop                   # continue loop
.done:
  retq                        # return n


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
