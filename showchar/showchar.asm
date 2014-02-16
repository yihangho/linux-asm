section .data
	EOL     equ 10
	FILLCHR equ 32
	CHRTROW equ 2
	CHRTLEN equ 32

	ClrHome db 27, "[2J", 27, "[01;01H"
	CLRLEN  equ $-ClrHome

section .bss
	COLS    equ  81
	ROWS    equ  25
	VidBuff resb COLS*ROWS

section .text
global _start

%macro ClearTerminal 0
	pushad
	mov eax, 4
	mov ebx, 1
	mov ecx, ClrHome
	mov edx, CLRLEN
	int 0x80
	popad
%endmacro

Show:
	pushad
	mov eax, 4
	mov ebx, 1
	mov ecx, VidBuff
	mov edx, COLS*ROWS
	int 0x80
	popad
	ret

ClrVid:
	push eax
	push ecx
	push edi
	
	cld

	mov al, FILLCHR
	mov edi, VidBuff
	mov ecx, COLS*ROWS
	rep stosb

	mov edi, VidBuff
	dec edi
	mov ecx, ROWS

PtEOL:
	mov al, EOL
	add edi, COLS-1
	stosb
	loop PtEOL

	pop edi
	pop ecx
	pop eax

	ret

Ruler:
	push eax
	push ebx
	push ecx
	push edi

	mov edi, VidBuff
	dec eax
	dec ebx
	
	mov ah, COLS
	mul ah

	add edi, eax
	add edi, ebx

	mov al, '1'

DoChar:
	stosb
	add al, '1'
	aaa
	add al, '0'
	loop DoChar

	pop edi
	pop ecx
	pop ebx
	pop eax

	ret

_start:

	ClearTerminal
	call ClrVid

	mov eax, 1
	mov ebx, 1
	mov ecx, 32
	call Ruler
	
	mov edi, VidBuff
	add edi, COLS*CHRTROW
	mov ecx, 224
	mov al, 32
.DoLn:
	mov bl, CHRTLEN
.DoChr:
	stosb
	jcxz AllDone
	inc al
	dec bl
	loopnz .DoChr
	add edi, COLS-CHRTLEN
	jmp .DoLn

AllDone:
	call Show

Exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
