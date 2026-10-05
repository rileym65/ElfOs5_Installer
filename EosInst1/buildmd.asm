#include   ../macros.inc
#include   equ.inc

; ****************************
; ***** Build diretories *****
; ****************************
           proc    buildmd

           extrn   copy
           extrn   d_idewrite
           extrn   data
           extrn   dataau
           extrn   datasec
           extrn   filldir
           extrn   getdata
           extrn   incsec
           extrn   loadr7r8
           extrn   sector
           extrn   storer7r8
           extrn   zero

           call    loadr7r8            ; get data sector
           dw      datasec
           call    zero                ; zero sector buffer
           mov     rf,sector           ; point to sector buffer
           call    getdata             ; point to MD data
           dw      data
           dw      md_offset
           mov     rc,md_size          ; number of bytes to copy
           call    copy                ; copy pre-bootloader
           push    r7                  ; save sector
           push    r8
           call    loadr7r8            ; get data AU
           dw      dataau
           call    incsec              ; plus 1
           call    storer7r8           ; write lump for /bin directory
           dw      sector
           call    incsec              ; plus 1
           call    storer7r8           ; write lump for /os directory
           dw      sector+32
           pop     r8                  ; recover sector
           pop     r7
           call    d_idewrite          ; write it
           call    incsec              ; increment sector
           call    filldir             ; zero rest of directory

           call    zero                ; zero the sector buffer
           mov     rf,sector           ; point to sector buffer
           call    getdata             ; point to /bin data
           dw      data
           dw      bin_offset
           mov     rc,bin_size         ; number of bytes to copy
           call    copy                ; copy pre-bootloader
           push    r7                  ; save directory
           push    r8
           call    loadr7r8            ; read data AU
           dw      dataau
           call    incsec              ; add 5
           call    incsec
           call    incsec
           call    incsec
           call    incsec
           mov     rf,sector           ; need to write AUs for 5 entries
           ldi     5
           plo     rc
binloop:   ghi     r8                  ; write next au to dirent
           str     rf
           inc     rf
           glo     r8
           str     rf
           inc     rf
           ghi     r7
           str     rf
           inc     rf
           glo     r7
           str     rf
           inc     rf
           call    incsec              ; point to next au
           glo     rf                  ; add 28 to the pointer
           adi     28
           plo     rf
           ghi     rf
           adci    0
           phi     rf
           dec     rc                  ; decrement entry number
           glo     rc                  ; see if done
           lbnz    binloop             ; loop back if not
           pop     r8                  ; recover sector
           pop     r7

           mov     rf,sector+4         ; update eof for dir
           ldi     dir_size.1
           str     rf
           inc     rf
           ldi     dir_size.0
           str     rf

           mov     rf,sector+36        ; update eof for chdir
           ldi     chdir_size.1
           str     rf
           inc     rf
           ldi     chdir_size.0
           str     rf

           mov     rf,sector+68        ; update eof for lbr
           ldi     lbr_size.1
           str     rf
           inc     rf
           ldi     lbr_size.0
           str     rf

           mov     rf,sector+100       ; update eof for xr
           ldi     xr_size.1
           str     rf
           inc     rf
           ldi     xr_size.0
           str     rf

           mov     rf,sector+132       ; update eof for chmod
           ldi     chmod_size.1
           str     rf
           inc     rf
           ldi     chmod_size.0
           str     rf

           call    d_idewrite          ; write it
           call    incsec              ; increment sector
           call    filldir             ; zero rest of directory

           call    zero                ; zero the sector buffer
           mov     rf,sector           ; point to sector buffer
           call    getdata             ; point to /os data
           dw      data
           dw      os_offset
           mov     rc,os_size          ; number of bytes to copy
           call    copy                ; copy pre-bootloader
           push    r7                  ; save directory
           push    r8
           call    loadr7r8            ; get data au
           dw      dataau
           call    incsec              ; plus 3
           call    incsec
           call    incsec
           call    storer7r8           ; write au to dir entry
           dw      sector
           mov     rf,sector+4         ; need to write kernel eof
           ldi     kernel_size.1
           ani     0fh
           str     rf
           inc     rf
           ldi     kernel_size.0
           str     rf
           pop     r8                  ; recover sector
           pop     r7
           call    d_idewrite          ; write it
           call    incsec              ; increment sector
           call    filldir             ; zero rest of directory
           rtn

           endp

