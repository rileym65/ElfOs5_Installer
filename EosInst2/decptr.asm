#include   ../macros.inc

; *****************************************************************
; ***** Decrement double word pointed to by immediate address *****
; *****************************************************************
           proc    decptr

           lda     r6                  ; retrieve pointer
           phi     r9
           lda     r6
           adi     3                   ; point to lsb
           plo     r9
           ghi     r9
           adci    0
           phi     r9
           ldn     r9                  ; retrieve byte
           smi     1
           str     r9
           dec     r9
           ldn     r9
           smbi    0
           str     r9
           dec     r9
           ldn     r9
           smbi    0
           str     r9
           dec     r9
           ldn     r9
           smbi    0
           str     r9
           rtn

           endp
