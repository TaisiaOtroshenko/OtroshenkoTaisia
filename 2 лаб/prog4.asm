.model small
.stack 100h
.data
	W_TAB dw 7h
	B_TAB db 12
	W_TAB2 dw 1Dh
.code
Start:
	mov AX, @Data
	mov DS, AX

;непосредственная (операңд-источник)
	mov al,-3
	mov ax,3
	mov B_TAB,-3
	mov W_TAB,-3
	mov ax,2A1Bh
;регистровая
	mov bl,al
	mov bh,al
	sub ax,bx
	sub ax,ax
;прямая
	mov ax,W_TAB
	mov ax,W_TAB+3 ; смещение адреса
	mov ax,W_TAB+5
	mov al,byte ptr W_TAB+6
	mov al,B_TAB
	mov al,B_TAB+2
	mov ax,word ptr B_TAB
	mov es:W_TAB2+4,ax
;косвенная
	mov bx,offset B_TAB ;относительный адрес
	mov si,offset B_TAB+1
	mov di,offset B_TAB+2
	mov dl,[bx] ;взятие значения по адресу
	mov dl,[si]
	mov dl,[di]
	mov ax,[di]
	mov bp,bx
	mov al,[bp]
	mov al,ds:[bp]
	mov al,es:[bx]
	mov ax,cs:[bx]
;базовая
	mov ax,[bx]+2 ;в сегменте данных 
	mov ax,[bx]+4
	mov ax,[bx+2]
	mov ax,[4+bx]
	mov ax,2+[bx]
	mov ax,4+[bx]
	mov al,[bx]+2
	mov bp,bx
	mov ax,[bp+2]
	mov ax,ds:[bp]+2
	mov ax,ss:[bx+2]
;индексная
	mov si,2
	mov ah,B_TAB[si]
	mov al,[B_TAB+si]
	mov bh,[si+B_TAB]
	mov bl,[si]+B_TAB
	mov bx,es:W_TAB2[si]
	mov di,4
	mov bl,byte ptr es:W_TAB2[di]
	mov bl,B_TAB[si]
;базовая индексная
	mov bx,offset B_TAB
	mov al,3[bx][si]
	mov ah,[bx+3][si]
	mov al,[bx][si+2]
	mov ah,[bx+si+2]
	mov bp,bx
	mov ah,3[bp][si]
	mov ax,ds:3[bp][si]
	mov ax,word ptr ds:2[bp][si]

	mov AX, 4C00h
	int 21
end Start
END
