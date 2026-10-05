#include   ../macros.inc

           proc    getdata

           lda     r6
           phi     ra
           lda     r6
           plo     ra
           lda     r6
           stxd
           lda     r6
           str     r2
           glo     ra
           add
           plo     ra
           irx
           ghi     ra
           adc
           phi     ra
           rtn

           endp

