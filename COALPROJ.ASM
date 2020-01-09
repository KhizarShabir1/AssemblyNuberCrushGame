include delay.inc
include blank.inc

.model small
.stack 100h
.data
randArray db 100 dup(7)
randArraySize word 100
dupArray db 100 dup(7)
cursorCount byte 0 ; when it becomes 10 cursor moves to next row
colrOfChar byte ?
cursorCol byte 10
SvdCursorCol byte  10
cursorRow byte 4
ten word 10
nine word 9
boxSize db 16
gridX dw 74
gridY dw 28
swap1x dw 0
swap1y dw 0
swap2x dw 0
swap2y dw 0
color db 0h
outOfRange db 0
x_axis dw 0
y_axis dw 0
blankx dw 0
blanky dw 0
ifMatched db ?  
temp1 dw 0
temp2 dw 0
countSame word 1
countColcrush db 1
temp3prev db 0
countTercol dw 0
phase2Started db 0

countBubblesort word 0
swapbubbleVar byte 0
rowplus1index word 0
column_indexbubble word 0
tempBubble byte 0

allClearCheck db 0

;Name
EnterName db "Please enter your Name:$"
StrName db 20 dup('S')
rownumCrsName db 1
colnumCrsName db 0
svecolnumCrsName db 0
colurName db 10
svecolurName db 10
;Score
StrScore db "Score: $"
rownumCrsScore db 1
colnumCrsScore db 16
svecolnumCrsScore db 16
scoreVal dw 0
svescoreVal dw 0
scorelen dw 0
scorenum db 0
;Moves
strMoves db "Moves: $"
colnumCrsMoves db 30
svecolnumCrsMoves db 30
MovesVal dw 20
sveMovesVal dw 0
;welcome 
welcomeStr db "WELCOME TO THE NUMBER CRUSH GAME LET'S PLAY !$"
weldispstr db 46 dup('$')
rownumWEL db 5
columnoWEL db 5

;crush the hurdles
up word ?
down word ?
left word ?
right word ?
hurdleNumber db ?


;swap back procedure
swapBackX dw ?
swapBackY dw ?

;skip unnecessary display
dontDisplay db ?

;rectangle move
xUP word  40
XupEND WORD 0
XDOWNEND WORD 0
yUP word 80
xDown word  ?
yDown word 120
xend word 640
chkdec byte 0
;

colleveld db 8
svecolleveld db 8
strlevel1 db " LEVEL:1$"
strlevel2 db " LEVEL:2$"
strlevel3 db " LEVEL:3$"

rowcrushlast db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ending of level
limit dw 10

endsttr db "Hope you enjoyed :) $"
.code

main PROC
mov ax,@data
mov ds,ax


;Name

mov ax,0
mov dx,0
mov ah,09h
mov dx,offset EnterName
int 21h

mov ah,3fh
mov dx,offset StrName
int 21h

;Name ends

blank
;jmp phase1
;lets welcome
mov di,0
welLoop1:

	mov dx,0
	mov dl,welcomeStr[di]
	mov weldispstr[di],dl
	mov columnoWEL,5
		mov rownumWEL,8
	mov si,0
	welLoop2:
		cmp weldispstr[si],'$'
		je goUP
		mov ax,0
		mov dx,0
		mov bx,00
		mov ah,02h
		mov dh,rownumWEL
		mov dl,columnoWEL
		int 10h
		
		mov ah,09h
		mov al,weldispstr[si]
		mov bh,0
		mov bl,colurName
		mov cx,1
		int 10h
		
		inc si
		inc colurName
		inc columnoWEL
		cmp columnoWEL,37
		 jne moveonWEL
		   add rownumWEL,5
		   mov columnoWEL,14
		
		moveonWEL:
		cmp colurName,16
		jne loop2wel
		mov colurName,10

		loop2wel:
		jmp welLoop2
	
	
	goUP:
	inc di
	delay 3h,0h
	cmp di,44
	jne welLoop1
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov bx,0
mov ax,0
mov ah,0
mov al,13h
int 10h
start:
mov dx,0
mov cx,0
mov si,0
;mov xup,40
move:

mov cx,40
mov dx,20
loopfirst:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopfirst
mov cx,280
mov dx,20
loopsec:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopsec
delay 01h,0fffh
		   mov cx,0
		   mov dx,0
		   mov dl,colleveld
		   mov svecolleveld,dl
		   mov dl,0
mov di,0
displaylevelname:

cmp strlevel1[di],'$'
je makeRectangle
cmp strlevel1[di],'1'
jne conty
mov colurName,11

conty:
cmp strlevel1[di],':'
jne conty1
mov colurName,10
conty1:
mov ah,02h
mov dh,12
mov dl,colleveld
int 10h

mov ah,09h
mov al,strlevel1[di]
mov bh,0
mov bl,colurName
mov cx,1
int 10h

inc di

inc colleveld
inc colurName
jmp displaylevelname

makeRectangle:
mov colurName,10
mov dl,svecolleveld
mov colleveld,dl
inc colleveld


CALL RECTANGLE
  mov cx,0
  mov dx,0

 ;  sub xup,5

   mov cx,002h
   mov dx,4240h
   mov ah,86h
   int 15h
   mov ax,0
   mov ah,0
   mov al,13h
   int 10h

   inc si
    add xup,10
   mov ax,0
   cmp si,16
 jne move
	
	
	
	
	
	
	
	
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
phase1:	

blank

mov colurName,10
mov ax,0
mov dx,0
mov cx,0
mov si,0
mov di,0
mov bx,0



mov si,0
mov temp1,1
randomInitiaizer:
	add temp1,si
    call generateRandom
	mov randArray[si],dl
	inc si
	cmp si,100
		jne randomInitiaizer
	
	;call initializeDupArray

