section .data
    text1 db "Escriba tu primer numero: ", 0
    text2 db "Escriba tu segundo numero: ", 0
    resultado_sum db "Tu resultado de la Suma es: ", 0
    buffer db 0
    num1 db 0
    num2 db 0
    signo1 db 1      ; 1 si es positivo, -1 si es negativo
    signo2 db 1      ; 1 si es positivo, -1 si es negativo

section .bss
    suma resb 1

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, text1
    mov rdx, 25
    syscall

    call leer_numero
    mov [num1], al

    call limpiar_buffer

    mov rax, 1
    mov rdi, 1
    mov rsi, text2
    mov rdx, 26
    syscall

    call leer_numero
    mov [num2], al

    call limpiar_buffer

    ; Multiplica num1 y num2 por sus respectivos signos
    mov al, [num1]
    imul al, byte [signo1]
    mov bl, [num2]
    imul bl, byte [signo2]

    ; Sumar num1 y num2
    add al, bl
    mov [suma], al

    ; Convertir el resultado a ASCII
    cmp al, 0
    jge positivo

    ; Si es negativo, agregar signo '-' y convertir a positivo
    neg al
    add al, '0'
    mov [suma], al

    ; Mostrar el signo negativo
    mov rax, 1
    mov rdi, 1
    mov rsi, '-'
    mov rdx, 1
    syscall

    jmp mostrar_resultado

positivo:
    add al, '0'
    mov [suma], al

mostrar_resultado:
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado_sum
    mov rdx, 27
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, suma
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

leer_numero:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    mov al, [buffer]

    ; Verificar si el número es negativo
    cmp al, '-'
    jne positivo_numero

    ; Si es negativo, establece el signo como -1 y vuelve a leer el número
    mov byte [signo1], -1
    syscall
    mov al, [buffer]

positivo_numero:
    sub al, '0'
    ret

limpiar_buffer:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    ret
