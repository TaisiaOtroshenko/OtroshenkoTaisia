.model tiny
.code
.386
org 100h

    mPrint macro string
        pusha

        mov ax, 0900h
        lea dx, string
        int 21h

        popa
    endm

start:
    mov ax, 3D00h
    xor cx, cx
    lea dx, input_file_name
    int 21h

    mov input_file_ID, ax
    jc opening_error  

    mov ax, 3C00h
    xor cx, cx
    lea dx, output_file_name
    int 21h

    mov output_file_ID, ax
    jc creation_error
    
    lea di, string
    lea si, string

    mov ax, 0
    push ax
    push ax

file_read_loop:
    mov ax, 3F00h
    mov bx, input_file_ID
    mov cx, 1
    lea dx, char
    int 21h

    jc read_error

    cmp ax, 0
    je end_file_read_loop
    
    mov al, char
    cmp al, 0Dh
    je end_of_line

    pop bx
    pop cx
    cmp bx, 1
    jne save_char

    inc cx
    xor ah, ah
    push ax
    jmp continue_file_read_loop

save_char:
    stosb

continue_file_read_loop:
    push cx
    push bx
    jmp file_read_loop

end_of_line:
    pop bx
    pop cx
    cmp bx, 1
    jne save_end_line

reverse_loop:
    pop ax
    stosb
    loop reverse_loop

save_end_line:
    push cx
    push bx
    mov al, 0Dh
    stosb

    mov ax, 3F00h
    mov bx, input_file_ID
    mov cx, 1
    lea dx, char
    int 21h

    pop ax
    inc ax
    push ax

    jmp file_read_loop

end_file_read_loop:

    sub di, si

    mov ax, 4000h
    mov bx, output_file_ID
    mov cx, di
    lea dx, string
    int 21h

    jc write_error

    mov ax, 3E00h
    mov bx, input_file_ID
    int 21h

    mov ax, 3E00h
    mov bx, output_file_ID
    int 21h

    mPrint completion_message
    jmp end_program

opening_error:
    mPrint opening_error_message
    jmp end_program

creation_error:
    mPrint creation_error_message
    jmp end_program

read_error:
    mPrint read_error_message
    jmp end_program

write_error:
    mPrint write_error_message
    jmp end_program

end_program:
    mov ax, 4C00h
    int 21h

; данные
input_file_name  db "ifile.txt", 0
output_file_name db "ofile.txt", 0

input_file_ID  dw ?
output_file_ID dw ?

opening_error_message  db "File could not be opened", "$"
creation_error_message db "File could not be created", "$"
read_error_message     db "File could not be read", "$"
write_error_message    db "Error in writing in the file", "$"
completion_message     db "Program completed successfully", "$"

char_buffer db 2, ?
char        db ?, ?
string      db 256 dup(?)

end start