mov MovesVal,3
mov dontDisplay,0
mainLoop:
	call display
	cmp dontDisplay,1
		je dontDisplayIfNotCrush

	allnotclear:
		mov allClearCheck,0
		call crush
		call display
		delay 3h,0h
		call bubblesort
		call display
		delay 3h,0h
		call randomInCrushed
		call display
		delay 3h,0h
		cmp allClearCheck,1
			je allnotclear
			
	dontDisplayIfNotCrush:
	
	cmp MovesVal,0
		je phase2

	mov outOfRange,0
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap1x,ax
	mov ax,temp2
	mov swap1y,ax
	call cal1
	cmp outOfRange,1
		je mainLoop
	
	
	delay 03h,0h
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap2x,ax
	mov ax,temp2
	mov swap2y,ax
	call cal2
	cmp outOfRange,1
		je mainLoop
		
	delay 03h,0h
	mov dontDisplay,0
	call swap
	dec MovesVal
	
	jmp mainLoop
		
		
		
phase2:

mov limit,9
phase1ending:

call displayending
	delay 1,0fff6h
	
	add limit,9
	cmp limit,100
	jb phase1ending





mov phase2Started,1

blank
	
mov	xUP , 40
mov XupEND ,0
mov XDOWNEND ,0
mov yUP ,80
mov xDown,  0
mov yDown ,120
mov xend , 640

mov colleveld , 8
	
	
		mov bx,0
mov ax,0
blank
start1:
mov dx,0
mov cx,0
mov si,0
;mov xup,40
move1:

mov cx,40
mov dx,20
loopfirst1:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopfirst1
mov cx,280
mov dx,20
loopsec1:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopsec1
delay 01h,0fffh
		   mov cx,0
		   mov dx,0
		   mov dl,colleveld
		   mov svecolleveld,dl
		   mov dl,0
mov di,0
displaylevelname1:

cmp strlevel2[di],'$'
je makeRectangle1
cmp strlevel2[di],'1'
jne conty2
mov colurName,11

conty2:
cmp strlevel2[di],':'
jne conty3
mov colurName,10
conty3:
mov ah,02h
mov dh,12
mov dl,colleveld
int 10h

mov ah,09h
mov al,strlevel2[di]
mov bh,0
mov bl,colurName
mov cx,1
int 10h

inc di

inc colleveld
inc colurName
jmp displaylevelname1

makeRectangle1:
mov colurName,10
mov dl,svecolleveld
mov colleveld,dl
inc colleveld


CALL RECTANGLE
  mov cx,0
  mov dx,0

 ;  sub xup,5

   mov cx,002h
   mov dx,4240h
   mov ah,86h
   int 15h
   mov ax,0
   mov ah,0
   mov al,13h
   int 10h

   inc si
    add xup,10
   mov ax,0
   cmp si,16
 jne move1
mov dx,0
mov cx,0
mov si,0
	
	
	mov colurName,10


	blank
	
	mov si,0
	mov temp1,1
	randomInitiaizerPH2:
		add temp1,si
		
		call generateRandom
		mov al,dl
		mov ah,0
		mov bl,4
		div bl
		mov randArray[si],ah
		inc si
		cmp si,100
			jne randomInitiaizerPH2
		
		mov randArray[0],10
		mov randArray[1],10
		mov randArray[2],10
		mov randArray[10],10
		mov randArray[11],10
		mov randArray[12],10
		mov randArray[20],10
		mov randArray[21],10
		mov randArray[22],10
		
		mov randArray[70],10
		mov randArray[71],10
		mov randArray[72],10
		mov randArray[80],10
		mov randArray[81],10
		mov randArray[82],10
		mov randArray[90],10
		mov randArray[91],10
		mov randArray[92],10
		
		mov randArray[7],10
		mov randArray[8],10
		mov randArray[9],10
		mov randArray[17],10
		mov randArray[18],10
		mov randArray[19],10
		mov randArray[27],10
		mov randArray[28],10
		mov randArray[29],10
	
		mov randArray[77],10
		mov randArray[78],10
		mov randArray[79],10
		mov randArray[87],10
		mov randArray[88],10
		mov randArray[89],10
		mov randArray[97],10
		mov randArray[98],10
		mov randArray[99],10
		
		
		mov randArray[43],10
		mov randArray[44],10
		mov randArray[45],10
		mov randArray[46],10
		mov randArray[53],10
		mov randArray[54],10
		mov randArray[55],10
		mov randArray[56],10

	mov MovesVal,3
	mov dontDisplay,0
	mainLoop2:
	call display
	cmp dontDisplay,1
		je dontDisplayIfNotCrush2
	
	allnotclear2:
		mov allClearCheck,0
		call crush
		call display
		delay 3h,0h
		mov hurdleNumber,10
		call bubblesortPhase2
		call display
		delay 3h,0h
		call randomInCrushed
		call display
		delay 3h,0h
		cmp allClearCheck,1
		je allnotclear2
	
	dontDisplayIfNotCrush2:
	
	cmp MovesVal,0
		je phase3
	
	mov outOfRange,0
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap1x,ax
	mov ax,temp2
	mov swap1y,ax
	call cal1
	cmp outOfRange,1
		je mainLoop2
	
	delay 03h,0h
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap2x,ax
	mov ax,temp2
	mov swap2y,ax
	call cal2
	cmp outOfRange,1
		je mainLoop2
		
	delay 03h,0h
	mov dontDisplay,0
	call swap
	dec MovesVal
	
	jmp mainLoop2
		
	
		;;;;;;;;;;;;;;;;;;PHSE 3;;;;;;;;;;;;;;;;;;;;;;;;
		;ascii of x is 88
