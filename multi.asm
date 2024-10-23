section .data
    text1 db "Escriba tu primer numero: ", 0
    text2 db "Escriba tu segundo numero: ", 0
    resultado_mult db "Tu resultado de la Multiplicacion es: ", 0
    buffer db 0
    num1 db 0
    num2 db 0

section .bss
    producto resb 3

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

    movzx ax, byte [num1]
    movzx bx, byte [num2]
    imul ax, bx

    call convertir_a_ascii

    mov rax, 1
    mov rdi, 1
    mov rsi, resultado_mult
    mov rdx, 34
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, producto
    mov rdx, 3
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

convertir_a_ascii:
    mov rdi, producto
    add rdi, 2
    mov byte [rdi], 0

    mov rcx, 10
    xor rbx, rbx

convertir_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rbx
    test rax, rax
    jnz convertir_loop

    ret
