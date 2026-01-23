%include "stud_io.inc"
global _start

section .text
_start:
	GETCHAR

	cmp	al, 'A'	;if (al == 'A') print("YES")
	jnz	.else	

	PRINT	"YES"
	jmp	.end

.else:			;else print("NO")
	PRINT	"NO"

.end:
	PUTCHAR 10	;'\n'
	FINISH
