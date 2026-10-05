#include ../bios.inc
#include ../macros.inc

           proc    d_idewrite

           extrn   sector

           mov     rf,sector
           ghi     r8
           ani     0fh
           ori     0e0h
           phi     r8
           call    f_idewrite
           rtn

           endp
