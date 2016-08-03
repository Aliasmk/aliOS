assemble:
	nasm -o ../bin/bootld.bin ./bootld.asm

floppy:
	dd if=/dev/zero of=../img/floppy.img ibs=1k count=1440
	dd if=../bin/bootld.bin of=../img/floppy.img conv=notrunc