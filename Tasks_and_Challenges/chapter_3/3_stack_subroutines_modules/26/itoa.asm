global	itoa
section .text
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

