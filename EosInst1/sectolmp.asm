#include   ../macros.inc

           proc    sectolmp

           ldi     3                   ; need 3 shifts
           plo     re
loop:      ghi     r8                  ; divide by 2
           shr
           phi     r8
           glo     r8
           shrc
           plo     r8
           ghi     r7
           shrc
           phi     r7
           glo     r7
           shrc
           plo     r7
           dec     re                  ; see if done
           glo     re
           lbnz    loop
           rtn

           endp

