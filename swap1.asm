.model small
.data
    init_array db 1,3,5,7,9,11,13,15  ; Ваш однобайтовый массив чисел
    len equ $-init_array
    array db len dup (?)
    input_msg db 'Innput: ', '$'
    output_msg db 'Output: ', '$'

.code

mov ax, @data
mov ds, ax

mov cx, len
lea si, init_array
lea di, array

transport_loop:
	mov al, [si]
	mov [di], al
	inc di
	inc si
	loop transport_loop

mov cx, len/2       ; Сколько пар чисел в массиве
lea si, array   ; Загрузка адреса массива в SI

swap_loop:
    mov al, [si]       ; Загружаем значение текущего элемента массива в AL
    mov bl, [si+1]     ; Загружаем значение следующего элемента массива в BL

    mov [si], bl       ; Меняем местами значения текущего и следующего элементов
    mov [si+1], al

    add si, 2          ; Увеличиваем указатель на 2 байта, переходя к следующей паре элементов
    loop swap_loop     ; Продолжаем цикл, пока не обработаем все элементы

mov cx, len                    ; Количество элементов в массиве
lea si, init_array           ; Загрузка адреса массива в SI

mov dx, offset input_msg
call print_msg

call print ; выведем начальнй массив

mov ah, 02h    ; Установить функцию 02h - вывод символа
mov dl, 0Ah    ; Загрузить символ перевода строки (ASCII 10) в dl
int 21h

mov cx, len       ; Количество элементов в массиве
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
	    mov al, [si]            ; Загрузка байта из массива в AL
	    cmp al, 10              ; Сравнение с 10 (для определения двузначных чисел)
	    jl print_digit          ; Если число однозначное, перейти к выводу
	    call print_2_digits     ; иначе вывести двухзначеное число
	ret

print_digit:
    add al, '0'             ; Преобразовать число в символ
    mov dl, al
    mov ah, 02h             ; Сервисная функция вывода одного символа
    int 21h

    call print_space

    inc si                  ; Перейти к следующему элементу массива
    loop print_loop         ; Повторять для всех элементов массива

    ret

print_space:
	mov dl, ' '
    mov ah, 02h
    int 21h

    ret

print_2_digits:          ; так как невозможно вывести двухзначное число, создадим соответствующую функцию
	mov bl, 10
    xor ah, ah
    div bl

    mov bl, ah

    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    add bl, '0'
    mov dl, bl
    mov ah, 02h
    int 21h

    call print_space

    inc si                  ; Перейти к следующему элементу массива
    loop print_loop         ; Повторять для всех элементов массива

    ret

end
