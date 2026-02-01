global _start

%macro sys_exit 0-1 0
	mov	ebx, %1
	mov	eax, 1
	int 	80h
%endmacro

section .text
_start:
	mov	ebp, esp
	cmp	[ebp], 4
	jne	.err
	sys_exit
.err:	sys_exit 1
