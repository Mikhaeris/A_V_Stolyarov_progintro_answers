%include "stud_io.inc"
global	get_str
section .text
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
