section .data

	SCRWIDTH:  equ 80
	PosTerm:   db 27,"[01;01H"
	POSLEN:    equ $-PosTerm
	ClearTerm: db 27,"[2J"
	CLEARLEN:  equ $-ClearTerm
	AdMsg:     db "Eat At Joe's!"
	ADLEN:     equ $-AdMsg
	Prompt:    db "Press Enter: "
	PROMPTLEN: equ $-Prompt

	Digits: db "00010203040506070809"
	        db "10111213141516171819"
			db "20212223242526272829"
			db "30313233343536373839"
			db "40414243444546474849"
			db "50515253545556575859"
			db "60616263646566676869"
			db "7071727374757677787980"

section .text

%macro ExitProg 0
	mov eax, 1
	mov ebx, 0
	int 0x80
%endmacro

%macro WaitEnter 0
	mov eax, 3
	mov ebx, 0
	mov edx, 1
	int 0x80
%endmacro

%macro ClrScr 0
	push eax
	push ebx
	push ecx
	push edx
	WriteStr ClearTerm, CLEARLEN
	pop edx
	pop ecx
	pop ebx
	pop eax
%endmacro

%macro GotoXY 2
	pushad
	xor ebx, ebx
	xor ecx, ecx

	mov bl, %2
	mov cx, word[Digits+ebx*2]
	mov word[PosTerm+2], cx

	mov bl, %1
	mov cx, word[Digits+ebx*2]
	mov word[PosTerm+5], cx

	WriteStr PosTerm, POSLEN

	popad
%endmacro

%macro WriteCtr 3
	push ebx
	push edx
	
	mov edx, %3
	xor ebx, ebx
	mov bl, SCRWIDTH
	sub bl, dl
	shr ebx, 1

	GotoXY bl, %1
	
	WriteStr %2, %3

	pop edx
	pop ebx
%endmacro

%macro WriteStr 2
	push eax
	push ebx

	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 0x80

	pop ebx
	pop eax
%endmacro

global _start
_start:
	nop

	ClrScr
	
	WriteCtr 12, AdMsg, ADLEN

	GotoXY 1, 23
	
	WaitEnter

	ExitProg
