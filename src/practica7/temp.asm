atoi:
	push ecx
	push eax
	push ebx
	push esi
	push edx

	mov esi, edx
	mov dword[numero], 0
	mov dword[signo], 1
	xor ecx, ecx

	.largoArreglo:
	cmp byte[esi+ecx], 0
	je .convertir
	inc ecx
	jmp .largoArreglo

	.convertir:
	cmp byte[esi], 0
	je .fin
	mov eax, 1
	cmp byte[esi], '-'
	jne .multiplicar
	mov dword[signo], -1
	dec ecx
	inc esi

	.multiplicar
	dec ecx
	cmp ecx, 0
	je .guardarMult
	mov ebx, 10
	mul ebx
	
	jmp .multiplicar

	.guardarMult
	mov [mult], eax

	.ciclo:
	cmp byte[esi], 0
	je .fin
	cmp byte[esi], '0'
	jl .fin
	cmp byte[esi], '9'
	jg .fin
	movzx ebx, byte[esi]
	sub ebx, '0'
	mov eax, [mult]
	mul ebx
	add dword[numero], eax
	mov eax, [mult]
	xor edx, edx
	mov ebx, 10
	div ebx
	mov [mult], eax
	inc esi
	jmp .ciclo


	.fin:
	mov eax, [numero]
	imul eax, dword[signo]
	mov [numero], eax
	pop edx
	pop esi
	pop ebx
	pop eax
	pop ecx
	ret
