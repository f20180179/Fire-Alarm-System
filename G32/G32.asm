#MAKE_BIN#

#LOAD_SEGMENT=FFFFH#
#LOAD_OFFSET=0000H#

#CS=0000H#
#IP=0000H#

#DS=0000H#
#ES=0000H#

#SS=0000H#
#SP=FFFEH#

#AX=0000H#
#BX=0000H#
#CX=0000H#
#DX=0000H#
#SI=0000H#
#DI=0000H#
#BP=0000H#
 
;JUMP TO THE START OF THE CODE - RESET ADDRESS IS KEPT AT 0000:0000
        JMP     ST1 ; 3 BYTES
        NOP         ; 1 BYTE
        DB	1020 DUP (0)
;MAIN PROGRAM          
ST1:    CLI 		; CLEARS INTERRUPT
; INTIALIZE DS, ES,SS TO START OF RAM
        MOV       AX,2000H
        MOV       DS,AX
        MOV       ES,AX
        MOV       SS,AX
        MOV       SP,0FFFEH
        MOV       SI,0000 
          
;8253 INTIALIZE THE TIMER TO MODE 1
        MOV AL,00110010B
        OUT 8EH,AL
        MOV AL,0ACH ; INITIALIZE COUNT AS 3500 IN DECIMAL
        OUT 88H,AL
        MOV AL,0DH
        OUT 88H,AL  
        
;8255 INTIALIZE PORT A AS INPUT AND PORT C AS OUTPUT WITH BSR MODE
INIT:   MOV AL,90H
        OUT 86H,AL
		 	  

MAIN:
  
DELAY:        
                MOV     DL,4       ;DELAY OF 2 SECONDS 
        XM:     MOV	    CX,50000      ;DELAY GENERATED WILL BE APPROX 0.45 SECS
        XN:     LOOP    XN
        		DEC     DL
        		JNZ     XM 

READ:	IN  AL,80H             
        CMP AL,00H	           
        JE  MAIN
        CMP AL,09H
        JE  MALF
        CMP AL,0AH
        JE  MALF
        CMP AL,0CH
        JE  MALF  
        JMP FIRE


MALF:   MOV AL,01H             ; OPEN MALF ALARM
        OUT 86H,AL
        MOV AL,02H             ; CLOSE FIRE ALARM
        OUT 86H,AL
        MOV AL,04H             ; CLOSE MOTORS
        OUT 86H,AL
        HLT

FIRE:   
        MOV AL,00H             ; CLOSE MALF ALARM
        OUT 86H,AL
        MOV AL,03H             ; OPEN FIRE ALARM
        OUT 86H,AL
        MOV AL,05H             ; OPEN MOTORS
        OUT 86H,AL 
         
        MOV       DL,4        ;DELAY OF 2 SECONDS 
        XM1:    MOV	      CX,50000      ;DELAY GENERATED WILL BE APPROX 0.45 SECS
        XN1:    LOOP      XN1
        		DEC       DL
        		JNZ       XM1 
        
CHECK:         
        IN  AL,80H             
        CMP AL,00H	           
        JE DONE
        CMP AL,09H	           
        JE DONE 
        CMP AL,0AH	           
        JE DONE
        CMP AL,0CH	           
        JE DONE
        JMP CHECK  

DONE:   MOV AL,02H             ; CLOSE FIRE ALARM
        OUT 86H,AL
              