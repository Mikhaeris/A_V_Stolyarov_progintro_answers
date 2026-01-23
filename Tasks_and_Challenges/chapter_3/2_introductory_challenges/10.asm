%include "stud_io.inc"
global _start

section .text
_start:
	xor	ebx, ebx	;counter '+'
	xor	esi, esi	;counter '-'

.again:
	GETCHAR

	cmp	al, 10		;check \n
	je	.calculate
	cmp	eax, -1		;check eof
	je	.calculate

;check_plus:
	cmp	al, '+'
	jne	.check_minus
	inc	ebx
	jmp	.again

.check_minus:
	cmp	al, '-'
	jne	.again
	inc	esi
	;cycle
	jmp	.again

.calculate:
	;count '+' * count '-'
	mov	eax, ebx
	mul	esi

	mov	ecx, eax
	jecxz	.fin

.lp:
	PUTCHAR	'*'
	loop	.lp

.fin:
	PUTCHAR	10
	FINISH
