global _start

%macro sys_exit 0-1 0
	mov	ebx, %1
	mov	eax, 1
	int 	80h
%endmacro

%define arg(n) ebp+(4*n)+4
%define local(n) ebp-(4*n)

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

section .text
; main:
; arg(0) - program name
; arg(1) - pointer to first str
; arg(2) - pointer to second str
; ...
_start:
	mov	ebp, esp

	mov	edx, [ebp]	;argc
	xor	ebx, ebx	;max length
	xor	esi, esi	;number longet arg

	;if argc == 1
	cmp	edx, 1
	jbe	.end
	
	dec	edx
.lp:
	;get length cur arg
	mov	edi, [arg(edx)]
	push	edi
	call	get_length_str
	add	esp, 4

	;if cur length > max length
	cmp	ecx, ebx
	jb	.if_quit
	mov	ebx, ecx
	mov	esi, edx
.if_quit:
	
	dec	edx
	cmp	edx, 0
	jbe	.lp_end
	
	jmp	.lp

.lp_end:
	;print arg
	mov	edx, ebx
	mov	ecx, [arg(esi)]
	mov	ebx, 1
	mov	eax, 4
	int	80h

	;print '\n'
	push	10
	mov	edx, 1
	mov	ecx, esp
	mov	ebx, 1
	mov	eax, 4
	int	80h
	add	esp, 4

.end:
	sys_exit
