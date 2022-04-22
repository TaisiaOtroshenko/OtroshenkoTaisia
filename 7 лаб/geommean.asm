
mDegree macro value, degree ; число в степени находится в памяти
local mulVal, noloop
push cx
push bx
; push ax
push dx
    mov ax, 1
    mov bx, value
    mov cx, degree
    dec cx
    cmp cx, 0
    jz noloop
mulVal:
    mul bx
    loop mulVal
noloop:
mov degree_duff, dx
mov degree_duff+2, ax
pop dx
; pop ax
pop dx
pop cx
endm mDegree


mGeometricMeanForNeg macro array, size_ar
local colLoop, next_el, search
; рабочая часть - вычисление суммы и счет отрицательных чисел
    push ax ; Сохранение регистров, используемых в макросе, в стек
    push bx
    push cx
    push dx
    push si

    xor dx, dx
    xor si, si ; Обнуляем смещение по столбцам
    mov ax, 1
    mov cx, size_ar

    colLoop: ; Внутренний цикл, проходящий по столбцам
    mov bx, array[si] ; bx - смещение по строкам, si - по столбцам
    cmp bx, 0
    jns next_el
    neg bx
    mul bl ; ах - накопитель умножения 
    inc dx ; dx - количество элементов
    next_el:
    add si, 2 ; Переходим к следующему элементу (размером в слово)
    dec cx
    cmp cx, 0
    jnz colLoop

    mWriteAX
    mWriteStr endl
    xchg ax, dx
    mWriteAX
    mWriteStr endl
    xchg dx, ax

; ;---код Димы

    ; mov mulOfElems, ax
    ; mov countOfElems, dx

    ; ;Нам надо подобрать C, для этого переберём cx элементов
    ; ;пока ax <= c^n

    ; ;пусть максимальная степень для C будет 20
    ; mov cx, 20

    ; newDegree:
    ;     mDegree fiveN, twoN
    ; mov ax, degreeResault
    ; ; mWriteAX
    ; ;---конец кода Димы

mov si, ax ; сохранение накопителя
; dx - degree
mov bx, 1 ; первое возможное искомое число
search:
    mDegree bx, dx
    mWriteAX
    mWriteStr tab
    ; cmp si, degree_duff+2
    cmp si, ax
    jmp nloop
    inc bx
jmp search

nloop:
mov ax, bx
; dec ax
mWriteStr med_ariph
mWriteAX
mWriteStr endl
pop si ; Перенос сохранённых значений обратно в регистры
pop dx
pop cx
pop bx
pop ax
endm mGeometricMeanForNeg





;--переменные Димы
mulOfElems dw 1    
countOfElems dw 0
degreeResault dw 0
fiveN dw 5
twoN dw 2
