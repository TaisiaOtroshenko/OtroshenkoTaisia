.model small
.stack 100h

;Дана матрица.
;а) В каждой строке разместить вначале нулевые элементы, затем все остальные. 
;б) Проверить строки с нечётными номерами на возрастание, с чётными номерами – на убывание. 
;в) Найдите среднее арифметическое положительных чисел среди элементов матрицы, выделенных чѐрным цветом.
mWriteAX macro
    local convert, write
    push ax ; Сохранение регистров, используемых в макросе, в стек
    push bx
    push cx
    push dx
    push di
    mov cx, 10 ; cx - основание системы счисления
    xor di, di ; di - количество цифр в числе
    or ax, ax ; Проверяем, равно ли число в ax нулю и устанавливаем флаги
    jns convert ; Переход к конвертированию, если число в ax положительное
    push ax
    mov dx, '-'
    mov ah, 02h ; 02h - функция вывода символа на экран
    int 21h ; Вывод символа "-"
    pop ax
    neg ax ; Инвертируем отрицательное число
    convert:
    xor dx, dx
    div cx ; После деления dl = остатку от деления ax на cx
    add dl, '0' ; Перевод в символьный формат
    inc di ; Увеличиваем количество цифр в числе на 1
    push dx ; Складываем в стек
    or ax, ax ; Проверяем, равно ли число в ax нулю и устанавливаем флаги
    jnz convert ; Переход к конвертированию, если число в ax не равно нулю
    write: ; Вывод значения из стека на экран
    pop dx ; dl = очередной символ
    mov ah, 02h
    int 21h ; Вывод очередного символа
    dec di ; Повторяем, пока di <> 0
    jnz write
    pop di ; Перенос сохранённых значений обратно в регистры
    pop dx
    pop cx
    pop bx
    pop ax
endm mWriteAX
mReadAX macro buffer, size
local input, startOfConvert, endOfConvert
push bx ; Сохранение регистров, используемых в макросе, в стек
push cx
push dx
input:
mov [buffer], size ; Задаём размер буфера
mov dx, offset [buffer]
mov ah, 0Ah ; 0Ah - функция чтения строки из консоли
int 21h
; mov ah, 02h ; 02h - функция вывода символа на экран
; mov dl, 0Dh
; int 21h ; Переводим каретку на новою строку
mov ah, 02h ; 02h - функция вывода символа на экран
mov dl, 0Ah
int 21h ; Переносим курсор на новою строку
xor ah, ah
cmp ah, [buffer][1] ; Проверка на пустую строку
jz input ; Если строка пустая - переходим обратно к вводу
xor cx, cx
mov cl, [buffer][1] ; Инициализируем переменную счетчика
xor ax, ax
xor bx, bx
xor dx, dx
mov bx, offset [buffer][2] ; bx = начало строки
; (строка начинается со второго байта)
cmp [buffer][2], '-' ; Проверяем, отрицательное ли число
jne startOfConvert ; Если отрицательное - пропускаем минус
inc bx
dec cl
startOfConvert:
mov dx, 10
mul dx ; Умножаем на 10 перед сложением с младшим разрядом
cmp ax, 8000h ; Если число выходит за границы, то
jae input ; возвращаемся на ввод числа
mov dl, [bx] ; Получаем следующий символ
sub dl, '0' ; Переводим его в числовой формат
add ax, dx ; Прибавляем к конечному результату
cmp ax, 8000h ; Если число выходит за границы, то
jae input ; врзвращаемся на ввод числа
inc bx ; Переходим к следующему символу
loop startOfConvert
cmp [buffer][2], '-' ; Ещё раз проверяем знак
jne endOfConvert ; Если знак отрицательный, то
neg ax ; инвертируем число
endOfConvert:
pop dx ; Перенос сохранённых значений обратно в регистры
pop cx
pop bx
endm mReadAX
mTransposeMatrix macro matrix, row, col, resMatrix
local rowLoop, colLoop
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push di
push si
push dx
xor di, di ; Обнуляем смещение по строкам
mov cx, row
rowLoop: ; Внешний цикл, проходящий по строкам
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
colLoop: ; Внутренний цикл, проходящий по столбцам
mov ax, col
mul di ; Устанавливаем смещение по строкам
add ax, si ; Устанавливаем смешение по столбцам
mov bx, ax
mov ax, matrix[bx]
push ax ; Заносим текущий элемент в стек
mov ax, row
mul si ; Устанавливаем смещение по строкам
add ax, di ; Устанавливаем смешение по столбцам
; (смещения по строкам и столбцам меняются 
; местами по сравнению с оригинальной матрицей)
mov bx, ax
pop ax
mov resMatrix[bx], ax ; Заносим в новую матрицу элемент,
 ; сохранённый в стеке
