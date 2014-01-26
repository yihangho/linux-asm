section .data
section .bss
section .text

global _start

_start:
	nop
	
	mov eax,1000000

	Loop:
		dec eax
		jnz Loop

	mov eax, 1
	mov ebx, 0
	int 0x80
