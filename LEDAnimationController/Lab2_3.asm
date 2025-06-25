

 .include "ATxmega128a1udef.inc"

 .org 0x0000
 rjmp main

 main:

	ldi r16, low(stack_init)
	out CPU_SPL, r16
	ldi r16, high(stack_init)
	out CPU_SPH, r16
	ldi r16, 0xFF
	ldi r17, 0xFF
	sts PORTC_DIR, r17

	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCC0_CTRLB, r16

	ldi r16, low(60000)
	sts TCC0_PERL, r16
	ldi r16, high(60000)
	sts TCC0_PERH, r16

	ldi r16, TC_CLKSEL_DIV1_gc
	sts TCC0_CTRLA, r16


	CheckOVF:
		ldi r16, TCC0_INTFLAGS
		sbrs r16, 0
		rjmp CheckOVF

		ldi r18, 0xff
		eor r16, r18
		sts PORTC_OUT, R16

		ldi r16, 0x01
		sts TCC0_INTFLAGS, r16

	