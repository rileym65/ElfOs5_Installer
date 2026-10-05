#include   ../macros.inc

; *****************************************************************
; ***** Increment double word pointed to by immediate address *****
; *****************************************************************
           proc    incptr

           lda     r6                  ; retrieve pointer
           phi     r9
           lda     r6
           adi     3                   ; point to lsb
           plo     r9
           ghi     r9
           adci    0
           phi     r9
           ldn     r9                  ; retrieve byte
           adi     1
           str     r9
           dec     r9
           ldn     r9
           adci    0
           str     r9
           dec     r9
           ldn     r9
           adci    0
           str     r9
           dec     r9
           ldn     r9
           adci    0
           str     r9
           rtn

           endp
