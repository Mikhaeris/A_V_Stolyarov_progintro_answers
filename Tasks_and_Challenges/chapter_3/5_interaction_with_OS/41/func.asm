%include "syscalls.inc"

global openf_or_die
global get_length_str
global atoi

extern exit_with_msg

; in:
;	[arg(1)] - file name ptr
;	[arg(2)] - mode
;	[arg(3)] - err msg
; out:
;	eax - file descriptor
openf_or_die:
	push	ebp
	mov	ebp, esp

	sys_open [arg(1)], [arg(2)]
	cmp	eax, 0xfffff000
	jb	.next
	mov	eax, [arg(3)]
	call	exit_with_msg
.next:
	mov	esp, ebp
	pop	ebp
	ret

; in:
;	[arg(1)] - pointer to str
; out:
;	eax - length
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
	mov	eax, ecx

	pop	esi

	mov	esp, ebp
	pop	ebp
	ret

; in:
;	[arg(1)] - buf ptr
;	[arg(2)] - length
; locals:
;	[local(1)] - store result
; out:
;	eax - num
;	cl  - res (0 - true, 1 - false)
atoi:
	push	ebp
	mov	ebp, esp
	sub	esp, 4

	mov	dword [local(1)], 0
	
	; CDECL convention
	push	ebx
	push	edx
	push	esi
	push	edi
	
	mov	esi, [arg(1)]	; store address for process support string work
	xor	eax, eax	; temp store curr char
	mov	ebx, 10		; multiplier
	mov	ecx, [arg(2)]	; length
	jecxz	.err		; if size is zero
.lp:
	lodsb			; get char from buf
	
	; if not num
	cmp	al, '0'
	jb	.err
	cmp	al, '9'
	ja	.err

	sub	al, '0'		; get val char
	movzx	edi, al 	; store cur num to edi
	
	mov	eax, [local(1)]
	mul	ebx		; mul cur num to ten
	add	eax, edi	; add new num to last place
	mov	[local(1)], eax

	loop	.lp
	jmp	.good
.err:
	mov	cl, 1
.good:
	mov	eax, [local(1)]	; return value

	; CDECL convention
	pop	edi
	pop	esi
	pop	edx
	pop	ebx

	mov	esp, ebp
	pop	ebp
	ret
