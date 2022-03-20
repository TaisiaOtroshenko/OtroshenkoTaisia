.model small
.stack 100h

.data
a       db 10101010b

.code
start:
mov ax, @data
mov ds, ax
mov ax, 0

; mov ax,-5
; mov bl, 2
; idiv bl ; fffe = 1111 1110 = -1

; mov al, -5
; sar al, 1 ; fffd = 1111 1101 = -2

mov al, a
xor al, 01010000b ; старшей части числа все четные биты заменить на противоположные
and al, 11110101b ; младшей части числа все нечетные биты обнулить
shr al, 4 ; результат разделить на 16

mov ax, 4c00h
int 21h
end start
END