phase3:


mov limit,9
phase1ending1:

call displayending
	delay 1,0fff6h
	
	add limit,9
	cmp limit,100
	jb phase1ending1










mov phase2Started,0
blank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;level
	
mov	xUP , 40
mov XupEND ,0
mov XDOWNEND ,0
mov yUP ,80
mov xDown,  0
mov yDown ,120
mov xend , 640

mov colleveld , 8
	
	
		mov bx,0
mov ax,0

start2:
mov dx,0
mov cx,0
mov si,0
;mov xup,40
move2:

mov cx,40
mov dx,20
loopfirst2:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopfirst2
mov cx,280
mov dx,20
loopsec2:
		MOV AH,0CH
	      MOV AL,0
	      INT 10H
	      inc dx
	      cmp dx,180
	      jne loopsec2
delay 01h,0fffh
		   mov cx,0
		   mov dx,0
		   mov dl,colleveld
		   mov svecolleveld,dl
		   mov dl,0
mov di,0
displaylevelname2:

cmp strlevel3[di],'$'
je makeRectangle2
cmp strlevel3[di],'1'
jne conty5
mov colurName,11

conty5:
cmp strlevel3[di],':'
jne conty6
mov colurName,10
conty6:
mov ah,02h
mov dh,12
mov dl,colleveld
int 10h

mov ah,09h
mov al,strlevel3[di]
mov bh,0
mov bl,colurName
mov cx,1
int 10h

inc di

inc colleveld
inc colurName
jmp displaylevelname2

makeRectangle2:
mov colurName,10
mov dl,svecolleveld
mov colleveld,dl
inc colleveld


CALL RECTANGLE
  mov cx,0
  mov dx,0

 ;  sub xup,5

   mov cx,002h
   mov dx,4240h
   mov ah,86h
   int 15h
   mov ax,0
   mov ah,0
   mov al,13h
   int 10h

   inc si
    add xup,10
   mov ax,0
   cmp si,16
 jne move2

mov dx,0
mov cx,0
mov si,0
	
	
	mov colurName,10
	




	blank
	
	mov si,0
	mov temp1,1
	randomInitiaizerPH3:
		add temp1,si
		
		call generateRandomHurdlz
	
		mov randArray[si],dl
		hurdle:
		inc si
		cmp si,100
			jne randomInitiaizerPH3
		
		
	mov MovesVal,3
	mov dontDisplay,0
	
	mainLoop3:
	
	call display 
	cmp dontDisplay,1
		je dontDisplayIfNotCrush3
		
	allnotclear3:
		mov allClearCheck,0
		call crush
		call display
		delay 3h,0h
		mov hurdleNumber,5
		call bubblesortPhase2
		call display
		delay 3h,0h
		call randomInCrushed
		call display
		delay 3h,0h
		cmp allClearCheck,1
			je allnotclear3
		
	dontDisplayIfNotCrush3:
	
	cmp MovesVal,0
		je exit
	
	mov outOfRange,0
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap1x,ax
	mov ax,temp2
	mov swap1y,ax
	call cal1
	cmp outOfRange,1
		je mainLoop3
	
	delay 03h,0h
	call getCurPos
	mov dx,0
	mov ax,temp1
	mov bh,0
	mov bl,2
	div bx
	mov swap2x,ax
	mov ax,temp2
	mov swap2y,ax
	call cal2
	cmp outOfRange,1
		je mainLoop3
		
	delay 03h,0h
	mov dontDisplay,0
	call swap
	dec MovesVal
	
	jmp mainLoop3
	
	
	exit:
mov limit,9
phase1ending2:

call displayending
	delay 1,0fff6h
	
	add limit,9
	cmp limit,100
	jb phase1ending2

	
;;;;;;;;;;;;;;;;;;;;;;final page ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
blank
mov colnumCrsName,16
;mov colnumCrsMoves,9
mov rownumCrsName,9
call Score
mov rownumCrsName,7
call nameDisplay
mov di,0
mov colleveld,5
displayendpage:

cmp endsttr[di],'$'
je khtm


mov ah,02h
mov dh,12
mov dl,colleveld
int 10h

mov ah,09h
mov al,endsttr[di]
mov bh,0
mov bl,colurName
mov cx,1
int 10h

inc di
cmp colurName,15
jne contkro
mov colurName,10
contkro:
inc colleveld
inc colurName
jmp displayendpage


khtm:

delay 1,0ffffh
	

    mov ah,4ch
    int 21h

main endp





displayending PROC





	blank
	;initialize registors
	mov dx,0
	mov bx,0
	mov cx,0
	
	mov si,0
	loop1:
	
	mov dx,0
	mov bx,0
	
	;setting cursor position
	mov ah,02h
	mov dh,cursorRow   ;row num of cursor
	
	mov dl,cursorCol   ; col num of cursor
	int 10h
;displaying character at cursor position
	cmp randArray[si],10
	je plusSign
	mov ah,09h
	cmp randArray[si],5
	jne nohurdle
	mov al,40
	jmp addedHurdle
	
	nohurdle:
	mov al,randArray[si]
addedHurdle:
cmp al,-1
jne chkif0
mov bl,9
	jmp add48
	
	chkif0:
	cmp al,0
	jne chkif1
	mov bl,2Ah
	jmp add48
	
	chkif1:
	cmp al,1
	jne chkif2
	mov bl,11
	jmp add48
	
	chkif2:
	cmp al,2
	jne chkif3
	mov bl,12
	jmp add48
	
	chkif3:
	cmp al,3
	jne chkif4
	mov bl,13
	jmp add48
	
	chkif4:
	cmp al,4
	jne chkif5
	mov bl,14
	jmp add48
	
	chkif5:
	cmp al,5
	jne chkifbomb
	mov bl,15
	jmp add48
	
	chkifbomb:
	cmp al,-47
	mov bl,3

	
	add48:
	cmp si,limit
	ja goonadd48
	
	mov bl,0
	goonadd48:
	add al,48
	mov bh,0
	
	mov cx,1
	int 10h
