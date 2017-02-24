	BITS 16
	;FAT12 Header Begins
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

	s_version db 'aliOS v0.0.1',0
	s_newline db 0Ah,0Dh,0
	s_prompt db '$ ',0

	ptr_keybuffer db 0
	times 32 db 0
	
	;string compare addresses
	testString db 'ayy',0
	lmaoString db 'lmao',0
	firstAddress dw 1234h
	secondAddress dw 1234h
	sameWord db 0

start:
	mov ax, 07C0h	;Setting up a 4K stack space after bootloader
	add ax, 288
	mov ss, ax
	mov sp,4096

	mov ax, 07C0h
	mov ds, ax

	mov si, s_version	;String position in memory goes into SI
	call print_string	;Call the string method
	
	mov si, s_newline	
	call print_string	
	mov si, s_prompt
	call print_string

.key:
	call wait_key
	;iterate through keybuffer until finding a zero
	mov bx,ptr_keybuffer
.find:
	cmp byte [bx],0		
	je .found		
	inc bx
	jmp .find	
.found	
	;replace the zero with the character, add a zero after
	mov byte [bx], al 
	inc bx
	mov byte [bx], 0
	
	mov ah, 0Eh
	int 10h	
	
	;Check for Enter Key
	cmp al,0Dh
	jne .key			
	mov si, s_newline	
	call print_string	
	
	call echo_input  
	mov [ptr_keybuffer],byte 0 ;reset keybuffer
	
	mov si, s_newline	
	call print_string
	mov si, s_prompt
	call print_string

	jmp .key




;PRINT STRING METHOD
print_string:
	mov ah, 0Eh     ;BIOS procedure - Calling int 10h with 0Eh in AH means output to screen

.nextletter:
	lodsb			;Load a byte from the string at SI, increment SI Address
	cmp al,0		;If zero, it's the end of the string
	je .done		;Jump if equal to zero to .done
	int 10h			;BIOS interrupt
	jmp .nextletter	;Jump back to the top of label

.done:
	ret			;Returns from call location.





;WAIT FOR KEYBOARD METHOD
wait_key:
	mov ah, 0
	int 16h
	ret

;ECHO INPUT METHOD - TEMP
echo_input:
	mov word [firstAddress],ptr_keybuffer
	mov word [secondAddress],testString
	call str_compare
	cmp byte [sameWord],1
	je .lmao
	mov byte [sameWord],0
	mov si, ptr_keybuffer
	call print_string
	ret
	
.lmao
	mov si, lmaoString
	call print_string
	ret

;COMPARES STRINGS STORED IN ADDRESSES POINTED TO BY THE TOP TWO ADDRESSES IN STACK, stores result in AL


str_compare:

.comparenext
	;Loop through each character and compare them. Break if a character is not equal
	mov bx,[firstAddress]
	mov dl,[bx]
	cmp dl,0
	je .charend
	
	mov bx,[secondAddress]
	mov dh,[bx]
	cmp dh,0
	je .charend
	
	cmp dl,dh
	jne .differ ;End if one of the chars is different than the other
	inc byte [firstAddress]
	inc byte [secondAddress]
	jmp .comparenext ;Loop back if they are equal

.charend
	;End positive if both characters are null as well
	mov ax,dx
	jnz .differ
	;Strings are the same, return 1
	mov byte [sameWord],1
	ret
		
.differ
	;Strings are different, return 0
	;mov si, s_prompt
	;call print_string
	mov byte [sameWord],0
	ret


;End of Code
	times 510-($-$$) db 0	;Pads remainder of boot sector with 0s
	dw 0xAA55		;Standard PC boot signature


