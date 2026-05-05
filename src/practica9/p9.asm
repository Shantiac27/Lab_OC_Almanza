%include "../../lib/pc_io.inc" ;incluir declaraciones del procedimiento

%macro FOR 4
    push ecx
    push edx
    mov ecx, %1
    mov edx, %2
    .%4:
        call %3
    loop .%4
    pop edx
    pop ecx
%endmacro

section .text
    global _start
    global _imprimir

_start:

    push msg1 ;segundo parametro
    push msg2 ;primer parametro
    call _imprimir
    add esp, 8 ;limpia parametros de la funcion de la pila

    push msg2  ;segundo parametro
    push msg1  ;primer parametro
    call _imprimir
    call esp, 8 ;limpia parametros de la funcion de la pila

    FOR 3, msg1, puts, l1
    FOR 2, msg2, puts, l2

    mov eax, 1 ;seleccionar llamada al sistema para fin de programa
    int 0x80 ;llamada al sistema - fin de programa

    _imprimir:
        push ebp
        mov ebp, esp
        sub esp, 4 ;reservar 4 bytes en la pila para la variable local [ebp-4]

        mov dword[ebp-4], msg3 ;variable local

        mov edx, [ebp-4] ;variable local
        call puts

        mov edx, [ebp+8] ;primer parametro
        call puts
        mov edx, [ebp+12] ;segundo parametro
        call puts

        mov esp, ebp  ;restaurar el puntero de la pila (libera el espacio para [ebp-4])
        pop ebp
        ret

section .data
    msg1 db 'Hola mundo',0xa,0
    msg2 db 'OC',0xa,0
    msg3 db 'Practica 9',0xa,0
    x db 1
    y db 2
