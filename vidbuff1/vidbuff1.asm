section .data
	EOL     equ 10
	FILLCHR equ 32
	HBARCHR equ 45
	STRTROW equ 2

	Dataset db 9, 71, 17, 52, 55, 18,29, 36, 18, 68, 77, 63, 58, 44, 0

	Message db "data current as of 5/13/2009"
	MSGLEN  equ $-Message

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

PtEOL: ; TODO: Why not use stosb?
	add edi, COLS
	mov byte[edi], EOL
	loop PtEOL

	pop edi
	pop ecx
	pop eax

	ret

WrtLn:
	push eax
	push ebx
	push ecx
	push edi

	cld

	mov edi, VidBuff

	dec eax
	dec ebx

	; ?? Isn't it bl*COLS?
	mov ah, COLS
	mul ah

	add edi, eax
	add edi, ebx

	rep movsb

	pop edi
	pop ecx
	pop ebx
	pop eax

	ret

WrtHB:
	push eax
	push ebx
	push ecx
	push edi

	cld

	mov edi, VidBuff
	dec eax
	dec ebx
	
	mov ah, COLS
	mul ah

	add edi, eax
	add edi, ebx

	mov al, HBARCHR

	rep stosb

	pop edi
	pop ecx
	pop ebx
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
	mov ecx, COLS-1
	call Ruler

	mov esi, Dataset
	mov ebx, 1
	mov ebp, 0
.blast:
	mov eax, ebp
	add eax, STRTROW
	mov cl, byte[esi+ebp]
	cmp ecx, 0
	je .rule2
	call WrtHB
	inc ebp
	jmp .blast

.rule2:
	mov eax, ebp
	add eax, STRTROW
	mov ebx, 1
	mov ecx, COLS-1
	call Ruler

	mov esi, Message
	mov ecx, MSGLEN
	mov ebx, COLS
	sub ebx, ecx
	shr ebx, 1
	mov eax, 24
	call WrtLn

	call Show

Exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