plusSign:
	inc si
	;increment the column for cursor
	add cursorcol,2
	;checking for next row of cursor
	mov dx,0  
	mov ax,0
	mov ax,si
	div ten 
	cmp dx,0              ;if remainder is zero means 10 charceter has been printed
	jne cont

	add cursorrow,2
	mov dl,SvdCursorCol
	mov cursorCol,dl
	cont:
	cmp si,100
		jne loop1
		
		mov cursorCol, 10
mov SvdCursorCol ,10
mov cursorRow , 4

	
	ret
	
displayending endp












display PROC

	blank
	;initialize registors
	mov dx,0
	mov bx,0
	mov cx,0
	
	mov si,0
	loop1:
	
	mov dx,0
	mov bx,0
	
	;setting cursor position
	mov ah,02h
	mov dh,cursorRow   ;row num of cursor
	
	mov dl,cursorCol   ; col num of cursor
	int 10h
	;displaying character at cursor position
	cmp randArray[si],10
	je plusSign
	mov ah,09h
	cmp randArray[si],5
	jne nohurdle
	mov al,40
	jmp addedHurdle
	
	nohurdle:
	mov al,randArray[si]
addedHurdle:
cmp al,-1
jne chkif0
mov bl,9
	jmp add48

	chkif0:
	cmp al,0
	jne chkif1
	mov bl,2Ah
	jmp add48
	
	chkif1:
	cmp al,1
	jne chkif2
	mov bl,11
	jmp add48
	
	chkif2:
	cmp al,2
	jne chkif3
	mov bl,12
	jmp add48
	
	chkif3:
	cmp al,3
	jne chkif4
	mov bl,13
	jmp add48
	
	chkif4:
	cmp al,4
	jne chkif5
	mov bl,14
	jmp add48
	
	chkif5:
	cmp al,5
	jne chkifbomb
	mov bl,15
	jmp add48
	
	chkifbomb:
	cmp al,-47
	mov bl,3

	
	add48:
	add al,48
	mov bh,0
	;sub al,41
	;;mov bl,al	     ;colour is 1 plus the number of character
	;add al,41		 ; again change the no to its prev state
	mov cx,1
	int 10h
plusSign:
	inc si
	;increment the column for cursor
	add cursorcol,2
	;checking for next row of cursor
	mov dx,0  
	mov ax,0
	mov ax,si
	div ten 
	cmp dx,0              ;if remainder is zero means 10 charceter has been printed
	jne cont

	add cursorrow,2
	mov dl,SvdCursorCol
	mov cursorCol,dl
	cont:
	cmp si,100
		jne loop1
		
		mov cursorCol, 10
mov SvdCursorCol ,10
mov cursorRow , 4

call grid
call nameDisplay 
call Score
call Moves

ret 

display endp

squarePhase2 PROC

mov ifMatched,0

;upper-left block
mov blankx,74
mov blanky,28
call compare

mov blankx,90
mov blanky,28
call compare

mov blankx,106
mov blanky,28
call compare

mov blankx,74
mov blanky,44
call compare

mov blankx,90
mov blanky,44
call compare

mov blankx,106
mov blanky,44
call compare

mov blankx,74
mov blanky,60
call compare

mov blankx,90
mov blanky,60
call compare

mov blankx,106
mov blanky,60
call compare

;upper-right block

mov blankx,186
mov blanky,28
call compare

mov blankx,202
mov blanky,28
call compare

mov blankx,218
mov blanky,28
call compare

mov blankx,186
mov blanky,44
call compare

mov blankx,202
mov blanky,44
call compare

mov blankx,218
mov blanky,44
call compare

mov blankx,186
mov blanky,60
call compare

mov blankx,202
mov blanky,60
call compare

mov blankx,218
mov blanky,60
call compare

;lower-left block
mov blankx,74
mov blanky,140
call compare

mov blankx,90
mov blanky,140
call compare

mov blankx,106
mov blanky,140
call compare

mov blankx,74
mov blanky,156
call compare

mov blankx,90
mov blanky,156
call compare

mov blankx,106
mov blanky,156
call compare

mov blankx,74
mov blanky,172
call compare

mov blankx,90
mov blanky,172
call compare

mov blankx,106
mov blanky,172
call compare

;lower-right block

mov blankx,186
mov blanky,140
call compare

mov blankx,202
mov blanky,140
call compare

mov blankx,218
mov blanky,140
call compare

mov blankx,186
mov blanky,156
call compare

mov blankx,202
mov blanky,156
call compare

mov blankx,218
mov blanky,156
call compare

mov blankx,186
mov blanky,172
call compare

mov blankx,202
mov blanky,172
call compare

mov blankx,218
mov blanky,172
call compare

;middle 

mov blankx,122
mov blanky,92
call compare

mov blankx,138
mov blanky,92
call compare

mov blankx,154
mov blanky,92
call compare

mov blankx,170
mov blanky,92
call compare

mov blankx,122
mov blanky,108
call compare

mov blankx,138
mov blanky,108
call compare

mov blankx,154
mov blanky,108
call compare

mov blankx,170
mov blanky,108
call compare

cmp ifMatched,1
	je q
jmp r
q:
ret

r:

mov bh,0
mov bl,boxSize
upline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	inc x_axis
	dec bx
	CMP bx,0
		jne upline
		
mov bh,0
mov bl,boxSize
rightline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	inc y_axis
	dec bx
	CMP bx,0
		jne rightline
		
