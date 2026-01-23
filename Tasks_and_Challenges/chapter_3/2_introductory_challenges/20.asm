%include "stud_io.inc"
global _start

section .bss
num1	resd	1
num2	resd	1
buf	resb	10

section .text
_start:
	xor	ebx, ebx	;temp store num

	;flag
	;first for getnums
	;0: num1
	;1: num2
	;second for do right operations
	;0: add
	;1: sub
	;2: mul
	xor	ebp, ebp

;get first num to num1
	jmp	.loop

.second_num:
	mov	[num1], ebx
	xor	ebx, ebx

	jmp	.loop
.process:
	mov	[num2], ebx
	xor	ebx, ebx
	xor	eax, eax
	
	;reset for operations
	xor	ebp, ebp

;add_f
	mov	ebx, [num1]
	mov	eax, [num2]

	add	ebx, eax

	jmp	.print_num
.sub_f:
	mov	ebx, [num1]
	mov	eax, [num2]

	sub	ebx, eax

	jmp	.print_num
.mul_f:
	mov	ebx, [num1]
	mov	eax, [num2]

	mul	ebx
	mov	ebx, eax

	jmp	.print_num
.finish:
	FINISH

;get num to ebx
.loop:
	GETCHAR

	;if ' ' or \'n' then exit
	;if not num then error
	cmp	al, ' '
	je	.exit_loop
	cmp	al, 10
	je	.exit_loop
	cmp	al, '0'
	jb	.error_read
	cmp	al, '9'
	ja	.error_read
	
	sub	al, '0'		;get val char
	movzx	esi, al 	;store cur num to esi
	
	mov	eax, 10
	mul	ebx		;mul cur num to ten
	add	eax, esi	;add new num to last place
	mov	ebx, eax

	jmp	.loop
.exit_loop:
	;reset registers
	xor	eax, eax
	xor	ecx, ecx
	xor	edx, edx
	xor	esi, esi
	xor	edi, edi

	inc	ebp
	cmp	ebp, 1
	je	.second_num
	jmp	.process

.error_read:
	PRINT	"Bad Input!"
	FINISH

;get num from ebx and print it
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
	PUTCHAR	10
	
	;reset registers
	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx
	xor	esi, esi
	xor	edi, edi

	inc	ebp
	cmp	ebp, 1
	je	.sub_f
	cmp	ebp, 2
	je	.mul_f
	jmp	.finish
