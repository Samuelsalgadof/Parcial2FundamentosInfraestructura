section .data
    text1 db "Escriba tu primer numero: ", 0
    text2 db "Escriba tu segundo numero: ", 0
    resultado_mult db "Tu resultado de la Multiplicacion es: ", 0
    buffer db 0
    num1 db 0
    num2 db 0

section .bss
    producto resb 1

section .text
    global _start

_start:
    ; Mostrar mensaje para el primer número
    mov rax, 1
    mov rdi, 1
    mov rsi, text1
    mov rdx, 25
    syscall

    ; Leer el primer número
    call leer_numero
    mov [num1], al

    call limpiar_buffer

    ; Mostrar mensaje para el segundo número
    mov rax, 1
    mov rdi, 1
    mov rsi, text2
    mov rdx, 26
    syscall

    ; Leer el segundo número
    call leer_numero
    mov [num2], al

    call limpiar_buffer

    ; Realizar la multiplicación de num1 * num2
    mov al, [num1]
    imul al, [num2]
    mov [producto], al

    ; Convertir el producto a ASCII sumando '0'
    add byte [producto], '0'

    ; Mostrar el mensaje del resultado de la multiplicación
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado_mult
    mov rdx, 34
    syscall

    ; Imprimir el valor del producto
    mov rax, 1
    mov rdi, 1
    mov rsi, producto
    mov rdx, 1
    syscall

    ; Terminar la ejecución del programa
    mov rax, 60
    xor rdi, rdi
    syscall

leer_numero:
    ; Leer un número del usuario
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    mov al, [buffer]
    sub al, '0'
    ret

limpiar_buffer:
    ; Limpiar el buffer de entrada
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    ret
