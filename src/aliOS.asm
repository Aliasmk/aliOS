;Initially coded with MikeOS tutorial - planning to rewrite and continue building up
	BITS 16

start:
	mov ax, 07C0h	;Setting up a 4K stack space after bootloader
	add ax, 288	;
	mov ss, ax
	mov sp,4096

	mov ax, 07C0h
	mov ds, ax

	mov si, text_string	;String position in memory goes into SI
	call print_string	;Call the string method

	jmp $ 			;Once the string has been printed, jump infinite


;PRINT STRING METHOD
text_string:
	db 'aliOS -- Hello, World',0
print_string:
	mov ah, 0Eh     ;BIOS procedure - Calling int 10h with 0Eh in AH means output to screen

.nextletter:
	;call delay
	lodsb			;Load a byte from the string at SI, increment SI Address
	cmp al,0		;If zero, it's the end of the string
	je .done		;Jump if equal to zero to .done
	int 10h			;BIOS interrupt
	jmp .nextletter	;Jump back to the top of label

.done:
	ret			;Returns from call location.

delay:
	;Yeah this kind of delay isnt going to work on a 2.5 GHz processor - use RTC instead?
	push ax
	mov ax,0
.delay_repeat:
	cmp ax,50000
	inc ax
	jne .delay_repeat
	pop ax
	ret


;End of Code
	times 510-($-$$) db 0	;Pads remainder of boot sector with 0s
	dw 0xAA55		;Standard PC boot signature


