%include "stud_io.inc"
global _start

section .text
_start:
	xor	edx, edx	;flag in word

.main_loop:
	GETCHAR
	
	;eof
	cmp	eax, -1
	je	.eof_situation

	;eol
	cmp	al, 10
	je	.eol_situation

	;if separator
	cmp	al, ' '
	jbe	.separator
	
	;if in word
	test	edx, edx
	jnz	.print_char

	mov	edx, 1
	PUTCHAR	'('

.print_char:
	PUTCHAR	al
	jmp	.main_loop

.separator:
	;if be in word
	test	edx, edx
	jz	.print_ch

	xor	edx, edx
	PUTCHAR	')'

.print_ch:
	PUTCHAR	al
	jmp	.main_loop

.eol_situation:
	;if in word
	test	edx, edx
	jz	.new_line

	xor	edx,  edx
	PUTCHAR	')'

.new_line:
	PUTCHAR	al
	jmp	.main_loop

.eof_situation:
	test	edx, edx
	jz	.finish

	PUTCHAR	')'

.finish:
	FINISH
