%include "syscalls.inc"

global openf_or_die
global get_length_str

extern exit_with_msg

; in:
;	arg(1) - file name ptr
;	arg(2) - mode
;	arg(3) - err msg
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
;	arg(1) - pointer to str
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
