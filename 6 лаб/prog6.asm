.model small
.stack 100h
.data 
buffer      db 10 dup (0)
n           db 10
mass        dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ;10 dup (0)
k           db 6
c           dw 3
d           dw 5

; buffer      db 10 dup (0)
; n           db 10
; mass        dw -100, -200, -400, 100, 1, 2, 3, -500, 0, 5
; k           db 5
; c           dw -500
; d           dw 0

str_mass        db "Input mass ", 10, 13, '$'
str_inp_k       db "Input K ", '$'
str_inp_c       db "Input c ", '$'
str_inp_d       db "Input b ", '$'
str_fin         db " - Answer", '$'
.code
;Ввести с клавиатуры последовательность из N чисел, размером в слово. 
;Найти сумму первых K элементов введенной последовательности удовлетворяющих условию: c<=a[i]<=d. 
;Значение k, c, d задается с клавиатуры. Результат вывести на экран.

mWriteAX macro
    local convert, write
    push ax ; Сохранение регистров, используемых в макросе, в стек
    push bx
    push cx
    push dx
    push di
    mov cx, 10 ; cx - основание системы счисления
    xor di, di ; di - количество цифр в числе
    or ax, ax ; Проверяем, равно ли число в ax нулю и устанавливаем флаги
    jns convert ; Переход к конвертированию, если число в ax положительное
    push ax
    mov dx, '-'
    mov ah, 02h ; 02h - функция вывода символа на экран
    int 21h ; Вывод символа "-"
    pop ax
    neg ax ; Инвертируем отрицательное число
    convert:
    xor dx, dx
    div cx ; После деления dl = остатку от деления ax на cx
    add dl, '0' ; Перевод в символьный формат
    inc di ; Увеличиваем количество цифр в числе на 1
    push dx ; Складываем в стек
    or ax, ax ; Проверяем, равно ли число в ax нулю и устанавливаем флаги
    jnz convert ; Переход к конвертированию, если число в ax не равно нулю
    write: ; Вывод значения из стека на экран
    pop dx ; dl = очередной символ
    mov ah, 02h
    int 21h ; Вывод очередного символа
    dec di ; Повторяем, пока di <> 0
    jnz write
    pop di ; Перенос сохранённых значений обратно в регистры
    pop dx
    pop cx
    pop bx
    pop ax
endm mWriteAX

mReadAX macro buffer, size
local input, startOfConvert, endOfConvert
push bx ; Сохранение регистров, используемых в макросе, в стек
push cx
push dx
input:
mov [buffer], size ; Задаём размер буфера
mov dx, offset [buffer]
mov ah, 0Ah ; 0Ah - функция чтения строки из консоли
int 21h
; mov ah, 02h ; 02h - функция вывода символа на экран
; mov dl, 0Dh
; int 21h ; Переводим каретку на новою строку
mov ah, 02h ; 02h - функция вывода символа на экран
mov dl, 0Ah
int 21h ; Переносим курсор на новою строку
xor ah, ah
cmp ah, [buffer][1] ; Проверка на пустую строку
jz input ; Если строка пустая - переходим обратно к вводу
xor cx, cx
mov cl, [buffer][1] ; Инициализируем переменную счетчика
xor ax, ax
xor bx, bx
xor dx, dx
mov bx, offset [buffer][2] ; bx = начало строки
; (строка начинается со второго байта)
cmp [buffer][2], '-' ; Проверяем, отрицательное ли число
jne startOfConvert ; Если отрицательное - пропускаем минус
inc bx
dec cl
startOfConvert:
mov dx, 10
mul dx ; Умножаем на 10 перед сложением с младшим разрядом
cmp ax, 8000h ; Если число выходит за границы, то
jae input ; возвращаемся на ввод числа
mov dl, [bx] ; Получаем следующий символ
sub dl, '0' ; Переводим его в числовой формат
add ax, dx ; Прибавляем к конечному результату
cmp ax, 8000h ; Если число выходит за границы, то
jae input ; врзвращаемся на ввод числа
inc bx ; Переходим к следующему символу
loop startOfConvert
cmp [buffer][2], '-' ; Ещё раз проверяем знак
jne endOfConvert ; Если знак отрицательный, то
neg ax ; инвертируем число
endOfConvert:
pop dx ; Перенос сохранённых значений обратно в регистры
pop cx
pop bx
endm mReadAX

start:
mov ax, @data
mov ds, ax
mov ax, 0

mov ah, 09h
mov dx, offset str_mass
int 21h

mov cl, n
mov si, offset mass
input_mass:
mReadAX buffer, 10
mov ds:[si+bx], ax
add bx, 2
loop input_mass

mov ah, 09h
mov dx, offset str_inp_k
int 21h
mReadAX buffer, 10
mov k, al

mov ah, 09h
mov dx, offset str_inp_c
int 21h
mReadAX buffer, 10
mov c, ax

mov ah, 09h
mov dx, offset str_inp_d
int 21h
mReadAX buffer, 10
mov d, ax

mov si, offset mass
mov bx, 0
mov ax, 0
mov cl, k

sum_loop:
mov dx, ds:[si+bx]
cmp c, dx
jg next
cmp d, dx
jl next
add ax, dx
next:
add bx, 2 
loop sum_loop

mWriteAX
mov ah, 09h
mov dx, offset str_fin
int 21h

mov ax, 4c00h
int 21h
end start
