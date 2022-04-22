.model small
.stack 100h
.data
nam     db 'Otroshenko$'
fk      db 'IUK$'
gr      db '31$'
s       db '!!!!!$'
; t       db 4 dup (09h)
; h       db 32 dup (03h)
menu    db 'Menu',13,10
        db 4 dup (09h),'1 - a = 4, x = 1',13,10 ; 8
        db 4 dup (09h),'2 - a = -15, x = 5', 13,10 ; -60
        db 4 dup (09h),'3 - a = 4, x = 0', 13,10 ; 0
        db 4 dup (09h),'0 - Exit', 13,10,'$'
select  db 4 dup (09h),'Select > $'
output  db 'Answer ready $'
a       db 4, -15, 4
x       db 1, 5, 0
y       dw 0
msg1    db 'hjckhc'
.code
start:
mov ax,@data
mov ds, ax

; установка видеорежима
mov ah, 0fh
int 10h
mov ah, 00
int 10h
mov ah, 09h  ; розовый фон из сердечек)))))))))))))))))  
    mov bl, 75h
    mov cx, 0FFFFh
    int 10h

вывод информации по углам
    ; лев верх
    mov ah, 09h    
    mov bl, 05h; цвет
    mov cx, 15 ; hehe случайные сердечки))
    int 10h
    mov dh, 0
    mov dl, 1
    int 10h
    mov ah, 09 
    lea dx, nam
    int 21h
    ; вниз
    mov ah, 02
    mov dh, 24
    mov dl, 1
    int 10h

    mov ah, 09h    
    mov bl, 82h; цвет
    mov cx, 5
    int 10h

    mov ah, 09 
    lea dx, s
    int 21h
    ; право верх
    mov ah, 02
    mov dh, 0
    mov dl, 76
    int 10h
    mov ah, 09 
    lea dx, fk
    int 21h
    ; вниз
    mov ah, 02
    mov dh, 24
    mov dl, 77
    int 10h
    mov ah, 09 
    lea dx, gr
    int 21h

; меню 
mov ah, 02
mov dh, 8
mov dl, 38
int 10h
mov ah, 09h
lea dx, menu
int 21h

select_loop:
    mov ah,09h
    lea dx, select
    int 21h

    mov ah,01h
    int 21h

    mov bl, al
    sub bl, 31h
    mov di, offset a
    mov si, offset x
    mov ch, si[bx]; - для х
    mov cl, di[bx]; - для a
    cmp al,'0'
    jz exit
    cmp al,'1'
    jz cal
    cmp al,'2'
    jz cal
    cmp al,'3'
    jz cal
jmp select_loop

cal: ; взято из prog5_2 с заменой а на di[bx], x на si[bx] и bl на dl
    mov ax, 0

    cmp ch, 5 ; первая часть выражения
    jnl y1_2
    mov al, ch
    sal al, 1 ; умножение на два
    jmp sec_

    y1_2:
        mov al, cl
        cmp al, 0
        js abs_
        abs_rtn:
            add al, ch ; сложение a и x
    jmp sec_

    abs_: ; модуль числа
        xor al, 0FFh
        add al, 1
    jmp abs_rtn

    sec_: ; вторая часть выражения
        xchg ax, dx ; сохранение результата

        cmp ch, 0
        jz y2_2
        cmp cl, 0 ; поместить байт в слово с сохранением знака
        jns z_sign
        mov ah, 0FFh
        z_sign:
        mov al, cl
        idiv ch
    jmp thr_
    
    y2_2:
        mov al, 4
    jmp thr_

    thr_: ; третья часть выражения
    imul dl
    mov y, ax 

    ;вывод ответа
    mov ah, 02
    mov dh, 14
    mov dl, 32
    int 10h
    mov ah, 09h
    lea dx, output
    int 21h

exit:
mov ax,4c00h
int 21h
end start
