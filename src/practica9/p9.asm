%include "../../lib/pc_io.inc" ;incluir declaraciones del procedimiento

section .text
    global _start
    global _imprimir

_start:

    push msg1 ;segundo parametro
    push msg2 ;primer parametro
    call _imprimir
    add esp, 8 ;limpia parametros de la funcion de la pila
