global	atoi
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
