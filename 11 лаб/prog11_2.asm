.model small
.data
action      db 0
msg	        db 'Hello, World!!!$'
 
.stack 256
.code
 
start:
    JUMPS
    mov ax,@data        
    mov ds,ax
        
    mov ax,351Ch ; получаем старый вектор прерывания
    int 21h

    mov word  ptr  cs:Old1c,BX  ; заносим его в память
    mov word  ptr  cs:Old1c+2,ES
    
    mov ax,251Ch ; устанавливаем свой вектор прерывания
    push ds         
    push cs ; помещаем в сегмент кода область нашего прерывания
    pop ds          
    mov dx,offset  New1c   
    int 21h  
    pop ds          
    mov ax,3
    int 10h         
    mov ax,0B800h ; записываем адрес графического буфера
    mov es,ax       
    mov ah,15       
    xor di,di       
    mov al,0  
    mov AH,0Fh
    int 10h ; получение видеорежима
    mov ah, 02h
    mov dx, 0B20h
    int 10h ; установка курсора
    mov dx, offset msg
    mov ah, 09h
    int 21h ; вывод сообщения

enter_action: 
    cmp action,-1       
    jz exit           
    cmp action,1        
    jz up         
    cmp action,2       
    jz down            
    jmp enter_action          
up:   
    mov bx,2        
l4: 
    mov dx,es:[bx]      
    mov cx, 4000
l3: 
    cmp bx, 160
    jg skip
        push bx
        mov ax,es:[bx+160]
        add bx, 4160
        mov es:[bx],ax  
        pop bx  
    skip:      
    mov ax,es:[bx+160]  
    mov es:[bx],ax     
    add bx, 2           
    loop l3         
    mov es:[bx],dx      
    add bx,2        
    cmp bx, 4000     
    jb l4           
    mov action,0        
    jmp enter_action          
down:  
    mov bx, 4000      
l14:    
    mov dx,es:[bx]
    mov cx, 1896
l13:    
    cmp bx, 3840
    jl skip2
        push bx
        mov ax,es:[bx]
        sub bx, 3840
        mov es:[bx],ax 
        pop bx 
    skip2:
    mov ax,es:[bx-160]
    mov es:[bx],ax  
    sub bx, 2 
    loop l13   
    mov es:[bx],dx
    sub bx, 2      
    cmp bx, 0
    jl l14      
    mov action,0     
    jmp enter_action          
    
exit: 
    mov ax,251ch        
    lds dx,cs:old1c ; возвращаем старый вектор прерывания       
    int 21h         
    mov ax,4c00h    
    int 21h
    NOJUMPS

Old1c   dd  ?    
New1c  proc        
    pushf           
    call    dword   ptr CS:[Old1c]  
    cli ; маскирование прерываний
    push ds         
    push ax
    mov ax,@data
    mov ds,ax   
    mov ah,1        
    int 16h  ; ввод с клавиатуры       
    jz ex1c         
    mov ah,0        
    int 16h 

    cmp al, '0' ; выход из приложения     
    jnz nesc
    mov action,-1       
    jmp ex1c        
nesc:   
    cmp al,'1'      
    jb ex1c         
    cmp al,'2'                
    ja ex1c                  
    sub al,'0'      
    mov action,al       
ex1c: ; звершение прерывания
    pop ax      
    pop ds
    sti 
    iret         
New1c  endp
end start