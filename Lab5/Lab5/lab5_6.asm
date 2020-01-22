/*
 * lab5_6.asm
;Name: Nicholas Legault
;Class#: 12379
;Description: This code takes into a string from the user which can be backspaced and when it receives a line break it appends a null character before outputting the string to the terminal 
 */ 



.include "ATxmega128A1Udef.inc"	
;******************************INITIALIZATIONS***************************************
;Initialize the baud rate information for the USART to use 
.EQU BSel = 150		; 57600 HZ
.EQU BScale = -7	; 57600 Hz
.equ String = 0x2000 ; Initialize the place in program memory where the string will be stored 

.DSEG
.org String
.byte(50) ; Allocate memory for my name to be stored into data memory 

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
;Initialize Y to point to the beginning of the data space allocated for the input string 
	ldi YL, low(String)
	ldi YH, high(String)
	ldi r16, byte3(String)
	out CPU_RAMPY, r16
	rcall INIT_GPIO
	rcall INIT_USART
	rcall IN_STRING
LOOP:
rcall OUT_STRING
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
	lds R16, USARTD0_STATUS		;Check the status register for the receive complete flag and sees if it is set
	sbrs R16, 7					
	rjmp RX_POLL				;else continue polling
	lds R16, USARTD0_DATA		;read the character into R16

	ret

; *********************************************
; SUBROUTINE:   OUT_STRING
; FUNCTION:	Outputs the contents of a stored string in program memory until it hits a null character then terminates  
OUT_STRING:
;Push the original address of Z onto the stack to return its original position after the subroutine 
	push YL
	push YH
	in r16, CPU_RAMPY
	push r16
;Loads in the string character by character then sends it over to the OUT_CHAR subroutine to poll for the character properly 
READ_STRING:
	ld r16, Y+
;If the null character is encountered then jump to Done and return to main routine
	cpi r16,0
	breq DONE
	rcall OUT_CHAR
	rjmp READ_STRING
DONE:
;Return the original address to the Z from the stack before returning to the main routine
	pop r16
	out CPU_RAMPY, r16
	pop YH
	pop YL
	ret
; *********************************************
; SUBROUTINE:   IN_STRING
; FUNCTION:	Receives the string typed into the terminal character by character then deletes characters is a backspace is received
;and if enter is pressed appends a null character before terminating the subroutine
IN_STRING:
;Push the original Y position onto the stack to the be restored after the subroutine 
	push YL
	push YH
	in r16, CPU_RAMPY
	push r16
;Writes the character to the terminal after it is typed to for clarity 
WRITE_STRING:
	rcall IN_CHAR
	rcall OUT_CHAR
;Checks for backspace if backspace is found then decrement Y 
	cpi r16,0x08
	breq DELETE
;Same with the backspace but for the * key, 
	cpi r16, 0x2A
	breq DELETE
;Check if the enter key is pressed then if it is jump to the end 
	cpi r16, 0x0D
	breq FIN
	st Y+, r16
	rjmp WRITE_STRING
;Decrements Y if the backspace or delete key is pressed 
DELETE:
	sbiw Y, 1
	rjmp WRITE_STRING
;Appends the null character and restores Y's original position before returning the main routine 
FIN:
	ldi r16, 0
	st Y+, r16
	pop r16
	out CPU_RAMPY, r16
	pop YH
	pop YL
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