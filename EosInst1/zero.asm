#include   ../macros.inc

           proc     zero

           extrn    sector

           push     rc
           mov      rf,sector          ; point to sector buffer
           mov      rc,512             ; 512 bytes to zero
loop:      ldi      0                  ; zero next byte
           str      rf
           inc      rf
           dec      rc                 ; check for done
           glo      rc
           str      r2
           ghi      rc
           or
           lbnz     loop               ; loop until all bytes written
           pop      rc
           rtn                         ; return to caller

           endp
