%include "syscalls.inc"
global _start

extern openf_or_die
extern count_line_feed
extern itoa
extern exit_with_msg

extern msg_help

section .bss

data		resb 4096
data_size	equ $-data

buf		resb 10
buf_size	equ $-buf

section .data

line_feed	db 10

section .text

; [ebp]  - argc
; arg(0) - program name
; arg(1) - pointer to first arg
; ...
; local(1) - file descriptor
_start:
	mov	ebp, esp
	sub	esp, 4

	; if argc < 1
	cmp	[ebp], 2
	jne	.err
	
	; open file
	push	dword 0
	push	dword [arg(1)]
	call	openf_or_die
	add	esp, 8
	mov	[local(1)], eax

	xor	ebx, ebx
.lp:
	; read data from file
	push	ebx
	sys_read [local(1)], data, data_size
	pop	ebx
	cmp	eax, 0
	je	.end_lp

	; count line feeds in data
	push	eax
	push	data
	call	count_line_feed
	add	esp, 8
	add	ebx, eax

	jmp	.lp
.end_lp:
	; int to str
	push	dword buf
	push	ebx
	call	itoa
	add	esp, 8

	; calc real start
	mov	ecx, 10
	sub	ecx, eax
	
	mov	ebx, buf
	add	ebx, ecx

	; print num str
	sys_write 1, ebx, eax

	; print '\n'
	sys_write 1, line_feed, 1

	; close file
	sys_close [local(1)]

	sys_exit
.err:
	mov	eax, msg_help
	jmp	exit_with_msg
