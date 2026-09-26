.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl   $2, %edi             # n-2 
  jl .less                    # jump to less if n<2
  testl $1, %edi              # n && 1  
  je .even                    # jump if n is even
  movl $3, %ecx               # i = 3

.loop:
  movl %ecx, %eax            # eax = i
  imull %eax, %eax           # eax = i * i
  cmpl %edi, %eax            # i*i - n
  jg .prime                  # jump to prime if i*i > n

  movl %edi, %eax            # eax = n
  cltd                       # sign-extend eax into edx:eax
  idivl %ecx                 # eax = n / i, edx = n % i
  testl %edx, %edx           # n%1 && n%1
  je .less                   # jump to less if n%1 == 0

  addl $2, %ecx              # i += 2
  jmp .loop                  # continue loop

.less:
  movl $0, %eax              # %eax = 0
  ret                        # return %eax
.even:
  cmpl   $2, %edi              # n-2
  sete   %al                   # set n==2 to %al
  movzbl %al, %eax             # fill all bytes of %eax with %al
  ret                          # return %eax
.prime:
  movl $1, %eax                # %eax = 1
  ret                          # return %eax

# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
