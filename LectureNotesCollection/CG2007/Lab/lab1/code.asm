; Individual Lab 1
;  Song Yangyu
;  A0077863N

stk	segment		stack
	db		128	dup(?)
tos	label		word
stk	ends

; data segment
data	segment
	msg_welcome		            db	"       Individual Lab 1",10,"$"
    msg_current_processing_arr  db  10,"--- Currently Process Array: ","$"
    msg_prompt_marr_content     db  "Content of Master Array: ","$"
    msg_show_offset_addr        db  "Offset Address of elements in master array where value = 1:",10,"     ","$"
    msg_show_copied_content     db  "The 0,2,...,18 bit of the master array formed hex number: ","$"
    msg_debug_pass              db  " DEBUG: pass here.",10,"$"
    msg_parity_is_odd           db  "This word is odd parity",10,"$"
    msg_parity_is_even          db  "This word is even parity",10,"$"
    msg_haming_dist             db  "Square of the hamming distance between words: ","$"

    M_SIZE      equ 20
    A1_SIZE     equ 7
    A2_SIZE     equ 16
    PARAM_L_SiZE    equ 10

	master_arr	db	M_SIZE	dup(0)
	arr1		db	1,3,4,6,8,10,15
	arr2		db	1,2,3,5,8,9,10,11,12,13,14,15,16,17,18,20
    word1       dw  ?
    word2       dw  ?
    current_w   db  1

    param_list  dw  PARAM_L_SiZE dup(?) ; support up to 10 word of parameters
data	ends
;   code segment
code	segment
assume	cs:code, ss:stk, ds:data

start:
	; jump the read input part -- for testing simply define

	; update the ds
	mov     ax,data
	mov     ds,ax
    ; update the ss
    mov     ax,stk
    mov     ss,ax
    ; and update the stack pointer
    mov     sp,offset tos

	; print out msg
	mov     ah,9h
	lea     dx,msg_welcome
	int     21h

start_dealing_with_arr:

    ; init the master array -- set it all 0
    mov     si,0
loop_start_dealing_with_arr_init:
    mov     master_arr + si,0
    inc     si
    
    cmp     si,M_SIZE
    jb      loop_start_dealing_with_arr_init

    ; then the welcome message for array specific
    mov     ah,9h
    lea     dx,msg_current_processing_arr
    int     21h

    ; finish the welcome str
    mov     ah,2    ; put array num
    mov     dl,current_w
    add     dl,'0'
    int     21h
    mov     ah,2    ; then print a new line
    mov     dl,10
    int     21h

	; fill in master array using appropriate

    ; this part to load appropriate address into bx, and size into al
    ; bx - offset address of the corresponding array
    ; al - size of array
    cmp     current_w,1
    je      loop_start_copying_arr1
    cmp     current_w,2
    je      loop_start_copying_arr2
loop_start_copying_arr1:
    mov     bx,offset arr1
    mov     ax,A1_SIZE
    jmp     loop_start_copying_end_jmp
loop_start_copying_arr2:
    mov     bx,offset arr2
    mov     ax,A2_SIZE
    jmp     loop_start_copying_end_jmp      ; can ignore this jump, but for systematic, put it
loop_start_copying_end_jmp:

    mov     si,0
loop_start_copying:
    mov     cl,byte ptr [bx] + si   ; get the element in array    
    
    cmp     cl,10
    jae     after_assigning
    mov     ch,0
    mov     di,cx
    dec     di                  ; need to decrease element cuz the first index is 1
    mov     master_arr + di,1  ; copy number 1 to master[di]
after_assigning:
	inc     si
    cmp     si,ax               ; al stores the size of array
    jb      loop_start_copying  ; if there's no loop

    ; display the content of the master array
    mov     ah,9h
    lea     dx,msg_prompt_marr_content
    int     21h
    
    mov     si,0
loop_show_marr_content:
    cmp     byte ptr [offset master_arr] + si,1
    jb      cmp_assign_ascii0
    mov     dl,'1'      ; didn't jump, so content is 1
    jmp     cmp_assign_complete
cmp_assign_ascii0:
    mov     dl,'0'
cmp_assign_complete:

    mov     ah,02       ; then print out the res
    int     21h
    inc     si
    mov     dl,' '      ; use a space to separate
    mov     ah,02
    int     21h
    cmp     si,M_SIZE
    jb      loop_show_marr_content
    ; print a new line char to complete this part
    mov     dl,10
    mov     ah,02
    int     21h

    ; display the offset address of the maste array that are 1s
    ; show message first
    mov     ah,9h
    lea     dx,msg_show_offset_addr
    int     21h

    mov     cx,0
loop_disp_marr_offset_content_1:
    mov     bx,offset master_arr
    add     bx,cx
    cmp     [bx],byte ptr 1
    jb      loop_disp_marr_offset_done_print
    ; then call the print method to print addrss
    mov     param_list,bx
    mov     param_list[2],4    ; print 4 digits
    mov     byte ptr param_list[4],' '  ; separate by space char
    call    proc_print_num
