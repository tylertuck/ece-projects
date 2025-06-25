;
; Lab4.asm
; Lab 4 Section 2
; Name: Tyler Tucker
; Class: 10886
; PI Name: Lester Bonilla
; Description: Program to read inputs from an I/O port and output them through the same I/O port

.include "ATxmega128A1Udef.inc"

.equ SRAM_START_ADDR = 0xCD0000  
.equ IO_START_ADDR = 0x7B3200   

.org 0x0000
rjmp MAIN


.org 0x200
MAIN:
;call subroutines
	rcall EBI_IO_INIT
	rcall EBI_INIT

; load Z with I/O address
	ldi r30, low(IO_START_ADDR + 1)
	ldi r31, high(IO_START_ADDR)
	ldi r17, byte3(IO_START_ADDR)
	out CPU_RAMPZ, r17
 
LOOP:
;load value from IO bus into r16 and store that same value into Z
; loading it makes the read enable true and storing it makes the write enable true
	ld r16, Z
	st Z, r16
	rjmp LOOP

/*--------------------------------------------------------------
  ebi_io_init --

  Description:
    Initialize and enable the EBI IO pins for the relevant
    hardware expansion.

  Input(s): N/A
  Output(s): N/A
--------------------------------------------------------------*/	
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