add si, 2 ; Переходим к следующему элементу
; (размером в слово)
loop colLoop
add di, 2 ; Переходим к следующей строке
pop cx
loop rowLoop
pop dx ; Перенос сохранённых значений обратно в регистры
pop si
pop di
pop cx
pop bx
pop ax
endm mTransposeMatrix

mWriteStr macro string
push ax ; Сохранение регистров, используемых в макросе, в стек
push dx
mov ah, 09h ; 09h - функция вывода строки на экран
mov dx, offset string
int 21h
pop dx ; Перенос сохранённых значений обратно в регистры
pop ax
endm mWriteStr

mReadMatrix macro matrix, row, col
local rowLoop, colLoop
JUMPS ; Директива, делающая возможным большие прыжки
push bx ; Сохранение регистров, используемых в макросе, в стек
push cx
push si
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop: ; Внешний цикл, проходящий по строкам
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
colLoop: ; Внутренний цикл, проходящий по столбцам
mReadAX buffer 4 ; Макрос ввода значения регистра AX с клавиатуры
; [Приложение 1]
mov matrix[bx][si], ax
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop
mWriteStr endl ; Макрос вывода строки на экран [Приложение 3]
; Перенос курсора и каретки на следующую строку
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop
pop si ; Перенос сохранённых значений обратно в регистры
pop cx
pop bx
NOJUMPS ; Прекращение действия директивы JUMPS
endm mReadMatrix
mWriteMatrix macro matrix, row, col
local rowLoop, colLoop
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop: ; Внешний цикл, проходящий по строкам
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
colLoop: ; Внутренний цикл, проходящий по столбцам
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
mWriteAX ; Макрос вывода значения регистра AX на экран [Приложение 2]
; Вывод текущего элемента матрицы
xor ax, ax
mWriteStr tab ; Макрос вывода строки на экран *Приложение 3]
; Вывод на экран табуляции, разделяющей элементы строки
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop
mWriteStr endl ; Макрос вывода строки на экран *Приложение 3]
; Перенос курсора и каретки на следующую строку
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop
pop si ; Перенос сохранённых значений обратно в регистры
pop cx
pop bx
pop ax
endm mWriteMatrix
mSearchPositiveRows macro matrix, row, col
local rowLoop, colLoop, positiveNumber, nonzeroNumber
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
push di
push dx
mov di, 1 ; di - счётчик строк, начиная с единицы
xor dx, dx ; dx - счётчик отрицательных чисел в строке
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop:
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
colLoop:
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
or ax, ax ; Проверяем, отрицательное ли число
jns positiveNumber ; Если найдено отрицательное число, то
inc dx ; Увеличиваем счётчик отрицательных числе в строке
positiveNumber:
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop
or dx, dx ; Проверяем счётчик отрицательных чисел на равенство 0
jnz nonzeroNumber ; Если счётчик отрицательных чисел строки пуст, то:
mov ax, di
mWriteAX ; Макрос вывода значения регистра AX на экран [Приложение 2]
; Выводим номер текущей строки
mWriteStr space ; Макрос вывода строки на экран [Приложение 3]
; Выводим пробел между номерами строк
nonzeroNumber:
xor dx, dx ; Обнуляем счётчик отрицательных чисел
inc di ; Увеличиваем счётчик строк
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop
pop dx ; Перенос сохранённых значений обратно в регистры
pop di
pop si
31
pop cx
pop bx
pop ax
endm mSearchPositiveRows
mGetSumAboveMainDiagonal macro matrix, row, col
local rowLoop, colLoop, belowTheDiagonal
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
push di
push dx
xor dx, dx ; В dx будет храниться окончательная сумма нужных элементов
xor di, di ; di - счётчик строк
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop:
push cx
xor si, si ; si - счётчик столбцов
mov cx, col
colLoop:
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
cmp si, di ; Сравниваем счётчики строк и столбцов
jbe belowTheDiagonal ; Если элемент выше главной диагонали,
add dx, ax ; то добавляем его к результату
belowTheDiagonal:
add si, 2 ; Увеличиваем смещение по столбцу/счётчик столбцов
loop colLoop
add di, 2 ; Увеличиваем счётчик строк
22
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop
mov ax, dx
mWriteAX ; Макрос вывода значения регистра AX на экран [Приложение 2]
; Вывод на экран результата
pop dx ; Перенос сохранённых значений обратно в регистры
pop di
pop si
pop cx
pop bx
pop ax
endm mGetSumAboveMainDiagonal
mSumOfRowElements macro matrix, row, col, min, max
local rowLoop, colLoop, conditions
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
push dx
xor dx, dx ; Обнуляем регистр для сохранения результата суммы элементов
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop: ; Внешний цикл, проходящий по строкам
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
colLoop: ; Внутренний цикл, проходящий по столбцам
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
cmp ax, max ; Проверяем элемент массива на условие A >= min
jg conditions
cmp ax, min ; Проверяем элемент массива на условие A <= max
jl conditions
add dx, ax ; Суммируем все элементы, которые входят в границы [min..max]
conditions:
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop
mov ax, dx
mWriteAX ; Макрос вывода значения регистра AX на экран [Приложение 2]
; Выводим на экран сумму элементов на данной строке матрицы
mWriteStr endl ; Макрос вывода строки на экран [Приложение 3]
; Перенос курсора и каретки на следующую строку
xor dx, dx
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop
pop dx ; Перенос сохранённых значений обратно в регистры
pop si
pop cx
pop bx
pop ax
endm mSumOfRowElements
mZiroBeforeMatrix macro matrix, row, col, resMatrix
local rowLoop, colLoop, colLoopReverse, zs, placeziro, next
    push ax ; Сохранение регистров, используемых в макросе, в стек
    push bx
    push cx
    push di
    push si
    push dx
