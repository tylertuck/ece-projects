;****************************************************
;  File name: Lab2_4.asm
;  Name: Tyler Tucker
;  Purpose: To allow LED animations to be created with the OOTB uPAD, 
;			OOTB SLB, and OOTB MB by storing frames of LEDs and playing them back

.include "ATxmega128a1udef.inc"

;*******DEFINED SYMBOLS******************************
.equ ANIMATION_START_ADDR	=	0x2000 ;useful, but not required
.equ ANIMATION_SIZE			=	64	;useful, but not required
;*******END OF DEFINED SYMBOLS***********************

;*******MEMORY CONSTANTS*****************************
; data memory allocation
.dseg

.org ANIMATION_START_ADDR
ANIMATION:
.byte ANIMATION_SIZE
;*******END OF MEMORY CONSTANTS**********************

;*******MAIN PROGRAM*********************************
.cseg
; upon system reset, jump to main program (instead of executing
; instructions meant for interrupt vectors)
.org 0x0000
	rjmp MAIN

; place the main program somewhere after interrupt vectors (ignore for now)
.org 0x0200		; >= 0xFD
MAIN:
; initialize the stack pointer
	ldi r16, low(0x3FFF)
	out CPU_SPL, r16
	ldi r16, high(0x3FFF)
	out CPU_SPH, r16
; initialize relevant I/O modules (switches and LEDs)
	rcall IO_INIT

; initialize (but do not start) the relevant timer/counter module(s)
	rcall TC_INIT

; Initialize the X and Y indices to point to the beginning of the 
; animation table. (Although one pointer could be used to both
; store frames and playback the current animation, it is simpler
; to utilize a separate index for each of these operations.)
; Note: recognize that the animation table is in DATA memory
	ldi r26, low(ANIMATION_START_ADDR)
	ldi r27, high(ANIMATION_START_ADDR)

	ldi r28, low(ANIMATION_START_ADDR)
	ldi r29, high(ANIMATION_START_ADDR)

; begin main program loop 
	
; "EDIT" mode
EDIT:
	
; Check if it is intended that "PLAY" mode be started, i.e.,
; determine if the relevant switch has been pressed.
	lds r16, PORTF_IN
	sbrs r16, 3

; If it is determined that relevant switch was pressed, 
; go to "PLAY" mode.
	rjmp PLAY

; Otherwise, if the "PLAY" mode switch was not pressed,
; update display LEDs with the voltage values from relevant DIP switches
; and check if it is intended that a frame be stored in the animation
; (determine if this relevant switch has been pressed).
	lds r16, PORTA_IN
	sts PORTC_OUT, r16

; If the "STORE_FRAME" switch was not pressed,
; branch back to "EDIT".
	lds r16, PORTF_IN
	sbrc r16, 2
	rjmp EDIT
	

; Otherwise, if it was determined that relevant switch was pressed,
; perform debouncing process, e.g., start relevant timer/counter
; and wait for it to overflow. (Write to CTRLA and loop until
; the OVFIF flag within INTFLAGS is set.)
	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCC0_CTRLA, r16

	ldi r16, low(4000)
	sts TCC0_PER, r16
	ldi r16, high(4000)
	sts TCC0_PER+1, r16

	ldi r16, TC_CLKSEL_DIV64_gc
	sts TCC0_CTRLA, r16


	CheckOVF:
		lds r16, TCC0_INTFLAGS
		sbrs r16, 0
		rjmp CheckOVF

		rjmp AfterDebounce
	
; After relevant timer/counter has overflowed (i.e., after
; the relevant debounce period), disable this timer/counter,
; clear the relevant timer/counter OVFIF flag,
; and then read switch value again to verify that it was
; actually pressed. If so, perform intended functionality, and
; otherwise, do not; however, in both cases, wait for switch to
; be released before jumping back to "EDIT".
AfterDebounce:


	ldi r16, 0x01
	sts TCC0_INTFLAGS, r16

	lds r16, PORTF_IN
	sbrc r16, 2
	rjmp EDIT
	lds r16, PORTA_IN
	st X+, r16

