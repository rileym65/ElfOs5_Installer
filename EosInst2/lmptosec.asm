#include   ../macros.inc

           proc    lmptosec

           ldi     3                   ; need 3 shifts
           plo     re
loop:      glo     r7                  ; multiply by 2
           shl
           plo     r7
           ghi     r7
           shlc
           phi     r7
           glo     r8
           shlc
           plo     r8
           glo     r8
           shlc
           phi     r8
           dec     re                  ; see if done
           ghi     re
           lbnz    loop
           rtn

           endp

