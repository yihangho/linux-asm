section .bss
	Buff resb 1

section .text
global _start
_start:
	
Read:
	; sys_read
	mov eax, 3
	mov ebx, 0
	mov ecx, Buff
	mov edx, 1
	int 0x80

	; exit if EOF is found
	cmp eax, 0
	je Exit

	; proceed to write if less than 'a'
	cmp byte[Buff], 0x61
	jb Write

	; proceed to write if greater than 'z'
	cmp byte[Buff], 0x7A
	ja Write

	; At this point, that character is lowercase
	sub byte[Buff], 32

Write:
	mov eax, 4
	mov ebx, 2
	mov ecx, Buff
	mov edx, 1
	int 0x80

	; Read another character
	jmp Read

Exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
