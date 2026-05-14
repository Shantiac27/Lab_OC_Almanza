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
	mov al, [nlin]
	call putchar

	call atoi
	mov esi, cad
	call itoa

	mov edx, cad
	call puts

	mov al, [nlin]
	call putchar

	mov eax, 1          ; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

capturar:
    push edx
	push cx
	mov cx, bx
	dec cx
	push bx 
	mov bl, 0

.ciclo:
    call getch
	cmp al, 0x7f
	jne .guardar
	call borrar
	jmp .ciclo

	.guardar:
	call putchar
	mov [edx], al
	cmp al, 0xa
	je .salir
	inc edx
	inc bl
	loop .ciclo
.salir:
	mov byte[edx],0
	pop bx
	pop cx
	pop edx
	ret

borrar:
    push ax 
	cmp bl, 0
	je .regresar
	mov al, 0x8
	call putchar 
	mov al, ' '
	call putchar
	mov al, 0x8
	call putchar
	dec edx
	dec bl
	inc cx
	.regresar:
	pop ax
	ret

atoi:
	push ecx
	push ebx
	push esi
	push edx

	mov esi, edx
	mov eax, 0
	push eax ;guardar "variable" numero en la pila
	mov ebx, 1 ;registro para el signo
	xor ecx, ecx

	.largoArreglo:
	cmp byte[esi+ecx], 0
	je .convertir
	cmp byte[esi+ecx],'.'
	je .convertir
	inc ecx
	jmp .largoArreglo

	.convertir:
	cmp byte[esi], 0
	je .fin
	cmp byte[esi], '-'
	jne .multiplicar
	mov ebx, -1
	dec ecx
	inc esi

	.multiplicar:
	push ebx ;guardar el signo en la pila
	mov eax, 1

	.mult:
	dec ecx
	cmp ecx, 0
	je .guardarMult
	mov ebx, 10
	mul ebx
	
	jmp .mult

	.guardarMult:
	push eax

	;pasar la variable numero hasta la cima de la pila
	pop ecx ;variable mult
	pop ebx ; variable signo
	pop eax ; variable numero

	push ebx ; pasar signo a la pila
	push eax ; pasar numero a la pila
	push ecx ; pasar mult a la pila ->ahora es la cima

	.ciclo:
	cmp byte[esi], 0
	je .fin
	cmp byte[esi], '0'
	jl .fin
	cmp byte[esi], '9'
	jg .fin

	movzx ebx, byte[esi]
	sub ebx, '0'

	pop ecx ; pasar mult a  ecx

	mov eax, ecx ; pasar mult a eax
	mul ebx ; multiplicar mult con el digito
	
	pop ebx ; pasar numero a ebx
	add ebx, eax ; sumar el resultado a numero
	push ebx ; pasar numero a la pila

	mov eax, ecx ; pasar otra vez mult a eax
	xor edx, edx ; limpiar edx
	mov ebx, 10  
	div ebx ; dividir mult entre 10
	push eax ; pasar mult a la pila

	inc esi ; incrementar la direccion de la cadena
	jmp .ciclo


	.fin:
	pop ebx ; sacar mult de la pila
	pop eax ; sacar numero de la pila
	pop ecx ; sacar signo de la pila

	imul eax, ecx ; multiplicar el numero por el signo

	pop edx
	pop esi
	pop ebx
	pop ecx
	ret

itoa:
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov ebx, 10
	xor ecx, ecx

	cmp eax, 0
	jge .positivo ;saltar si el numero es positivo
	mov byte[esi], '-'
	inc esi
	imul eax, -1 ; volver el numero a positivo

	.positivo:
	push eax
	cmp eax, 0
	jne .contar
	mov byte[esi], '0'
	inc esi
	jmp .fin

	.contar:
	xor edx, edx
	cmp eax, 10
	jl .siguiente1 ; saltar si el conciente es menor a 10
	div ebx ; eax/10
	inc ecx
	jmp .contar

	.siguiente1:
	mov eax, 1
	.mult:
	cmp ecx, 0
	je .siguiente2
	mul ebx ; mul*10
	dec ecx
	jmp .mult

	.siguiente2:
	mov ebx, eax ; guardar el mult en ebx
	pop eax 
	
	.ciclo:
	xor edx, edx
	div ebx ; eax/mult
	add al, '0'
	mov [esi], al
	inc esi
	cmp ebx, 1
	je .fin

	mov edi, edx

	mov eax, ebx
	xor edx, edx
	mov ecx, 10
	div ecx
	mov ebx, eax
	mov eax, edi
	
	jmp .ciclo

	.fin:
	mov byte[esi], 0
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
	

section	.data
    ncad db 0xa, 'Cadena :',0
	nlin db 0xa
	len db 64
	cad times 64 db 0



