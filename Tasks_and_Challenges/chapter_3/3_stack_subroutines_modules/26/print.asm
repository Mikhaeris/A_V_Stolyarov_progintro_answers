%include "stud_io.inc"
global	print_num_from_buf
section .text
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
