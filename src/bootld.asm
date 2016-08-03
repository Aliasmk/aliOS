	BITS 16
	s_version db 'aliOS v0.0.1',0
	s_newline db 0Ah,0Dh,0
	s_prompt db '$ ',0

	ptr_keybuffer db 0
	times 8 db 0

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

;EVALUATE INPUT METHOD - TEMP
echo_input:
	;mov si, s_tempText
	;call print_string
	
	mov si, ptr_keybuffer
	call print_string
	ret

;End of Code
	times 510-($-$$) db 0	;Pads remainder of boot sector with 0s
	dw 0xAA55		;Standard PC boot signature


