assemble:
	nasm -o ../bin/aliOS.bin ./aliOS.asm

floppy:
	dd if=/dev/zero of=../bin/floppy.img ibs=1k count=1440
	dd if=../bin/aliOS.bin of=../bin/floppy.img conv=notrunc