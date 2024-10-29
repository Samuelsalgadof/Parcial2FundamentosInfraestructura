section .data
    msg1 db 0xA, "Ingrese el primer numero: ", 0
    lmsg1 equ $ - msg1
    msg2 db "Ingrese el segundo numero: ", 0
    lmsg2 equ $ - msg2
    msg3 db "Seleccione la operacion (+, -, *, /, s para salir): ", 0
    lmsg3 equ $ - msg3
    msg4 db "Resultado: ", 0
    lmsg4 equ $ - msg4
    msg_error db "Error: No se puede dividir por cero", 10, 0
    lmsg_error equ $ - msg_error
    msg_entrada db "Error: Caracter no valido", 10, 0
    lmsg_entrada equ $ - msg_entrada

section .bss
    num1 resb 6
    num2 resb 6
    num1_decimal resd 1
    num2_decimal resd 1
    op resb 1
    resultado resb 12

section .text
    global _start

_start:
operacion_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 6
    int 80h
    call ascii_a_decimal_num1

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 6
    int 80h
    call ascii_a_decimal_num2

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 80h

    mov al, [op]
    cmp al, 's'
    je salir
    cmp al, '+'
    je sumar
    cmp al, '-'
    je restar
    cmp al, '*'
    je multiplicar
    cmp al, '/'
    je dividir
    jmp mensaje_operacion

sumar:
    mov eax, [num1_decimal]
    add eax, [num2_decimal]
    call decimal_a_ascii
    jmp mostrar_resultado

restar:
    mov eax, [num1_decimal]
    sub eax, [num2_decimal]
    call decimal_a_ascii
    jmp mostrar_resultado

multiplicar:
    mov eax, [num1_decimal]
    mov ebx, [num2_decimal]
    imul eax, ebx
    call decimal_a_ascii
    jmp mostrar_resultado

dividir:
    mov eax, [num1_decimal] 
    mov ebx, [num2_decimal] 
    cmp ebx, 0              
    je error_division_cero   

    cdq                      
    idiv ebx                 
    call decimal_a_ascii     
    jmp mostrar_resultado    

error_division_cero:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error
    mov edx, lmsg_error
    int 80h
    jmp operacion_loop

mostrar_resultado:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, lmsg4
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 12
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, resultado
    mov edx, 1
    int 80h
    jmp operacion_loop

salir:
    mov eax, 1
    mov ebx, 0
    int 80h

ascii_a_decimal_num1:
    xor eax, eax
    xor ecx, ecx
    mov esi, num1
    movzx ebx, byte [esi]
    cmp bl, '-'
    je negativo_num1

convertir_num1:
    mov cl, byte [esi]
    cmp cl, 10
    je fin_conversion1
    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp convertir_num1

negativo_num1:
    inc esi
    jmp convertir_num1

fin_conversion1:
    cmp bl, '-'
    jne positivo_num1
    neg eax
positivo_num1:
    mov [num1_decimal], eax
    ret

ascii_a_decimal_num2:
    xor eax, eax
    xor ecx, ecx
    mov esi, num2
    movzx ebx, byte [esi]
    cmp bl, '-'
    je negativo_num2

convertir_num2:
    mov cl, byte [esi]
    cmp cl, 10
    je fin_conversion2
    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp convertir_num2

negativo_num2:
    inc esi
    jmp convertir_num2

fin_conversion2:
    cmp bl, '-'
    jne positivo_num2
    neg eax
positivo_num2:
    mov [num2_decimal], eax
    ret

decimal_a_ascii:
    mov edi, resultado + 11
    mov ecx, 10
    mov byte [edi], 0
    dec edi
    test eax, eax
    jns convertir_positivo

    neg eax
convertir_positivo:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convertir_positivo
    test ebx, ebx
    js agregar_signo_negativo
    jmp fin_conversion_ascii

agregar_signo_negativo:
    mov byte [edi], '-'
    dec edi

mensaje_operacion:
    mov eax, 3
    mov ebx, 0
    mov ecx, msg_entrada
    mov edx, lmsg_entrada
    int 80h
    jmp operacion_loop

fin_conversion_ascii:
    inc edi
    mov ecx, edi
    ret
