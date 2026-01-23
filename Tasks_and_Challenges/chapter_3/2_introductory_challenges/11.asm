%include "stud_io.inc"
global _start

section .text
_start:
	xor	ecx, ecx
.again:
	;put chat from I/O to al
	GETCHAR
	
	;if (end of line or end of file) then exit
	cmp	eax, -1		;if eof
	je	.check_zero
	cmp	al, 10		;if '\n'
	je	.check_zero

	;if (char is not number) then continue
	cmp	al, '0'
	jb	.skip
	cmp	al, '9'
	ja	.skip

	sub	al, '0'
	add	ecx, eax
.skip:
	jmp	.again

.check_zero:
	jecxz	.exit

.print_stars:
	PUTCHAR	'*'
	loop	.print_stars

	PUTCHAR	10
.exit:
	FINISH
