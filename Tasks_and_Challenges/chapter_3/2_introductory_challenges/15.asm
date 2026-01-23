;modified for check line have bracket
%include "stud_io.inc"
global _start

section .text
_start:
	xor	edx, edx	;check line for bracket
	xor	ebx, ebx	;cur bracket
	mov	ecx, 1		;flag
.again:
	GETCHAR

	;if end of file
	cmp	eax, -1
	je	.eof_situation

	;if end of line
	cmp	eax, 10
	je	.print_inf
	
;if 	;if ch == '('
	cmp	al, '('
	jne	.elif
	inc	ebx
	mov	edx, 1
.elif:
	;if ch == ')'
	cmp	al, ')'
	jne	.end_if
	dec	ebx
	mov	edx, 1

.end_if:
	;if ebx < 0 then set flag
	cmp	ebx, 0
	jae	.skip
	xor	ecx, ecx

.skip:
	jmp	.again

.print_inf:
	test	edx, edx
	jz	.print_exit
	jecxz	.print_no
	test	ebx, ebx
	jnz	.print_no
	PRINT	"YES"
	PUTCHAR	10
	jmp	.print_exit

.print_no:
	PRINT	"NO"
	PUTCHAR	10

.print_exit:
	xor	edx, edx
	xor	ebx, ebx
	mov	ecx, 1

	;if eof then finish
	cmp	eax, -1
	je	.finish

	jmp	.again

.eof_situation:
	jmp	.print_inf
.finish:
	FINISH
