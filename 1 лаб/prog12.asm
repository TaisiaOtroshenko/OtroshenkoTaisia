.model small
.stack 100h
.data
message 	db 'First message', '$'
pa	 		db 0AEh
pb	 		dw 63BCh
pc	 		dd 63BCDEF3h
mas 		db 9,8,3 dup (0)
pole	  	db 5 dup (" ")
adr 		dw pc
adr_f, l 	dd pc

.code
start:
	mov ax,@data
	mov ds,ax
	mov ah,09h
	mov dx,offset message
	int 21h
	mov ah,7h
	int 21h
	mov ax,4c00h
	int 21h
end start