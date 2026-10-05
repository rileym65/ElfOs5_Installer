; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

; #define RAM

#include   ../bios.inc
#include   ../macros.inc

           extrn   buildmd
           extrn   buildlat
           extrn   compute
           extrn   copy
           extrn   crlf
           extrn   d_idewrite
           extrn   data
           extrn   decptr
           extrn   dsecplus
           extrn   filldir
           extrn   getdata
           extrn   incau
           extrn   incsec
           extrn   itoa32
           extrn   loadr7r8
           extrn   sectolmp
           extrn   storer7r8
           extrn   writeboot
           extrn   writefile
           extrn   zero
           extrn   zerocheck

#define  IDE_SELECT     2       ;  ... IDE register select I/O port
#define  IDE_DATA       3       ;  ... IDE data I/O port

sector:    equ     0100h
sectors:   equ     0500h
aus:       equ     0504h
latsects:  equ     0508h
lataus:    equ     050ch
datasec:   equ     0510h
dataau:    equ     0514h

#include   equ.inc

#ifdef RAM
           org     2000h
#else
           org     8000h
#endif
           br      cold
           lbr     warm
cold:      mov     r2,00ffh            ; Setup initial stack
           mov     r6,start
           lbr     f_initcall          ; setup scall/sret

readid:    ldi   high waitrdy          ; get address of subs
           phi   rc
           ldi   low waitrdy
           plo   rc
           sex   r2                    ; be sure X points to stack
           mark                        ; save current P and X
           sep   rc                    ; call wait for RDY routine
           dec   r2                    ; compensate for RET instruction
           ldi   0ech                  ; command to read configuration
           mark                        ; save current P and X
           sep   rc                    ; call command sequence
           dec   r2                    ; compensate for RET instructino
           ldi   2                     ; high byte of 512
           phi   r7                    ; store into counter
           ldi   0                     ; lo byte of 512
           plo   r7                    ; put into low of count
           str   r2                    ; store into memory
           out   2                     ; select data register
           dec   r2                    ; move pointer back
           sex   rf                    ; set data pointer
rdloop:    inp   3                     ; read from ide controller
           inc   rf                    ; point to next position
           dec   r7                    ; decrement byte count
           glo   r7                    ; see if all bytes read
           bnz   rdloop                ; loop back if not
           ghi   r7                    ; check high byte as well
           bnz   rdloop
           adi   0                     ; signify read completed
           sex   r2                    ; restore X pointer
           sep     sret                ; and return to caller
beforerdy: irx                         ; move pointer to SAV location
           ret                         ; and return to caller
waitrdy:   sex     r2                  ; be sure X points to stack
           ldi     07h                 ; need status register
           str     r2                  ; store onto stack
           out     2                   ; write ide selection port
           dec     r2                  ; point x back to free spot
rdyloop:   inp     3                   ; read status port
           ani     0c0h                ; mask for BSY and RDY
           smi     040h                ; want only RDY bit
           bnz     rdyloop             ; loop back until drive is ready
           ldn     r2                  ; get status byte
           irx                         ; move pointer to SAV location
           ret                         ; and return to caller
wrtcmd:    sex     r2                  ; be sure X points to stack
           stxd                        ; write command to memory
           ldi     7                   ; command register
           str     r2                  ; store for outs
           out     2                   ; select IDE register
           out     3                   ; send command
           dec     r2                  ; move pointer back
drqloop:   inp     3                   ; read status register
           ani     0c0h                ; mask for BSY and DRQ bit
           smi     040h                ; wany only DRQ set
           bnz     drqloop             ; loop until found
           br      beforerdy           ; return, readying waitrdy again

start:     call    f_setbd             ; setup terminal
warm:      mov     r2,0ffh             ; setup stack
           call    f_inmsg             ; display startup message
           db      'EosInst v5 - FsType I',10,13,10,13,0

           ldi     0                   ; master drive
           plo     rd
           call    f_idereset          ; perform ide reset

           mov     rf,sector
           sep     scall               ; read ide id dta
           dw      readid

           call    compute               ; compute disk pointers

           call    f_inmsg
           db      'Setting up Boot2',10,13,0
           call    writeboot           ; write boot sector

           call    f_inmsg
           db      'Creating LAT table',10,13,0
           call    buildlat            ; build LAT table

           call    f_inmsg
           db      'Creating directories',10,13,0
           call    buildmd             ; build directories

           call    f_inmsg
           db      'Installing binaries',10,13,0

           call    dsecplus            ; kernel
           db      24
           call    getdata
           dw      data
           dw      kernel_offset
           mov     rc,kernel_size
           call    writefile

           call    dsecplus            ; dir
           db      40
           call    getdata
           dw      data
           dw      dir_offset
           mov     rc,dir_size
           call    writefile

           call    dsecplus            ; chdir
           db      48
           call    getdata
           dw      data
           dw      chdir_offset
           mov     rc,chdir_size
           call    writefile

           call    dsecplus            ; lbr
           db      56
           call    getdata
           dw      data
           dw      lbr_offset
           mov     rc,lbr_size
           call    writefile

           call    dsecplus            ; xr
           db      64
           call    getdata
           dw      data
           dw      xr_offset
           mov     rc,xr_size
           call    writefile

           call    dsecplus            ; chmod
           db      72
           call    getdata
           dw      data
           dw      chmod_offset
           mov     rc,chmod_size
           call    writefile

           call    f_inmsg
           db      'Finished',10,13,10,13
           db      'Press <ENTER> to boot into Elf/OS',10,13,0

           mov     rf,0100h
           call    f_input

           lbr     0ff00h

              public aus
              public dataau
              public datasec
              public lataus
              public latsects
              public sector
              public sectors

