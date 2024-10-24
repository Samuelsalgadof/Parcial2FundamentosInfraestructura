section .data
    text1 db "Escriba tu primer numero: ", 0      
    text2 db "Escriba tu segundo numero: ", 0     
    text3 db "Menu...", 0xA                       
    text4 db "1. Suma", 0xA                       
    text44 db "4. División", 0xA                       
    text5 db "Ingresar opción: ", 0                       
    text6 db 0xA, "¿Desea continuar (s/n)?: "                       
    resultado_sum db "Tu resultado de la Suma es: ", 0 
    resultado_div db "Tu resultado de la division es: ", 0
    error_msg db "Error: Division por cero", 0xA
    buffer db 0                                    
    num1 db 0                                      
    num2 db 0                                      
    opcion db 0                                    
    repetir db 's'                                 
    cociente db 0

section .bss
    suma resb 1                                    

section .text
    global _start                                   

_start:
    
    cmp byte [repetir], 's'
    je menu
    jmp exit

    
menu:
    call limpiar_buffer
    call pintar_menu

    call leer_letra                                ; Llamar a la función para leer el primer número
    mov [opcion], al                                 ; Almacenar el primer número

    cmp byte [opcion], '1'
    je sumar
    cmp byte [opcion], '4'
    je division
    jmp exit


sumar:
    
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
    mov rdx, 26                                    ; longitud del mensaje
    syscall

    ; Leer la opción de continuar
    call leer_letra                                ; Llamar a la función para leer la opción

    mov [repetir], al  
    jmp _start


division:
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

    ; Realizar la división
    mov al, [num1]
    xor ah, ah              ; limpiar el registro ah
    mov bl, [num2]
    
    ; Verificar división por cero
    cmp bl, 0
    je division_por_cero     ; saltar si segundo número es cero

    xor edx, edx            ; limpiar edx para división
    div bl                   ; dividir al / bl
    add al, '0'             ; convertir a carácter
    mov [cociente], al

    ; Mostrar resultado
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    mov rsi, resultado_div   ; mensaje de resultado
    mov rdx, 32             ; longitud del mensaje
    syscall                 ; llamada al sistema

    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, cociente                              ; dirección del resultado
    mov rdx, 1                                     ; longitud del resultado
    syscall

    ; Mostrar el mensaje de continuar
    mov rax, 1                                     ; syscall: write
    mov rdi, 1                                     ; file descriptor: stdout
    mov rsi, text6                                 ; dirección del mensaje
    mov rdx, 26                                    ; longitud del mensaje
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
    mov rsi, text44                                ; dirección del mensaje
    mov rdx, 13                                    ; longitud del mensaje
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

    division_por_cero:
    ; Manejo de error: división por cero
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    mov rsi, error_msg      ; mensaje de error
    mov rdx, 26             ; longitud del mensaje de error
    syscall                 ; llamada al sistema

    jmp _start
    
