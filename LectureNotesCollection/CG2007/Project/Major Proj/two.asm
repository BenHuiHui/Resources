
;NAME EG0_COMP

;IO Setup for 80C188 
    PCB_BASE    EQU 0FF00H
	UMCS    EQU     0FFA0H ; Upper Memory Control Register
	LMCS    EQU     0FFA2H ; Lower Memory control Register         
	PACS    EQU     0FFA4H ; PACS -- PCS Control Register.
	MPCS    EQU     0FFA8H ; MMCS and PCS Alter Control Register
	PORTA 	EQU	    0080H 
	PORTB   EQU     0081H
	PORTC   EQU     0082H
	CWR		EQU	    0083H ; Address of Control Word Register

    EOI     EQU     PCB_BASE + 22H
    TCUCON  EQU     PCB_BASE + 32H
	I1CON   EQU     PCB_BASE + 3AH
	I1TYP   EQU     0dh

    T0CNT   EQU     PCB_BASE + 50H
    T0CMPA  EQU     PCB_BASE + 52H
    T0CMPB  EQU     PCB_BASE + 54H
    T0CON   EQU     PCB_BASE + 56H
	T0TYP   EQU     8

    T1CNT   EQU     PCB_BASE + 58H
    T1CMPA  EQU     PCB_BASE + 5AH
    T1CMPB  EQU     PCB_BASE + 5CH
    T1CON   EQU     PCB_BASE + 5EH
	T1TYP   EQU     18

    T2CNT   EQU     PCB_BASE + 60H
    T2CMPA  EQU     PCB_BASE + 62H
    T2CON   EQU     PCB_BASE + 66H
	T2TYP   EQU     19
	
; magic variables for mov status
    MS_NO_MOVE  EQU     0   ; would only handle button click when there's no movement
    ; make sure the first bit is one
    MS_INC      EQU     3   ; increasing
    MS_DEC      EQU     1   ; decreasing
    MS_BTN_CLK  EQU     4   ; button clicked, need check

; DATA SEGMENT
DATA_SEG        SEGMENT
    ORG     600H
	db		128	dup(?)
tos	label		word
    ORG     500H
    to_level    db      ?   ; only the proper level for display
    c_level     db      ?   ; current level
    old_pa_val  db      ?   ; the value of port A
    mov_stats   db      ?   ; 
    safe_mode   db      ?   ; bool for safe/unsafe mode
                            ; bit 7 of PORTB
                            ; bit on:  safe mode
                            ; bit off: unsafe mode
    multi_mode  db      ?   ; bool for multi/single mode
                            ; bit 6 of PORTB
                            ; bit on:  multi mode
                            ; bit off: single mode
DATA_SEG        ENDS


; RESET SEGMENT -- the first piece of code being executed.
Reset_Seg   SEGMENT
    MOV DX, UMCS
    MOV AX, 03E07H  ; U17:10 = 11 1110 00 (0011 1111 1111 1100 0000, pos of 1 in the whole reg) = F8.
                    ; Block Size 8, starting address 0FE000H (referring to Page 167 of the user manual)
                    ; starting address FF, bus wait for 3 cycle
    OUT DX, AX
	JMP far PTR start
Reset_Seg  ends

; MESSAGE SEGMENT
MESSAGE_SEG     SEGMENT
MESSAGE_SEG     ENDS



;CODE SEGMENT
CODE_SEG        SEGMENT
       
PUBLIC	START

ASSUME  CS:CODE_SEG, DS:DATA_SEG, SS:DATA_SEG

START:
    cli     ; disable interrupt to do necessary configuration first.

; Initialize the stack segment and data segment
    mov ax,DATA_SEG
    mov ds,ax
    mov ss,ax
    mov sp,offset tos
    mov ax,0
    mov es,ax

; Initialize MPCS to MAP peripheral to IO address
	MOV DX, MPCS
	MOV AX, 0083H   ; block size unknown -- 00 is not specified in the table on the user manual
                    ; Wait activate PCS6:0 for IO bus cycle 
                    ; Wait for 3 bus cycle -- for PCS6:4
	OUT DX, AX

; PACS initial, set the parallel port start from 00H
	MOV DX, PACS
	MOV AX, 0003H ; Peripheral starting address 00H, Wait for 3 Bus Cycle
	OUT DX, AX

; Initialize LMCS 
    MOV DX, LMCS
    MOV AX, 01C4H  ; ending address B01 1100 01 = 71H, wait for 3 wait states
    OUT DX, AX

	; YOUR CODE HERE ...
; init my variables
    mov al,031h
    mov to_level,0  ; starting from 0 level
    mov c_level,0
    mov mov_stats,MS_NO_MOVE
    mov old_pa_val,0ffh   ; should be all off -- therefore ff

; Initialize 8255 with the right MCW	
	mov dx, CWR
	mov al, 82h ; Binary 1000 0010  -- O mode, Group A - 0, Group B - 1(input), Group C - 0(output);
	out dx, al

; Clear lights
    mov al,0ffh
    mov dx,PORTA
    out dx,al
; clear level info
    mov al,0
    mov dx,PORTC
    out dx,al

    ; *** PUSH BUTTON RELATED ***
; Initialize the int 1 in the interrupt table
    mov si, 4 * I1TYP
    mov word ptr es:[si], offset btn_isr
    mov si, 4 * I1TYP + 2
    mov word ptr es:[si], seg btn_isr
