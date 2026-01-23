%include "stud_io.inc"
global _start

section .text
_start:
	xor ebx, ebx		;flag
.again:
	GETCHAR

	;if (end of line or end of file)
	cmp	eax, -1		;if eof
	je	.eof_situation
	cmp	al, 10		;if '\n'
	je	.print_ok
	
	mov	ebx, 1		;if symbol
	jmp	.again

.print_ok:
	PRINT	"OK"
	PUTCHAR	10
	xor	ebx, ebx
	jmp	.again
	
.eof_situation:
	test	ebx, ebx
	je	.finish

	PUTCHAR	10
	PRINT	"OK"
	PUTCHAR	10

.finish:
	FINISH