mov bh,0
mov bl,boxSize
downline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	dec x_axis
	dec bx
	CMP bx,0
		jne downline
		
mov bh,0
mov bl,boxSize
leftline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	dec y_axis
	dec bx
	CMP bx,0
		jne leftline

	ret
squarePhase2 endp

square PROC

mov bh,0
mov bl,boxSize
upline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	inc x_axis
	dec bx
	CMP bx,0
		jne upline
	
mov bh,0
mov bl,boxSize
rightline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	inc y_axis
	dec bx
	CMP bx,0
		jne rightline
		
mov bh,0
mov bl,boxSize
downline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	dec x_axis
	dec bx
	CMP bx,0
		jne downline
		
mov bh,0
mov bl,boxSize
leftline:
	mov ah,0ch
	mov al,color
	mov cx,x_axis
	mov dx,y_axis
	int 10h
	dec y_axis
	dec bx
	CMP bx,0
		jne leftline

	ret

square endp


compare PROC

mov ax,blankx
cmp x_axis,ax
	jne b
a:
	mov ax,blanky
	cmp y_axis,ax
	jne b
mov ifMatched,1

b:
ret

compare endp

grid PROC

mov color,0fh
mov ax,gridX
mov x_axis,ax
mov ax,gridY
mov y_axis,ax
mov temp1,10
mov temp2,10
outloop:
	cmp phase2Started,1
		je started
	jmp notStarted

	conti:
	mov ah,0
	mov al,boxSize
	add x_axis,ax
	dec temp1
	cmp temp1,0
		jne outloop
	
	mov ax,gridX
	mov x_axis,ax
	mov ah,0
	mov al,boxSize
	add y_axis,ax
	mov temp1,10
	dec temp2
	cmp temp2,0
		jne outloop
	ret
	
	started:
		call squarePhase2
		jmp conti
	
	notStarted:
		call square
		jmp conti
grid endp

cal1 PROC

mov ax,gridX
cmp swap1x,ax
	jb noRange1
	
mov dx,0
mov ax,gridX
sub swap1x,ax
mov ax,swap1x
mov bh,0
mov bl,boxSize
div bx
mov swap1x,ax

mov ax,ten
cmp swap1x,ax
	jae noRange1

mov ax,gridY
cmp swap1y,ax
	jb noRange1
	
mov ax,gridY
sub swap1y,ax
mov ax,swap1y
mov bl,boxSize
div bl
mov ah,0
mov swap1y,ax

mov ax,ten

cmp swap1y,ax
	jae noRange1
	
mov ax,swap1y
mov bl,10
mul bl
add ax,swap1x
mov si,ax
cmp randArray[si],10
	je noRange1

;if X then don't select
cmp randArray[si],5
	je noRange1

	
;square highlight
mov cx,swap1x
mov dx,swap1y
mov ax,cx
mov bl,boxSize
mul bl
add ax,gridX
mov cx,ax
mov ax,dx
mov bl,boxSize
mul bl
add ax,gridY
mov dx,ax
mov x_axis,cx
mov y_axis,dx
mov color,02h
call square
jmp ret1

noRange1:
	mov outOfRange,1
	
ret1:
ret

cal1 endp

cal2 PROC

mov ax,gridX
cmp swap2x,ax
	jb noRange2

mov dx,0
mov ax,gridX
sub swap2x,ax
mov ax,swap2x
mov bh,0
mov bl,boxSize
div bx
mov swap2x,ax

mov ax,ten
cmp swap2x,ax
	jae noRange2

mov ax,gridY
cmp swap2y,ax
	jb noRange2
	
mov ax,gridY
sub swap2y,ax
mov ax,swap2y
mov bl,boxSize
div bl
mov ah,0
mov swap2y,ax

mov ax,ten
cmp swap2y,ax
	jae noRange2
	
mov ax,swap2y
mov bl,10
mul bl
add ax,swap2x
mov si,ax
cmp randArray[si],10
	je noRange2

;if X then don't select
cmp randArray[si],5
	je noRange2
	
;square highlight
mov cx,swap2x
mov dx,swap2y
mov ax,cx
mov bl,boxSize
mul bl
add ax,gridX
mov cx,ax
mov ax,dx
mov bl,boxSize
mul bl
add ax,gridY
mov dx,ax
mov x_axis,cx
mov y_axis,dx
mov color,02h
call square
jmp ret2

noRange2:
mov outOfRange,1

ret2:
ret

cal2 endp


swap PROC

;formula
mov ax,swap1y
mov bl,10
mul bl
add ax,swap1x
mov temp1,ax

mov ax,swap2y
mov bl,10
mul bl
add ax,swap2x
mov temp2,ax

mov ax,temp1
cmp temp2,ax
	je equalPos
jmp notEqual
equalPos:
	inc MovesVal
	ret

notEqual:

;mov ax,temp1
cmp temp2,10
	jb l1

mov ax,temp2
sub ax,10
cmp ax,temp1
	je continue

l1:
cmp temp2,89
	ja l2

mov ax,temp2
add ax,10
cmp ax,temp1
	je continue
	
l2:
mov dx,0
mov ax,temp2
mov bx,10
div bx
cmp dx,9
	je l3

mov ax,temp2
inc ax
cmp ax,temp1
	je continue
	
l3:
mov dx,0
mov ax,temp2
mov bx,10
div bx
cmp dx,0
	je l4

mov ax,temp2
dec ax
cmp ax,temp1
	je continue

l4:
jmp ret3	

continue:
;swapping
mov si,temp1
mov ah,randArray[si]

mov si,temp2
mov al,randArray[si]

mov si,temp1
mov randArray[si],al

mov si,temp2
mov randArray[si],ah

