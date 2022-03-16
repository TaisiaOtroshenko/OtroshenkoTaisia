.model small
.stack 100h
; Написать три варианта программы, позволяющие работать с исходных данных:
; диапазон от -100 до 100

.data
message 	db 'Offset message','$'
x			db -25
a		 	db -20
b	 		db 27
y			dw 0
; x			db -20
; a		 	db -25
; b	 		db -18
; y			dw 0

.code

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

start:
	mov ax,@data
	mov ds, ax
	mov ah, 0

	mov al, a
	imul al
	xchg bx, ax
	mov al, x 
	imul al
	imul bx ;возникает переполнение
	; mov bl, b
	; ; mWriteAX
	; sub bx, 2
	; idiv bx
	; ; mWriteAX
	; mov cx, ax
	; mov ax, 0

	; mov al, a
	; imul al
	; ; mov bx, 0
	; mov bl, x
	; add al, x
	; mov bl, 5
	; div bl

	; sub cx, ax
	; mov y, cx
	
	; xchg ax, cx
	; mWriteAX

	mov ax, 4c00h
	int 21
end start
END
