.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi             # b && b
    movl %edi, %eax              # eax = a (dividend)
    je .base                     # jump to the base case
    cltd                         # sign-extend eax into edx:eax
    idivl %esi                   # edx = a % b
    movl %esi, %edi              # %esi = b
    movl %edx, %esi              # %esi = a % b
    callq gcd                      

.base:
    ret                         # b == 0: return a


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
