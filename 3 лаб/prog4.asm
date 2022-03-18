.model small
.stack 100h
.data
;1.1) В сегменте данных определить:
; байтовые значения Хi, a, b, c, d в десятичной системе счисления;
;1.2) В сегменте данных зарезервировать байтовые ячейки для хранения:
; суммы и разности с нулевыми первоначальными значениями, 
; двухбайтовую ячейку для хранения произведения с единичным первоначальным значением, 
; две байтовые ячейки для хранения остатка от деления и частного с произвольными первоначальными значениями.
;1.3) Написать программу на языке Ассемблер, которая выполняет следующие операции над байтовыми значениями.
; из каждого целого числа Xi, где (i = 1, 2, 3), требуется вычесть число a , 
; к результату добавить число b,
; полученный результат умножить на число c,
; полученный результат разделить на число d. 
; Определить сумму инкремента неполного частного e и декремента остатка от деления f.
;1.4.) Результаты работы программ вместе с их листингами внести в отчет и сравнить со 
;значениями, полученными при выполнении тех же вычислений вручную.


; message 	db 'Offset message','$'
;1.1
xi			db 0
a		 	db 29
b	 		db 13h
c		 	db 13
d 			db 12
;x1	 		db 68
;x2			db 81h
;x3			db 252

;1.2
summ			db 0
diff			db 0
multi			dw 1
all				dw 0
part			db 0


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

;1 часть
	mov ah, 00
	mov xi, 68
;вычитание
	mov al, xi
	sub al, a
	mov diff, al
;сложение
	mov summ, al
	mov al, b
	add al, summ
;умножить
	mul c
	mov multi, ax
;делить
	div d
	mov byte ptr all, al
	mov byte ptr part, ah

;2 часть
	mov ah, 00
	mov xi, 81h
;вычитание
	mov al, xi
	sub al, a
	mov diff, al
;сложение
	mov summ, al
	mov al, b
	add al, summ
;умножить
	mul c
	mov multi, ax
;делить
	div d
	mov byte ptr all, al
	mov byte ptr part, ah

;3 часть
	mov ah, 00
	mov xi, 252
;вычитание
	mov al, xi
	sub al, a
	mov diff, al
;сложение
	mov summ, al
	mov al, b
	add al, summ
;умножить
	mul c
	mov multi, ax
;делить
	mov bl, d
	div bx
	mov all, ax
	mov part, dl
	
;учет переполнения
	;jnc dop_sum
	;adc word ptr l+2, 0
	;dop_sum:
	mov ax, 4c00h
	int 21
end start
END

