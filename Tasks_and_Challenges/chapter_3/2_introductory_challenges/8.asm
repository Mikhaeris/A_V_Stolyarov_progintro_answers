%include "stud_io.inc"
global _start

section .text
_start:
	GETCHAR

;if (0 <= al && al <= 9) then print
;else .end
	cmp 	al, '1'
	jb	.end
	cmp 	al, '9'
	ja	.end

;al - '0' to get real num to iterate
;and move iterator to cx for jcxz
	sub	al, '0'
	movzx	cx, al

;while (cx > 0)
.again:
	PUTCHAR	'*'
	loop 	.again

	PUTCHAR	10
.end:
	FINISH
