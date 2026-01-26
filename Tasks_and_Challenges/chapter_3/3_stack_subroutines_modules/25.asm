%include "stud_io.inc"
global _start

section .text
;str to integer ([ebp+8]=address, [ebp+12]=length): eax=integer_num, cl=res
atoi:
	push	ebp
	mov	ebp, esp
	sub	esp, 4

	;[ebp-4] store result
	mov	dword [ebp-4], 0
	
	;CDECL convention
	pushfd
	push	ebx
	push	edx
	push	esi
	push	edi
	
	mov	esi, [ebp+8]	;store address for process support string work
	xor	eax, eax	;temp store curr char
	mov	ebx, 10		;multiplier
	mov	ecx, [ebp+12]	;length
	jecxz	.err		;if size is zero
.lp:
	lodsb			;get char from buf
	
	;if not num
	cmp	al, '0'
	jb	.err
	cmp	al, '9'
	ja	.err

	sub	al, '0'		;get val char
	movzx	edi, al 	;store cur num to edi
	
	mov	eax, [ebp-4]
	mul	ebx		;mul cur num to ten
	add	eax, edi	;add new num to last place
	mov	[ebp-4], eax

	loop	.lp
	jmp	.good
.err:
	mov	cl, 1
.good:
	mov	eax, [ebp-4]	;return value

	;CDECL convention
	pop	edi
	pop	esi
	pop	edx
	pop	ebx
	popfd

	mov	esp, ebp
	pop	ebp
	ret			;end function

;integer to str ([ebp+8]=number, [ebp+12]=address): eax=length
;assumed length buf is 10
;(because max length 32-bit num is ten)
;fill from end to begin
;put zero after last character
itoa:
	push	ebp
	mov	ebp, esp

	;CDECL convention
	pushfd
	push	ebx
	push	edx
	push	esi
	push	edi

	mov	edi, [ebp+12]
	add	edi, 9		;edi store last el of buf
	
	std			;set flag dr

	mov	esi, 10		;divisor
	xor	ecx, ecx	;store length buf

	mov	ebx, [ebp+8]

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
	
	mov	esp, ebp
	pop	ebp
	ret			;end function

;print num from buf (eax[ebp+8]=address, ecx[ebp+12]=length)
print_num_from_buf:
	push	ebp
	mov	ebp, esp

	jecxz	.end		;if size is zero

	;CDECL convention
	pushfd
	push	ecx
	push	esi

	mov	esi, [ebp+8]	;put address to esi

	mov	ecx, [ebp+12]
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
	pop	ecx
	popfd
.end:
	mov	esp, ebp
	pop	ebp
	ret			;end function

;get str from input stream (eax[ebp+8]=address, ecx[ebp+12]=length)
;			: eax=count_read_char, ecx=code
;code:
;if bad input return last get char
;if eof return 1
;if count get char more than buf length return 2
get_str:
	push	ebp
	mov	ebp, esp

	;CDECL convention
	pushfd
	push	ecx
	push	edi
	push	ebx
	
	mov	edi, [ebp+8]	;where to put chars
	xor	eax, eax
	xor	ebx, ebx	;counter gets chars
	mov	ecx, [ebp+12]
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
	
	mov	esp, ebp
	pop	ebp
	ret		;end function

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
