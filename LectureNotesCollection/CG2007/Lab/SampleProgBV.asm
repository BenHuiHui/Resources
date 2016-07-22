;======================================================
; Some experiments you can do it yourself
;
; 1. Changing the color of the background (replace mov bh, 59h with 
;    mov bh, 61h and so on. Compile and see your results and have fun!
;
; 2. Give "message2" a space of about 16 dup(?) instead of 24 bytes. Observe 
;    what is happening. Do not forget to change cx as well! Count the number of 
;    characters appearing on the screen now.
;
; 3. Remove the $ symbol from message1 and in message 2. See what happens.
;
; 4. Change the message 1 - shorten it and see what happens. Do not change the 
;    counter. 
;
; 5. Consider "Set the cursor position" module. Replace dx=0000h with 
;    dx=0105h. What do you observe? 
;
; 6. Consider "get the keyboard input and display" module. 
;    Do not execute statements from "mov dl,0ah" to "int 21h" statement. 
;    Observe what happens.
;
; 7. Observe: It is ok to use 24(decimal) instead of 18h. Try this. 
;
; 8. See the end of this file for Expt 8. 
;=========================
; 9. Consider Tutorial #3 Problem #5; Try inserting the code that puts out sound and allow the 
;    user to stop the sound by pressing any key;
;
; 10. Modify the above Q9 by allowing the user to key in only "q" or "Q" to stop the sound! 
;
;*****************************************
;
data_area segment    ; Definition of the data segement begins here

message1        db      "Hello, This is from National University of Singapore!$"
message2        db      42h dup(),"$"      ; reserves 24 bytes of space
                                           ; without any inititalization
                                           ; ends with a $ - in order to use INT 21 function
                                           ; with 09 in AH register
data_area ends       ; data segment ends here
;******************************************


;*****************************************
code    segment     ; code segment begins here
assume cs:code,ds:data_area,es:data_area
start:
        mov     ax,data_area   ; loading ds, es segments indirectly using a GPR (ax)
	mov	ds,ax
        mov     es,ax
        mov     ax,0600h     ; to scroll upward the window - AH=06 is for the function of INT 10H
                             ; AL =00 means clearing the specific window 
        mov     bh,75h       ; reverse the video attribute - background and foreground
        sub     cx,cx        ; CH = 0, CL=0  ==>from line 0 and column 0
        mov     dx,184fh     ; DH=18H, DL=4F ==>to line 24 and column 79
        int     10h          ; Bios function 10H call 
        lea     si,message1  ; loading the effective address of message 1 to SI
        lea     di,message2  ; loading the effective address of message 2 to DI (destination)
        mov     cx,08h        ; counter setting up
        cld                  ; clear the direction flag, 
                             ; such that the string operation starts
                             ; from lower to higher address
        		     ; refer to "std"
        rep	movsb        ; repeating the string operation:
                             ; ((DI)) <-- ((SI)), (SI) <-- (SI)+1, (DI) <-- (DI)+1,
                             ; (CX) <--(CX)-1
			     ; until cx = 0
        		     ; as a result, the first 24 chars in message1 will
                             ; be copied to message2
;***********************************************************************
;set the cursor position
;***********************************************************************
	mov	bh,0	     ; set the current page number
			     ; for a single color monitor, BH is always equal to 0
        mov     dx,0000h     ; set the position of cursor ==> line DH=0, column DL=0      
	mov	ah,2	     ; entry parameter of function 10h
	int	10h	     ; Bios function 10H call
;*********************************************************************
        lea	dx,message2  ; loading the effective address of message2 to dx
	mov	ah,09h	     ; output message2 to the cursor postion
        int     21h          ; using this DOS function (AH=09h) to display a string,
                             ; one must end the string with a "$"
;**********************************************************************	
;get the keyboard input and display
;**********************************************************************
input:	
	mov	ah,01h	     ; Read a key with echo. AL= the input char.
                             ; This function will check whether the input
                             ; is "CTRL-BREAK"
	int	21h	     ; If yes, then system will automatically call
                             ; function 23H to end the program
;************************
	cmp	al,1bh	     ; if the input is "ESC", then jump to label "exit"
	je	exit
;************************
        cmp     al,0dh       ; if the input is "ENTER"(hex - odh), the system only returns
                             ; the cursor to the head of the line
        jne     input        ; so we need to output a "LF" (Line Feed - 0AH) 
                             ; to pull the cursor to the next line
;(A)
	mov     dl,0ah
        mov     ah,02h       ; output a char, DL= the output char
        int     21h          ; call DOS function
;*************************
	jmp	input
exit:	
        mov	ah, 4ch	    ; return to DOS. Normally
		    
code ends		    ; code segment ends here
end start		    ; the whold program ends here
;===============================================
; 
; Expt 8
;
; Try the following. CUT-AND-PASTE the following code at the mark (A). Define dx=054fh  
; instead of dx=184fh in the statement "mov dx,184fh" in the first part. This is 
; a setting for the window size. 
;
;---- just added 
;       mov 	ah, 03h
;	mov 	bh,00
;	int 	10h          ; to get the current cursor position we use ah=03h for int 10h
			     ; dh and dl will give the line and column positions
;	cmp	dh,05h       ; 05h is the num of lines defined earlier
;	jl	inside	     ; if dh < 05h then jump to inside.
;	mov     ax,0601h     ; to scroll upward the window - AH=06 is for the function of INT 10H
                             ; AL =00 means clearing the specific window 
;        mov     bh,61h       ; reverse the video attribute - background and foreground
;       sub     cx,cx        ; CH = 0, CL=0  ==>from line 0 and column 0
;        mov     dx,184fh     ; DH=18H, DL=4F ==>to line 24 and column 79
;        int     10h          ; Bios function 10H call 
;	jmp	input
;---------------
;inside:
