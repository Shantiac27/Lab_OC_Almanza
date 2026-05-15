%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   

    mov eax, 24
    mov esi, cad
    call itoa
    mov edx, cad
    call puts

    mov edx, ncad
    call puts
    mov eax, arr 
    mov edx, 0
    mov dl, byte[len]
    call ImpArreglo
    mov al, 10
    call putchar

	call ordenar

	mov edx, ncad
    call puts
    mov eax, arr 
    mov edx, 0
    mov dl, byte[len]
    call ImpArreglo
    mov al, 10
    call putchar

    mov eax, 1
    int 0x80

ImpArreglo:
    push ecx
    push esi
    mov ecx, 0
    mov esi, 0
    mov cl, dl 

    .cicloImpArr:
    push eax
    push edx
    push esi

    ;parametro de itoa
    mov edx, eax
    mov eax, dword[edx+esi*4]
    mov esi, cad
    call itoa

    mov edx, cad
    call puts
    mov al, ' '
    call putchar

    pop esi
    inc esi
    pop edx
    pop eax
    loop .cicloImpArr

    pop esi
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

ordenar:
	push eax
	push ebx
	push edx
	push ecx
	push esi
	push edi

	mov esi, 0 ; valor de i

	.ciclo1:
	movzx eax,byte[len]
	dec eax
	cmp esi, eax
	jge .fin

	mov edi, esi ; valor de minimo

	mov ebx, esi
	inc ebx ; valor de j = i + 1


	.ciclo2:
	movzx eax, byte[len]
	cmp ebx, eax
	jge .intercambio
	mov eax, [arr+ebx*4] 
	mov edx, [arr+edi*4]
	cmp eax, edx
	jge .continuar
	mov edi, ebx

	.continuar:
	inc ebx
	jmp .ciclo2

	.intercambio:
	cmp edi, esi
	je .siguiente

	mov eax, [arr+esi*4]
	mov edx, [arr+edi*4]

	mov [arr+esi*4], edx
	mov [arr+edi*4], eax

	.siguiente:
	inc esi
	jmp .ciclo1
	
	.fin:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

section	.data
    ncad db 0xa,'Arreglo: ',0
    nlin db 0xa
    lencad db 64
    cad	times 64 db 0
    len db 5
    arr	dd 24,4,3,2,52
