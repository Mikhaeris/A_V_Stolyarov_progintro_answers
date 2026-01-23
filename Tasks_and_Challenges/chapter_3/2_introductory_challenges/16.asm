%include "stud_io.inc"
global _start

section .text
_start:
	xor	ecx, ecx	;count words
	mov	ebx, ' '	;prev ch

.main_loop:
	GETCHAR

	;if eof
	cmp	eax, -1
	je	.eof_situation

	;if eol
	cmp	al, 10
	je	.print_inf

	;if prev = ' ' and cur is alph
	cmp	ebx, ' '
	jne	.skip
	cmp	al, 33
	jb	.skip
	cmp	al, 126
	ja	.skip

	inc ecx
.skip:
	movzx	ebx, al
	jmp .main_loop

.print_inf:
	jecxz	.main_loop

.lp:
	PUTCHAR	'*'
	loop	.lp
	PUTCHAR	10
	mov	ebx, ' '
	jmp	.main_loop

.eof_situation:
	jecxz	.finish
	PUTCHAR	10
.lp2:
	PUTCHAR	'*'
	loop	.lp2
	PUTCHAR	10

.finish:
	FINISH
