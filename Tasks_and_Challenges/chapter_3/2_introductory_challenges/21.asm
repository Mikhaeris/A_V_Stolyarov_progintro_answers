%include "stud_io.inc"
global _start

section .bss
num1	resd	1
num2	resd	1
buf	resb	10		;buf for print num
sign	resb	1		;store sign operation

section .text
_start:
	xor	ebx, ebx	;temp store num

	;flag
	;first for getnums
	;0: num1
	;1: num2
	xor	ebp, ebp
.main:
	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx
	xor	ebp, ebp
	mov	[sign], 0
	mov	[num1], 0
	mov	[num2], 0

.first_num:
	jmp	.loop

.get_operation_sign:
	cmp	al, '+'
	je	.add_s
	cmp	al, '-'
	je	.sub_s
	cmp	al, '*'
	je	.mul_s
	cmp	al, '/'
	je	.div_s
	jmp	.error_read

.add_s:
	mov	[sign], 0
	jmp	.second_num
.sub_s:
	mov	[sign], 1
	jmp	.second_num
.mul_s:
	mov	[sign], 2
	jmp	.second_num
.div_s:
	mov	[sign], 3
	jmp	.second_num

.second_num:
	mov	[num1], ebx
	xor	ebx, ebx

	jmp	.loop
.process:
	mov	[num2], ebx
	xor	ebx, ebx
	xor	eax, eax
	
	mov	ebp, [sign]
	cmp	ebp, 0
	je	.add_f
	cmp	ebp, 1
	je	.sub_f
	cmp	ebp, 2
	je	.mul_f
	cmp	ebp, 3
	je	.div_f

.add_f:
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

	xor	edx, edx
	mul	ebx
	mov	ebx, eax

	jmp	.print_num
.div_f:
	mov	eax, [num1]
	mov	ebx, [num2]
	
	xor	edx, edx
	test	ebx, ebx
	jz	.error_read
	div	ebx
	mov	ebx, eax

	jmp	.print_num
.finish:
	FINISH

;get num to ebx
.loop:
	GETCHAR

	;if \n' then exit
	;if not num then error
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
	cmp	ebp, 0
	je	.err
	;reset registers
	xor	ecx, ecx
	xor	edx, edx
	xor	esi, esi
	xor	edi, edi

	jmp	.process

.error_read:
	inc	ebp
	cmp	ebp, 2
	je	.err
	cmp	al, '+'
	je	.check_inp
	cmp	al, '-'
	je	.check_inp
	cmp	al, '*'
	je	.check_inp
	cmp	al, '/'
	je	.check_inp

.err:
	cmp	eax, -1
	je	.finish
	PRINT	"ERROR"
	PRINT	10
	cmp	ebp, 0
	je	.main
.err_lp:
	GETCHAR

	cmp	al, 10
	je	.main
	cmp	al, -1
	je	.finish
	
	jmp	.err_lp

.check_inp:
	cmp	ebp, 1
	je	.get_operation_sign
	PRINT	"ERROR"
	PUTCHAR	10
	jmp	.err_lp


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
	
	jmp	.main
