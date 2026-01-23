%include "stud_io.inc"
global _start

section .text
_start:
	xor	ecx, ecx
.again:
	GETCHAR
	
	;if (end of line or end of file)
	cmp	eax, -1		;if eof
	je	.eof_situation
	cmp	al, 10		;if '\n'
	je	.print_stars

	inc	ecx

	jmp	.again

.print_stars:
	jecxz	.again
.lp:
	PUTCHAR	'*'
	loop	.lp
	PUTCHAR	10
	jmp	.again

.eof_situation:
	jecxz	.end
	PUTCHAR	10
.lp2:
	PUTCHAR	'*'
	loop	.lp2
	PUTCHAR	10

.end:
	FINISH
