%include "syscalls.inc"

global openf_or_die
global count_line_feed
global itoa

extern exit_with_msg

extern msg_errsrc

section .text

; in:
;	arg(1) - file name ptr
;	arg(2) - mode
; out:
;	eax - file descriptor
openf_or_die:
	push	ebp
	mov	ebp, esp

	sys_open [arg(1)], [arg(2)]
	cmp	eax, 0xfffff000
	jb	.next
	mov	eax, msg_errsrc
	call	exit_with_msg
.next:
	mov	esp, ebp
	pop	ebp
	ret

; in:
;	arg(1) - buf ptr
;	arg(2) - buf size
; out:
;	eax - count line feeds
count_line_feed:
	push	ebp
	mov	ebp, esp

	push	esi

	mov	esi, [arg(1)]
	mov	ecx, [arg(2)]
	jecxz	.lp_end
	xor	edx, edx	; counter
.lp:
	lodsb
	
	; if '\n'
	cmp	al, 10
	jne	.skip
	inc	edx
.skip:
	loop	.lp
.lp_end:
	mov	eax, edx
	pop	esi

	mov	esp, ebp
	pop	ebp
	ret

; in:
;	arg(1) - num
;	arg(2) - buf with size 10
; out:
;	eax - length
itoa:
	push	ebp
	mov	ebp, esp

	;CDECL convention
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

	cld			;clear flag

	;CDECL convention
	pop	edi
	pop	esi
	pop	edx
	pop	ebx
	
	mov	esp, ebp
	pop	ebp
	ret
