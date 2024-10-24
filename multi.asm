section .data
    text1 db "Escriba tu primer numero: ", 0
    text2 db "Escriba tu segundo numero: ", 0
    resultado_mult db "Tu resultado de la Multiplicacion es: ", 0
    buffer db 0
    num1 db 0
    num2 db 0

section .bss
    producto resb 5   ; Reservar más espacio para un número grande convertido a ASCII

section .text
    global _start

_start:
    ; Mostrar "Escriba tu primer numero: "
    mov rax, 1
    mov rdi, 1
    mov rsi, text1
    mov rdx, 25
    syscall

    ; Leer primer número
    call leer_numero
    mov [num1], al

    call limpiar_buffer

    ; Mostrar "Escriba tu segundo numero: "
    mov rax, 1
    mov rdi, 1
    mov rsi, text2
    mov rdx, 26
    syscall

    ; Leer segundo número
    call leer_numero
    mov [num2], al

    call limpiar_buffer

    ; Multiplicar num1 * num2
    mov al, [num1]          ; Cargar num1 en AL
    mov bl, [num2]          ; Cargar num2 en BL
    mul bl                  ; Multiplicar AL * BL (resultado en AX)
    
    ; Convertir resultado de la multiplicación (en AX) a ASCII
    call convertir_a_ascii

    ; Mostrar "Tu resultado de la Multiplicacion es: "
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado_mult
    mov rdx, 38
    syscall

    ; Mostrar el resultado almacenado en 'producto'
    mov rax, 1
    mov rdi, 1
    mov rsi, producto
    mov rdx, 5     ; longitud máxima de un número de 16 bits en decimal
    syscall

    ; Salir del programa
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
    sub al, '0'  ; Convertir de ASCII a número
    ret

limpiar_buffer:
    ; Limpiar el buffer (lectura dummy)
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    ret

convertir_a_ascii:
    ; Convertir el valor en AX a una cadena ASCII (almacenada en 'producto')
    mov rsi, 5       ; Índice de la cadena (comenzar desde el final)
    mov rcx, 10      ; Divisor (base 10)

convertir_bucle:
    xor rdx, rdx     ; Limpiar RDX para la división
    div rcx          ; Dividir AX entre 10 (resultado en AL, residuo en DL)
    add dl, '0'      ; Convertir residuo a carácter ASCII
    mov [producto + rsi - 1], dl  ; Almacenar el carácter en producto
    dec rsi          ; Mover el índice hacia atrás
    test rax, rax    ; Verificar si AX es 0
    jnz convertir_bucle

    ret
