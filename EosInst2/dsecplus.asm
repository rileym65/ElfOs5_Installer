#include   ../macros.inc

           proc    dsecplus

           extrn   loadr7r8
           extrn   datasec

           lda     r6                  ; get additive
           stxd                        ; save for now
           call    loadr7r8            ; get data sector
           dw      datasec
           irx                         ; move x back to additive
           glo     r7                  ; and add to sector address
           add
           plo     r7
           ghi     r7
           adci    0
           phi     r7
           glo     r8
           adci    0
           plo     r8
           ghi     r8
           adci    0
           phi     r8
           rtn                          ; return to caller

           endp
