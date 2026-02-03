%include "syscalls.inc"
global _start

extern exit_with_msg
extern msg_help
extern msg_errdst

extern openf_or_die
extern get_length_str

section .data

ch_space	db ' '
ch_line_feed	db 10

section .text

; [ebp]    - argc
; [arg(0)] - program name
; [arg(1)] - first arg
; [arg(2)] - second arg
; ...
; [local(1)] - file descriptor
_start:
	mov	ebp, esp
	sub	esp, 4

	; if argc < 2
	cmp	[ebp], 3
	jb	.err

	; open file with O_WRONLY, O_CREAT and O_TRUNC
	push	dword msg_errdst
	push	dword 0x241
	push	dword [arg(1)]
	call	openf_or_die
	add	esp, 12
	mov	[local(1)], eax

	xor	edi, edi	; counter for first loop
.lp:
	mov	esi, 2		; counter for second loop
.lp2:
	; get length cur arg
	push	dword [arg(esi)]
	call	get_length_str
	add	esp, 4

	; write cur arg in file
	sys_write [local(1)], [arg(esi)], eax

	; if last word skip space
	mov	eax, [ebp]
	dec	eax
	cmp	esi, eax
	je	.skip_space

	; write space
	sys_write [local(1)], ch_space, 1
.skip_space:

	inc	esi
	cmp	esi, [ebp]
	jb	.lp2

	; write line weed
	sys_write [local(1)], ch_line_feed, 1

	inc	edi
	cmp	edi, 10
	jne	.lp
	
	; close file
	sys_close [local(1)]

	sys_exit
.err:
	mov	eax, msg_help
	jmp	exit_with_msg
