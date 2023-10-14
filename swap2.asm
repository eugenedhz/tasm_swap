.model small
.data
    init_array dw 20,30,40,50,-50,-40,-30,-20  ; Двухбайтовый массив чисел
    len equ $-init_array
    array dw len dup (?) ; Резервируем место под изменённый массив
    input_msg db 'Innput: ', '$'
    output_msg db 'Output: ', '$'
    divider dw 10
    mult dw -1

.code

mov ax, @data
mov ds, ax

mov cx, len/2
lea si, init_array
lea di, array

transport_loop:
    mov ax, [si]     ; Загружаем двухбайтовое значение из init_array
    mov [di], ax     ; Сохраняем его в array
    add di, 2        ; Увеличиваем di на 2, чтобы перейти к следующему двухбайтовому элементу
    add si, 2        ; Увеличиваем si на 2
    loop transport_loop

mov cx, len/4       ; Сколько пар чисел в массиве
lea si, array   ; Загрузка адреса массива в SI

swap_loop:
    mov ax, [si]       ; Загружаем значение текущего элемента массива в AL
    mov bx, [si+2]     ; Загружаем значение следующего элемента массива в BL

    mov [si], bx       ; Меняем местами значения текущего и следующего элементов
    mov [si+2], ax

    add si, 4          ; Увеличиваем указатель на 2 байта, переходя к следующей паре элементов
    loop swap_loop     ; Продолжаем цикл, пока не обработаем все элементы

mov cx, len/2                  ; Количество элементов в массиве
lea si, init_array           ; Загрузка адреса массива в SI

mov dx, offset input_msg
call print_msg

call print ; выведем начальнй массив

mov ah, 02h    ; Установить функцию 02h - вывод символа
mov dl, 0Ah    ; Загрузить символ перевода строки (ASCII 10) в dl
int 21h

mov cx, len/2       ; Количество элементов в массиве
lea si, array   ; Загрузка адреса массива в SI

mov dx, offset output_msg
call print_msg

call print ; выведем полученный массив

mov ah, 4Ch     ; Выход из программы
int 21h

print_msg:
    mov ah, 09h
    int 21h

    ret

print:
    print_loop:
        mov ax, [si]            ; Загрузка байта из массива в AL
        cmp ax, 0               ; проверка на отрицательность числа
        jl print_with_minus     ; если отрицательное, выведем с минусом
        call print_2_digits     ; иначе вывести просто двухзначеное число
    ret

print_with_minus:
    mov bx, mult
    mul bx

    mov bx, ax

    mov dl, '-'
    mov ah, 02h
    int 21h

    mov ax, bx

    call print_2_digits

    ret


print_2_digits:          ; так как невозможно вывести двухзначное число, создадим соответствующую функцию
    mov bx, divider
    xor dx, dx
    div bx

    mov bx, dx

    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    add bl, '0'
    mov dl, bl
    mov ah, 02h
    int 21h

    mov dl, ' '
    mov ah, 02h
    int 21h

    add si, 2               ; Перейти к следующему элементу массива
    loop print_loop         ; Повторять для всех элементов массива

    ret

end
