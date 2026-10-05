#include   ../macros.inc

           proc     loadr7r8

           lda      r6
           phi      r9
           lda      r6
           plo      r9
           lda      r9
           phi      r8
           lda      r9
           plo      r8
           lda      r9
           phi      r7
           lda      r9
           plo      r7
           rtn

           endp
