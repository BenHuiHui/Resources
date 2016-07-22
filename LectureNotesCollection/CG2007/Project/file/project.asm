$mod186
NAME EG0_COMP
; EE2007 project skeleton program
; Fill in your code inside this skeleton
;
; Author:       A/Prof Tay Teng Tiow
; Address:      Department of Electrical Engineering 
;               National University of Singapore
;               10, Kent Ridge Crescent
;               Singapore 119260. 
;
; This file contains proprietory information and cannot be copied 
; or distributed without prior permission from the author.
;---------------------------------------------------------------------------

DATA_SEG        SEGMENT 


DATA_SEG        ENDS



Reset_Seg   SEGMENT

    MOV DX, UMCR
    MOV AX, 03E07H
    OUT DX, AX

JMP far PTR start
Reset_Seg  ends



MESSAGE_SEG     SEGMENT


MESSAGE_SEG     ENDS



CODE_SEG        SEGMENT
       
	PUBLIC          START

	ASSUME  CS:CODE_SEG

START:

$include(project.inc)


;initialize LMCS 
    MOV DX, LMCR
    MOV AX, 01C4H  ; Starting address 1FFFH, 8K, No waits, last shoud be 5H for 1 waits      
    OUT DX, AX

;your code here...
	

CODE_SEG        ENDS
END
