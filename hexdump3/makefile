hexdump3: hexdump3.o textlib.o
	ld -o hexdump3 hexdump3.o textlib.o
hexdump3.o: hexdump3.asm
	nasm -f elf -g -F stabs hexdump3.asm
textlib.o: textlib.asm
	nasm -f elf -g -F stabs textlib.asm
