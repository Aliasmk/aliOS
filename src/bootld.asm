	BITS 16
	;FAT12 Header Begins
	ORG 0x7c00
	jmp start
	nop
	oem_name db 'aliOS0.1'
	byte_per_sector dw 512
	sector_per_cluster db 1
	reserved_sectors dw 1
	fat_copies db 2
	root_dir_entry dw 224
	total_sectors dw 2880
	media_type db 0F0h
	sectors_per_fat dw 9
	sectors_per_trk dw 12
	num_heads dw 2
	hidden_sect dw 0
	;FAT12 Header Ends
	
	
start:
	mov ax,0
	mov ds,ax
	mov ax,07c00h
	mov ss,ax
	
;Reset the Floppy Drive
reset_drive:
	mov ax,0 
	int 13h
	jc reset_drive
	
	;jumping to 0x7e0:0x0000 = 0x7e00
	mov ax, 0x07e0
	mov es, ax
	mov ax, 0
	mov bx,ax
	
;Load the Main Code from the Drive
load_from_drive:
	mov ah, 02h	;Read from Drive
	mov al, 01h	;Sectors to Read
	mov ch, 00h	;Cylinder
	mov cl, 02h ;Sector (Starts at 1)
	mov dh, 00h ;Head
	mov dl, 00h ;Drive
	int 13h		;Disk I/O interrupt
	jc load_from_drive

	jmp 0x7e0:0x0000	;Jump to main code in loaded Segment
	nop

;End of Code
	times 510-($-$$) db 0	;Pads remainder of boot sector with 0s
	dw 0xAA55		;Standard PC boot signature


