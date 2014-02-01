section .data
	StatMsg: db "Processing...",10
	StatLen equ $-StatMsg
	DoneMsg: db "...done!", 10
	DoneLen equ $-DoneMsg

	UpCase:
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x09, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F
	db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x28, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
	db 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F
	db 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F
	db 0x60, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F
	db 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x7B, 0x7C, 0x7D, 0x7E, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20

section .bss
	READLEN equ 1024
	ReadBuff: resb READLEN

section .text
global _start
_start:
	
	; Print the "Processing..." message to stderr
	mov eax, 4 ; sys_write
	mov ebx, 2 ; stderr
	mov ecx, StatMsg
	mov edx, StatLen
	int 0x80

Read:
	; read from stdin using sys_read
	mov eax, 3 ; sys_write
	mov ebx, 0 ; stdin
	mov ecx, ReadBuff
	mov edx, READLEN
	int 0x80

	; quit if EOF is found
	cmp eax, 0
	je Done

	xor ecx, ecx ; ecx will act as the loop counter, zero out ecx now
	mov ebx, UpCase ; xlat requires the translation table to be in ebx
	mov edx, eax ; store the number of bytes read in edx

Scan:
	; translate using translation table (UpCase)
	mov al, byte[ReadBuff+ecx] ; xlat requires the character to be translated be stored in al
	xlat
	mov byte[ReadBuff+ecx], al ; write the result back to memory

	; Continue if there are more bytes to translate
	inc ecx
	cmp ecx, edx
	jne Scan

Write:
	; write result to stdout using sys_write
	mov eax, 4 ; sys_write
	mov ebx, 1 ; stdout
	mov ecx, ReadBuff
	int 0x80 ; number of bytes to print already in edx
	jmp Read

Done:
	; write the done message to stderr using sys_write
	mov eax, 4 ; sys_write
	mov ebx, 2 ; stderr
	mov ecx, DoneMsg
	mov edx, DoneLen
	int 0x80

	; exit via sys_exit with status code 0
	mov eax, 1 ; sys_exit
	mov ebx, 0 ; status code
	int 0x80