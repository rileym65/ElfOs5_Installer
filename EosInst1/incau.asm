#include   ../macros.inc

           proc    incau

           inc     ra
           ghi     ra
           str     r2
           glo     ra
           or
           lsnz
           inc     rb
           nop
           rtn

           endp
