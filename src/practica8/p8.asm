%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa


    ImpArreglo:
        push ecx
        push esi
        mov ecx, 0
        mov esi, 0
        mov cl, dl 
        .cicloCapArr:
        mov , dword[eax+esi]

        call itoa
        inc esi
        loop .cicloCapArr
        pop esi
        pop ecx

section	.data
    ncad 
