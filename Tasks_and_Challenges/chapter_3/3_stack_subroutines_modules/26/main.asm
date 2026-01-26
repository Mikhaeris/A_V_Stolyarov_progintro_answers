%include "stud_io.inc"
global _start

extern get_str
extern atoi
extern itoa
extern print_num_from_buf

section .bss
buf	resb	10
len	equ	10

section .text
_start:
;first num
	;get first num to buf
	push	len
	push	buf
	call	get_str
	add	esp, 8
	
	;check for bad input
	cmp	ecx, ' '
	jne	.err_bad_input
	
	;from str to integer
	push	eax
	push	buf
	call	atoi
	add	esp, 8

	;check for bad input
	cmp	cl, 1
	je	.err_bad_input

	;push first num to stack
	push	eax

;second num
	;get second num to buf
	push	len
	push	buf
	call	get_str
	add	esp, 8
	
	;check for bad input
	cmp	ecx, 10
	jne	.err_bad_input
	
	;from str to integer
	push	eax
	push	buf
	call	atoi
	add	esp, 8

	;check for bad input
	cmp	cl, 1
	je	.err_bad_input

	;push second num to stack
	push	eax

;.add:
	mov	eax, [esp]
	mov	ebx, [esp+4]
	add	eax, ebx

	push	buf
	push	eax
	call	itoa
	add	esp, 8

	PRINT	"add: "
	push	eax
	push	buf
	call	print_num_from_buf
	add	esp, 8

;.sub:
	mov	ebx, [esp]
	mov	eax, [esp+4]
	sub	eax, ebx

	push	buf
	push	eax
	call	itoa
	add	esp, 8

	PRINT	"sub: "
	push	eax
	push	buf
	call	print_num_from_buf
	add	esp, 8

;.mul:
	mov	eax, [esp]
	mov	ebx, [esp+4]
	mul	ebx

	push	buf
	push	eax
	call	itoa
	add	esp, 8

	PRINT	"mul: "
	push	eax
	push	buf
	call	print_num_from_buf
	add	esp, 8
;.div:
	mov	ebx, [esp]
	test	ebx, ebx
	jz	.err_zero_divisor

	mov	eax, [esp+4]
	xor	edx, edx
	div	ebx

	push	buf
	push	eax
	call	itoa
	add	esp, 8

	PRINT	"div: "
	push	eax
	push	buf
	call	print_num_from_buf
	add	esp, 8

	jmp	.good
.err_zero_divisor:
	PRINT	"zero divisor!"
	PUTCHAR	10
.good:
	jmp	.finish

.err_bad_input:
	PRINT	"Error!"
	PUTCHAR	10

.finish:
	FINISH
