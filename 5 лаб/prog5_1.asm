.model small
.stack 100h
.data
a       db -15
x       db 5
y       dw 0
.code
start:
mov ax, @data
mov ds, ax
mov ax, 0

cmp x, 5 ; первая часть выражения
jnl y1_2
mov al, x
sal al, 1 ; умножение на два
jmp sec_

y1_2:
    mov al, a
    cmp al, 0
    js abs_
    abs_rtn:
        add al, x ; сложение a и x
jmp sec_

abs_: ; модуль числа
    xor al, 0FFh ;? 01111111b
    add al, 1
jmp abs_rtn

sec_: ; вторая часть выражения
    xchg ax, dx ; сохранение результата

    cmp x, 0
    jz y2_2
    cmp a, 0 ; поместить байт в слово с сохранением знака
    jns z_sign
    mov ah, 0FFh
    z_sign:
    mov al, a
    idiv x
jmp thr_
y2_2:
    mov al, 4
jmp thr_

thr_: ; третья часть выражения
imul dl
mov y, ax 

mov ax,4c00h
int 21h
end start