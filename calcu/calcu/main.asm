;
; calcu.asm
;
; Created: 08/03/2017 04:12:37 p. m.
; Author : GENARO
;


; Replace with your application code
	ldi r16,0xFF
	out DDRA,r16
	ldi r16,0x00
	out DDRF,r16
	out DDRC,r16
	ldi r16,0xFF
loop:
numero1:
	in r16,PINF	
	in r18,PINC
	cpi r18,0x80
	breq espera
	rjmp numero1
espera:
	out PORTA,r16
	in r18,PINC
	cpi r18,0x00
	breq numero2
	rjmp espera 
numero2:
	in r17,PINF	
	in r18,PINC
	cpi r18,0x40
	breq espera1
	rjmp numero2
espera1:
	out PORTA,r17
	in r18,PINC
	cpi r18,0x00
	breq operacion
	rjmp espera1
operacion:
	in r19,PINC
	cpi r19,0x01
	breq suma
	cpi r19,0x02
	breq resta
	cpi r19,0x04
	breq mult
	cpi r19,0x08
	breq div
	cpi r19,0x00
	breq operacion
	cpi r19,0x80
	breq operacion
	cpi r19,0x40
	breq operacion
    rjmp loop

suma:
	add r16,r17
	call result
	jmp loop

resta:
	sub r16,r17
	call result
	jmp loop

mult:
	mul r16,r17
	mov r16,r0
	call result
	jmp loop

div:
	ldi r19,0x00
	call ciclo
	call result
	jmp loop

ciclo:
	cp r16,r17
	brge decr
	mov r16,r19
	ret

decr:
	sub r16,r17
	inc r19
	jmp ciclo

result:
	call retardo
	out PORTA,r16
	call retardo
	out PORTA,r1
	in r19,PINC
	cpi r19,0x80
	breq finaliza
	jmp result

finaliza:
	in r19,PINC
	out PORTA,r23
	cpi r19,0x00
	breq end
	jmp finaliza

end:
	rjmp numero2
	ret

retardo:
	ldi		r25,0x00
retardos:
	ldi		r21, 0xFF
reta1:
	ldi		r22, 0xFF
	ldi		r23, 0xFF
	ldi		r24, 0xFF
reta2:
	dec		r22
	cpi		r22,0x00
	brne	reta2
reta3:
	dec		r23
	cpi		r23,0x00
	brne	reta3
reta4:
	dec		r24
	cpi		r24,0x00
	brne	reta4
	dec		r21
	cpi		r21,0x00
	brne	reta1
	inc		r25
	cpi		r25,0x0A
	brne	retardos
	ret