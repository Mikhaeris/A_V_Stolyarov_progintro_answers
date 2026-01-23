%include "stud_io.inc"
global _start

section .bss
buf	resb	10

section .text
_start:
	xor	ebx, ebx	;num
;get count symbols
.main_loop:
	GETCHAR
	
	;eof
	cmp	eax, -1
	je	.print_num

	inc	ebx
	jmp	.main_loop

;get num from digit and push in memory
.print_num:
	;edi store last el buff
	;and set dr
	mov	edi, buf
	add	edi, 9
	std

	mov	ecx, 10

.lp:
	mov	eax, ebx
	xor	edx, edx
	div	ecx
	mov	ebx, eax

	mov	al, dl
	add	al, '0'
	stosb

	test	ebx, ebx
	jnz	.lp
;get num by digit and print it
.end_loop:
	mov	esi, edi
	inc	esi
	cld
	
	mov	edi, buf
	add	edi, 10
.lp2:
	lodsb
	PUTCHAR	al

	cmp	esi, edi
	jnz	.lp2

.finish:
	PUTCHAR	10
	FINISH