xor di, di ; Обнуляем смещение по строкам
mov cx, row
rowLoop: ; Внешний цикл, проходящий по строкам
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
mov dx, 0
colLoop: ; Внутренний цикл, проходящий по столбцам
mov ax, col
mul di ; Устанавливаем смещение по строкам
add ax, si ; Устанавливаем смешение по столбцам
mov bx, ax
mov ax, matrix[bx]
cmp ax, 0
je zs
    inc dx ; dx хранит количество ненулевых элементов
    push ax ; Заносим текущий элемент в стек
zs:
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop

mov cx, col
colLoopReverse: ; Внутренний цикл, проходящий по столбцам
mov ax, col
mul di ; Устанавливаем смещение по строкам
add ax, si ; Устанавливаем смешение по столбцам
mov bx, ax
cmp dx, 0
je placeziro
    pop ax
    mov matrix[bx], ax
    dec dx
    jmp next
placeziro:
mov matrix[bx], 0
next:
sub si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoopReverse

add di, 2 ; Переходим к следующей строке
pop cx
loop rowLoop
    pop dx ; Перенос сохранённых значений обратно в регистры
    pop si
    pop di
    pop cx
    pop bx
    pop ax
endm mZiroBeforeMatrix



mGetAverageAboveDiagonal macro matrix, row, col
local rowLoop, colLoop, belowTheDiagonal
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
push di
push dx
xor ax, ax ; сумма элементов
xor dx, dx ; кол-во элементов
xor di, di ; di - счётчик строк
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop:
push cx
xor si, si ; si - счётчик столбцов
mov cx, col
colLoop:

cmp di, si ; Сравниваем счётчики строк и столбцов
ja belowTheDiagonal ; Если элемент ниже побочной диагонали, перейти к следующему
push ax
push dx
mov dx, col
inc dx
mov ax, si
add ax, di
cmp ax, dx
pop dx
pop ax
jae belowTheDiagonal
add ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
inc dx
belowTheDiagonal:
add si, 2 ; Увеличиваем смещение по столбцу/счётчик столбцов
dec cx
cmp cx, 0
jne colLoop
add di, 2 ; Увеличиваем счётчик строк
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
dec cx
cmp cx, 0
jne rowLoop
div dl
mov ah, 0
mWriteStr med_ariph
mWriteAX ; Макрос вывода значения регистра AX на экран
mWriteStr endl
pop dx ; Перенос сохранённых значений обратно в регистры
pop di
pop si
pop cx
pop bx
pop ax
endm mGetAverageveDiagonal


