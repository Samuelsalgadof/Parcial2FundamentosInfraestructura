section .data
    text1 db "Escriba tu primer numero: ", 0      ; Mensaje para solicitar el primer número
    text2 db "Escriba tu segundo numero: ", 0     ; Mensaje para solicitar el segundo número
    text3 db "Menu...", 0xA                       ; Menu inicio
    text4 db "1. Suma", 0xA                       
    text5 db "Ingresar opción: ", 0                       
    text6 db "¿Desea continuar (s/n)?: "                       
    resultado_sum db "Tu resultado de la Suma es: ", 0 ; Mensaje para mostrar el resultado
    buffer db 0                                    ; Buffer para almacenar un carácter leído
    num1 db 0                                      ; Variable para el primer número
    num2 db 0                                      ; Variable para el segundo número
    opcion db 0                                    ; Variable para la opcion
    repetir db 's'                                   ; Variable para la repeticion

section .bss
    suma resb 1                                    ; Reservar espacio para almacenar la suma

section .text
    global _start                                   ; Punto de entrada del programa

_start:
    
    cmp byte [repetir], 's'
    je menu
    jmp exit

    
   
menu:
    call limpiar_buffer
    call pintar_menu

    call leer_numero                                ; Llamar a la función para leer el primer número
    mov [opcion], al                                 ; Almacenar el primer número

    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el primer número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text1                                 ; dirección del mensaje
    mov rdx, 25                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Llamar a la función para leer el primer número
    mov [num1], al                                 ; Almacenar el primer número

    call limpiar_buffer                             ; Limpiar el buffer

    ; Mostrar el mensaje para el segundo número
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text2                                 ; dirección del mensaje
    mov rdx, 26                                    ; longitud del mensaje
    syscall

    call leer_numero                                ; Llamar a la función para leer el segundo número
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
    mov rsi, resultado_sum                          ; dirección del mensaje
    mov rdx, 27                                    ; longitud del mensaje
    syscall

    ; Mostrar el resultado
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, suma                                   ; dirección del resultado
    mov rdx, 1                                     ; longitud del resultado
    syscall

    ; Mostrar el mensaje de continuar
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text6                                 ; dirección del mensaje
    mov rdx, 25                                    ; longitud del mensaje
    syscall

    ; Leer la opción de continuar
    call leer_letra                                ; Llamar a la función para leer la opción

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
    mov rdx, 8                                    ; longitud del mensaje
    syscall

    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text4                                 ; dirección del mensaje
    mov rdx, 8                                    ; longitud del mensaje
    syscall
    
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text5                                 ; dirección del mensaje
    mov rdx, 18                                    ; longitud del mensaje
    syscall

    ret

leer_numero:
    ; Leer un número de un carácter
    mov rax, 0                                     ; syscall: read
    mov rdi, 0                                     ; file descriptor: stdin
    mov rsi, buffer                                 ; dirección del buffer
    mov rdx, 1                                     ; leer 1 byte
    syscall
    mov al, [buffer]                                ; Cargar el carácter leído
    sub al, '0'                                     ; Convertir de ASCII a número
    ret                                             ; Regresar de la función

limpiar_buffer:
    ; Limpiar el buffer (no se utiliza realmente)
    mov rax, 0                                     ; syscall: read
    mov rdi, 0                                     ; file descriptor: stdin
    mov rsi, buffer                                 ; dirección del buffer
    mov rdx, 1                                     ; leer 1 byte
    syscall
    ret                                             ; Regresar de la función

leer_letra:
    ; Leer un carácter del usuario (letra o número)
    mov rax, 0            ; syscall: read
    mov rdi, 0            ; file descriptor: stdin
    mov rsi, buffer       ; dirección del buffer
    mov rdx, 1            ; leer 1 byte
    syscall
    mov al, [buffer]      ; Cargar el carácter leído (no se hace conversión)
    ret                   ; Regresar de la función