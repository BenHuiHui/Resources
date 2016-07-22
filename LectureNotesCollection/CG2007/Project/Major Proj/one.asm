$mod186
NAME EG0_COMP

;IO Setup for 80C188 
	UMCR    EQU    0FFA0H ; Upper Memory Control Register
	LMCR    EQU    0FFA2H ; Lower Memory control Register         
	PCSBA   EQU    0FFA4H ; Peripheral Chip Select Base Address
	MPCS    EQU    0FFA8H ; MMCS and PCS Alter Control Register
	CWR		EQU	   0083H ; Address of Control Word Register
	PORTA 	EQU	   0080H ; Address of PORTA
	PORTB   EQU    0081H ; Address of PORTB
	PORTC   EQU    0082H ; Address of PORTC
	
; STACK SEGMENT
STACK_SEG		SEGMENT
    
	
STACK_SEG		ENDS
	
	
; DATA SEGMENT
DATA_SEG        SEGMENT 
	
DATA_SEG        ENDS


; RESET SEGMENT
Reset_Seg   SEGMENT

    MOV DX, UMCR
    MOV AX, 03E07H
    OUT DX, AX
	JMP far PTR start
	
Reset_Seg  ends


; MESSAGE SEGMENT
MESSAGE_SEG     SEGMENT


MESSAGE_SEG     ENDS


;CODE SEGMENT
CODE_SEG        SEGMENT
       
PUBLIC	START

ASSUME  CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

START:

; Initialize MPCS to MAP peripheral to IO address
	MOV DX, MPCS
	MOV AX, 0083H
	OUT DX, AX

; PCSBA initial, set the parallel port start from 00H
	MOV DX, PCSBA
	MOV AX, 0003H ; Peripheral starting address 00H no READY, No Waits
	OUT DX, AX

; Initialize LMCS 
    MOV DX, LMCR
    MOV AX, 01C4H  ; Starting address 1FFFH, 8K, No waits, last shoud be 5H for 1 waits      
    OUT DX, AX

	; YOUR CODE HERE ...

; Initialize 8255 with the right MCW	
	MOV DX, CWR
	MOV AL, 80H ; IO mode, Group A - 0, Group B - 0
	OUT DX, AL
	
HEAD:
; day
; Output to PORTC first, which connects to the 7-segment display	
		MOV DX, PORTC
		MOV AL, 031H  ; the day info
		OUT DX, AL

;Output to PORTA then, whichi connects to the LEDs
;Since LEDs are common cathode, the output values should be reverted first
		MOV DX, PORTA
		NOT AL
		OUT DX, AL

; Wait for 1 second
		MOV BX, 0008H			; 8 iterations for the outer loop, accounts for 1 second
	
		AGAIN5:	MOV CX, 0BA03H	; 47619 iterations for the inner loop, accounts for 1M clock cycles
		AGAIN6:	NOP				; takes three clock cycles
				LOOP AGAIN6		; takes 18 clock cycles, accumulate to 21 clock cycles per loop
			
		DEC BX
		JNZ AGAIN5

; month
		MOV DX, PORTC
		MOV AL, 01H
		OUT DX, AL
	
		MOV DX, PORTA
		NOT AL
		OUT DX,AL
		
; Wait for 1 second
		MOV BX, 0008H			; 8 iterations for the outer loop, accounts for 1 second
	
		AGAIN3:	MOV CX, 0BA03H	; 47619 iterations for the inner loop, accounts for 1M clock cycles
		AGAIN4:	NOP				; takes three clock cycles
				LOOP AGAIN4		; takes 18 clock cycles, accumulate to 21 clock cycles per loop
			
		DEC BX
		JNZ AGAIN3
		
; year
		MOV DX, PORTC
		MOV AL, 90H
		OUT DX, AL
	
		MOV DX, PORTA
		NOT AL
		OUT DX,AL
		
; Wait for 1 second
		MOV BX, 0008H			; 8 iterations for the outer loop, accounts for 1 second
	
		AGAIN5:	MOV CX, 0BA03H	; 47619 iterations for the inner loop, accounts for 1M clock cycles
		AGAIN6:	NOP				; takes three clock cycles
				LOOP AGAIN6		; takes 18 clock cycles, accumulate to 21 clock cycles per loop
			
		DEC BX
		JNZ AGAIN5

; Loop back to the beginning of this application and restart the display
		JMP HEAD

CODE_SEG        ENDS
END
