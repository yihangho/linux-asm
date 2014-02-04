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

ClrScr:
	push eax
	push ebx
	push ecx
	push edx
	mov ecx, ClearTerm
	mov edx, CLEARLEN
	call WriteStr
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

GotoXY:
	pushad
	xor ebx, ebx
	xor ecx, ecx

	mov bl, al
	mov cx, word[Digits+ebx*2]
	mov word[PosTerm+2], cx

	mov bl, ah
	mov cx, word[Digits+ebx*2]
	mov word[PosTerm+5], cx

	mov ecx, PosTerm
	mov edx, POSLEN
	call WriteStr

	popad
	ret

WriteCtr:
	push ebx
	
	xor ebx, ebx
	mov bl, SCRWIDTH
	sub bl, dl
	shr ebx, 1
	mov ah, bl
	call GotoXY
	
	call WriteStr

	pop ebx
	ret

WriteStr:
	push eax
	push ebx

	mov eax, 4
	mov ebx, 1
	int 0x80

	pop ebx
	pop eax
	ret

global _start
_start:

	call ClrScr
	
	mov al, 12
	mov ecx, AdMsg
	mov edx, ADLEN
	call WriteCtr

	mov ax, 0x0117 ; al = 0x17, ah = 0x01
	call GotoXY

	mov ecx, Prompt
	mov edx, PROMPTLEN
	call WriteStr

	mov eax, 3
	mov ebx, 0
	int 0x80

Exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
