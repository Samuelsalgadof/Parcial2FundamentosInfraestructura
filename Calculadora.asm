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
    num1 resb 6           ; espacio para el primer número (hasta 4 dígitos + signo + null)
    num2 resb 6           ; espacio para el segundo número (hasta 4 dígitos + signo + null)
    num1_decimal resd 1   ; espacio para el primer número en decimal
    num2_decimal resd 1   ; espacio para el segundo número en decimal
    op resb 1             ; espacio para la operación
    resultado resb 12     ; espacio para el resultado (10 dígitos + signo + null)

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
    mov edx, 6          ; Leer hasta 6 bytes para el número completo (incluyendo el signo y null)
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
    mov edx, 6          
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
    imul eax, ebx
    call decimal_a_ascii
    jmp mostrar_resultado

dividir:
    mov eax, [num1_decimal] 
    mov ebx, [num2_decimal] 
    cmp ebx, 0              
    ; Comparar divisor con 0
    je error_division_cero   

    cdq                      
    idiv ebx                 
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
    mov edx, 12
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
    cmp bl, '-'           ; Si el número es negativo, hacerlo negativo
    jne positivo_num1
    neg eax
positivo_num1:
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
    cmp bl, '-'           ; Si el número es negativo, hacerlo negativo
    jne positivo_num2
    neg eax
positivo_num2:
    mov [num2_decimal], eax
    ret

; Función para convertir decimal a ASCII
decimal_a_ascii:
    mov edi, resultado + 11
    mov ecx, 10
    mov byte [edi], 0
    dec edi
    test eax, eax
    jns convertir_positivo

    ; Si es negativo, convertir el valor positivo y añadir signo negativo
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
