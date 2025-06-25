/*
 * Lab2_2.asm
 *
 *  Created: 5/29/2025 9:28:36 PM
 *   Author: tyler
 */ 

 

 .include "ATxmega128a1udef.inc"

 .equ stack_init = 0x3FFF
 .equ delayNum = 3

 .org 0x0000

 rjmp MAIN

 .org 0x200
 MAIN: 
	ldi r16, low(stack_init)
	out CPU_SPL, r16
	ldi r16, high(stack_init)
	out CPU_SPH, r16
	ldi r16, 0
	ldi r17, 0xFF
	sts PORTC_DIR, r17

	TIMERLOOP:
		rcall DELAY_X_10MS
		eor r16, r17 
		sts PORTC_OUT, r16
		rjmp TIMERLOOP




DELAY_10MS:
	push r16
	push r17
	ldi r16, 0


	LOOP1:
		ldi r17, 0
		cpi r16, 20
		breq END
		inc r16

		LOOP2:
			cpi r17, 204
			breq LOOP1
			inc r17
			rjmp LOOP2

	END:
	pop r17
	pop r16

	ret

DELAY_X_10MS:
	push r16
	ldi r16, 0

	LOOP:
		cpi r16, delayNum
		breq ENDING
		rcall DELAY_10MS
		inc r16
		rjmp LOOP

	ENDING:
		pop r16
		ret