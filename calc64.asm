
TITLE  Liczby_64_bitowe		(calc64.asm)



.model medium

.386

.stack 200h




.Data

txt1 db "Przekroczenie Dodawania...",10,13,"$"
txt2 db "Przekroczenie Odejmowania...",10,13,"$"

l1 dd 12345678h
l2 dd 100000h

licz1 dq 18446744073709551531
licz2 dq 1
R dq 0
W dq 0
mn1 dd 4290123456
mn2 dd 4294967295
wyn dq 0

wynik dq 0

.Code


main proc

MOV ax,@data
MOV ds,ax


DZIELENIE:

	MOV si,offset licz1
	MOV di,offset licz2
	MOV bx,offset W	
	MOV dx,offset R
	CALL Div64

	MOV ebx,dword ptr R+4
	MOV ecx,dword ptr R
	MOV esi,dword ptr w+4
	MOV edi,dword ptr w

MNOZENIE:

	MOV si,offset mn1
	MOV di,offset mn2
	MOV bx,offset wyn
	call Mul64
	MOV edx,dword ptr wyn
	MOV ecx,dword ptr wyn+4
	MOV si,offset licz1
	MOV di,offset licz2	
	MOV bx,offset wynik
	
ODEJMOWANIE:

	call Sub64
	jnc DAL1
	MOV dx,offset txt2
	MOV ah,09h
	INT 21h	

DAL1:	
	
	MOV edx,dword ptr wynik
	MOV ecx,dword ptr wynik+4

mov ax,4c00h
int 21h

main endp



Add64 proc

	PUSHAD
	PUSH si
	PUSH di
	PUSH bX
	MOV bp,0
	CLC
	PUSHF

	MOV cx,4	
	Petla:

	MOV ax,word ptr [si]
	MOV dx,word ptr [di]
	POPF
	ADC ax,dx
	PUSHF 
	MOV word ptr [bx],ax
	add si,2
	add di,2
	add bx,2
	LOOP Petla
	
	POPF
	POP bx
	POP di
	POP si
	POPAD	
RET

Add64 endp


Sub64 proc
	
	PUSHAD
	PUSH si
	PUSH di
	PUSH bx
	
	CLC
	PUSHF

	MOV cx,4	
	Petla:

	MOV ax,word ptr [si]
	MOV dx,word ptr [di]
	POPF
	SBB ax,dx
	PUSHF 
	MOV word ptr [bx],ax
	add si,2
	add di,2
	add bx,2
	LOOP Petla
	

	POPF
	POP bx
	POP di
	POP si
	POPAD
	
	RET
Sub64 endp


Mul64 proc

	PUSHAD
	PUSH bx
	
	CLC

MNOZENIE:

	MOV edx,0
	MOV eax,0
	MOV ebx,0
	MOV ax,word ptr [si]
	MOV bx,word ptr [di]
	MUL bx
	MOV word ptr cs:[wyn1],ax
	MOV word ptr cs:[wyn1+2],dx
	
	ADD si,2
	
	MOV edx,0
	MOV eax,0
	MOV ebx,0
	MOV ax,word ptr [si]
	MOV bx,word ptr [di]
	MUL bx	
	MOV word ptr cs:[wyn2+2],ax
	MOV word ptr cs:[wyn2+4],dx
	
	SUB si,2
	ADD di,2


	MOV edx,0
	MOV eax,0
	MOV ebx,0
	MOV ax,word ptr [si]
	MOV bx,word ptr [di]
	MUL bx
	MOV word ptr cs:[wyn3+2],ax
	MOV word ptr cs:[wyn3+4],dx		
	
	ADD si,2
	
	MOV edx,0
	MOV eax,0
	MOV ebx,0
	MOV ax,word ptr [si]
	MOV bx,word ptr [di]
	MUL bx
	MOV word ptr cs:[wyn4+4],ax
	MOV word ptr cs:[wyn4+6],dx
	
DODAWANIE:
	
