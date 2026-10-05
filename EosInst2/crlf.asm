#include   ../bios.inc
#include   ../macros.inc

           proc     crlf

           call     f_inmsg
           db       10,13,0
           rtn

           endp

