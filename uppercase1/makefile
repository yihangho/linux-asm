uppercase1: uppercase1.o
	ld -o uppercase1 uppercase1.o
uppercase1.o: uppercase1.asm
	nasm -f elf -g -F stabs uppercase1.asm
