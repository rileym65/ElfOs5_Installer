#include   ../macros.inc

           proc    filldir

           extrn   d_idewrite
           extrn   incsec
           extrn   zero

           call    zero                ; zero sector buffer
filloop:   glo     r7                  ; see if done
           ani     7
           lbz     filldone
           call    d_idewrite
           call    incsec
           lbr     filloop
filldone:  rtn

           endp
