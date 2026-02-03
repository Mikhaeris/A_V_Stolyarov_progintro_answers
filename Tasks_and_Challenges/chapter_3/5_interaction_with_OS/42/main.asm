%include "syscalls.inc"
global _start

extern msg_errdst

extern openf_or_die

section .bss

prev_char	resb 1
char		resb 1

section .data

ch_space	db ' '
ch_line_feed	db 10

filename	db "result.dat", 0

section .text

; [ebp]    - argc
; [arg(0)] - program name
; ...
; [local(1)] - file descriptor
; [local(2)] - max length
_start:
	mov	ebp, esp
	sub	esp, 8
	mov	dword [local(2)], 0

	xor	ebx, ebx		; count eol
	xor	esi, esi		; cur length
	xor	edi, edi		; all length

.lp:
	; read data from file
	sys_read 0, char, 1
	test	eax, eax
	jz	.lp_end

	inc	esi
	inc	edi

	; if not eol
	cmp	byte [char], 10
	jne	.skip

	; count eol += 1
	inc	ebx
	
	; clear esi
	mov	eax, esi
	xor	esi, esi

	; if cur length < mex length
	cmp	eax, [local(2)]
	jb	.skip
	; else max length == cur length
	mov	[local(2)], eax

.skip:
	mov	al, [char]
	mov	[prev_char], al
	jmp	.lp
.lp_end:

	; if file size is zero or prev_char == '\n'
	cmp	byte [prev_char], 10
	je	.write_data
	cmp	byte [prev_char], 0
	je	.write_data

	; else
	inc	ebx

	; if one line with eof
	cmp	esi, [local(2)]
	jne	.write_data
	mov	[local(2)], esi
	
.write_data:
	; open second file with O_WRONLY, O_CREAT and O_TRUNC
	push	dword msg_errdst
	push	dword 0x241
	push	dword filename
	call	openf_or_die
	add	esp, 12
	mov	[local(1)], eax

	push	dword [local(2)]
	push	edi
	push	ebx
	mov	ecx, esp
	sys_write [local(1)], ecx, 12
	add	esp, 12

	; close file 1
	sys_close [local(1)]

	sys_exit