mov ax,temp1
mov swapBackX,ax
mov ax,temp2
mov swapBackY,ax

mov si,temp1
cmp randArray[si],-47
	je heart1
	

mov si,temp2
cmp randArray[si],-47
	je heart2

jmp noCrush

ret3:
ret

heart1:
mov randArray[si],-1
mov si,0
mov di,temp2
mov cl,randArray[di]
mov ch,0
bombloop1:
	cmp randArray[si],cl
		je equal1
	inc si
	cmp si,100
		jb bombloop1
	jmp ret3
	
equal1:
	mov randArray[si],-1
	inc si
	cmp si,100
		jb bombloop1
	jmp ret3
	
heart2:
mov randArray[si],-1
mov si,0
mov di,temp1
mov cl,randArray[di]
mov ch,0
bombloop2:
	cmp randArray[si],cl
		je equal2
	inc si
	cmp si,100
		jb bombloop2
	jmp ret3
	
equal2:
	mov randArray[si],-1
	inc si
	cmp si,100
		jb bombloop2
	jmp ret3

;if there is no crush then swap back
noCrush:
	call crush
	mov si,0
	isCrushed:
		cmp randArray[si],-1
			je ret3
		inc si
		cmp si,100
			jne isCrushed
	call display	
	delay 4h,0h
	;swapping back
	
	mov dontDisplay,1
	mov si,swapBackX
	mov ah,randArray[si]
	
	mov si,swapBackY
	mov al,randArray[si]
	
	mov si,swapBackX
	mov randArray[si],al

	mov si,swapBackY
	mov randArray[si],ah
	
	jmp ret3

swap endp

;return position of cursor click in cx and dx
getCurPos PROC

mov bx,0
loopTillButtonPressed: 
	;cursor on screen
	mov ax,01h
	int 33h
	;cursor position
	mov ax,03h
	int 33h
	cmp bx,1
		jne loopTillButtonPressed
	mov temp1,cx
	mov temp2,dx
	
	ret	
getCurPos endp

;procedure for random generation of numbers
generateRandom PROC
	mov dx,0
	mov cx,0
	mov ah,00h
	int 1Ah
	mov ax,dx
	mov dx,0
	mul temp1
	mov dx,0
	mov cx,5
	div cx
	ret
	
generateRandom  endp





;crushing code starts frm here
initializeDupArray PROC
mov si,0

	loopcopy:
	
		mov dupArray[si],7
		inc si
		cmp si,100
		jne loopcopy
		ret
initializeDupArray endp		
 	



copyArray PROC
	mov si,0
	mov bx,0
	loopcopy:
		mov bl,randArray[si]
		mov dupArray[si],bl
		inc si
		cmp si,100
		jne loopcopy
		
		mov si,0
		ret
copyArray endp		

crush PROC
	
	call copyArray

	mov countSame,1
	mov dx,0
	mov ax,0
	mov si,0
		mov bl,randArray[si]
		;mov temp3prev,dl
		;mov dx,0
	loopRoWiseCrush:
		
		cmp si,0
		je noneed
		mov ax,0
		mov dx,0 ; check nextline
		mov ax,si
		div ten
		cmp dx,0
		je startRevloop
		
		cmp randArray[si],5
		je  startRevloop
		
		cmp randArray[si],10
		je  startRevloop
		
		cmp randArray[si],bl
		jne startRevloop
		inc countSame
		jmp noneed
		
		startRevloop:
		
		cmp countSame,3
			jb startfresh
			mov di,0
			mov di, si
			dec di
				
			mov cx,countSame
				loopaddNeg:
				;;charoo trf dkho
				
				
					cmp cx,countSame
					jne nobomb
					cmp cx,3
					jbe nobomb
					mov randArray[di],-47
					jmp bombadded1
				
					nobomb:
						mov randArray[di],-1
						
					bombadded1:
				
				
				
	
					dec di
					mov left,di

					mov ax,0
					mov dx,0
					mov ax,left
					div nine  ;    dont go to above line
					cmp dx,0
					je checkright
					cmp randArray[di],5
					jne nohurdleleft
					
					mov randArray[di],-1
					nohurdleleft:
					checkright:
					inc di 
					inc di
					mov right,di
					mov ax,0
					mov dx,0
					mov ax,right
					div ten  ;dont go to above line
					cmp dx,0
					je checkUp
					cmp randArray[di],5
					jne nohurdleright
					mov randArray[di],-1
					
					nohurdleright:
					
					checkUp:
					dec di
					sub di,10
					cmp di,0
					 jb chkDown
					
					cmp randArray[di],5
					jne nohurdleup
					mov randArray[di],-1
					
					nohurdleup:
					chkDown:
					add di,10
					add di,10
					cmp di,99
					 ja contiNeg
					 
					cmp randArray[di],5
					jne nohurdledown
					mov randArray[di],-1
					nohurdledown:
					contiNeg:
					sub di,10
					
					inc scoreVal
					dec di
					;loop loopaddNeg
					dec cx 
					cmp cx,0
					jne loopaddNeg
											
		startfresh:
		    mov bl,randArray[si]
			mov countSame,1
		
		
		noneed:
		inc si
			cmp si,100
			je startRevloop
			
			cmp si,99
			jbe loopRoWiseCrush
			
	;now col crush
		mov dx,0
	mov cx,0
	mov di,0
	mov ax,0
	mov bx,0
	mov si,0
	mov countSame,1

	mov bl,dupArray[si]
	
			mov countTercol,0
	loopColWiseCrush:
	
		
		
		cmp si,0
		je noneed1
		cmp si,100
		ja startRevloop1
		cmp dupArray[si],5 ;phase2
		je  startRevloop1
			
	cmp dupArray[si],10  ;phase2
		je  startRevloop1
					
			cmp dupArray[si],bl
			jne startRevloop1
			inc countSame
			jmp noneed1
			
		
			
			startRevloop1:
				cmp countSame,3
				jb startfresh1
			
				mov cx,0
				mov di,0
				mov di,si
				sub di,10
			
				
				
				
				mov cx,countSame
				
					addNegcol:
					
					cmp cx,countSame
					jne nobomb1
					cmp cx,3
					jbe nobomb1
					mov randArray[di],-47
					jmp bombadded
				
					nobomb1:
						mov randArray[di],-1
						
					bombadded:
					dec di
					mov left,di

					mov ax,0
					mov dx,0
					mov ax,left
					div nine  ;    dont go to above line
					cmp dx,0
					je checkright1
					cmp randArray[di],5
					jne nohurdleleft1
					
					mov randArray[di],-1
					nohurdleleft1:
					checkright1:
					inc di 
					inc di
					mov right,di
					mov ax,0
					mov dx,0
					mov ax,right
					div ten  ;dont go to above line
					cmp dx,0
					je checkUp1
					cmp randArray[di],5
					jne nohurdleright1
					mov randArray[di],-1
					
					nohurdleright1:
					
					checkUp1:
					dec di
					sub di,10
					cmp di,0
					 jb chkDown1
					
					cmp randArray[di],5
					jne nohurdleup1
					mov randArray[di],-1
					
					nohurdleup1:
					chkDown1:
					add di,10
					add di,10
					cmp di,99
					 ja contiNeg1
					 
					cmp randArray[di],5
					jne nohurdledown1
					mov randArray[di],-1
					nohurdledown1:
					contiNeg1:
					sub di,10
					
					
					;loop loopaddNeg
				
						
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						inc scoreVal
						sub di,10
					dec cx 
					cmp cx,0
					jne addNegcol	
					
					;loop addNegcol
					
					
					
				startfresh1:
					cmp si,100
					jb cnt4
					inc countTercol
					mov si,countTercol
					cnt4:
						mov bl,dupArray[si]
						mov countSame,1
					
					
					
					
					
			
			;je startRevloop
	
		noneed1:
			add si,10
			
			checkout:
			cmp countTercol,10
			jb loopColWiseCrush
	
	
			
			;	
			;mov si,countTercol  ;colum +
		

 ret
