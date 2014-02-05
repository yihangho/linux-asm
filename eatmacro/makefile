eatmacro: eatmacro.o
	ld -o eatmacro eatmacro.o
eatmacro.o: eatmacro.asm
	nasm -f elf -g -F stabs eatmacro.asm
