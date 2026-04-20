%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:             

    mov edx, ncad
	call puts

	mov bx, word[len]
	mov edx, cad
	call capturar

    call getch
	add al, '0'
	call putchar
	mov edx. ncad
	call puts

	int	0x80        	; llamada al sistema - fin de programa

capturar:
    push ecx
    push edx
    push ebx
	mov cx,bx
	dec cx
	mov bx, 0

.ciclo:
    
	cmp cx, 1
	je .salir

    call getch
	cmp al, 0x7f
	jne .guardar
	cmp bx, 0
	je .ciclo
	call borrar
	dec bx
	jmp .ciclo

.guardar:
    cmp al, 10
	je .salir
	mov byte [edx + ebx], al
	call putchar
	inc bx
	loop .ciclo

.salir:
    mov byte[edx + ebx],0
	pop ebx
	pop edx
    pop ecx
	ret

borrar:
    push ax 

	mov al, 0x8
	call putchar 

	mov al, ' '
	call putchar

	mov al, 0x8
	call putchar

	pop ax
	ret

Mayusculas:
    push ebx
	push edx 
	mov ebx , -1

	.sig:
	    inc ebx 
		mov al, [edx + ebx]
		cmp al, 0
		je .salir 
		cmp al, 'a'
		jnb .cmpz
		jmp .sig

	.cmpz:
	    cmp al, 'z'
		jnb .sig

		sub al, 32
		mov byte [edx + ebx], al
		jmp .sig

	.

section	.data
    ncad db 0xa, 'Cadena :',0
	nlin db 0xa
	len db 64
	cad times 64 db 0


