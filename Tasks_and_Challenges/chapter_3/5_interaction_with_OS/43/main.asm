%include "syscalls.inc"
global _start

extern exit_with_msg
extern msg_help
extern msg_errdst
extern msg_errnum

extern openf_or_die

section .data

msg_ok		db "OK", 10
msg_ok_len	equ $-msg_ok

section .text

; [ebp]    - argc
; [arg(0)] - program name
; [arg(1)] - first arg ptr
; ...
_start:
	mov	ebp, esp

	; if argc < 1
	cmp	[ebp], 2
	jb	.err_args
	
	mov	esi, [arg(1)]
	xor	ebx, ebx		; sum
.lp:
	lodsb

	; if eof
	test	al, al
	je	.lp_end

	; if not num
	cmp	al, '0'
	jb	.err_input
	cmp	al, '9'
	ja	.err_input

	sub	al, '0'
	add	ebx, eax

	jmp	.lp
.lp_end:
	; check
	mov	eax, ebx
	mov	ebx, 3
	xor	edx, edx
	div	ebx

	; if remainder is zero
	test	edx, edx
	jnz	.end
	
	; write msg
	sys_write 1, msg_ok, msg_ok_len

.end:
	sys_exit
.err_args:
	mov	eax, msg_help
	jmp	exit_with_msg
.err_input:
	mov	eax, msg_errnum
	jmp	exit_with_msg