loop_disp_marr_offset_done_print:
    inc     cx
    cmp     cx,M_SIZE
    jb      loop_disp_marr_offset_content_1

    ; in the end, print a new line
    mov     ah,2h
    mov     dl,10
    int     21h
    
    
    ; form a word from the master array 
    ; print out message first
    mov     ah,9h
    lea     dx,msg_show_copied_content
    int     21h
    
    ;-- copy the content to bl
    mov     cx,10
    mov     si,0
    mov     bx,0
loop_copy_master_ele_start:
    shl     bx,1
    cmp     byte ptr [offset master_arr] + si,1    ; need to copy form MSB to LSB, cuz using shift
    jb      copy_master_ele_on_0
    or      bx,1    ; set the bl bit to be 1
copy_master_ele_on_0:   ; no need to copy actually, cuz it's 0 by default
    add     si,2
    loop     loop_copy_master_ele_start   ; jump on no sign -- when cx has sign, means < 0

    ; then print out a new line afterwards
    mov     ah,2
    mov     dl,10
    int     21h

    ; then print out the num
    mov     param_list,bx
    mov     param_list[2],4   ; display 4 digits, cuz it's a 10 bit number
    mov     byte ptr param_list[4],10  ; print a new line
    call    proc_print_num

; save the word
    cmp     current_w,1
    jmp     save_word_1_jmp
    cmp     current_w,2
    jmp     save_word_2_jmp
save_word_1_jmp:
    mov     word1,bx
    jmp     end_save_word_jmp
save_word_2_jmp:
    mov     word2,bx
    jmp     end_save_word_jmp
end_save_word_jmp:

copy_master_ele_after_print:
    ; then indicate whether this number of parity odd or even
    ; count the # of ones copied 
        ;-- this can be done in previous part, but do minimize coupling, do them separately
    mov     ax,bx
    mov     di,0    ; use di to count
    mov     cx,10   ; count 10 bits 
loop_count_parity_start: 
    shr     ax,1
    adc     di,0    ; use adc to avoid jump -- therefore increase efficiency
    loop    loop_count_parity_start

    and     di,1
    jz      count_parity_even
    ; count_parity odd
    lea     dx,msg_parity_is_odd
    jmp     count_parity_done
count_parity_even:
    lea     dx,msg_parity_is_even
count_parity_done:
    mov     ah,9h
    int     21h

; all complete, jmp back
    mov     al,current_w
    inc     al
    cmp     al,2
    ja      calculate_haming_dist
    mov     current_w,al
    jmp     start_dealing_with_arr

    ; in the end, culculate haming distance
calculate_haming_dist:  ; square of haming distance is just the number of different bits
    ; print out the message first
    mov     ah,9h
    lea     dx,msg_haming_dist
    int     21h

    mov     ax,word1
    xor     ax,word2
    mov     dl,1    ; use dl to count
    mov     cx,10
count_bits_haming_dist:
    shr     ax,1
    adc     dl,0
    loop    count_bits_haming_dist
    ; 1 bit digit, can print out directly -- cuz certainly less than 10 bits of difference
    add     dl,'0'
    mov     ah,2h
    int     21h
    ; then print out a new line char
    mov     dl,10
    mov     ah,2h
    int     21h

end_proc:
	mov     ah,4ch
	mov     al,0h	; the return value
	int     21h

; use this procedure to print a number
; use the param_list to pass parameter:
    ; the following elements are stored in the stack:
    ;   number to print   -- param_list
    ;   # of digits to display -- param_list[2]
    ;   separator         -- param_list[4]
; caller is in charge of saving and restoring the bp
proc_print_num proc
        push    bp
        mov     bp,sp   
        push    ax      ; save register
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        ; read the papameter list from the parameter table
        mov     bx,param_list
        mov     si,param_list[2]

print_loop:
        mov     dl,bh   
        ; value to print, dl cuz calling int 21,2
        mov     cl,4
        shr     dl,cl   ; leave the 4 higher bit only
        cmp     dl,10
        jb      add_to_char
        add     dl,'A'-'0' - 10
add_to_char:
        add     dl,'0'
        mov     ah,02
        int     21h     ; print one character

        ; update the bx
        mov     cl,4    ; 4 bit to shift each time
        shl     bx,cl
        dec     si
        jnz     print_loop

        ; then print out the separator -- the char to print after each number
        mov     dl,byte ptr param_list[4]
        and     dl,dl
        jz      proc_print_separator_done
        mov     ah,02
        int     21h
proc_print_separator_done:

        ; clean up
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     bp
        ; then shift by 2*3 parameters passed by the caller
        ret
proc_print_num  endp
	; the end prec
code	ends
end	start
