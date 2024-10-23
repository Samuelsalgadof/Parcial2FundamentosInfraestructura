section .data
    mensaje1 db "Ingrese su primer digito: ", 0xA
    mensaje2 db "Ingrese su segundo digito: ", 0xA
    resultado_div db "Tu resultado de la division es: ", 0xA
    error_msg db "Error: Division por cero", 0xA
    numero1 db 0
    numero2 db 0
    cociente db 0
    buffer db 0 ; Para leer y descartar el carácter extra

section .bss

section .text
    global _start

_start:
    ; Solicitar primer número
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    mov rsi, mensaje1       ; mensaje a mostrar
    mov rdx, 26             ; longitud del mensaje
    syscall                 ; llamada al sistema

    ; Leer primer dígito
    mov rax, 0              ; syscall read
    mov rdi, 0              ; entrada estándar
    lea rsi, [numero1]      ; guardar en numero1
    mov rdx, 1              ; leer un byte
    syscall                 ; llamada al sistema

    sub byte [numero1], '0'  ; convertir a número

    ; Limpiar el buffer leyendo el carácter de nueva línea
    mov rax, 0              ; syscall read
    mov rdi, 0              ; entrada estándar
    lea rsi, [buffer]       ; leer y descartar el carácter extra
    mov rdx, 1              ; longitud de 1 byte
    syscall                 ; llamada al sistema

    ; Solicitar segundo número
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    mov rsi, mensaje2       ; mensaje a mostrar
    mov rdx, 27             ; longitud del mensaje
    syscall                 ; llamada al sistema

    ; Leer segundo dígito
    mov rax, 0              ; syscall read
    mov rdi, 0              ; entrada estándar
    lea rsi, [numero2]      ; guardar en numero2
    mov rdx, 1              ; leer un byte
    syscall                 ; llamada al sistema

    sub byte [numero2], '0'  ; convertir a número

    ; Realizar la división
    mov al, [numero1]
    xor ah, ah              ; limpiar el registro ah
    mov bl, [numero2]
    
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

    ; Mostrar el resultado de la división
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    lea rsi, [cociente]     ; mostrar el resultado
    mov rdx, 1              ; longitud del resultado (1 byte)
    syscall                 ; llamada al sistema

    ; Salir del programa
    mov rax, 60             ; syscall exit
    xor rdi, rdi            ; código de salida 0
    syscall                 ; llamada al sistema

division_por_cero:
    ; Manejo de error: división por cero
    mov rax, 1              ; syscall write
    mov rdi, 1              ; salida estándar
    mov rsi, error_msg      ; mensaje de error
    mov rdx, 26             ; longitud del mensaje de error
    syscall                 ; llamada al sistema

    ; Salir del programa
    mov rax, 60             ; syscall exit
    xor rdi, rdi            ; código de salida 0
    syscall                 ; llamada al sistema