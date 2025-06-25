/*
 * Lab2_3_3.asm
 *
 *  Created: 6/1/2025 3:06:37 PM
 *   Author: tyler
 */ 
 

 .include "ATxmega128a1udef.inc"

 .def seconds = r20
 .def minutes = r21

 .org 0x0000
 rjmp main

 .org 0x200
 main:


	ldi r16, 0xFF
	ldi r17, 0xFF
	sts PORTC_DIR, r16

	sts PORTC_OUT, r17



	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCC0_CTRLB, r16

	ldi r16, low(8000)
	sts TCC0_PER, r16
	ldi r16, high(8000)
	sts TCC0_PER+1, r16

	ldi r16, TC_CLKSEL_DIV256_gc
	sts TCC0_CTRLA, r16


	CheckOVF:
		lds r16, TCC0_INTFLAGS
		sbrs r16, 0
		rjmp CheckOVF

		lds r16, PORTC_OUT
		eor r16, r17
		sts PORTC_OUT, r16

		ldi r16, 0x01
		sts TCC0_INTFLAGS, r16

		inc seconds
		cpi seconds, 60
		brne CheckOVF

		clr seconds
		inc minutes


		rjmp CheckOVF


