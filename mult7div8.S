.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl %dil, %edx          # edx = a, sign-extended from 8 to 32 bits
  imull $7, %edx, %ecx       # ecx = 7 * a
  movsbl %cl, %ecx           # ecx = (char)(7 * a)

  testl %edx, %edx           # a && a
  jg .a_pos                  # if a > 0, jump to a_pos
  jl .a_neg                  # if a < 0, jump to a_neg
  jmp .no_ovf                # jump to no_ovf

.a_pos:
  testl %ecx, %ecx           # mult && mult
  jl .ovf                    # if mult < 0, jump to ovf
  jmp .no_ovf                # jump to no_ovf

.a_neg:
  testl %ecx, %ecx           # mult && mult
  jg .ovf                    # if mult > 0, jump to ovf

.no_ovf:
  movb $0, (%rsi)            # *overflow = 0
  jmp .divide                # jump to divide

.ovf:
  movb $1, (%rsi)            # *overflow = 1

.divide:
  movl %ecx, %eax            # eax = mult
  testl %eax, %eax           # mult && mult
  jns .shift                 # if mult >= 0, jump to shift
  addl $7, %eax              # mult += 7
.shift:
  sarl $3, %eax              # eax = eax >> 3
  ret                        # return eax


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