crush endp

generateRandomHurdlz PROC
	
	mov dx,0
	mov cx,0
	delay 0h,0ff5h
	mov ah,00h
	int 1Ah
	
	mov ax,dx
	mov dx,0
	mul temp1
	mov dx,0
	mov cx,6
	div cx
	ret
	
generateRandomHurdlz  endp



;Bubble sorting

bubblesort PROC
	mov bx,0
	mov column_indexbubble,0
	mov countBubblesort,0

	loop1:
		mov countBubblesort,0
		loop2:
			mov bx,0
			loop3:
				;row_index *colums+column_index
				mov ax,bx
				mul ten
				add ax,column_indexbubble
				mov di,0
				mov di,ax
				
				cmp randArray[di],-1
					jne continue
				cmp bx,0
					je continue
				mov dx,0
				
				mov dl,randArray[di]
				sub di,10
				mov dh,randArray[di]
				mov randArray[di],dl
				add di,10
				mov randArray[di],dh
				
				continue:
				inc bx
				cmp bx,10
					jne loop3
				jmp bubble
			
			bubble:
			inc countBubblesort
			cmp countBubblesort,10
				jne loop2
	
		
		inc column_indexbubble
		cmp column_indexbubble,10
		jne loop1
	ret
	
bubblesort endp

;Bubble sorting of phase 2

bubblesortPhase2 PROC
	mov bx,0
	mov column_indexbubble,0
	mov countBubblesort,0

	loop12:
		mov countBubblesort,0
		loop22:
			mov bx,0
			loop32:
				;row_index *colums+column_index
				mov ax,bx
				mul ten
				add ax,column_indexbubble
				mov di,0
				mov di,ax
				
				cmp randArray[di],-1
					jne continue2
				cmp bx,0
					je continue2
		
				mov ax,di
				calculatejmp:
					sub ax,10
					mov temp1,ax
					add temp1,10
					cmp temp1,10
						jb continue2
					mov si,ax
					mov cl,hurdleNumber
					cmp randArray[si],cl
						je calculatejmp
				
		
				mov si,ax
				mov dx,0
				
				mov dl,randArray[si]
				mov dh,randArray[di]
				mov randArray[di],dl
				mov randArray[si],dh
				
				continue2:
				inc bx
				cmp bx,10
					jne loop32
				jmp bubble2
			
			bubble2:
			inc countBubblesort
			cmp countBubblesort,10
				jne loop22
	
		
		inc column_indexbubble
		cmp column_indexbubble,10
		jne loop12
	ret
	
bubblesortPhase2 endp


randomInCrushed PROC
	mov si,0
	mov temp1,0
	randomInitiaizer2:
	add temp1,3
	cmp randArray[si],-1
		jne continue2
	delay 0h,0311h
    call generateRandom
	mov randArray[si],dl
	inc si
	mov allClearCheck,1
	cmp si,100
		jb randomInitiaizer2
	ret
	
	continue2:
		inc si
		cmp si,100
			je ret1
		jmp randomInitiaizer2
		
	ret1:
	ret
randomInCrushed endp

nameDisplay PROC
	
	
	mov si,0
	mov ax,0
	mov bx,0
	mov dx,0

	loopName:
		cmp StrName[si],13
		je displayed
	mov ah,02h
	mov dh,rownumCrsName
	mov dl,colnumCrsName
	int 10h
	
	mov ah,09h
	mov al,StrName[si]
	mov bh,0
	mov bl,colurName 
	mov cx,1
	int 10h
	
	inc si  
	inc colurName
	cmp colurName,16
	jne contName
	mov colurName,10
	contName:
	inc colnumCrsName
	
