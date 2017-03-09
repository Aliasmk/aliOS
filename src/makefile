assemble:
	nasm -o ../bin/bootld.bin ./bootld.asm
	nasm -o ../bin/main.bin ./main.asm

floppy:
	dd if=/dev/zero of=../img/floppy.img ibs=1k count=1440
	dd if=../bin/bootld.bin of=../img/floppy.img conv=notrunc
	dd if=../bin/main.bin of=../img/floppy.img bs=512 seek=1 conv=notrunc

iso: 	
	mkisofs -quiet -V 'ALIOS' -input-charset iso8859-1 -o ../img/alios.iso -b floppy.img ../img/