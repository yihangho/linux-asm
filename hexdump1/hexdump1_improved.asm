section .bss
	BUFFLEN equ 16
	Buff: resb BUFFLEN

section .data
	HexStr: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 10
	HEXLEN equ $-HexStr

	Digits: db "0123456789ABCDEF"

section .text
global _start
_start:

Read:
	; Read from stdin, 16 bytes a time
	mov eax, 3 ; sys_read
	mov ebx, 0 ; stdin
	mov ecx, Buff
	mov edx, BUFFLEN
	int 0x80

	; Exit if EOF is read
	cmp eax, 0
	je Done

	; Store number of bytes read in ebp
	mov ebp, eax
	; and other addresses
	mov esi, Buff
	mov edi, HexStr
	; Set ecx to 0; it will be used as loop counter later
	xor ecx, ecx

Scan:
	; Set eax to 0, eax will be used to store the lower nybble
	; Note: it is unnecessary to set ebx (which will be used to store upper nybble) to 0 as we will be copying from eax to ebx later on (mov ebx, eax)
	xor eax, eax

	; edx will be used as the index to the HexStr, which is ecx * 3
	; Note: 3x = (2 * x) + x = (Left shift x) + x
	mov edx, ecx
	shl edx, 1   ; 2x
	add edx, ecx ; 2x + x

	; Copy to al and bl
	mov al, byte[Buff+ecx]
	mov ebx, eax

	; Zero out all but the last 4 bits (0xF = 0b00001111)
	and al, 0xF
	mov al, byte[Digits+eax]
	mov byte[HexStr+edx+2], al

	shr bl, 4 ; Move the upper nybble to the position of lower nybble
	mov bl, byte[Digits+ebx]
	mov byte[HexStr+edx+1], bl

	; Increase the loop counter and check if we should continue
	inc ecx
	cmp ecx, ebp
	jb Scan

	; Add \n at right after the last block
	mov byte[HexStr+edx+3], 0xA

	; Write to stdout
	mov eax, 4 ; sys_write
	mov ebx, 1 ; stdout
	mov ecx, HexStr
	add edx, 4
	int 0x80
	jmp Read

Done:
	mov eax, 1
	mov ebx, 0
	int 0x80
