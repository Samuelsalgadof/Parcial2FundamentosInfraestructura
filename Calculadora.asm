section .data
    msg1 db "Ingrese el primer numero: ", 0
    lmsg1 equ $ - msg1

    msg2 db "Ingrese el segundo numero: ", 0
    lmsg2 equ $ - msg2

    msg3 db "Seleccione la operacion (+, -, *, /, q para salir): ", 0
    lmsg3 equ $ - msg3

    msg4 db "Resultado: ", 0
    lmsg4 equ $ - msg4

    msg_error db "Error: No se puede dividir por cero", 10, 0
    lmsg_error equ $ - msg_error

section .bss
    num1 resb 5           ; espacio para el primer número (hasta 4 dígitos + signo)
    num2 resb 5           ; espacio para el segundo número (hasta 4 dígitos + signo)
    num1_decimal resd 1   ; espacio para el primer número en decimal
    num2_decimal resd 1   ; espacio para el segundo número en decimal
    op resb 1             ; espacio para la operación
    resultado resb 10     ; espacio para el resultado

section .text
    global _start

_start:
    ; Inicio del bucle de operaciones
operacion_loop:
    ; Solicitar el primer número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    ; Leer el primer número
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 5          ; Leer hasta 5 bytes para el número completo (incluyendo el signo)
    int 80h
    call ascii_a_decimal_num1

    ; Solicitar el segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    ; Leer el segundo número
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 5          ; Leer hasta 5 bytes para el número completo (incluyendo el signo)
    int 80h
    call ascii_a_decimal_num2

    ; Solicitar la operación
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    ; Leer la operación
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 80h

    ; Comparar operación y llamar a la función correspondiente
    mov al, [op]
    cmp al, 'q'
    je salir
    cmp al, '+'
    je sumar
    cmp al, '-'
    je restar
    cmp al, '*'
    je multiplicar
    cmp al, '/'
    je dividir

    ; Operaciones
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
    mul ebx
    call decimal_a_ascii
    jmp mostrar_resultado

dividir:
    mov eax, [num1_decimal]
    mov ebx, [num2_decimal]
    cmp ebx, 0
    je error_division_cero
    div ebx
    call decimal_a_ascii
    jmp mostrar_resultado

error_division_cero:
    ; Mostrar mensaje de error
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error
    mov edx, lmsg_error
    int 80h
    jmp operacion_loop

mostrar_resultado:
    ; Mostrar mensaje de resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, lmsg4
    int 80h

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 10
    int 80h

    ; Esperar a que el usuario presione enter antes de la siguiente operación
    mov eax, 3
    mov ebx, 0
    mov ecx, resultado   ; Usar el mismo buffer de resultado para capturar el enter
    mov edx, 1
    int 80h
    jmp operacion_loop

salir:
    ; Terminar el programa
    mov eax, 1
    mov ebx, 0
    int 80h

; Función para convertir ASCII a decimal (num1)
ascii_a_decimal_num1:
    xor eax, eax
    xor ecx, ecx
    mov esi, num1
    movzx ebx, byte [esi]  ; Cargar el primer carácter
    cmp bl, '-'            ; Comprobar si el número es negativo
    je negativo_num1

convertir_num1:
    mov cl, byte [esi]
    cmp cl, 10            ; Verificar si es salto de línea
    je fin_conversion1
    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp convertir_num1

negativo_num1:
    inc esi               ; Saltar el signo
    jmp convertir_num1

fin_conversion1:
    mov [num1_decimal], eax
    ret

; Función para convertir ASCII a decimal (num2)
ascii_a_decimal_num2:
    xor eax, eax
    xor ecx, ecx
    mov esi, num2
    movzx ebx, byte [esi]  ; Cargar el primer carácter
    cmp bl, '-'            ; Comprobar si el número es negativo
    je negativo_num2

convertir_num2:
    mov cl, byte [esi]
    cmp cl, 10            ; Verificar si es salto de línea
    je fin_conversion2
    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp convertir_num2

negativo_num2:
    inc esi               ; Saltar el signo
    jmp convertir_num2

fin_conversion2:
    mov [num2_decimal], eax
    ret

; Función para convertir decimal a ASCII
decimal_a_ascii:
    mov edi, resultado + 9
    mov ecx, 10
    mov byte [edi], 0
    dec edi
convierte_a_ascii:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convierte_a_ascii
    inc edi
    mov ecx, edi
    ret
