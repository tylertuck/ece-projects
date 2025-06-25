/*
 * Lab2_1.asm
 *
 *  Created: 5/29/2025 9:19:56 PM
 *   Author: tyler
 */ 


 .include "ATxmega128a1udef.inc"

 .org 0x0000
 rjmp main

 main:

	ldi r16, 0xFF
	sts PORTC_DIR, r16

	ldi r16, 0
	sts PORTA_DIR, r16

loop:
	lds r16, PORTA_IN
	sts PORTC_OUT, r16
	rjmp loop