section .bss
	BUFFLEN equ 10
	Buff resb BUFFLEN
	
section .text

EXTERN ClearLine, DumpChar, PrintLine

GLOBAL _start

_start:
	xor esi, esi ; esi will be used to record the total number of bytes processed
	
Read:
	; Get input from stdin
	mov eax, 3 ; sys_read
	mov ebx, 0 ; stdin
	mov ecx, Buff
	mov edx, BUFFLEN
	int 0x80
	mov ebp, eax
	cmp ebp, 0
	je Done
	xor ecx, ecx

Scan:
	; ecx is the counter of the current chunk
	; it is used to loop through the entire buffer
	; esi is used to control which bytes to write to in DumpLin and ASCLin
	xor eax, eax
	mov al, byte[Buff+ecx]
	mov edx, esi
	and edx, 0xF
	call DumpChar

	; increases the counter
	inc esi
	inc ecx
	cmp ecx, ebp
	jae Read

	; esi is a multiple of 16 if its last 4 bits are 0 (16 = 0b1000, 0xF = 0b1111)
	test esi, 0xF
	jnz Scan ; not a multiple of 16
	call PrintLine
	call ClearLine
	jmp Scan

Done:
	call PrintLine
	mov eax, 1
	mov ebx, 0
	int 0x80
