#include   ../macros.inc

; ********************************************************
; ***** Check dword pointed to by immediate for zero *****
; ********************************************************
           proc    zerocheck

           lda     r6
           phi     r9
           lda     r6
           plo     r9
           lda     r9
           lbnz    notzero
           lda     r9
           lbnz    notzero
           lda     r9
           lbnz    notzero
           lda     r9
           lbnz    notzero
           smi     0
           rtn
notzero:   adi     0
           rtn

           endp
