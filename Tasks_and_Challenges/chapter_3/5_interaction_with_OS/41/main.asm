%include "syscalls.inc"
global _start

extern exit_with_msg
extern msg_help
extern msg_errdst
extern msg_errnum

extern openf_or_die
extern get_length_str
extern atoi

section .bss

buf		resb 4096
buf_len		equ $-buf

section .data

ch_space	db ' '
ch_line_feed	db 10

section .text

; [ebp]    - argc
; [arg(0)] - program name
; [arg(1)] - first file name ptr
; [arg(2)] - second file name ptr
; [arg(3)] - str with num N ptr
; ...
; [local(1)] - file descriptor 1
; [local(2)] - file descriptor 2
; [local(3)] - int N
_start:
	mov	ebp, esp
	sub	esp, 12

	; if argc < 3
	cmp	[ebp], 3
	jb	.err_args

	; open first file with O_RDONLY
	push	dword msg_errdst
	push	dword 0x000
	push	dword [arg(1)]
	call	openf_or_die
	add	esp, 12
	mov	[local(1)], eax

	; open second file with O_WRONLY, O_CREAT and O_TRUNC
	push	dword msg_errdst
	push	dword 0x241
	push	dword [arg(2)]
	call	openf_or_die
	add	esp, 12
	mov	[local(2)], eax

	; get length [arg(3)]
	push	dword [arg(3)]
	call	get_length_str
	add	esp, 4

	; str to int
	push	eax
	push	dword [arg(3)]
	call	atoi
	add	esp, 8
	cmp	cl, 1
	je	.err_atoi
	mov	[local(3)], eax


.lp:
	; read data from file
	sys_read [local(1)], buf, buf_len
	test	eax, eax
	jz	.lp_end
	
	; min(read_data, N)
	mov	ebx, [local(3)]
	cmp	eax, ebx
	jbe	.write
	mov	eax, ebx

.write:
	push	eax

	; write data from buf
	sys_write [local(2)], buf, eax

	pop	eax
	sub	[local(3)], eax
	jz	.lp
.lp_end:

	; close file 1
	sys_close [local(1)]

	; close file 2
	sys_close [local(2)]

	sys_exit
.err_args:
	mov	eax, msg_help
	jmp	exit_with_msg
.err_atoi:
	mov	eax, msg_errnum
	jmp	exit_with_msg
