;IO Setup for 80C188XL 

         UMCR    EQU    0FFA0H ; Upper Memory Control Register
         LMCR    EQU    0FFA2H ; Lower Memory control Register         
         PCSBA   EQU    0FFA4H ; Peripheral Chip Select Base Address
         MPCS    EQU    0FFA8H ; MMCS and PCS Alter Control Register

; Initial 80C188XL UCS Pin
; |start address|block size| value for No waits, No Ready   
;   FE000H            8K                 3E04H
;   FC000H           16K                 3C04H
;   F8000H           32K                 3804H
      
; Initialize Upper Chip Select pin with 8K ROM 
;         MOV DX, UMCR
;         MOV AX, 03E04H
;         OUT DX, AX

; Initialize Lower Chip Select pin with 8k RAM
;         MOV DX, LMCR
;         MOV AX, 01C4H  ; Start address 1FFFH, 8K, No waits
;         OUT DX, AL

; Initialize MPCS to MAP peripheral to IO address
         MOV DX, MPCS
         MOV AX, 0083H
         OUT DX, AL

		 

