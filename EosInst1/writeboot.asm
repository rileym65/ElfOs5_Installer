#include   ../macros.inc
#include   equ.inc

; *************************************
; ***** Write sectors 0, 1, and 2 *****
; *************************************
           proc    writeboot

           extrn   aus
           extrn   copy
           extrn   d_idewrite
           extrn   data
           extrn   datasec
           extrn   getdata
           extrn   loadr7r8
           extrn   sectolmp
           extrn   sector
           extrn   sectors
           extrn   storer7r8
           extrn   zero

           call    zero                ; zero out sector buffer
           mov     rf,sector           ; point to sector buffer

;           mov     ra,data+sector0_offset ; point to sector 0 data
           call    getdata
           dw      data
           dw      sector0_offset

           mov     rc,sector0_size     ; number of bytes to copy
           call    copy                ; copy pre-bootloader
           mov     rf,sector+100h      ; copy master data
           mov     ra,sectors
           mov     rc,4
           call    copy
           ldi     1                   ; fstype
           str     rf
           inc     rf
           call    loadr7r8            ; get data sector
           dw      datasec
           ghi     r7                  ; write to sector 0
           str     rf
           inc     rf
           glo     r7
           str     rf
           inc     rf
           ldi     2                   ; 2 sectors for pre-boot
           str     rf
           inc     rf
           inc     rf
           inc     rf
           ldi     8                   ; 8 sectors per lump
           str     rf
           inc     rf
           call    loadr7r8            ; get data sector
           dw      aus
           ghi     r7                  ; write to sector 0
           str     rf
           inc     rf
           glo     r7
           str     rf
           inc     rf
           mov     rf,sector+110h      ; copy md sector
           mov     ra,datasec
           mov     rc,4
           call    copy
           call    loadr7r8            ; get data sector
           dw      datasec
           call    sectolmp            ; convert to lump
           call    storer7r8           ; write to sector 0
           dw      sector+012ch
           mov     rf,sector+0130h     ; point to eof
           ldi     0fh                 ; write eof
           str     rf
           inc     rf
           ldi     0ffh
           str     rf
           inc     rf
           ldi     5                   ; flags
           str     rf
           inc     rf
           ldi     0                   ; now 5 zeroes
           str     rf
           inc     rf
           str     rf
           inc     rf
           str     rf
           inc     rf
           str     rf
           inc     rf
           str     rf
           inc     rf
           ldi     'M'                 ; name of master directory
           str     rf
           inc     rf
           ldi     'D'
           str     rf
           inc     rf
           ldi     0
           str     rf
           ldi     0                   ; need to write sector 0
           plo     r7
           plo     r8
           phi     r7
           ldi     0e0h                ; master drive
           phi     r8
           call    d_idewrite          ; and write sector

           call    zero                ; prepare sector 1
           mov     rf,sector           ; point to sector buffer
;           mov     ra,data+sector1_offset ; point to sector 1 data
           call    getdata
           dw      data
           dw      sector1_offset
           mov     rc,sector1_size     ; number of bytes to copy
           call    copy                ; copy sector data
           inc     r7
           call    d_idewrite

           call    zero                ; prepare sector 2
           mov     rf,sector           ; point to sector buffer
;          mov     ra,data+sector2_offset ; point to sector 2 data
           call    getdata
           dw      data
           dw      sector2_offset
           mov     rc,sector2_size     ; number of bytes to copy
           call    copy                ; copy sector data
           inc     r7
           call    d_idewrite
           rtn                         ; then return to caller

           endp

