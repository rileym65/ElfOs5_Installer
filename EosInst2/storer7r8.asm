#include   ../macros.inc

           proc     storer7r8

           lda      r6
           phi      r9
           lda      r6
           plo      r9
           ghi      r8
           str      r9
           inc      r9
           glo      r8
           str      r9
           inc      r9
           ghi      r7
           str      r9
           inc      r9
           glo      r7
           str      r9
           rtn

           endp
