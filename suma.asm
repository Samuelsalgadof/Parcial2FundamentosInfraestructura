.model small 

.stack

.data
    text1 db 13,10, "Escriba tu primer numero: ", "$"
    text2 db 13,10, "Escriba tu segundo numero ", "$"

    resultado_sum db 13,10, "Tu resultado de la Suma es: ", "$"

    num1 db 0
    num2 db 0

    suma db 0

.code
    main proc far
        mov ax,@data
        mov ds,ax




        mov ah,09h
        lea dx,text1
        int 21h


        mov ah,01h
        int 21h
        sub al, 30h


        mov num1, al




        mov ah,09h
        lea dx,text2
        int 21h


        mov ah,01h
        int 21h
        sub al,30h


        mov num2,al


        mov ax,0h
        mov al,num1
        add al,num2
        add al,30h


        mov suma,al




        mov ah,09h
        lea dx, resultado_sum
        int 21h

        mov ah,02h
        mov dl,suma
        int 21h

        mov ah,4ch
        int 21h

    main endp
end main    