mTestIncrease macro matrix, row, col
local rowLoop, colLoop, colLoop1, parity, next_str
JUMPS
push ax ; Сохранение регистров, используемых в макросе, в стек
push bx
push cx
push si
push di
push dx
mov di, 1 ; di - счётчик строк, начиная с единицы
xor bx, bx ; Обнуляем смещение по строкам
mov cx, row
rowLoop:
push cx
xor si, si ; Обнуляем смещение по столбцам
mov cx, col
dec cx

mov ax, di
mov dx, 2h
div dl
cmp ah, 0
jnz parity

colLoop:
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
cmp ax, matrix[bx][si+2]; сравниваем со следующим
jl next_str ; если не подходит под условие - перейти к следующей строке
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop

mov ax, di
mWriteAX ; Выводим номер текущей строки
mWriteStr dec_str ; тип проверки
jmp next_str

parity:
colLoop1:
mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
cmp ax, matrix[bx][si+2]; сравниваем со следующим
jg next_str ; если не подходит под условие - перейти к следующей строке
add si, 2 ; Переходим к следующему элементу (размером в слово)
loop colLoop1

mov ax, di
mWriteAX ; Выводим номер текущей строки
mWriteStr inc_str ; тип проверки

next_str:
mWriteStr endl
inc di ; Увеличиваем счётчик строк
add bx, col ; Увеличиваем смещение по строкам
add bx, col ; (дважды, так как размер каждого элемента - слово)
pop cx
loop rowLoop

pop dx ; Перенос сохранённых значений обратно в регистры
pop di
pop si
pop cx
pop bx
pop ax
NOJUMPS
endm mTestIncrease


; mTextIncrease macro matrix, row, col
; local rowLoop, colLoop, incr, decr, next_el, parity, negative_result
; JUMPS
; push ax ; Сохранение регистров, используемых в макросе, в стек
; push bx
; push cx
; push si
; push di
; push dx

; mov di, 1 ; di - счётчик строк, начиная с единицы
; xor bx, bx ; Обнуляем смещение по строкам
; mov cx, row
; rowLoop:
; push cx
; xor si, si ; Обнуляем смещение по столбцам
; sub cx, 1
;     push cx 
; ; mov ax, di
; ; 
; ; div 



; colLoop:
; mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
; cmp ax, matrix[bx][si+2]
; jl incr
; jg decr
; jmp next_el
;     incr:
;     inc dx
;     jmp next_el
;     decr:
;     dec dx
; next_el:
; ; push dx
; add si, 2 ; Переходим к следующему элементу (размером в слово)
; ; pop dx
; loop colLoop

; ; push dx
; ; mov ah, 09h
; ; mov dx, di
; ; add dx, '0'
; ; int 21h
; ; pop dx

; mWriteStr endl
; push dx
; mov ax, di
; mov dh, 2h
; div dh
; cmp ah, 0
; pop dx

; pop ax
; jz parity
;     neg ax
; parity:
; cmp ax, dx
; jnz negative_result
;     mWriteStr test_par
; negative_result:
; inc di ; Увеличиваем счётчик строк
; add bx, col ; Увеличиваем смещение по строкам
; add bx, col ; (дважды, так как размер каждого элемента - слово)
; pop cx
; loop rowLoop

; pop dx ; Перенос сохранённых значений обратно в регистры
; pop di
; pop si
; pop cx
; pop bx
; pop ax
; NOJUMPS
; endm mTextIncrease

; mTextIncrease macro matrix, row, col
; local rowLoop, colLoop, incr, decr, next_el, parity, negative_result
; JUMPS
; push ax ; Сохранение регистров, используемых в макросе, в стек
; push bx
; push cx
; push si
; push di
; push dx

; mov di, 1 ; di - счётчик строк, начиная с единицы
; xor bx, bx ; Обнуляем смещение по строкам
; mov cx, row
; rowLoop:
; push cx
; xor si, si ; Обнуляем смещение по столбцам
; sub cx, 1
;     push cx 
; ; mov ax, di
; ; 
; ; div 



