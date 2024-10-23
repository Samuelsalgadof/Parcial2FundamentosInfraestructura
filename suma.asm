section .data
    text1 db "Escriba tu primer numero: ", 0
    text2 db "Escriba tu segundo numero: ", 0
    resultado_sum db "Tu resultado de la Suma es: ", 0
    buffer db 0
    num1 db 0
    num2 db 0

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

    mov al, [num1]
    add al, [num2]
    mov [suma], al

    add byte [suma], '0'

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
    sub al, '0'
    ret

limpiar_buffer:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
ret