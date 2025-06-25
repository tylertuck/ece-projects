/*
 * lab4_3b.asm
;
; lab4_3b.asm
; Lab 4 Section 3b
; Name: Tyler Tucker
; Class: 10886
; PI Name: Lester Bonilla
; Description: Program to store a value into one SRAM location and read from another SRAM location
*/

.include "ATxmega128a1udef.inc"


.equ SRAM_START_ADDR = 0xCD0000  
.equ IO_START_ADDR = 0x7B3200

.org 0
rjmp MAIN

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

;	initialize stack pointer address
	ldi r16, low(0x3FFF)
	out CPU_SPL, r16

	ldi r16, high(0x3FFF)
	out CPU_SPH, r16

	;load X with sram address
	ldi XL, low(SRAM_START_ADDR + 3)
	ldi XH, high(SRAM_START_ADDR + 3)
	ldi r17, byte3(SRAM_START_ADDR + 3)
	out CPU_RAMPX, r17

	;load Y with end of sram data
	ldi r28, low(0xCD7FFF)
	ldi r29, high(0xCD7FFF)
	ldi r17, byte3(0xCD7FFF)
	out CPU_RAMPY, r17

	;load Z with address where sram data starts in program memory
	ldi ZL, low(SRAM_DATA_START*2 + 13)
	ldi ZH, high(SRAM_DATA_START*2 + 13)
	ldi r17, byte3(SRAM_DATA_START*2 + 13)
	out CPU_RAMPZ, r17
	
	;load value into end of sram
	ldi r16, 0xFF
	st Y, r16

LOOP:
;load value into 3rd address in sram
	ldi r16, 0xF5
	st X, r16

	;load r16 with stored value from before loop
	ld r16, Y
	rjmp LOOP




; initialize subroutine
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


