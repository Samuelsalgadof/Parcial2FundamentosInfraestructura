section .data
    text1 db "Escriba tu primer numero: ", 0      ; Mensaje para solicitar el primer número
    text2 db "Escriba tu segundo numero: ", 0     ; Mensaje para solicitar el segundo número
    text3 db "Menu...", 0xA                       ; Menu inicio
    text4 db "1. Suma", 0xA                       
    text5 db "2. Multiplicacion", 0xA             ; Opción de multiplicación
    text6 db "Ingresar opción: ", 0               
    text7 db 0xA, "¿Desea continuar (s/n)?: "                       
    resultado_sum db "Tu resultado de la Suma es: ", 0  ; Mensaje para mostrar el resultado de la suma
    resultado_mul db "Tu resultado de la Multiplicacion es: ", 0  ; Mensaje para mostrar el resultado de la multiplicación
    buffer db 0                                    ; Buffer para almacenar un carácter leído
    num1 db 0                                      ; Variable para el primer número
    num2 db 0                                      ; Variable para el segundo número
    opcion db 0                                    ; Variable para la opción
    repetir db 's'                                 ; Variable para la repetición

section .bss
    suma resb 1                                    ; Reservar espacio para almacenar la suma
    producto resb 2                                ; Reservar espacio para almacenar el producto

section .text
    global _start                                  ; Punto de entrada del programa

_start:
    
    cmp byte [repetir], 's'
    je menu
    jmp exit

menu:
    call limpiar_buffer
    call pintar_menu

    call leer_letra                                ; Llamar a la función para leer la opción
    mov [opcion], al                               ; Almacenar la opción

    cmp byte [opcion], '1'
    je sumar
    cmp byte [opcion], '2'
    je multiplicar
    jmp exit

sumar:
    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el primer número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text1                                 ; dirección del mensaje
    mov rdx, 25                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Leer el primer número
    mov [num1], al                                 ; Almacenar el primer número

    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el segundo número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text2                                 ; dirección del mensaje
    mov rdx, 26                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Leer el segundo número
    mov [num2], al                                 ; Almacenar el segundo número

    call limpiar_buffer                             ; Limpiar el buffer

    ; Calcular la suma de los dos números
    mov al, [num1]                                 ; Cargar el primer número
    add al, [num2]                                 ; Sumar el segundo número
    mov [suma], al                                 ; Almacenar el resultado de la suma

    add byte [suma], '0'                           ; Convertir el resultado a carácter

    ; Mostrar el mensaje del resultado
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, resultado_sum                         ; dirección del mensaje
    mov rdx, 27                                    ; longitud del mensaje
    syscall

    ; Mostrar el resultado
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, suma                                  ; dirección del resultado
    mov rdx, 1                                     ; longitud del resultado
    syscall

    call continuar                                 ; Llamar a la función continuar

multiplicar:
    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el primer número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text1                                 ; dirección del mensaje
    mov rdx, 25                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Leer el primer número
    movzx ax, byte [num1]                          ; Cargar el primer número en un registro de 16 bits

    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el segundo número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text2                                 ; dirección del mensaje
    mov rdx, 26                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Leer el segundo número
    movzx bx, byte [num2]                          ; Cargar el segundo número en un registro de 16 bits

    call limpiar_buffer                             ; Limpiar el buffer

    ; Calcular la multiplicación de los dos números
    imul ax, bx                                    ; Multiplicar AX por BX (resultado en AX)
    mov [producto], ax                             ; Almacenar el resultado de la multiplicación (16 bits)

    ; Convertir el resultado a carácter (asumimos un resultado de un solo dígito por simplicidad)
    add byte [producto], '0'

    ; Mostrar el mensaje del resultado de la multiplicación
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, resultado_mul                         ; dirección del mensaje
    mov rdx, 34                                    ; longitud del mensaje
    syscall

    ; Mostrar el resultado
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, producto                              ; dirección del resultado
    mov rdx, 1                                     ; longitud del resultado
    syscall

    call continuar                                 ; Llamar a la función continuar

continuar:
    ; Mostrar el mensaje de continuar
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text7                                 ; dirección del mensaje
    mov rdx, 26                                    ; longitud del mensaje
    syscall

    ; Leer la opción de continuar
    call leer_letra                                ; Leer la opción
    mov [repetir], al  
    jmp _start

exit:
    ; Terminar el programa
    mov rax, 60                                    ; syscall: exit
    xor rdi, rdi                                   ; exit code 0
    syscall

pintar_menu:
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text3                                 ; dirección del mensaje
    mov rdx, 8                                     ; longitud del mensaje
    syscall

    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text4                                 ; dirección del mensaje
    mov rdx, 8                                     ; longitud del mensaje
    syscall
    
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text5                                 ; dirección del mensaje
    mov rdx, 18                                    ; longitud del mensaje
    syscall

    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text6                                 ; dirección del mensaje
    mov rdx, 18                                    ; longitud del mensaje
    syscall

    ret

leer_numero:
    ; Leer un número de un carácter
    mov rax, 0                                     ; syscall: read
    mov rdi, 0                                     ; file descriptor: stdin
    mov rsi, buffer                                ; dirección del buffer
    mov rdx, 1                                     ; leer 1 byte
    syscall
    mov al, [buffer]                               ; Cargar el carácter leído
    sub al, '0'                                    ; Convertir de ASCII a número
    ret                                            ; Regresar de la función

limpiar_buffer:
    ; Limpiar el buffer (no se utiliza realmente)
    mov rax, 0                                     ; syscall: read
    mov rdi, 0                                     ; file descriptor: stdin
    mov rsi, buffer                                ; dirección del buffer
    mov rdx, 1                                     ; leer 1 byte
    syscall
    ret                                            ; Regresar de la función

leer_letra:
     ; Leer un carácter del usuario (letra o número)
    mov rax, 0                                     ; syscall: read
    mov rdi, 0                                     ; file descriptor: stdin
    mov rsi, buffer                                ; dirección del buffer
    mov rdx, 1                                     ; leer 1 byte
    syscall
    mov al, [buffer]                               ; Cargar el carácter leído
    ret                                            ; Regresar de la función

   