@1:
	CLC
	
	MOV ax,word ptr wyn1
	MOV bx,word ptr wyn2
	ADC ax,bx
	POP bx
	PUSHF
	
	MOV word ptr [bx],ax
	ADD bx,2
	POPF
	PUSH bx

	MOV ax,word ptr wyn1+2
	MOV bx,word ptr wyn2+2
	ADC ax,bx
	POP bx
	PUSHF
	
	MOV word ptr [bx],ax
	ADD bx,2
	POPF
	PUSH bx
	
	MOV ax,word ptr wyn1+4
	MOV bx,word ptr wyn2+4
	ADC ax,bx
	POP bx
	PUSHF
	
	MOV word ptr [bx],ax
	ADD bx,2
	POPF
	PUSH bx
	
	MOV ax,word ptr wyn1+6
	MOV bx,word ptr wyn2+6
	ADC ax,bx
	POP bx
	PUSHF

	MOV word ptr [bx],ax
	SUB bx,6
	POPF
	PUSH bx
	JC OVER
 	
@2:
	CLC
	
	POP si
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn3
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF


	MOV ax,word ptr [si]
	MOV bx,word ptr wyn3+2
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF

	
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn3+4
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF
	
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn2+6
	ADC ax,bx
	PUSHF

	MOV word ptr [si],ax
	SUB si,6
	POPF
	JC OVER


@3:

	CLC
	
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn4
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF


	MOV ax,word ptr [si]
	MOV bx,word ptr wyn4+2
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF

	
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn4+4
	ADC ax,bx
	PUSHF
	
	MOV word ptr [si],ax
	ADD si,2
	POPF
	
	MOV ax,word ptr [si]
	MOV bx,word ptr wyn4+6
	ADC ax,bx
	PUSHF

	MOV word ptr [si],ax
	SUB si,6

	POPF
	JC OVER
	JMP KON
	

OVER:
	POPAD
	STC	
	RET
KON:	

	POPAD

RET

wyn1 dq 0
wyn2 dq 0
wyn3 dq 0
wyn4 dq 0

Mul64 endp



Div64 proc
	
	PUSHAD

	PUSH bx
	PUSH dx
	MOV bp,0
	
	MOV ecx,dword ptr [di+4]
	MOV edx,dword ptr [di]
	MOV dword ptr _Dzielnik+4,ecx
	MOV dword ptr _Dzielnik,edx
	MOV ecx,dword ptr [si+4]
	MOV edx,dword ptr [si]
	MOV dword ptr _Dzielna+4,ecx
	MOV dword ptr _Dzielna,edx

	
	MOV ecx,dword ptr [si+4]
	MOV edx,dword ptr [di+4]
	CMP ecx,edx
	JA @1
	JE @2


@0:
	
	CLC
	MOV edx,dword ptr [si]
	MOV ecx,dword ptr [di]
	SBB ecx,edx
	PUSHF
	MOV dword ptr cs:[_Mod],ecx

	MOV edx,dword ptr [si+4]
	MOV ecx,dword ptr [di+4]
	POPF
	SBB ecx,edx
	MOV dword ptr cs:[_Mod+4],ecx
	MOV ecx,dword ptr cs:[_Mod+4]
	MOV edx,dword ptr cs:[_Mod]
	POP bx
	PUSH si
	MOV si,bx
	MOV dword ptr [si],edx
	MOV dword ptr[si+4],ecx
	POP bx
	POP cx
	PUSH cx
	PUSH si
	PUSH bx
	MOV si,cx
	MOV dword ptr [si],0
	Mov dword ptr [si+4],0
	POP si
	JMP OVER
	

	
@1:	
	
	MOV ecx,dword ptr [si+4]
	CMP ecx,0
	JE @1_1
	MOV edx,dword ptr[di+4]
	CMP edx,0
	JNE @1_1
	MOV edx,dword ptr [di]
	CMP edx,1000
	JA @1_1
	CMP edx,650
	JBE MN_1000
	MOV eax,edx
	MOV bx,10
	MUL bx
	MOV dword ptr [di],eax
	MOV bp,10
	jmp ZAP

MN_1000:
	CMP edx,65
	JA MN_100
	MOV eax,edx
	MOV bx,1000
	MUL bx
	MOV dword ptr [di],eax
	MOV bp,1000
	JMP ZAP

MN_100:
	MOV eax,edx
	MOV bx,100
	MUL bx
	MOV dword ptr [di],eax
	MOV bp,100

ZAP:
	MOV ecx,dword ptr [di+4]
	MOV edx,dword ptr [di]
	MOV dword ptr _Dzielnik+4,ecx
	MOV dword ptr _Dzielnik,edx

