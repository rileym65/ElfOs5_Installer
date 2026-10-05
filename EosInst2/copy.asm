#include   ../macros.inc

           proc    copy

           lda     ra                  ; read byte from source
           str     rf                  ; write to destination
           inc     rf
           dec     rc                  ; decrement count
           glo     rc
           lbnz    copy
           ghi     rc
           lbnz    copy
           rtn

           endp
