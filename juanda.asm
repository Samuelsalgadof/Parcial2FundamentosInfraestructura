section .data
    prompt db 'Ingrese dos numeros y una operacion (+, -, *, /, %), o "exit" para salir: ', 0
    result_msg db 'Resultado: ', 0
    error_msg db 'Error: Division por cero', 0
    newline db 0xA, 0
    exit_cmd db 'exit', 0
    buffer db 0

section .bss
    num1 resb 10
    num2 resb 10
    operation resb 1
    input resb 20

section .text
    global _start

_start:
    ; Bucle principal
main_loop:
    ; Mostrar mensaje de entrada
    mov eax, 4           ; syscall write
    mov ebx, 1           ; descriptor de salida (stdout)
    mov ecx, prompt      ; puntero al mensaje de entrada
    mov edx, 72          ; longitud del mensaje
    int 0x80             ; llamada al sistema

    ; Leer entrada del usuario
    mov eax, 3           ; syscall read
    mov ebx, 0           ; descriptor de entrada (stdin)
    mov ecx, input       ; puntero al buffer de entrada
    mov edx, 20          ; longitud máxima de la entrada
    int 0x80             ; llamada al sistema

    ; Verificar si el usuario quiere salir
    mov ecx, input
    mov edi, exit_cmd
    call str_cmp
    cmp eax, 0
    je exit_program

    ; Parsear la entrada
    call parse_input

    ; Realizar la operación según la entrada
    cmp byte [operation], '+'
    je suma
    cmp byte [operation], '-'
    je resta
    cmp byte [operation], '*'
    je multiplicacion
    cmp byte [operation], '/'
    je division
    cmp byte [operation], '%'
    je modulo

    ; Si no coincide con ninguna operación válida, repetir el bucle
    jmp main_loop

suma:
    ; Cargar los valores en registros
    mov eax, [num1]
    add eax, [num2]
    jmp print_result

resta:
    mov eax, [num1]
    sub eax, [num2]
    jmp print_result

multiplicacion:
    mov eax, [num1]
    mov ebx, [num2]
    imul ebx
    jmp print_result

division:
    ; Verificar si es una división por cero
    mov eax, [num2]
    cmp eax, 0
    je error_division_cero
    mov eax, [num1]
    cdq
    idiv dword [num2]
    jmp print_result

modulo:
    ; Verificar si es una división por cero
    mov eax, [num2]
    cmp eax, 0
    je error_division_cero
    mov eax, [num1]
    cdq
    idiv dword [num2]
    mov eax, edx
    jmp print_result

error_division_cero:
    ; Mostrar mensaje de error por división por cero
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 24
    int 0x80
    jmp main_loop

print_result:
    ; Mostrar el mensaje de resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 10
    int 0x80

    ; Convertir el resultado a cadena y mostrarlo
    call print_number

    ; Salto al final del bucle para repetir
    jmp main_loop

exit_program:
    ; Salida del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Función para convertir entrada a número y operación
parse_input:
    ; Convertir los primeros dos números de la entrada a enteros
    ; Leer el primer número
    mov esi, input
    call str_to_int
    mov [num1], eax

    ; Leer el segundo número
    mov esi, input
    add esi, 5
    call str_to_int
    mov [num2], eax

    ; Leer la operación
    mov esi, input
    add esi, 10
    mov al, [esi]
    mov [operation], al
    ret

; Función para convertir cadena a entero
str_to_int:
    xor eax, eax      ; limpiar el registro eax
    xor ebx, ebx      ; limpiar el registro ebx
    mov ecx, 10       ; base 10

convert_loop:
    mov bl, [esi]     ; cargar el byte actual
    cmp bl, 0xA       ; comparar con el salto de línea
    je done_convert   ; si es un salto de línea, salir
    sub bl, '0'       ; convertir el carácter en un número
    imul eax, ecx     ; multiplicar el acumulador por 10
    add eax, ebx      ; sumar el dígito actual al acumulador
    inc esi           ; avanzar al siguiente carácter
    jmp convert_loop

done_convert:
    ret

; Función para comparar dos cadenas
str_cmp:
    push edi
    push esi
    mov esi, ecx
    mov edi, input
    cld
    repe cmpsb
    sete al
    pop esi
    pop edi
    ret

; Función para imprimir un número
print_number:
    ; Conversión de entero a cadena y salida
    ; Implementación simple para mostrar el número en eax
    mov ecx, buffer
    mov ebx, 10

convert_number:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz convert_number

    ; Mostrar el número convertido
    mov eax, 4
    mov ebx, 1
    mov edx, buffer + 10 - ecx
    int 0x80
    ret