.model small
.stack 100h
.data
	numbers	dw 0,1,2,3,4,5,6,7,8,9
			;3, 1, 1, 2, 2, 0, 0, 2
			;ax,bx,cx,dx,si,di,bp,sp

	fio 	db "Otroshenko Taisia Vladimirovna"
			;Определить физические адреса заглавных букв
			;Разместить в регистр AL среднюю букву ФИО

			;По адресу равному дню и месяцу Вашего рождения 3112
			;занести год Вашего рождения 2002h
	const	dw 3112h
			;присвоить const 3112h 
			;Разместить это значение в регистре CX
	name 	db "Taya"
			;Поместить в переменную name уменьшительно-ласкательную форму Вашего имени. 
			;Определить адрес name.

			;В памяти сразу после name разместить символ, код которого в ASCII-кодах 25+14=39. 
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
; fio - средняя буква
	mov al, fio+15
; задание 5 - разместить по адресу число
	mov bx, 3112h
	mov bp,2002h
	mov ds:[bx],bp
; Разместить значение сonst в регистре CX
	mov cx, const
; name - определить адрес
	mov bx, offset name
; поместить символ после name и через пробел дату рождения
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
