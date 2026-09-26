.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  xorl %ecx, %ecx     # lo = 0
  movl %esi, %r8d     # hi = n
  decl %r8d           # hi = (int)n - 1
.loop:
  cmpl %r8d, %ecx     # lo - hi 
  jg .done             # jump to done if lo > hi
  movl  %r8d, %r9d     # mid = hi
  subl  %ecx, %r9d     # mid = hi - lo
  sarl  $1, %r9d       # mid = (hi - lo) / 2
  addl  %ecx, %r9d     # mid = lo + (hi - lo) / 2
  cmpl %edx, (%rdi, %r9, 4)          # arr[mid] - target
  jl .add              # jump to add if arr[mid] < target
  jg .subtract         # jump to subtract if arr[mid] > target
  movl %r9d, %eax      # %eax = mid
  ret                  # return mid

.add:
  movl %r9d, %ecx     # lo = mid
  incl %ecx           # lo = mid + 1
  jmp .loop           # continue loop
.subtract:
  movl %r9d, %r8d     # hi = mid
  decl %r8d           # hi = mid - 1
  jmp .loop           # continue loop
.done:
  movl $-1, %eax      # %eax = -1  
  ret                 # return -1


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
