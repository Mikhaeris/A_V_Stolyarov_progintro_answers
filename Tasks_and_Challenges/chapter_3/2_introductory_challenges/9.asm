%include "stud_io.inc"
global _start

_start:
.again: GETCHAR
	cmp	eax, -1	;check eof situation
	jz	.end	;if eof goto end
	PUTCHAR al
	jmp	.again	;loop
.end:
	FINISH
