global _start

%macro sys_exit 0-1 0
	mov	ebx, %1
	mov	eax, 1
	int 	80h
%endmacro

%define arg(n) ebp+(4*n)+4
%define local(n) ebp-(4*n)

section .text
; get length str:
;	arg(1) - pointer to str
; return:
;	ecx - length
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
	pop	esi

	mov	esp, ebp
	pop	ebp
	ret

; main:
; arg(0) - program name
; arg(1) - pointer to first str
; arg(2) - pointer to second str
_start:
	mov	ebp, esp

	;if argc < 3
	cmp	[ebp], 3
	jne	.err

	mov	esi, [arg(1)]
	mov	edi, [arg(2)]
	
	;get first str length
	push	dword esi
	call	get_length_str
	add	esp, 4
	mov	ebx, ecx
	
	;get second str length
	push	dword edi
	call	get_length_str
	add	esp, 4
	mov	edx, ecx
	
	;if length str1 != length str2
	cmp	ebx, edx
	je	.success

	;if last chars not equal
	mov	al, [edi+edx-1]
	mov	cl, [edi+edx-1]
	cmp	al, cl
	je	.success

	jmp	.err

.success:
	sys_exit
.err:
	sys_exit 1