jmp loopName

	
	displayed:
	mov dx,0
	mov dl,svecolnumCrsName 
	mov colnumCrsName,dl
	mov dl,svecolurName
	mov colurName,dl
	ret
nameDisplay endp



Score PROC

;StrScore db "Score : $"
;rownumCrsScore db 1
;colnumCrsScore db 14
;svecolnumCrsScore db 14	
    mov si,0
	mov ax,0
	mov bx,0
	mov dx,0
	loopScore:
		cmp StrScore[si],'$'
		   je displayedScr
		   
			mov ah,02h
			mov dh,rownumCrsName
			mov dl,colnumCrsScore
			int 10h
	
	mov ah,09h
	mov al,StrScore[si]
	mov bh,0
	mov bl,colurName 
	mov cx,1
	int 10h
	
	inc si  
	inc colurName 
	inc colnumCrsScore	  
	jmp loopScore

		
	displayedScr:
	
		inc colnumCrsScore
		mov dx,scoreVal
		mov svescoreVal,dx

			labelpushScore:

				mov ax,0
				mov dx,0
	 
				mov ax,scoreVal
				div ten
				push dx
				inc scorelen ;number
				cmp ax,0
					je labelpopScore
					
				mov scoreVal,ax
				jmp labelpushScore

labelpopScore:
mov colurName ,10
			
	mov dx,0

   	mov ax,0
  dispscr:
  
    pop ax
    mov ah,0
    mov dl,al
    add dl,48
	mov scorenum,dl
	mov dx,0
	
			mov ah,02h
			mov dh,rownumCrsName
			mov dl,colnumCrsScore
			int 10h
	mov ax,0
	
	mov ah,09h
	mov al,scorenum
	mov bh,0
	mov bl,colurName 
	mov cx,1
	int 10h
	
	inc colurName
	inc colnumCrsScore
	
	dec scorelen
	cmp scorelen,0
		jne  dispscr

	
	mov dx,0
	mov dl,svecolnumCrsScore
	mov colnumCrsScore,dl
	mov dl,svecolurName
	mov colurName,dl
	mov dx,svescoreVal
	mov scoreVal,dx

	ret
Score endp

;now displaying moves
	

Moves PROC
	
	 mov si,0
	mov ax,0
	mov bx,0
	mov dx,0
	loopScore:
		cmp strMoves[si],'$'
		   je displayedScr
		   
			mov ah,02h
			mov dh,rownumCrsName
			mov dl,colnumCrsMoves
			int 10h
	
	mov ah,09h
	mov al,strMoves[si]
	mov bh,0
	mov bl,colurName 
	mov cx,1
	int 10h
	
	inc si  
	inc colurName 
	inc colnumCrsMoves	  
	jmp loopScore

		
	displayedScr:
		inc colnumCrsMoves	
		mov dx,MovesVal
		mov sveMovesVal,dx
		mov scorelen,0

			labelpushScore:

				mov ax,0
				mov dx,0
	 
				mov ax,MovesVal
				div ten
				push dx
				inc scorelen ;number
				cmp ax,0
					je labelpopScore
					
				mov MovesVal,ax
				jmp labelpushScore
				
				
				
labelpopScore:
mov colurName ,10
			
	mov dx,0

   	mov ax,0
  dispscr:
  
    pop ax
    mov ah,0
    mov dl,al
    add dl,48
	mov scorenum,dl
	mov dx,0
	
			mov ah,02h
			mov dh,rownumCrsName
			mov dl,colnumCrsMoves
			int 10h
	mov ax,0
	
	mov ah,09h
	mov al,scorenum
	mov bh,0
	mov bl,colurName 
	mov cx,1
	int 10h
	
	inc colurName
	inc colnumCrsMoves

	dec scorelen
	cmp scorelen,0
		jne  dispscr
	;strMoves db "Moves: $"
	;colnumCrsMoves db 24
	;svecolnumCrsMoves db 24
	;MovesVal dw 0
	;sveMovesVal dw 0
	mov dx,0
	mov dl,svecolnumCrsMoves
	mov colnumCrsMoves,dl
	
	mov dl,svecolurName
	mov colurName,dl
	mov dx,sveMovesVal
	mov MovesVal,dx
	
	
ret 
Moves endp


;lets move the rectangle........................
rectangle proc
    pop bx
       mov cx,0
    mov dx,0
    MOV AX,0
    MOV AX,XUP
    MOV XUPEND,AX
    ADD XUPEND,80
    ;horizontal upline
    MOV CX,XUP
    MOV DX,YUP

    loop1:
	      MOV AH,0CH
	      MOV AL,03
	      INT 10H
	      INC CX
		CMP CX,XUPEND
		JNE LOOP1
	    ;LEFT LINE

	    MOV CX,XUP
	    LOOP2:
	       MOV AH,0CH
	       MOV AL,03
	       INT 10H
	       INC DX
	       CMP DX,YDOWN
	       JNE LOOP2
    mov cx,xup
    mov dx,ydown
    LOOP3:
	       MOV AH,0CH
	       MOV AL,03
	       INT 10H
	       INC cx
	       CMP cx,xupend
	       JNE LOOP3
		 MOV AH,0CH
	       MOV AL,03
	       INT 10H
		   


     mov cx,xupend
     mov dx,yup
     loop4:
	    mov ah,0ch
	    mov al,03
	    int 10h
	    inc dx
	    cmp dx,ydown
	    jne loop4

     mov cx,0
	  mov dx,0
    push bx
     ret
    rectangle endp
	

end