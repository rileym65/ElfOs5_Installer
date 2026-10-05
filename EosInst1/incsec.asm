#include   ../macros.inc

           proc    incsec

           inc     r7
           glo     r7
           str     r2
           ghi     r7
           or
           lsnz
           inc     r8
           nop
           rtn

           endp
