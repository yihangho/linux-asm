section .bss
	BUFFLEN equ 1024
	Buff: resb BUFFLEN

section .text
global _start
_start:

Read:
	mov eax, 3
	mov ebx, 0
	mov ecx, Buff
	mov edx, BUFFLEN
	int 0x80

	mov esi, eax
	cmp eax, 0
	je Exit

	mov ecx, esi
	mov ebp, Buff
	dec ebp

Scan:
	cmp byte[ebp+ecx], 0x61
	jb Next

	cmp byte[ebp+ecx], 0x7A
	ja Next

	sub byte[ebp+ecx], 32

Next:
	dec ecx
	jnz Scan

Write:
	mov eax, 4
	mov ebx, 1
	mov ecx, Buff
	mov edx, BUFFLEN
	int 0x80
	jmp Read

Exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
	
