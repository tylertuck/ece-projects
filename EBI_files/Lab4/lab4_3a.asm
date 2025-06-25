/*
 * lab4_3a.asm
;
; lab4_3a.asm
; Lab 4 Section 3a
; Name: Tyler Tucker
; Class: 10886
; PI Name: Lester Bonilla
; Description: Program to copy values from program memory into external SRAM and cycle through
			them every 300 ms.

*/
.include "ATxmega128a1udef.inc"


.equ SRAM_START_ADDR = 0xCD0000
.equ IO_START_ADDR = 0x7B3200

.org 0
rjmp MAIN

;jump to overflow ISR after interrupt
.org TCD0_OVF_vect
jmp TCD0_OVF_ISR

;initialize sram data at a specific address
.cseg
.org 0x2000
SRAM_DATA_START:
.include "sram_data_asm.txt"
SRAM_DATA_END:

.org 0x200
MAIN:
; call subroutines
	rcall EBI_IO_INIT
	rcall EBI_INIT
	rcall INITSTUFF

;	initialize stack pointer address
	ldi r16, low(0x3FFF)
	out CPU_SPL, r16

	ldi r16, high(0x3FFF)
	out CPU_SPH, r16

	;load X with sram address
	ldi XL, low(SRAM_START_ADDR)
	ldi XH, high(SRAM_START_ADDR)
	ldi r17, byte3(SRAM_START_ADDR)
	out CPU_RAMPX, r17

	;load Y with IO address
	ldi r28, low(IO_START_ADDR)
	ldi r29, high(IO_START_ADDR)
	ldi r17, byte3(IO_START_ADDR)
	out CPU_RAMPY, r17

	;load Z with address where sram data starts in program memory
	ldi ZL, low(SRAM_DATA_START*2)
	ldi ZH, high(SRAM_DATA_START*2)
	ldi r17, byte3(SRAM_DATA_START*2)
	out CPU_RAMPZ, r17

;infinite loop
COPY:
;load sram data from program memory at Z into r16 and store it into X, incrementing each time
	lpm r16, Z+
	st X+, r16
	ldi r18, low(SRAM_DATA_END)
	ldi r19, high(SRAM_DATA_END)

	; Compare X address with the end of the data to see if it has reached the end
	cp  r26, r18
	cpc r27, r19
	; branch if X is equal to end address, if not loop again
	breq ADDRESSES_EQUAL
	rjmp COPY

	; after copying all values, reset X and Z addresses
ADDRESSES_EQUAL:
	ldi ZL, low(SRAM_DATA_START*2)
	ldi ZH, high(SRAM_DATA_START*2)
	ldi r17, byte3(SRAM_DATA_START*2)
	out CPU_RAMPZ, r17

	ldi XL, low(SRAM_START_ADDR)
	ldi XH, high(SRAM_START_ADDR)
	ldi r17, byte3(SRAM_START_ADDR)
	out CPU_RAMPX, r17
	; infinite loop to read from external sram and output it to Y, the IO address
LOOP:
	ld r16, X 
	st Y, r16
	rjmp LOOP

; initialize subroutine
INITSTUFF:
;push register 
	push r16

	ldi r16, 0
	sts TCD0_CNT, r16
	sts TCD0_CNT+1, r16

	;initialize tc ctrls
	ldi r16, TC_WGMODE_NORMAL_gc
	sts TCD0_CTRLB, r16

	ldi r16, TC_CLKSEL_DIV64_gc
	sts TCD0_CTRLA, r16

	ldi r16, low(9375)
	sts TCD0_PER, r16

	ldi r16, high(9375)
	sts TCD0_PER+1, r16

	;enables tc interrupt at medium level
	ldi r16, 0b00000010
	sts TCD0_INTCTRLA, r16

	;enables medium level interrupts
	ldi r16, 0b00000010			
	sts PMIC_CTRL, r16

	;enables global interrupts
	sei

	pop r16
	ret

EBI_IO_INIT: 

  ; Symbols for start of relevant memory address ranges.
 
  ; Preserve the relevant register.
  push r16


   

  ; Initialize the relevant EBI control signals to be 
  ; in a `false` state.
  ldi r16, 0b01010011	

  sts PORTH_OUTSET, r16

  ldi r16, 0b00000100

  sts PORTH_OUTCLR, r16

  ; Initialize the EBI control signals to be output from 
  ; the microcontroller.
  ldi r16, 0b01010111	


  sts PORTH_DIRSET, r16                 




  ; Initialize the address signals to be output
  ; from the microcontroller.
  ldi r16, 0xFF


  sts PORTK_DIRSET, r16         
  

;  ldi r16, 0
 ; sts PORTJ_DIRSET, r16       




  ; Recover the relevant register.
  pop r16

                       
  
  ; Return from subroutine.
  ret

  /*--------------------------------------------------------------
 ebi_init --

 Description:
  Initialize and enable the EBI system for the relevant
  hardware expansion.

 Input(s): N/A
 Output(s): N/A
--------------------------------------------------------------*/
EBI_INIT: 

  ; Preserve the relevant register. (See 3 above)
  push r16                        

  ; Initialize the EBI system for SRAM 3-PORT ALE1 mode.
  ldi r16, 0b00000001         


  sts EBI_CTRL, r16

  ; Initialize the relevant chip select(s).
  ; The following dropdown boxes contain a blank 
   ; (i.e., empty) option; select this option if
   ; no other option applies.

  ; Configure chip select CS0, only if necessary.
  ldi r16, 0b00011101 
  sts EBI_CS0_CTRLA, r16 

  ldi r16, byte2(SRAM_START_ADDR) 
  sts EBI_CS0_BASEADDR, r16


  ldi r16, byte3(SRAM_START_ADDR) 
  sts EBI_CS0_BASEADDR+1, r16 





  ; Configure chip select CS1, only if necessary.



  ; Configure chip select CS2, only if necessary.
  ldi r16, 0b00001001 
  sts EBI_CS2_CTRLA, r16

  ldi r16, byte2(IO_START_ADDR) 
  sts EBI_CS2_BASEADDR, r16 

  ldi r16, byte3(IO_START_ADDR) 
  sts EBI_CS2_BASEADDR+1, r16 




  ; Recover the relevant register.
  pop r16



  ; Return from subroutine.
  ret

; overflow ISR
TCD0_OVF_ISR:

	push r16
	
	;increment X
	ld r16, X+

	;resets int flag
	ldi r16, 1
	sts TCD0_INTFLAGS, r16

	pop r16


	reti
	