; Initialize the int 1
    mov dx, I1CON   ; location of the interrupt control register
    mov ax, 1       ; enable interrupt, and priority 1
    out dx, ax      ; -- cuz handling this interrupt is supposed to be fast
    ; *** END OF PUSH BUTTON RELATED *** 

    ; *** TIMER RELATED *** 
        ; timer 1
; Initialize the interrupt table for timer 1 -- used for updating display
    mov si, 4 * T1TYP
    mov word ptr es:[si], offset timer1_isr
    add si,2
    mov word ptr es:[si], seg timer1_isr
; Initialize the timer 1
    mov dx,T1CNT    ; clear the timer count
    mov ax,0
    ; out dx,ax
    mov dx,T1CMPA   ; 40
    mov ax,40
    ;out dx,ax
    ; control reg
    mov dx,T1CON
    mov ax,1010000000001001b    ; Use CMPA, RTG0, P is 1 (use T2 to trigger) last bit set to enable

        ; timer 2
; initialize the interrupt vector table for timer 2 -- used for blinking LED
    mov si, 4 * T2TYP
    mov word ptr es:[si], offset timer2_isr
    add si,2
    mov word ptr es:[si], seg timer2_isr
    ; Clear Timer 2
    ; use timer 2 to blink LED
    mov dx,T2CNT    
    mov ax,0
    out dx,ax

    mov dx,T2CMPA   ;50000 for T2
    mov ax,50000     
    out dx,ax

    ; control reg
    mov dx,T2CON
    mov ax,1010000000000001b    ; Use T2, enable, generate interrupt; also used to trigger T1)
    out dx,ax

    ; in the end, the tcucon -- internal interrupt control register
    mov dx,TCUCON
    mov ax,0
    out dx,ax
    ; *** END OF TIMER RELATED *** 

    sti

head_st:
    nop ; just wait here... all the things should be handled by different interrupt
    jmp head_st

    ret ; just end here (but actually no need cuz here's a loop)

btn_isr proc
    cli

    call read_input

    mov dx,EOI
    mov ax,I1TYP
    out dx,ax

    sti
    iret
btn_isr endp

timer1_isr proc
    cli
    call update_disp

    mov ax,T1TYP
    mov dx,EOI
    out dx,ax
    sti

    iret
timer1_isr endp

timer2_isr proc
    cli
    call update_pta_led

    mov ax,T2TYP
    mov dx,EOI
    out dx,ax
    sti

    iret
timer2_isr endp

read_input proc
    mov dx,PORTB
    in al,dx

    ; test safe mode
    test    al,10000000b
    jz  ri_safe_test_done
    test    mov_stats,1 ; see moving or not
    jz  ri_safe_test_done ; non-moving, allowed
    ret     ; in safemode, simply return

        ri_safe_test_done:

    and al,00111111b
    
    ; save it to to_level
    mov to_level, al

    ; save this value in old_pa_val, use update
    xor al,0ffh
    mov old_pa_val,al

    call update_disp
    call update_pta_led
    ; and reset the timer 1, timer 2
    mov dx,T1CNT
    mov ax,0
    out dx,ax
    mov dx,T2CNT
    mov ax,0
    out dx,ax

    ret

read_input endp

; update the display of the move info -- caller should disable interrupt for it
update_disp proc

    ; cmp to_level, c_level
    ; update level
    ; update status
    ; display level
    
    ; update current info
    mov al,c_level
    cmp to_level,al
    ja  update_lvl_above
    jb  update_lvl_below

        ; otherwise it's no move
    mov mov_stats,MS_NO_MOVE
        ; clear the first two bit of the move status
        mov bl,old_pa_val
        or  bl,11000000b
        mov old_pa_val,bl
        ; no move, no need to update display
    jmp update_sts

        update_lvl_above:
    inc al
    jmp update_lel_var

        update_lvl_below:
    dec al

        ; and update the c_level info
        update_lel_var:
    mov c_level,al

        ; update status variable
        update_sts:
    cmp to_level,al
    ja  update_sts_above
    jb  update_sts_below
        ; status no move
    mov mov_stats,MS_NO_MOVE
    jmp disp_c_level
        update_sts_above:
        jmp disp_c_level
    mov mov_stats,MS_INC
        update_sts_below:
    mov mov_stats,MS_DEC

    disp_c_level:
        ; al is still holding the current level info
        mov bl,10
        mov ah,0
        div bl
        mov cl,4
        shl al,cl
        or  al,ah
        mov dx,PORTC
        out dx,al

    ret

update_disp endp


; caller should disable interrupt for it
update_pta_led proc
    test    mov_stats,1 ; see it's moving or not
    jz update_pta_led_done ; no move, done the job
    mov al,old_pa_val
    test    mov_stats,10b   ; see it's raising or falling
    jz update_pta_led_fall ; true when it's increaseing, false when falling
    xor al,10000000b ; first bit for increasing
    jmp update_pta_led_update_pta
        update_pta_led_fall:
    xor al,01000000b ; second bit for decreasing
        update_pta_led_update_pta:
    mov dx,PORTA
    out dx,al
    mov al,old_pa_val   ; and save the updated val
        update_pta_led_done:

    ret
update_pta_led endp

code_seg        ends
end
