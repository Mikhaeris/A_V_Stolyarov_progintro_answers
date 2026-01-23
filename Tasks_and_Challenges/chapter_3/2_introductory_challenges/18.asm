%include "stud_io.inc"
global _start

section .text
_start:
	xor	ebx, ebx	;num
	xor	edi, edi	;flag eof
.main_loop:
	GETCHAR

	cmp	eax, -1
	jne	.next
	mov	edi, 1

.next:
	;if not num
	cmp	al, '0'
	jb	.print_stars
	cmp	al, '9'
	ja	.print_stars
	
	sub	al, '0'		;get val char
	movzx	esi, al 	;store cur num to esi
	
	mov	eax, 10
	mul	ebx		;mul cur num to ten
	add	eax, esi	;add new num to last place
	mov	ebx, eax

	jmp	.main_loop

.print_stars:
	test	edi, edi
	jz	.next2
	PUTCHAR	10

.next2:
	mov	ecx, ebx
	jecxz	.finish

.lp:
	PUTCHAR	'*'
	loop	.lp
	PUTCHAR	10

.finish:
	FINISH
