;
; lab5_1.asm
;
; Created: 10/21/2019 5:08:18 PM
; Author : Nicholas
;
.include "ATxmega128A1Udef.inc"

.org 0x00
rjmp MAIN

.org 0x100
MAIN:




start:
    inc r16
    rjmp start
