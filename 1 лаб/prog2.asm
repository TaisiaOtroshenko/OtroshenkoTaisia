.model small
.stack 100h
.data
message 	db 'First message','$'
perem_1 	db 0ffh
perem_2 	dw 3a7fh
perem_3 	dd 0f54d567ah
mas 		db 10 dup (' ')
pole_1  	db 5 dup (?)
adr 		dw. erem_3
adr_full 	dd 11, 34, 56, 23
str1    	db 10,13,'My name is Otroshenko Taisia','$'
str2		db 10,13,'My group ITD-31','$'

.code
start:
	mov ax,@data
	mov ds,ax
	mov ah,09h
	mov dx,offset message
	int 21h
	mov dx,offset str1
	int 21h
	mov dx,offset str2
	int 21h
	mov ah,7h
	int 21h
	mov ax,4c00h
	int 21h
end start