.model small
.stack 100h
.data
	A db ?
	B db ?
	C db ?
	D db ?
.code
Start:

	mov AX, @Data
	mov DS, AX
	mov A, 7h
	mov B, 12
	mov C, 1Dh
	mov D, 9

	mov Al, A
	mov AH, B
	xchg Al,Ah
	mov BX, 3E10H

	push BX
	push CX
	push AX
	lea SI, C
	mov AX, SI
	lea DI, D
	mov BX, DI
	pop AX
	pop CX
	pop BX

	mov BX, AX
	mov A, Al
	mov B, Ah
	mov C, 0
	mov AX, 4C00H
	int 21
end Start
END