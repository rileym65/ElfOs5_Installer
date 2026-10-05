#include   ../macros.inc

; **********************************
; ***** build LAT table        *****
; ***** R8:R7 - current sector *****
; ***** RB:RA - AU counter     *****
; ***** RC    - dta pointer    *****
; ***** RD.0  - pre-alloc      *****
; **********************************
           proc    buildlat

           extrn   aus
           extrn   d_idewrite
           extrn   dataau
           extrn   datasec
           extrn   decptr
           extrn   incau
           extrn   incsec
           extrn   lataus
           extrn   loadr7r8
           extrn   sector
           extrn   zerocheck

           ldi     17                  ; starts in sector 17
           plo     r7
           ldi     0
           phi     r7
           plo     r8
           ldi     0e0h
           phi     r8
           ldi     10                  ; pre-allocated lumps
           plo     rd
           ldi     0                   ; AU counter starts at zero
           plo     ra
           phi     ra
           plo     rb
           phi     rb
latsloop:  mov     rc,sector           ; point to sector buffer
latloop:   ghi     rc                  ; see if end of buffer
           smi     3
           lbz     latdone             ; done with sector
           call    zerocheck           ; see if lataus > 0
           dw      lataus
           lbz     notlataus           ; jump if no longer lat aus
           ldi     0ffh                ; unavailable lump
           str     rc
           inc     rc
           str     rc
           inc     rc
           call    decptr              ; decrement lataus
           dw      lataus
           call    decptr              ; decrement aus
           dw      aus
           call    incau               ; increment au counter
           lbr     latloop             ; then loop back
notlataus: glo     rd                  ; see if still in prealloc
           lbz     notpre              ; no more pre-allocated
           smi     7                   ; check for kernel lump
           lbnz    notkernel           ; jump if not kernel
           push    r7                  ; save sector
           push    r8
           call    loadr7r8            ; get datalat
           dw      dataau
           glo     r7                  ; plus 4
           adi     4
           plo     r7
           ghi     r7
           adci    0
           phi     r7
           glo     r8
           adci    0
           plo     r8
           ghi     r8
           adci    0
           plo     r8
           ghi     r7                  ; write second kernel au to LAT
           str     rc
           inc     rc
           glo     r7
           str     rc
           inc     rc
           pop     r8                  ; recover sector
           pop     r7
           lbr     decpre              ; then continue
notkernel: ldi     0feh                ; write end of lump marker
           str     rc
           inc     rc
           str     rc
           inc     rc
decpre:    dec     rd                  ; decrement preallocated
           call    decptr              ; decrement aus
           dw      aus
           call    incau               ; increment au counter
           lbr     latloop             ; then loop back
notpre:    ghi     rb                  ; see if 0000fefe
           str     r2
           glo     rb
           or
           lbnz    notfefe
           ghi     ra
           smi     0feh
           lbnz    notfefe
           glo     ra
           smi     0feh
           lbnz    notfefe
           ldi     0feh                 ; write lump terminator
           str     rc
           inc     rc
           str     rc
           inc     rc
           call    decptr               ; decrement aus
           dw      aus
           call    incau                ; increment au counter
           lbr     latloop              ; then back to beginning ofl oop
notfefe:   call    zerocheck            ; see if done with allocatable aus
           dw      aus
           lbdf    endofaus             ; jump if so
           ldi     0                    ; otherwise au is free
           str     rc
           inc     rc
           str     rc
           inc     rc
           call    decptr               ; decrement aus
           dw      aus
           call    incau                ; and increment au counter
           lbr     latloop              ; then back to beginning of loop
endofaus:  ldi     0ffh                 ; mark as unallocatable
           str     rc
           inc     rc
           str     rc
           inc     rc
           lbr     latloop
latdone:   ghi     r8
           ani     0fh
           ori     0e0h
           phi     r8
           call    d_idewrite          ; write current sector
           call    incsec              ; increment sector pointer
           mov     rf,datasec+1        ; need to see if hit data sector
           lda     rf
           str     r2
           glo     r8
           sm
           lbnz    latsloop
           lda     rf
           str     r2
           ghi     r7
           sm
           lbnz    latsloop
           lda     rf
           str     r2
           glo     r7
           sm
           lbnz    latsloop
           rtn                          ; all done with LAT table

           endp

