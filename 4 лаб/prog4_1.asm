.model small
.stack 100h

.data
bool    db 11100011b

.code
start:
mov ax, @data
mov ds, ax

mov dl, 11110001b
AND DL, BOOL ; E1
mov dl, 11110001b
OR DL, BOOL ;F3
mov dl, 11110001b
XOR DL, BOOL ;12
mov dl, 11110001b
AND DL, 0Ch ; 00 - zf
mov dl, 11110001b
XOR DL, 0FFh ; 0E
mov dl, 11110001b
NOT DL ; 0E

mov ax, 4c00h
int 21h
end start
END