; colLoop:
; mov ax, matrix[bx][si] ; bx - смещение по строкам, si - по столбцам
; cmp ax, matrix[bx][si+2]
; jl incr
; jg decr
; jmp next_el
;     incr:
;     inc dx
;     jmp next_el
;     decr:
;     dec dx
; next_el:
; ; push dx
; add si, 2 ; Переходим к следующему элементу (размером в слово)
; ; pop dx
; loop colLoop

; ; push dx
; ; mov ah, 09h
; ; mov dx, di
; ; add dx, '0'
; ; int 21h
; ; pop dx

; mWriteStr endl
; push dx
; mov ax, di
; mov dh, 2h
; div dh
; cmp ah, 0
; pop dx

; pop ax
; jz parity
;     neg ax
; parity:
; cmp ax, dx
; jnz negative_result
;     mWriteStr test_par
; negative_result:
; inc di ; Увеличиваем счётчик строк
; add bx, col ; Увеличиваем смещение по строкам
; add bx, col ; (дважды, так как размер каждого элемента - слово)
; pop cx
; loop rowLoop

; pop dx ; Перенос сохранённых значений обратно в регистры
; pop di
; pop si
; pop cx
; pop bx
; pop ax
; NOJUMPS
; endm mTextIncrease



.data
matrix          db 09, 'Matrix', 13, 10, '$'
transmatrix     db 09, 'Tronspose matrix', 13, 10, '$'
med_ariph       db 'Average - ', '$'
inc_str         db ' Increase', '$'
dec_str         db ' Decrease', '$'
endl            db 13, 10, '$'
buffer      db 20 dup(?)
rows        dw 5
cols        dw 5
currentMatrix       dw 101,102,103,104,105, 8,6,4,2,0, 11,12,13,14,15, 16,17,18,19,20, 21,22,28,24,25
transposedMatrix    dw 100 dup (0)
.code
start:
mov ax,@data
mov ds, ax

; mTransposeMatrix currentMatrix, rows, cols
; mZiroBeforeMatrix currentMatrix, rows, cols
; mTestIncrease currentMatrix, rows, cols
mGetAverageAboveDiagonal currentMatrix, rows, cols

    ; push ax ; Сохранение регистров, используемых в макросе, в стек
    ; push bx
    ; push cx
    ; push si
    ; push di
    ; push dx

    ; mov di, 1 ; di - счётчик строк, начиная с единицы

    ; xor bx, bx ; Обнуляем смещение по строкам
    ; mov cx, rows
    ; rowLoop:
    ; push cx
    ; xor si, si ; Обнуляем смещение по столбцам
    ; mov cx, cols
    ; sub cx, 1

    ; colLoop:
    ; mov ax, currentMatrix[bx][si] ; bx - смещение по строкам, si - по столбцам
    ; cmp ax, currentMatrix[bx][si+2]
    ; jl incr
    ; jg decr
    ; jmp next_el
    ;     incr:
    ;     inc dx
    ;     jmp next_el
    ;     decr:
    ;     dec dx
    ; next_el:
    ; push dx
    ; add si, 2 ; Переходим к следующему элементу (размером в слово)
    ; pop dx
    ; loop colLoop

    ; div di, 2h
    ; cmp al, 0
    ; jz parity
    ; jnz notparity
    ;     parity:
    ;     mov ax, col
    ;     sub ax, 1
    ;     jmp output
    ;     notparity:
    ;     mov ax, col
    ;     sub ax, 1
    ;     neg ax
    ;     jmp output
    ; output:
    ; cmp ax, dx
    ; jz pozitive_result
    ; jnz negative_result
    ;     pozitive_result:
    ;     mov ax, di
    ;     mWriteAX
    ;     mWriteStr space
    ;     mWriteStr test_par
    ;     jmp next_str
    ;     negative_result:
    ;     mov ax, di
    ;     mWriteAX
    ;     mWriteStr space
    ;     mWriteStr test_notpar
    ;     jmp next_str

    ; next_str:
    ; inc di ; Увеличиваем счётчик строк
    ; add bx, col ; Увеличиваем смещение по строкам
    ; add bx, col ; (дважды, так как размер каждого элемента - слово)
    ; pop cx
    ; loop rowLoop

    ; pop dx ; Перенос сохранённых значений обратно в регистры
    ; pop di
    ; pop si
    ; pop cx
    ; pop bx
    ; pop ax


mov ax,4c00h
int 21h
end start

