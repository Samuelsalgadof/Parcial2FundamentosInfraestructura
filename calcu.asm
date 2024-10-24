section .data
    menu db "Selecciona una operacion:", 0xA
    menu_op db "1. Suma", 0xA, "2. Resta", 0xA, "3. Multiplicacion", 0xA, "4. Division", 0xA, "5. Salir", 0xA, 0
    mensaje1 db "Ingrese su primer numero:", 0xA, 0
    mensaje2 db "Ingrese su segundo numero:", 0xA, 0
    resultado db "El resultado es: ", 0xA, 0
    error_msg db "Error: Division por cero", 0xA, 0

section .bss
    buffer resb 10          ; Buffer para entrada
    numero1 resd 1          ; Espacio para el primer número
    numero2 resd 1          ; Espacio para el segundo número
    resultado_final resd 1  ; Espacio para el resultado final

section .text
    global _start

_start:
    jmp main

main:
    call mostrar_menu
    call leer_opcion
    sub al, '0'  ; Convertir de ASCII a número

    cmp al, 5
    je exit_program

    cmp al, 1
    je suma_op
    cmp al, 2
    je resta_op
    cmp al, 3
    je multiplicacion_op
    cmp al, 4
    je division_op

    jmp main

suma_op:
    call pedir_dos_numeros
    mov eax, [numero1]
    add eax, [numero2]
    mov [resultado_final], eax
    call mostrar_resultado
    jmp main

resta_op:
    call pedir_dos_numeros
    mov eax, [numero1]
    sub eax, [numero2]
    mov [resultado_final], eax
    call mostrar_resultado
    jmp main

multiplicacion_op:
    call pedir_dos_numeros
    mov eax, [numero1]
    imul eax, [numero2]  ; Multiplicación
    mov [resultado_final], eax
    call mostrar_resultado
    jmp main

division_op:
    call pedir_dos_numeros
    mov eax, [numero1]
    xor edx, edx              ; Limpiar edx antes de la división
    mov ebx, [numero2]
    cmp ebx, 0
    je division_por_cero
    div ebx                    ; Dividir eax entre ebx
    mov [resultado_final], eax
    call mostrar_resultado
    jmp main

division_por_cero:
    ; Mostrar mensaje de error
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, 24
    syscall
    jmp main

pedir_dos_numeros:
    ; Pedir el primer número
    mov rax, 1
    mov rdi, 1
    mov rsi, mensaje1
    mov rdx, 26
    syscall
    call leer_numero
    mov [numero1], eax

    ; Pedir el segundo número
    mov rax, 1
    mov rdi, 1
    mov rsi, mensaje2
    mov rdx, 27
    syscall
    call leer_numero
    mov [numero2], eax
    ret

leer_opcion:
    ; Leer una opción del menú
    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer]
    mov rdx, 1
    syscall
    mov al, [buffer]
    ret

leer_numero:
    ; Leer un número de hasta 4 dígitos
    xor eax, eax        ; Inicializar eax para el número
    xor ebx, ebx        ; Registro temporal para el número leído
leer_digito:
    ; Leer un dígito
    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer]
    mov rdx, 1
    syscall
    mov al, [buffer]
    cmp al, 0xA         ; Comprobar si es salto de línea (fin de entrada)
    je fin_lectura
    cmp al, '0'
    jb fin_lectura      ; Si el valor es menor que '0', finalizar la lectura
    cmp al, '9'
    ja fin_lectura      ; Si el valor es mayor que '9', finalizar la lectura
    sub al, '0'         ; Convertir ASCII a número
    imul ebx, ebx, 10   ; Desplazar el número leído a la izquierda
    add ebx, eax        ; Agregar el nuevo dígito al número
    jmp leer_digito
fin_lectura:
    mov eax, ebx        ; Mover el número completo a eax (32-bit)
    ret

mostrar_resultado:
    ; Mostrar el resultado
    mov eax, [resultado_final]
    call print_num
    ret

print_num:
    ; Mostrar un número guardado en eax
    mov rsi, rax        ; Mover el número a rsi (el registro a usar para mostrar)
    mov rcx, 10         ; Para dividir por 10
    xor rbx, rbx        ; Registro temporal para almacenar caracteres
    xor rdx, rdx        ; Limpiar rdx antes de dividir
convertir:
    xor rdx, rdx
    div rcx              ; Dividir eax por 10
    add dl, '0'          ; Convertir a ASCII
    push rdx             ; Empujar el dígito al stack
    test rax, rax
    jnz convertir        ; Seguir si el cociente no es 0
print_digitos:
    pop rax
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall             ; Mostrar un carácter
    cmp rsp, rbp
    jne print_digitos
    ret

mostrar_menu:
    ; Mostrar el menú
    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, 27
    syscall

    ; Mostrar opciones
    mov rax, 1
    mov rdi, 1
    mov rsi, menu_op
    mov rdx, 63
    syscall
    ret

exit_program:
    ; Salir del programa
    mov rax, 60
    xor rdi, rdi
    syscall
