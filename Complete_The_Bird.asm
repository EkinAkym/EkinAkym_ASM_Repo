; multi-segment executable file template.
;made by Ekin and Mesut

data segment
    
    ;DRAWING BIRD DATA (START)
    
        rightWing1 db ".~~-.","$"
        rightWing2 db ".' -.~-.~-.","$"
        rightWing3 db "/  .~-.~-.~-.~-.","$"
        rightWing4 db "/ .~-.~-.~-.~-.~-.~-.","$"
        rightWing5 db "-.~-.~  ~","$"
        rightWing6 db "~.~- ~","$"
    
        vase1 db "\~~~~~~~~~~/","$"
        vase2 db "\        /","$"
        vase3 db "\      /","$"
        vase4 db "\____/","$"
    
        body1 db  "| |","$"
        body2 db  "V   \","$"
        body3 db  "{    }","$"
        body4 db  "\  /","$"
    
        legs1 db  "//\\","$"
        legs2 db  ":--""--""--:","$" 
    
        head1 db  ".--.","$"
        head2 db  "{ O ]]>","$"
        
        leftWing1 db ".-~~.","$"
        leftWing2 db ".-~.-~.- `.","$"
        leftWing3 db ".-~.-~.-~.-~.  \","$"
        leftWing4 db ".-~.-~.-~.-~.-~.-~. ","$"
        leftWing5 db "~  ~.-~.-","$"
        leftWing6 db "~ -~.~","$" 
    
    ;DRAWING BIRD DATA (END)
    


    
    ;ARRANGEMENT DATA (START)
    
        newLine    DB 0DH,0AH, '$'
        clear db "                                                                              ","$" 
    
    ;ARRANGEMENT DATA (END)
    
    

    
    ;MENU AND CREDITS DATA (START)
    
        msgCOMPLETE db "COMPLETE",'$'
        msgTHEBIRD  db "THE BIRD",'$'
    
        msgPVP db " Please Press 2 to play two-player mode. ","$"
        msgPVC db " Please Press 1 to play single-player mode. ","$"
    
        msgCREDITS db "CREDITS",'$'
        msgEKIN db  "Ekin AKYILDIRIM 2200357029",'$'
        msgMESUT db "Mesut YILDIZ    2200357098",'$'
        
    ;MENU AND CREDITS DATA (END)    
    
    

    
    ;PLAYER MESSAGE DATA (START)
        
        messageRoll DB "Plase press SPACE to roll dice! ","$"
        messageRollbot DB "Then please press space and I'll show you who's the master! ","$"
    
        player1turnMSG  DB "Your Turn ","$"
        player2turnMSG  DB "Your Turn ","$" 
        
        messageDice DB "Previous Dice: ","$"
    
    
        messageFinish DB "YOU WINN!!    ","$"

        
        msgPlayer1WIN DB  "    THE WINNER IS.... ","$"
        msgPlayer2WIN DB  "    THE WINNER IS.... ","$"
        
        botmsg DB "Hmm, is it my turn?","$"
        msgbotwin DB "Nice	try,	better	luck	next	time",'$' 
    
    ;PLAYER MESSAGE DATA (END)
        
    
    
    ;PLAYER NAMES DATA (START)
    
        player1name db 80, 0, 78 DUP('$')
        player2name db 80, 0, 78 DUP('$')
        botname db "Bot","$"
        
        msgName     DB "Please enter your name:  " ,"$"
        msgName1    DB "Please enter first player's name:  ","$"
        msgName2    DB "Please enter second player's name:  ","$"
    
    ;PLAYER NAMES DATA (END
    
    
    
    ;COUNTER DATA (START)

        count  db 0
        countH db 0
        countL db 0
        countR db 0
        
        roundcount db 0
        
        playerturn db 2 
    
        player1count DB 0
        player2count DB 0
        
        PVP_or_PVC   DB 0 
    
    ;COUNTER DATA (END)


ends

stack segment
    dw   128  dup(0)
ends

code segment

MAIN PROC FAR
    
    mov ax, data
    mov ds, ax
    mov es, ax
    mov cl,0h
    
         call menu
    
    START:
        mov bh,pvp_or_pvc
        cmp bh,01h
        je pvc
        cmp bh,02h
        je pvp
                
        
    ;PVP part calls starter and roll_pvp functions
    
    PVP:
        mov bh,02h
        mov pvp_or_pvc,02h
        
        call starter
        
        call roll_pvp
    
    ;PVC part calls starter and roll_pvc functions
        
    PVC:        
        mov bh,01h
        mov pvp_or_pvc,01h
        
        call starter

        call roll_pvc
    
    ;vase part calls draw_vase function then jumps secondrollpvc or secondroll (pvp)
    vase:
    
        call draw_vase
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  secondrollpvc
        jmp secondroll       
    
    ;legs part calls draw_legs function then jumps thirdrollpvc or thirdroll (pvp)    
    legs: 
    
        call draw_legs
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  thirdrollpvc
        jmp thirdroll             
    
    ;body part calls draw_body function then jumps fourthrollpvc or fourthroll (pvp)
    body:    
        
        call draw_body
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  fourthrollpvc        
        jmp fourthroll             
    
    ;head part calls draw_head function and  checks whether the bird is completely drawn or not
    ;then jumps finish or fourthrollpvc or fourthroll (pvp)
    head:
    
        call draw_head

        mov bh,00h
        mov counth,01h
        mov bl,counth    
        add bh,bl
        mov bl,countl
        add bh,bl
        mov bl,countr
        add bh,bl

        cmp bh,03h    
        je  finish
        
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  fourthrollpvc
        jmp fourthroll    
    
    ;leftwing part calls draw_left_wing function and  checks whether the bird is completely drawn or not
    ;then jumps finish or fourthrollpvc or fourthroll (pvp)    
    leftwing:
    
        call draw_left_wing
    
        mov bh,00h
        mov countl,01h
        mov bl,counth    
        add bh,bl
        mov bl,countl
        add bh,bl
        mov bl,countr
        add bh,bl
        cmp bh,03h
        je  finish
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  fourthrollpvc
        jmp fourthroll
    
    ;rightwing part calls draw_right_wing function and  checks whether the bird is completely drawn or not
    ;then jumps finish or fourthrollpvc or fourthroll (pvp)
    rightwing:
    
        call draw_right_wing
    
        mov bh,00h
        mov countr,01h
        mov bl,counth    
        add bh,bl
        mov bl,countl
        add bh,bl
        mov bl,countr
        add bh,bl 
    
        cmp bh,03h
        je  finish
        mov bh,pvp_or_pvc
        cmp bh,01h
        je  fourthrollpvc 
        jmp fourthroll   
    
    
    ;FINISH part calls function_finish
    FINISH:
        
        
        call function_finish
        
        mov ax, 4c00h ; exit to operating system.
        int 21h 
   


ENDP MAIN

;the starter function prints the score on the screen and sets the finishing counters to zero.

STARTER PROC
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 3              
        mov dl, 15             
        int 10h
    
        mov ch,player1count
        add ch,30h   
        mov dl,ch  
        mov ah,02h 
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 3              
        mov dl, 65             
        int 10h
    
        mov ch,player2count
        add ch,30h   
        mov dl,ch  
        mov ah,02h 
        int 21h
        
        mov countl,00h
        mov counth,00h
        mov countr,00h 
        
        ret
ENDP STARTER


;MENU function prints all the writings on the screen and 
;Allows choosing between single player and two player
;Retrieves and saves player names by user according to game mode
MENU PROC
    
    MENU1:
    mov ah, 02h             
    mov bh, 0               
    mov dh, 5              
    mov dl, 36             
    int 10h
     
    lea dx,msgcomplete
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 6              
    mov dl, 36             
    int 10h
     
    lea dx,msgthebird
    mov ah,9
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 11              
    mov dl, 20             
    int 10h
     
    lea dx,msgpvc
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 13              
    mov dl, 20             
    int 10h
     
    lea dx,msgpvp
    mov ah,9
    int 21h
    
 
    
    mov ah, 02h             
    mov bh, 0              
    mov dh, 19              
    mov dl, 36             
    int 10h
     
    lea dx,msgcredits
    mov ah,9
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 21              
    mov dl, 27             
    int 10h
     
    lea dx,msgekin
    mov ah,9
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 22              
    mov dl, 27             
    int 10h
     
    lea dx,msgmesut
    mov ah,9
    int 21h   
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 15              
    mov dl, 39             
    int 10h
    
    mov ah,01h               
    int 21h
            
    cmp al,32h 
    jz clearandnamepvp
    
    cmp al,31h 
    jz clearandnamepvc
    
    jnz menu1
    
    ClearAndNamePVP:
    mov pvp_or_pvc,al
    call clear_screen
    jmp pvpname
    
    ClearAndNamePVC: 
    mov pvp_or_pvc,al
    call clear_screen
    jmp pvcname
    
    PVPname:
    mov ah, 02h             
    mov bh, 0               
    mov dh, 11              
    mov dl, 20             
    int 10h
     
    lea dx,msgname1
    mov ah,9
    int 21h
            
    lea dx, player1name     
    MOV AH,0AH                               
    INT 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 13              
    mov dl, 20             
    int 10h 
    
    lea dx,msgname2
    mov ah,9
    int 21h
            
    lea dx, player2name     
    MOV AH,0AH                               
    INT 21h
    call clear_screen
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 3              
    mov dl, 5             
    int 10h
    
    lea dx, player1name+2     
    MOV AH,9                               
    INT 21h
    
     mov ah, 02h             
    mov bh, 0               
    mov dh, 3              
    mov dl, 55             
    int 10h
    
    lea dx, player2name+2    
    MOV AH,9                               
    INT 21h
     
    jmp pvp
    
    PVCname:
    
        mov ah, 02h             
    mov bh, 0               
    mov dh, 11              
    mov dl, 20             
    int 10h
     
    lea dx,msgname
    mov ah,9
    int 21h
            
    lea dx, player1name     
    MOV AH,0AH                               
    INT 21h      
    
  
    call clear_screen
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 3              
    mov dl, 5             
    int 10h
    
    lea dx, player1name+2     
    MOV AH,9                               
    INT 21h
    
     mov ah, 02h             
    mov bh, 0               
    mov dh, 3              
    mov dl, 58             
    int 10h
    
    lea dx, botname     
    MOV AH,9                               
    INT 21h
     
    jmp pvc
    
     
ret    
ENDP MENU
  

    

;FUNCTION_FINISH Firstly, it determines who completed the bird last
;Then it checks whether the game is completely finished or not.
;Finally, it prints on the screen who won.
FUNCTION_FINISH PROC
    
    mov bx,0002h
    mov al,playerturn
    mov ah,00h
    div bl
    cmp ah,0h
    jnz player1_turnwin
    jz player2_turnwin
    
    player1_turnWIN:
    
        call clear_screen
        inc player1count
        inc roundcount
         
        mov ah, 02h             
        mov bh, 0               
        mov dh, 3              
        mov dl, 15             
        int 10h
    
        mov ch,player1count
        add ch,30h   
        mov dl,ch  
        mov ah,02h 
        int 21h
        
        mov bh,roundcount
        cmp bh,03h
        jz playerwin 
        jnz start
    
    player2_turnWIN:
        
            
        call clear_screen
        inc player2count
        inc roundcount
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 3              
        mov dl, 65             
        int 10h
        
        mov ch,player2count
        add ch,30h
        mov dl,ch
        mov ah,02h    
        
        int 21h 
        
        mov bh,roundcount
        cmp bh,03h
        jz playerwin 
        jnz start
        
    
    playerWIN:
        
        mov ah,player1count
        mov bh,player2count
        
        cmp ah,bh
        ja player1win
        jb player2win   
    
    player1WIN:
    
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h
    
        lea dx,msgplayer1win+2  
        mov ah,09h 
        int 21h
        
        lea dx,player1name  
        mov ah,09h 
        int 21h                      
    
        mov ax, 4c00h ; exit to operating system.
        int 21h
    
    player2WIN:
        mov al,pvp_or_pvc
        cmp al,01h
        je botWIN
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h
    
        lea dx,msgplayer1win  
        mov ah,09h 
        int 21h
        
        lea dx,player2name+2  
        mov ah,09h 
        int 21h
                
        mov ax, 4c00h ; exit to operating system.
        int 21h        
                
    BOTWIN:
    
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h
    
        lea dx,msgbotwin  
        mov ah,09h 
        int 21h    
    
    
ENDP FUNCTION_FINISH



;GENERATE_DICE Divide the time by 6 and then add 1 to the remainder to form a dice

GENERATE_DICE PROC
    
     mov ah,0h
     int 1ah
     mov ax,dx
     mov dx,0
     mov bx,6
     div bx
     inc dl

     mov ch,dl
     ret

ENDP GENERATE_DICE 


;ROLL_PVC,In single player mode, the rounds are determined by the drawing of the bird
;also determines whose turn it is to roll the dice.
;Prints on the screen whose turn it is and what the previous dice was.  

ROLL_PVC PROC 
    
    
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder
    FirstRollpvc:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        jz bot2.1
    
    ;When it's the first player's turn, it says player one turn
    Player1.1pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
        
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
        
        jmp continue1pvc
    
    ;When it's the second bot's turn, it says bot's turn
    bot2.1:
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 25             
        int 10h 
        
        lea dx,botmsg
        mov ah,09h
        int 21h
    
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 1, it switches to the vase drawing part. (FOR BOT)
    Continue1pvcbot:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 10             
        int 10h
    
        lea dx,messageRollbot  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
        
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
        
        sub ch,30h
        cmp ch,01h
        
        je  vase
        jne firstrollpvc
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 1, it switches to the vase drawing part. (PLAYER)    
    Continue1pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               ;input
        int 21h
        
  
    
        call generate_dice
        
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
        
        sub ch,30h
        cmp ch,01h
        
        je  vase
        jne firstrollpvc    
    
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder
    SecondRollpvc:
        
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        
        cmp ah,01h
        jz bot2.2
    
    ;When it's the first player's turn, it says player one turn
    Player1.2pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
        
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
        
        jmp continue2pvc
    
    ;When it's the bot's turn, it says bot's one turn
    bot2.2:
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 25             
        
        int 10h 
        lea dx,botmsg
        mov ah,09h
        int 21h
    
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 2, it switches to the legs drawing part. (BOT)
    Continue2pvcbot:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 10             
        int 10h
    
        lea dx,messagerollbot  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,02h
        
        je  legs
        jne secondrollpvc
    
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 2, it switches to the legs drawing part. (PLAYER)
    Continue2pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,02h
        
        je  legs
        jne secondrollpvc
     
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder 
    ThirdRollpvc:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        
        jz bot2.3
    
    ;When it's the first player's turn, it says player one turn
    Player1.3pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
        
        jmp continue3pvc
        
    ;When it's the bot's turn, it says bot's turn    
    bot2.3:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 25             
        int 10h 
    
        lea dx,botmsg
        mov ah,09h
        int 21h
        
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 3, it switches to the body drawing part. (BOT)    
    Continue3pvcbot:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 10             
        int 10h
    
        lea dx,messagerollbot  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,03h
    
        je  body
        jne thirdrollpvc
     
     ;It tells us to roll the dice, then it rolls the dice and 
     ;if the result is 3, it switches to the body drawing part. (PLAYER)   
     Continue3pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
        
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,03h
    
        je  body
        jne thirdrollpvc
        
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder    
    FourthRollpvc:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        
        jz bot2.4
    
    ;When it's the first player's turn, it says player one turn
    Player1.4pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player1turnmsg
        mov ah,09h
        int 21h 
        
        lea dx,player1name+2
        mov ah,09h
        int 21h
    
        jmp continue4pvc
        
    ;When it's the first bot's turn, it says bot's turn    
    bot2.4:
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 25             
        int 10h 
    
        lea dx,botmsg
        mov ah,09h
        int 21h
        
     ;It tells us to roll the dice, then it rolls the dice and 
     ;if the result is 4,5 or 6, it switches to the left wing,right wing or head drawing part. (BOT)    
    Continue4pvcbot:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 10             
        int 10h
    
        lea dx,messagerollbot  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
    
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h
        
        cmp ch,04h
        je  leftwing
        
        cmp ch,05h
        je  rightwing
    
        cmp ch,06h
        je  head
        jnz fourthrollpvc
        
     ;It tells us to roll the dice, then it rolls the dice and 
     ;if the result is 4,5 or 6, it switches to the left wing,right wing or head drawing part. (PLAYER)  
      Continue4pvc:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 22              
        mov dl, 20             
        int 10h
    
        lea dx,messageDice  
        mov ah,09h
        int 21h
    
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h
        
        cmp ch,04h
        je  leftwing
        
        cmp ch,05h
        je  rightwing
    
        cmp ch,06h
        je  head
        jnz fourthrollpvc      

ENDP ROLL_PVC
    

;ROLL_PVP,In two player mode, the rounds are determined by the drawing of the bird.
;also determines whose turn it is to roll the dice.
;Prints on the screen whose turn it is and what the previous dice was.

ROLL_PVP PROC 
    
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder
    FirstRoll:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        jz player2.1
    
    ;When it's the first player's turn, it says player one turn
    Player1.1:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
        
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
        
        jmp continue1
    
    ;When it's the second player's turn, it says player two turn
    Player2.1:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
        
        lea dx,player2turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player2name+2
        mov ah,09h
        int 21h
    
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 1, it switches to the vase drawing part. 
    Continue1:
    
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
        
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
        
        sub ch,30h
        cmp ch,01h
        
        je  vase
        jne firstroll 
    
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder    
    SecondRoll:
        
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        
        cmp ah,01h
        jz player2.2
    
    ;When it's the first player's turn, it says player one turn
    Player1.2:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
        
        lea dx,player1turnmsg
        mov ah,09h
        int 21h 
        
        lea dx,player1name+2
        mov ah,09h
        int 21h
        
        jmp continue2
    
    ;When it's the second player's turn, it says player two turn
    Player2.2:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        
        int 10h 
        lea dx,player2turnmsg
        mov ah,09h
        int 21h 
        
        lea dx,player2name+2
        mov ah,09h
        int 21h
    
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 2, it switches to the legs drawing part.    
    Continue2:
    
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,02h
        
        je  legs
        jne secondroll
     
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder 
    ThirdRoll:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        
        jz player2.3
    
    ;When it's the first player's turn, it says player one turn
    Player1.3:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
        
        jmp continue3
        
    ;When it's the second player's turn, it says player two turn    
    Player2.3:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player2turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player2name+2
        mov ah,09h
        int 21h
        
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 3, it switches to the body drawing part.    
    Continue3:
    
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  ;asks for square height
        mov ah,09h
        int 21h
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h 
        cmp ch,03h
    
        je  body
        jne thirdroll
        
    ;records the total number of dice rolls
    ;Divides the total number of games by 2 and determines whose turn it is based on the remainder    
    FourthRoll:
    
        mov ah,0
        mov al,playerturn
        inc playerturn 
        mov bl,2
        div bl
        cmp ah,01h
        
        jz player2.4
    
    ;When it's the first player's turn, it says player one turn
    Player1.4:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player1turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player1name+2
        mov ah,09h
        int 21h 
    
        jmp continue4
        
    ;When it's the second player's turn, it says player two turn    
    Player2.4:
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 1             
        int 10h 
        
        lea dx,clear
        mov ah,09h
        int 21h
        
        mov ah, 02h             
        mov bh, 0               
        mov dh, 18              
        mov dl, 20             
        int 10h 
    
        lea dx,player2turnmsg
        mov ah,09h
        int 21h
        
        lea dx,player2name+2
        mov ah,09h
        int 21h
        
    ;It tells us to roll the dice, then it rolls the dice and 
    ;if the result is 4 or,5 or 6, it switches to the leftwing, right wing or head drawing part.    
    Continue4:
    
        mov ah, 02h             
        mov bh, 0               
        mov dh, 20              
        mov dl, 20             
        int 10h
    
        lea dx,messageroll  
        mov ah,09h
        int 21h
    
        mov ah,01h               ;input
        int 21h 
    
        call generate_dice
    
        add ch,30h 
        mov ah,02h    
        mov dl,ch
        int 21h
    
        sub ch,30h
        
        cmp ch,04h
        je  leftwing
        
        cmp ch,05h
        je  rightwing
    
        cmp ch,06h
        je  head
        jnz fourthroll 

ENDP ROLL_PVP

;draws the head of the bird on the screen    

DRAW_HEAD PROC 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 4              
    mov dl, 38             
    int 10h
        
    lea dx,head1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 5              
    mov dl, 37             
    int 10h
        
    lea dx,head2
    mov ah,9
    int 21h  
    
ret
ENDP DRAW_HEAD  

;draws the body of the bird on the screen
DRAW_BODY PROC 

    mov ah, 02h             
    mov bh, 0               
    mov dh, 6              
    mov dl, 39             
    int 10h
        
    lea dx,body1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 7              
    mov dl, 38             
    int 10h
        
    lea dx,body2
    mov ah,9
    int 21h
        
    mov ah, 02h             
    mov bh, 0               
    mov dh, 8              
    mov dl, 38             
    int 10h
        
    lea dx,body3
    mov ah,9  
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 9              
    mov dl, 39             
    int 10h 
           
    lea dx,body4
    mov ah,9
    int 21h 
ret    
ENDP DRAW_BODY 

;draws the vase of the bird on the screen
DRAW_VASE PROC 
               
    mov ah, 02h             
    mov bh, 0               
    mov dh, 12              
    mov dl, 35             
    int 10h
        
    lea dx,vase1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 13              
    mov dl, 36             
    int 10h
        
    lea dx,vase2
    mov ah,9
    int 21h
        
    mov ah, 02h             
    mov bh, 0               
    mov dh, 14              
    mov dl, 37             
    int 10h
        
    lea dx,vase3
    mov ah,9  
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 15              
    mov dl, 38             
    int 10h 
           
    lea dx,vase4
    mov ah,9
    int 21h 
ret    
ENDP DRAW_VASE


;draws the legs of the bird on the screen
DRAW_LEGS PROC 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 10              
    mov dl, 39             
    int 10h
        
    lea dx,legs1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 11              
    mov dl, 35             
    int 10h
        
    lea dx,legs2
    mov ah,9
    int 21h  
ret
ENDP DRAW_LEGS  

;draws the left wing of the bird on the screen
DRAW_LEFT_WING PROC 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 4              
    mov dl, 29             
    int 10h
        
    lea dx,leftwing1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 5              
    mov dl, 25             
    int 10h
        
    lea dx,leftwing2
    mov ah,9
    int 21h
        
    mov ah, 02h             
    mov bh, 0               
    mov dh, 6              
    mov dl, 22             
    int 10h
        
    lea dx,leftwing3
    mov ah,9  
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 7              
    mov dl, 18             
    int 10h 
           
    lea dx,leftwing4
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 8              
    mov dl, 28             
    int 10h
     
    lea dx,leftwing5
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 9              
    mov dl, 33             
    int 10h
    
    lea dx,leftwing6
    mov ah,9
    int 21h   
ret    
ENDP DRAW_LEFT_WING

;draws the right of the bird on the screen
DRAW_RIGHT_WING PROC
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 4              
    mov dl, 46             
    int 10h
        
    lea dx,rightwing1
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 5              
    mov dl, 44             
    int 10h
    
    
    lea dx,rightwing2
    mov ah,9
    int 21h
    
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 6              
    mov dl, 44             
    int 10h
    
    
    lea dx,rightwing3
    mov ah,9  
    int 21h
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 7              
    mov dl, 43             
    int 10h 
     
      
    lea dx,rightwing4
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 8              
    mov dl, 45             
    int 10h
     
    lea dx,rightwing5
    mov ah,9
    int 21h 
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 9              
    mov dl, 43             
    int 10h
    
    lea dx,rightwing6
    mov ah,9
    int 21h

ret
ENDP DRAW_RIGHT_WING  

;clears all of the screen
CLEAR_SCREEN PROC
    
    
    
    mov ah, 02h             
    mov bh, 0               
    mov dh, 2              
    mov dl, 2             
    int 10h
    mov bl,15h
    clearscreenloop:    
    
    lea dx,clear
    mov ah,9
    int 21h     
    lea dx,newline  
    mov ah,9
    int 21h 
    dec bl
    jnz clearscreenloop:
    ret
    
ENDP CLEAR_SCREEN
   
END
