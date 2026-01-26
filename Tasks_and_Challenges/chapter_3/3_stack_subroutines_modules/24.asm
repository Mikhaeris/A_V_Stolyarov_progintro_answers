%include "stud_io.inc"
global _start

section .text
;str to integer (eax=address, cl=length): eax=integer_num, cl=res
atoi:
	;CDECL convention
	pushfd
	push	ebx
	push	edx
	push	esi
	push	edi
	push	ebp
	
	jecxz	.err		;if size is zero

	mov	esi, eax	;store address for process support string work
	xor	eax, eax	;temp store curr char
	xor	ebx, ebx	;store result
	mov	ebp, 10		;multiplier
.lp:
	lodsb			;get char from buf
	
	;if not num
	cmp	al, '0'
	jb	.err
	cmp	al, '9'
	ja	.err

	sub	al, '0'		;get val char
	movzx	edi, al 	;store cur num to edi
	
	mov	eax, ebx
	mul	ebp		;mul cur num to ten
	add	eax, edi	;add new num to last place
	mov	ebx, eax

	loop	.lp
	jmp	.good
.err:
	mov	cl, 1
.good:
	mov	eax, ebx	;return value

	;CDECL convention
	pop	ebp
	pop	edi
	pop	esi
	pop	edx
	pop	ebx
	popfd

	ret			;end function

;integer to str (eax=number, ecx=address): eax=length
;assumed length buf is 10
;(because max length 32-bit num is ten)
;fill from end to begin
;put zero after last character
itoa:
	;CDECL convention
	pushfd
	push	ebx
	push	edx
	push	esi
	push	edi

	mov	edi, ecx
	add	edi, 9		;edi store last el of buf
	
	std			;set flag dr

	mov	esi, 10		;divisor
	xor	ecx, ecx	;store length buf

	mov	ebx, eax

.lp:
	mov	eax, ebx	;for do div
	xor	edx, edx	;to zero for div
	div	esi		;div edx:eax and esi(10)
	mov	ebx, eax	;store quotient

	mov	al, dl		;to use stosb(from al to [esi])
	add	al, '0'		;integer to char
	stosb

	inc	ecx		;count length
	test	ebx, ebx	;if num is zero end loop
	jnz	.lp

	mov	eax, ecx	;return length

	;CDECL convention
	pop	edi
	pop	esi
	pop	edx
	pop	ebx
	popfd

	ret			;end function

;print num from buf (eax=address, ecx=length)
print_num_from_buf:
	jecxz	.end		;if size is zero

	;CDECL convention
	pushfd
	push	esi

	mov	esi, eax	;put address to esi

	mov	eax, 10		;calc start str
	sub	eax, ecx	;get offset from start
	add	esi, eax

	xor	eax, eax	;clear
.lp:
	lodsb
	PUTCHAR	al
	loop .lp
	PUTCHAR	10
	
	;CDECL convention
	pop	esi
	popfd
.end:
	ret			;end function

;get str from input stream (eax=address, ecx=length)
;			: eax=count_read_char, ecx=code
;code:
;if bad input return last get char
;if eof return 1
;if count get char more than buf length return 2
get_str:
	;CDECL convention
	pushfd
	push	edi
	push	ebx
	
	mov	edi, eax	;where to put chars
	xor	eax, eax
	xor	ebx, ebx	;counter gets chars
.lp:
	GETCHAR

	;eof
	cmp	eax, -1
	je	.eof_situation

	;if not num
	cmp	al, '0'
	jb	.err_get_not_num
	cmp	al, '9'
	ja	.err_get_not_num

	inc	ebx		;increase the counter

	;if get more char than size of buf
	cmp	ebx, ecx
	ja	.err_out_of_range
	
	stosb
	jmp	.lp

.eof_situation:
	mov	ecx, 1
	jmp	.end

.err_get_not_num:
	movzx	ecx, al
	jmp	.end

.err_out_of_range:
	dec	ecx
	mov	ecx, 2
	jmp	.end
	
.end:
	mov	eax, ebx

	;CDECL convention
	pop	ebx
	pop	edi
	popfd

	ret		;end function

section .bss
buf	resb	10
len	equ	10

section .text
_start:
;first num
	;get first num to buf
	mov	eax, buf
	mov	ecx, len
	call	get_str
	
	;check for bad input
	cmp	ecx, ' '
	jne	.err_bad_input
	
	;from str to integer
	mov	ecx, eax
	mov	eax, buf
	call	atoi

	;check for bad input
	cmp	cl, 1
	je	.err_bad_input

	;push first num to stack
	push	eax

;second num
	;get second num to buf
	mov	eax, buf
	mov	ecx, len
	call	get_str
	
	;check for bad input
	cmp	ecx, 10
	jne	.err_bad_input
	
	;from str to integer
	mov	ecx, eax
	mov	eax, buf
	call	atoi

	;check for bad input
	cmp	cl, 1
	je	.err_bad_input

	;push second num to stack
	push	eax

;.add:
	mov	eax, [esp]
	mov	ebx, [esp+4]
	add	eax, ebx

	mov	ecx, buf
	call	itoa

	PRINT	"add: "
	mov	ecx, eax
	mov	eax, buf
	call	print_num_from_buf

;.sub:
	mov	ebx, [esp]
	mov	eax, [esp+4]
	sub	eax, ebx

	mov	ecx, buf
	call	itoa

	PRINT	"sub: "
	mov	ecx, eax
	mov	eax, buf
	call	print_num_from_buf

;.mul:
	mov	eax, [esp]
	mov	ebx, [esp+4]
	mul	ebx

	mov	ecx, buf
	call	itoa

	PRINT	"mul: "
	mov	ecx, eax
	mov	eax, buf
	call	print_num_from_buf
;.div:
	mov	ebx, [esp]
	test	ebx, ebx
	jz	.err_zero_divisor

	mov	eax, [esp+4]
	xor	edx, edx
	div	ebx

	mov	ecx, buf
	call	itoa

	PRINT	"div: "
	mov	ecx, eax
	mov	eax, buf
	call	print_num_from_buf

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