@1_1:
	

	MOV ecx,dword ptr[si+4]
	CMP ecx,0
	JNE @1_2
	MOV ecx,0
	MOV edx,0
	BSR ecx,dword ptr [si]
	BSR edx,dword ptr [di]
	CMP ecx,edx
	JA @1_3
	JMP @1_4
	
	

@1_2:

	MOV ecx,0
	MOV edx,0	
	BSR ecx,dword ptr [si+4]
	BSR edx,dword ptr [di+4]
	CMP cx,dx
	JA @1_3
	JMP @1_4
	



@1_3:	
	MOV ecx,dword ptr [di+4]
	MOV edx,dword ptr [di]
	SHLD ecx,edx,1
	SHL edx,1
	MOV dword ptr [di+4],ecx
	MOV dword ptr [di],edx
	MOV ecx,dword ptr _wyn1+4
	MOV edx,dword ptr _wyn1
	SHLD ecx,edx,1
	SHL edx,1
	MOV dword ptr _wyn1+4,ecx
	MOV dword ptr _wyn1,edx	

	JMP @1_1	

@1_4:
	MOV ecx,dword ptr [si+4]
	MOV edx,dword ptr [di+4]
	CMP ecx,edx
	JA @1_6
	JE @1_5
	
	MOV ecx,dword ptr [di+4]
	MOV edx,dword ptr [di]
	SHRD edx,ecx,1
	SHR ecx,1
	MOV dword ptr [di+4],ecx
	MOV dword ptr [di],edx
	MOV ecx,dword ptr _wyn1+4
	MOV edx,dword ptr _wyn1
	SHRD edx,ecx,1
	SHR ecx,1
	MOV dword ptr _wyn1+4,ecx
	MOV dword ptr _wyn1,edx
	
	JMP @1_6
	

@1_5:	
	MOV ecx,dword ptr [si]
	MOV edx,dword ptr [di]
	CMP ecx,edx
	JA @1_6
	JE @1_6

	MOV ecx,dword ptr [di+4]
	MOV edx,dword ptr [di]
	SHRD edx,ecx,1
	SHR ecx,1
	MOV dword ptr [di+4],ecx
	MOV dword ptr [di],edx
	MOV ecx,dword ptr _Wyn1+4
	MOV edx,dword ptr _wyn1
	SHRD edx,ecx,1
	SHR ecx,1
	MOV dword ptr _wyn1+4,ecx
	MOV dword ptr _wyn1,edx




@1_6:	

	PUSH si
	PUSH di
	MOV cx,4
	MOV si,offset _wyn
	Mov di,offset _Wyn1
	CLC
	PUSHF
	
	PETLA1:
		MOV ax,word ptr cs:[si]
		MOV bx,word ptr cs:[di]
		POPF
		ADC ax,bx
		PUSHF
		MOV word ptr cs:[si],ax
		ADD si,2
		ADD di,2
	LOOP PETLA1
	
	POPF
	POP di
	POP si


	PUSH si
	PUSH di
	MOV cx,4
	CLC
	PUSHF
	
	PETLA2:
		MOV ax,word ptr [si]
		MOV bx,word ptr [di]
		POPF
		SBB ax,bx
		PUSHF
		MOV word ptr [si],ax
		ADD si,2
		ADD di,2

	LOOP PETLA2
	
	POPF
	POP di
	POP si
	
	
	MOV ecx,dword ptr _Dzielnik+4
	MOV edx,dword ptr _Dzielnik
	MOV dword ptr [di+4],ecx
	MOV dword ptr [di],edx
	
	MOV dword ptr _Wyn1+4,0
	MOV dword ptr _Wyn1,1
	
	MOV ecx,dword ptr [si+4]
	MOV edx,dword ptr [di+4]
	CMP ecx,edx
	JA @1_1
	JB @1_7
			


	MOV ecx,dword ptr [si]
	MOV edx,dword ptr [di]
	
	CMP ecx,edx
	JA @1_1

@1_7:	
	
	MOV ecx,dword ptr [si+4]
	MOV edx,dword ptr [si]
	
	MOV dword ptr _Mod+4,ecx
	MOV dword ptr _Mod,edx
	
		
@1_8:

	CMP bp,0
	JE @1_9
	PUSH si
	PUSH di
	MOV dword ptr _Wyn1,0
	MOV si,offset _Wyn1
	MOV di,offset _Wyn	
	MOV cx,4
	CLC
	PUSHF
	
	X100:
		
		MOV eax,0
		MOV edx,0
		MOv ax,word ptr cs:[di]
		MOV bx,bp
		POPF
		MUL bx
		PUSHF
		MOV word ptr cs:[si],ax
		CMP cx,1
		je SK1
		MOV word ptr cs:[si+2],dx
