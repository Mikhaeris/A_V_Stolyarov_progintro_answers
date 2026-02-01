%include "sys.inc"
global get_length_str

section .text
; get length str:
;	arg(1) - pointer to str
; return:
;	ecx - length
get_length_str:
	push	ebp
	mov	ebp, esp

	push	esi

	xor	ecx, ecx
	mov	esi, [arg(1)]
.lp:
	lodsb
	cmp	al, 0
	je	.lp_end
	inc	ecx
	jmp	.lp

.lp_end:
	pop	esi

	mov	esp, ebp
	pop	ebp
	ret