; Wait for the "STORE FRAME" switch to be released
; before jumping to "EDIT".
STORE_FRAME_SWITCH_RELEASE_WAIT_LOOP:
	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCC0_CTRLA, r16

	ldi r16, low(4000)
	sts TCC0_PER, r16
	ldi r16, high(4000)
	sts TCC0_PER+1, r16

	ldi r16, TC_CLKSEL_DIV64_gc
	sts TCC0_CTRLA, r16


	CheckOVF1:
		lds r16, PORTF_IN
		sbrc r16, 2
		rjmp EDIT

		lds r16, TCC0_INTFLAGS
		sbrs r16, 0
		rjmp CheckOVF1

		ldi r16, 0x01
		sts TCC0_INTFLAGS, r16

		rjmp CheckOVF1
	
; "PLAY" mode
PLAY:

; Reload the relevant index to the first memory location
; within the animation table to play animation from first frame.
	ldi r28, low(ANIMATION_START_ADDR)
	ldi r29, high(ANIMATION_START_ADDR)

PLAY_LOOP:

; Check if it is intended that "EDIT" mode be started
; i.e., check if the relevant switch has been pressed.`
	lds r16, PORTF_IN
	sbrs r16, 3

; If it is determined that relevant switch was pressed, 
; go to "EDIT" mode.
	rjmp EDIT

; Otherwise, if the "EDIT" mode switch was not pressed,
; determine if index used to load frames has the same
; address as the index used to store frames, i.e., if the end
; of the animation has been reached during playback.
; (Placing this check here will allow animations of all sizes,
; including zero, to playback properly.)
; To efficiently determine if these index values are equal,
; a combination of the "CP" and "CPC" instructions is recommended.
	cp r26, r28
    cpc r27, r29



; If index values are equal, branch back to "PLAY" to
; restart the animation.
	breq PLAY

; Otherwise, load animation frame from table, 
; display this "frame" on the relevant LEDs,
; start relevant timer/counter,
; wait until this timer/counter overflows (to more or less
; achieve the "frame rate"), and then after the overflow,
; stop the timer/counter,
; clear the relevant OVFIF flag,
; and then jump back to "PLAY_LOOP".
	ld r16, Y+
	sts PORTC_OUT, r16

	ldi r21, 0
	ldi r22, ANIMATION_SIZE
	cp r21, r22
	brne REST
	ldi r28, low(ANIMATION_START_ADDR)
	ldi r29, high(ANIMATION_START_ADDR)

REST:
	inc r21
	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCC0_CTRLA, r16

	ldi r16, low(3000)
	sts TCC0_PER, r16
	ldi r16, high(3000)
	sts TCC0_PER+1, r16

	ldi r16, TC_CLKSEL_DIV64_gc
	sts TCC0_CTRLA, r16


	CheckOVF2:

		lds r16, TCC0_INTFLAGS
		sbrs r16, 0
		rjmp CheckOVF2


		ldi r16, 0x01
		sts TCC0_INTFLAGS, r16


		rjmp PLAY_LOOP
; end of program (never reached)
DONE: 
	rjmp DONE
;*******END OF MAIN PROGRAM *************************

;*******SUBROUTINES**********************************

;****************************************************
; Name: IO_INIT 
; Purpose: To initialize the relevant input/output modules, as pertains to the
;		   application.
; Input(s): N/A
; Output: N/A
;****************************************************
IO_INIT:
; protect relevant registers
	push r16
; initialize the relevant I/O
	ldi r16, 0xFF
	sts PORTC_DIR, r16

	ldi r16, 0
	sts PORTA_DIR, r16

; recover relevant registers
	pop r16
; return from subroutine
	ret
;****************************************************
; Name: TC_INIT 
; Purpose: To initialize the relevant timer/counter modules, as pertains to
;		   application.
; Input(s): N/A
; Output: N/A
;****************************************************
TC_INIT:
; protect relevant registers
	push r16
; initialize the relevant TC modules
	ldi r16, 0
	sts TCC0_CTRLB, r16
	
	ldi r16, low(50000)
	sts TCC0_PER, r16
	ldi r16, high(50000)
	sts TCC0_PER+1, r16

	
; recover relevant registers
	pop r16
; return from subroutine
	ret

;*******END OF SUBROUTINES***************************