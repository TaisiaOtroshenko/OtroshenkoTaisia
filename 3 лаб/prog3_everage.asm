.model small
.stack 100h
; диапазон значений данных от -15 до 15
.data
x			db -10
a		 	db -10
b	 		db 12
; x			db 5
; a		 	db 2
; b	 		db 3
y			dw 0


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
	imul bx

	mov bl, b
	sub bl, 2
	idiv bx 
      xchg ax, cx;сохранение результата первого выражения

	mov al, a
	imul al
	add al, x
	mov bl, 5
	idiv bl

	mov ah, 0

	sub cx, ax
	mov y, cx
	
	mov ax, 4c00h
	int 21
end start
END    
