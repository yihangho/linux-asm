section .data
Snippet db "KANGAROO"

section .text
global _start
_start:
	nop

	mov ebx, Snippet
	mov eax, 8
DoMore:
	add byte [ebx], 32
	inc ebx
	dec eax
	jnz DoMore

	mov eax, 4
	mov ebx, 1
	mov ecx, Snippet
	mov edx, 8
	int 0x80
	
	mov eax, 1
	mov ebx, 0
	int 0x80
