org 100h

.data

messageTS  DB 'To draw a triangle please press T or t, to draw a square press S or s:  ','$' 
messageF   DB 'It is not a valid input! ','$'
messageSH  DB 'Please enter the height of Square: ',0DH,0AH,'$'
messageTH  DB 'Please enter the height of Triangle: ',0DH,0AH,'$'
height     DB ?
newLine    DB 0DH,0AH, '$'


.code

MAIN PROC 


Input:
MOV AH,09H
MOV DX,offset messageTS ;asks for triangle or square 
INT 21H 
MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV AH,01H  ;input
INT 21H

CMP AL,53H        ;commpare with S
JE drawS 

CMP AL,73H        ;compare with s
JE drawS

CMP AL,54H        ;compare with T
JE drawT

CMP AL,74H        ;compare with t
JE drawT

MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV AH,09H
MOV DX,offset messageF  ;input is not valid 
INT 21H

MOV DX,offset newLine
MOV AH,09H
INT 21H
JMP Input               ;asks again

drawS: call drawSquare
drawT: call drawTriangle

ENDP MAIN  

drawSquare PROC
    
MOV DX,offset newLine 
MOV AH,09H
INT 21H

MOV DX,offset messageSH  ;asks for square height
MOV AH,09H
INT 21H
MOV AH,01H               ;input
INT 21H

SUB AL,30H               ;asci to hex
MOV height,AL

MOV DX,offset newLine
MOV AH,09H
INT 21H
MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV CL,height

MOV DL,09H               ;tab
MOV AH,02H
INT 21H
Top:
MOV DL,'X'              ;print the top side of square
MOV AH,02H
INT 21H
DEC CL
JNZ Top

MOV DX,offset newLine
MOV AH,09H
INT 21H

 
MOV CL,height
SUB CL,02H              ;we need height-2 for side of square

Sides:
MOV DL,09H
MOV AH,02H
INT 21H
                       ;left side 
MOV DL,'X'
MOV AH,02H
INT 21H
MOV BL,height
SUB BL,02H 

Space: 

MOV DL,' '             ;space of inside
MOV AH,02H
INT 21H
DEC BL
JNZ Space

MOV DL,'X'             ;right side
MOV AH,02H
INT 21H
MOV DX,offset newLine
MOV AH,09H
INT 21H
DEC CL 
JNZ Sides

MOV CL,height

MOV DL,09H
MOV AH,02H
INT 21H

Bottom:

MOV DL,'X'             ;bottom side
MOV AH,02H
INT 21H
DEC CL
JNZ Bottom
INT 20H
ret
ENDP drawSquare

drawTriangle PROC

MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV DX,offset messageTH  ;asks hright of triangle
MOV AH,09H
INT 21H
MOV AH,01H
INT 21H

SUB AL,30H               ;ascii to hex
MOV height,AL



MOV CL,height  


MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV CH,CL
SpaceT1:

MOV DX,offset newLine
MOV AH,09H
INT 21H

MOV DL,09H
MOV AH,02H
INT 21H
MOV DL,09H
MOV AH,02H
INT 21H                  ;two tabs for create space to drawing

MOV BL,CH                
DEC BL
JZ buttomT                


SpaceT2:
MOV DL,' '               ;space before first side of triangle
MOV AH,02H
INT 21H

DEC BL
JNZ SpaceT2              ;space until first X comes

MOV DL,'X'               ;draw first(left) side 
MOV AH,02H
INT 21H 


MOV BH,CL                ;calculates the space between two sides
SUB BH,CH 
JZ noSpace
JNZ inSpace
 
 

noSpace:
DEC CH
JMP SpaceT1

inSpace: 
ADD BH,BH
DEC BH
SpaceT3:
                        ;prints space of inside of triangle
MOV DL,' '
MOV AH,02H
INT 21H
DEC BH
JNZ SpaceT3 

MOV DL,'X'              ;prints right side of triangle
MOV AH,02H
INT 21H

DEC CH
JNZ SpaceT1 


buttomT: 
ADD CL,CL
DEC CL                  ;calculates how many X to draw
buttomTprint:
MOV DL,'X'              ;draws bottom of triangle
MOV AH,02H
INT 21H
DEC CL
JNZ buttomTprint


INT 20H
ret
ENDP drawTriangle   
End
            
            



