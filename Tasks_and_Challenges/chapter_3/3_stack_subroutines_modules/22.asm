%include "stud_io.inc"
global _start

section .text
_start:
	mov	eax, -1
	push	eax
.get_loop:
	GETCHAR

	cmp	eax, -1		;eof
	je	.print_loop
	cmp	eax, 10		;eol
	je	.print_loop

	push	eax
	jmp	.get_loop

.print_loop:
	pop	eax

	cmp	eax, -1		;end symbols
	je	.finish
	
	PUTCHAR	al

	jmp	.print_loop

.finish:
	FINISH
