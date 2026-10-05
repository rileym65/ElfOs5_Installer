#include   ../bios.inc
#include   ../macros.inc

           proc    compute

           extrn   aus
           extrn   crlf
           extrn   dataau
           extrn   datasec
           extrn   incsec
           extrn   itoa32
           extrn   lataus
           extrn   latsects
           extrn   loadr7r8
           extrn   sectolmp
           extrn   sector
           extrn   sectors
           extrn   storer7r8

           mov     rf,sector+120       ; point to sector data
           lda     rf                  ; get sector count
           plo     r7
           lda     rf
           phi     r7
           lda     rf
           plo     r8
           lda     rf
           phi     r8
           call    storer7r8           ; store sectors
           dw      sectors
           call    f_inmsg             ; display number of sectors
           db      'Sectors     : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf
           call    sectolmp            ; convert to lump

           call    storer7r8           ; store AUs
           dw      aus

           call    f_inmsg             ; display number of sectors
           db      'AUs         : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf

           ghi     r7                  ; compute number of LAT sectors
           plo     r7
           glo     r8
           phi     r7
           ghi     r8
           plo     r8
           ldi     0
           phi     r8
           call    incsec
           call    storer7r8
           dw      latsects

           glo     r7                  ; compute starting data sector
           adi     25
           ani     0f8h
           plo     r7
           ghi     r7
           adci    0
           phi     r7
           glo     r8
           adci    0
           plo     r8
           ghi     r8
           adci    0
           phi     r8
           call    storer7r8
           dw      datasec

           call    f_inmsg             ; display number of sectors
           db      'Data Sector : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf

           call    sectolmp            ; get starting data lump
           call    storer7r8
           dw      dataau

           call    f_inmsg             ; display number of sectors
           db      'Data AU     : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf

           call    loadr7r8            ; retrieve data sectors
           dw      datasec
           glo     r7                  ; true last sectors is data sec-17
           smi     17
           plo     r7
           ghi     r7
           smbi    0
           phi     r7
           glo     r8 
           smbi    0
           plo     r8
           ghi     r8
           smbi    0
           phi     r8
           call    storer7r8           ; write actual LAT sector count
           dw      latsects

           call    f_inmsg             ; display number of sectors
           db      'LAT Sectors : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf
           
           call    loadr7r8            ; data LAT is number of LAT sectors
           dw      dataau
           call    storer7r8           ; and store
           dw      lataus

           call    f_inmsg             ; display number of sectors
           db      'LAT AUs     : ',0
           mov     rb,r7               ; move count for display
           mov     ra,r8
           mov     rd,0300h            ; character buffer
           call    itoa32              ; convert to ascii
           mov     rf,0300h            ; point to converted data
           call    f_msg               ; and display it
           call    crlf                ; then cr/lf

           endp