SK1:
		ADD di,2
		ADD si,10
		

	LOOP X100
	
	POPF
	
	MOV si,offset _Wyn1
	MOV di,offset _Wyn2
	MOV cx,4
	CLC
	PUSHF

	D100:
		MOV ax,word ptr cs:[si]
		MOV bx,word ptr cs:[di]
		POPF
		ADC ax,bx
		PUSHF
		MOV word ptr cs:[si],ax
		ADD si,2
		ADD di,2	

	LOOP D100


	POPF
	
	MOV eax,dword ptr _Wyn1+4
	MOV edx,dword ptr _Wyn1
	MOV dword ptr _Wyn+4,eax
	MOV dword ptr _Wyn,edx
	MOV dword ptr Wyn1+4,0
	MOV dword ptr _Wyn1,0
	
	MOV si,offset _Wyn
	MOV di,offset _Wyn3
	MOV cx,4
	CLC
	PUSHF

	DD100:
		MOV ax,word ptr cs:[si]
		MOV bx,word ptr cs:[di]
		POPF
		ADC ax,bx
		PUSHF
		MOV word ptr cs:[si],ax
		ADD si,2
		ADD di,2	

	LOOP DD100
	
	POPF

	MOV si,offset _Wyn
	MOV di,offset _Wyn4
	MOV cx,4
	CLC
	PUSHF

	DDD100:
		MOV ax,word ptr cs:[si]
		MOV bx,word ptr cs:[di]
		POPF
		ADC ax,bx
		PUSHF
		MOV word ptr cs:[si],ax
		ADD si,2
		ADD di,2	

	LOOP DDD100
	
	POPF
	POP di
	POP si

	MOV dword ptr _Wyn1+4,0
	MOV dword ptr _Wyn1,0	
	
	MOV eax,dword ptr [di]
	MOV edx,0
	MOV bx,bp
	DIV bx
	MOV dword ptr [di],eax
	MOV eax,dword ptr _Mod
	MOV ebx,dword ptr [di]
	DIV bx
	MOV dword ptr _Wyn1,eax
	MOV dword ptr _Mod, edx
	
	PUSH si
	PUSH di
	MOV si,offset _Wyn1
	MOV di,offset _Wyn
	MOV cx,4
	CLC
	PUSHF

	DOD1:
		MOV ax,word ptr cs:[si]
		MOV bx,word ptr cs:[di]
		POPF
		ADC ax,bx
		PUSHF
		MOV word ptr cs:[di],ax
		ADD si,2
		ADD di,2	

	LOOP DOD1
	
	POPF
	POP di
	POP si
	
	JMP @1_9

	X10:

@1_9:
	POP dx
	POP bx
	PUSH di
	PUSH si
	MOV si,bx
	MOV di,dx
	MOV ecx,dword ptr _Wyn+4
	MOV edx,dword ptr _Wyn
	MOV dword ptr [si+4],ecx
	MOV dword ptr [si],edx
	
	MOV ecx,dword ptr _Mod+4
	MOV edx,dword ptr _Mod
	MOV dword ptr [di+4],ecx
	MOV dword ptr [di],edx
	
	POP si
	POP di
		

	MOV eax,dword ptr _Dzielna+4
	MOV ecx,dword ptr _Dzielna
	MOV dword ptr [si+4],eax
	MOV dword ptr [si],ecx
	
	MOV eax,dword ptr _Dzielnik+4
	MOV ecx,dword ptr _Dzielnik
	MOV dword ptr [di+4],eax
	MOV dword ptr [di],ecx
	
	JMP KON	
	
	

JMP OVER

	
@2:
	
	MOV ecx,dword ptr [si]
	MOV edx,dword ptr [di]
	CMP ecx,edx
	JA @1
	JMP @0


OVER:
	POP dx	
	POP bx
KON:	
	POPAD
RET


ET label byte

_Dzielnik dq 0
_Dzielna dq 0

_Wyn dq 0
_Wyn1 dq 1
_Wyn2 dq 0
_Wyn3 dq 0
_Wyn4 dq 0
_Mod dq 0

Div64 endp


end