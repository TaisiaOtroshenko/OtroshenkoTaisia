.model small
.stack 100h
.data
<<<<<<< HEAD
	numbers	dw 6,0,1,4,8,2,7,9,5,3
=======
	numbers	dw 0,1,2,3,4,5,6,7,8,9
>>>>>>> 21e52c62b23932e807e355df6cd9e7dd9d2966f4
			;3, 1, 1, 2, 2, 0, 0, 2
			;ax,bx,cx,dx,si,di,bp,sp

	fio 	db "Otroshenko Taisia Vladimirovna"
			;Определить физические адреса заглавных букв
			;Разместить в регистр AL среднюю букву ФИО

			;По адресу равному дню и месяцу Вашего рождения 3112
			;занести год Вашего рождения 2002h
<<<<<<< HEAD
	con	dw 3112h
			;присвоить con 3112h 
=======
	cons	dw 3112h
			;присвоить cons 3112h 
>>>>>>> 21e52c62b23932e807e355df6cd9e7dd9d2966f4
			;Разместить это значение в регистре CX
	nam 	db "Taya"
			;Поместить в переменную nam уменьшительно-ласкательную форму Вашего имени. 
			;Определить адрес nam.

			;В памяти сразу после nam разместить символ, код которого в ASCII-кодах 25+14=39. 
			;А затем через пробел дату Вашего рождения 31122002.
.code
Start:
	mov AX, @Data
	mov DS, AX
;непосредственная (операңд-источник)
	mov bx,1 ; передается значение
	mov sp,2
;регистровая
	mov cx, bx ; значение берется из регистра
;прямая
<<<<<<< HEAD
	mov dx, numbers+10 ; указывается исполнительный адрес (сегмент данных)
;косвенная
	mov bp,offset numbers ; в регистр помещается адрес ячейки памяти
	mov di,ds:[bp+2] ; передется значение регистра, содержащее адрес ячейки памяти
;базовая
	mov si,ds:[bp+10] ; базовый регистр;
;индексная
	mov ax,numbers[si+16] ; индексный регистр
;базовая индексная
	mov bx,ds:[bp][si+2] ; базовые и индексные регистры
=======
	mov dx, numbers+4 ; указывается исполнительный адрес (сегмент данных)
;косвенная
	mov bp,offset numbers ; в регистр помещается адрес ячейки памяти
	mov di,ds:[bp] ; передется значение регистра, содержащее адрес ячейки памяти
;базовая
	mov si,ds:[bp+4] ; базовый регистр;
;индексная
	mov ax,numbers[si+4] ; индексный регистр
;базовая индексная
	mov bx,ds:[bp][si] ; базовые и индексные регистры
>>>>>>> 21e52c62b23932e807e355df6cd9e7dd9d2966f4
; fio - средняя буква
	mov al, fio+15
; задание 5 - разместить по адресу число
	mov bx, 3112h
	mov bp,2002h
	mov ds:[bx],bp
; Разместить значение сonst в регистре CX
<<<<<<< HEAD
	mov cx, con
=======
	mov cx, cons
>>>>>>> 21e52c62b23932e807e355df6cd9e7dd9d2966f4
; nam - определить адрес
	mov bx, offset nam
; поместить символ после nam и через пробел дату рождения
	mov al, 39h
	mov ds:[bx+4], al
	mov al, " "
	mov ds:[bx+5], al
	mov ds:[bx+6], cx
	mov ds:[bx+8], bp
	mov AX, 4C00h
	int 21
end Start
END
