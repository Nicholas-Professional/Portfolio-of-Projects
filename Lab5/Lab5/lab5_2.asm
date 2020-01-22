/*
 * lab5_2.asm 1826
;Name: Nicholas Legault
;Class#: 12379
;Description: This code continuously outputs the character U to the terminal via USART  
;

*/
.include "ATxmega128A1Udef.inc"	

;Initialize the baud rate information for the USART to use 
.EQU BSel = 150		; 57600 HZ
.EQU BScale = -7	; 57600 Hz


.cseg
.org 0x0000
	rjmp MAIN	

.org 0x200
MAIN:
; Initialize the stack pointer 
	ldi r16, 0xFF	
	out CPU_SPL, r16
	ldi r16, 0x3F
	out CPU_SPH, r16
;Initialize the GPIO in PORTD and USART 
	rcall INIT_GPIO
	rcall INIT_USART


;Loop the character U indefinitely 					
LOOP:
	ldi r16, 'U'
	rcall OUT_CHAR		
	rjmp LOOP





; *********************************************
; SUBROUTINE:   OUT_CHAR
; FUNCTION:     Outputs the character in register R16 to the SCI Tx pin 
;               after checking the data register empty flag is set 
;				and outputs onto the PC terminal 


OUT_CHAR:
	push R17

TX_POLL:
	lds R17, USARTD0_STATUS		;Check the status register for USARTD0 to see if the data register empty flag was set
	sbrs R17, 5					
								
	rjmp TX_POLL				;else go back to polling
	sts USARTD0_DATA, R16		;send the character out over the USART
	pop R17

	ret
; *********************************************
; SUBROUTINE:   IN_CHAR
; FUNCTION:    Receives the typed character via the PC terminal and stores it into the USARTD0_DATA register 
IN_CHAR:

RX_POLL:
	lds R16, USARTD0_STATUS		;load the status register
	sbrs R16, 7					;proceed to reading in a char if
								;  the receive flag is set
	rjmp RX_POLL				;else continue polling
	lds R16, USARTD0_DATA		;read the character into R16

	ret
; *********************************************
; SUBROUTINE:   INIT_USART
; FUNCTION:     Initializes the USARTDO's TX and Rx, 
;               57600 BAUD RATE, 8 data bits, 1 stop bit, an even parity bit, and 1 start bit.

INIT_USART:
	ldi R16, 0x18				
	sts USARTD0_CTRLB, R16		;turn on TXEN, RXEN lines

	ldi R16, 0b00100011
	sts USARTD0_CTRLC, R16		;Set Parity to even, 8 bit frame, 1 stop bit

	ldi R16, (BSel & 0xFF)		;select only the lower 8 bits of BSel
	sts USARTD0_BAUDCTRLA, R16	;set baudctrla to lower 8 bites of BSel 

	ldi R16, ((BScale << 4) & 0xF0) | ((BSel >> 8) & 0x0F)							
	sts USARTD0_BAUDCTRLB, R16	;set baudctrlb to BScale | BSel. Lower 
								;  4 bits are upper 4 bits of BSel 
								;  and upper 4 bits are the BScale. 
	ret
;************************************************
; SUBROUTINE:   INIT_GPIO
; FUNCTION:     Set up PortD_PIN3 as output for TX pin 
;               of USARTD0 using the pins alternate functions and initial output value to 1.
;				Then set up the PORTD_PIN4 as input for RX pin of USARTD0.
INIT_GPIO:
	ldi R16, 0x08	
	sts PortD_OUTSET, R16	;set the TX line to default to '1' as 
							;  described in the documentation
	sts PortD_DIRSET, R16	;Must set PortD_PIN3 as output for TX pin 
							;  of USARTD0					
	ldi R16, 0x04
	sts PortD_DIRCLR, R16	;Set RX pin for input

	ret