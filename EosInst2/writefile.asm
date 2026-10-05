#include ../macros.inc

; ***********************************
; ***** Write file to disk      *****
; ***** R8:R7 - starting sector *****
; ***** RA    - Address of data *****
; ***** RC    - Count           *****
; ***********************************
           proc    writefile

           extrn   sector
           extrn   zero
           extrn   incsec
           extrn   d_idewrite

           call    zero                ; zero the sector buffer
           mov     rf,sector           ; point to sector buffer
fileloop:  glo     rc                  ; see if done
           str     r2
           ghi     rc
           or
           lbz     filedone            ; jump if done
           lda     ra                  ; read byte from data
           str     rf                  ; store into sector
           inc     rf
           dec     rc                  ; decrement byte count
           ghi     rf                  ; see if done with sector
           smi     3
           lbnz    fileloop            ; jump if not done with sector
           call    d_idewrite          ; write sector to disk
           call    incsec              ; increment sector
           lbr     writefile           ; and loop back until done
filedone:  call    d_idewrite          ; write final sector
           rtn                         ; and return to caller

           endp

