.386
.model flat, C
.data

half 		dd 0.5
one 		dd 1.0
two 		dd 2.0
three 		dd 3.0
six 		dd 6.0
perem 		dd 0.0
num 		dd 0.0
save1 		dd 0.0
save2  		dd 0.0

.code 
Public C prog1
Public C prog2

prog1 proc C x: dword
	finit 
	;(2 / (pow(tan(x), 2))) + ((pow(2, (x * sin(sqrt(3 * pow(x, 2) + 1))))) / (sin(x) * cos(x) * log2(sqrt(pow(x, 2) + 1))))
	fld x                    ;ST(0)=x
	fmul st(0), st(0)        ;ST(0)=x^2
	fptan                    ;ST(0)=1, ST(1)=result
	fld st(1)                ;ST(1) to ST(0) 
	fld two                  ;ST(0)=two
	fdiv st(0), st(1)        ;ST(0)=2/tg(x^2)
	fstp perem               ;save perem

	fld x                    ;ST(0)=x
	fmul st(0), st(0)        ;ST(0)=x^2
	fld three                ;ST(0)=3, ST(1)=x^2
	fmul st(0), st(1)        ;ST(0)=3*x^2
	fadd one                 ;ST(0)=3*x^2+1
	fsqrt                    ;ST(0)=sqrt(3*x^2+1)
	fsin                     ;ST(0)=sin(sqrt(3*x^2+1))
	fld x                    ;ST(0)=x, ST(1)=sin(sqrt(3*x^2+1))
	fmul st(0), st(1)        ;ST(0)=x*sin(sqrt(3*x^2+1))
	f2xm1 ;2^x - 1           ;ST(0)=2^(x*sin(sqrt(3*x^2+1)))-1
	fadd one                 ;ST(0)=2^(x*sin(sqrt(3*x^2+1)))
	fstp num              	 ;save num

	fld x                    ;ST(0)=x
	fmul st(0), st(0)        ;ST(0)=x^2
	fadd one                 ;ST(0)=x^2+1
	fsqrt                    ;ST(0)=sqrt(x^2+1)
	fstp save1                ;save in save1
	fld x                    ;ST(0)=x
	fcos                     ;ST(0)=cos(x)
	fld save1                 ;ST(0)=save1(=sqrt(x^2+1))
	fyl2x                    ;ST(0)=cos(x)*log(sqrt(x^2+1)) (y*log(x))
	fld x                    ;ST(0)=x, ST(1)=cos(x)*log(sqrt(x^2+1))
	fsin                     ;ST(0)=sin(x), ST(1)=cos(x)*log(sqrt(x^2+1))
	fmul st(0), st(1)        ;ST(0)=sin(x)*cos(x)*log(sqrt(x^2+1))

	fld num                  ;ST(0)=num   
	fdiv st(0), st(1)        ;ST(0)=num/sin(x)*cos(x)*log(sqrt(x^2+1)) 
	fadd perem               ;ST(0)=2^(x*sin(sqrt(3*x^2+1)))/sin(x)*cos(x)*log(sqrt(x^2+1))+2/tg(x^2)
	fwait
	ret
prog1 endp



prog2 proc C x: dword
	finit 
	fld x                    ;ST(0)=x
	ftst                     ;compare ST(0) and 0
	FSTSW AX
	SAHF
	jb case_1
	fld half
	fld x                    ;<0
	fcomp st(1)              ;compare
	FSTSW AX
	SAHF
	ja case_3                ;>0,5
	jmp case_2               ;else

	case_1:
	fld x                    ;ST(0)=x
	fcos                     ;ST(0)=cos(x)
	fmul st(0), st(0)        ;ST(0)=(cos(x))^2
	fmul st(0), st(0)	     ;ST(0)=(cos(x))^4
	jmp fin

	case_2:
	fld x                    ;ST(0)=x
	f2xm1                    ;ST(0)=2^x-1
	fld six                  ;ST(0)=6
	fld st(1)                ;ST(1)=6
	fsub st(0), st(1)        ;ST(0)=2^x-7
	jmp fin

	case_3:
	fld x                    ;ST(0)=x
	fmul st(0), st(0)        ;ST(0)=x^2
	fadd one                 ;ST(0)=x^2+1
	fstp save2               ;save in save2
	fld one                  ;ST(0)=1
	fld x                    ;ST(0)=x, ST(1)=1
	fsub st(0), st(1)        ;ST(0)=x-1
	fld save2                ;ST(0)=x^2+1
	fmul st(0), st(1)        ;ST(0)=(x^2+1)(x-1)
	jmp fin

	fin:
	ret
	fwait
prog2 endp 
end
