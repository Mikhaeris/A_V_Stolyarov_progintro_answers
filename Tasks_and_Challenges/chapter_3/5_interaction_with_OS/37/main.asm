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

; condition_a
; arg(1) - pointer to string
; return:
;	eax - result(true - 1, false - 0)
condition_a:
	push	ebp
	mov	ebp, esp
	
	push	esi

	mov	esi, [arg(1)]
.lp:
	lodsb
	cmp	al, 'A'
	jb	.skip
	cmp	al, 'Z'
	ja	.skip
	jmp	.end_good

.skip:
	cmp	al, 0
	je	.end_bad
	jmp	.lp

.end_good:
	mov	eax, 1
	jmp	.end
.end_bad:
	mov	eax, 0
	jmp	.end
.end:
	pop	esi

	mov	ebp, esp
	pop	ebp
	ret

; condition_b
; arg(1) - pointer to string
; return:
;	eax - result(true - 1, false - 0)
condition_b:
	push	ebp
	mov	ebp, esp
	
	push	esi

	xor	ecx, ecx	;count '@'
	xor	edx, edx	;count '.'
	mov	esi, [arg(1)]
.lp:
	lodsb

	cmp	al, '@'
	jne	.check_dot
	inc	ecx
.check_dot:
	cmp	al, '.'
	jne	.skip
	inc	edx

.skip:
	cmp	al, 0
	je	.lp_end
	jmp	.lp

.lp_end:
	
	cmp	ecx, 1
	jne	.end_bad
	cmp	edx, 1
	jb	.end_bad
	jmp	.end_good

.end_bad:
	mov	eax, 0
	jmp	.end
.end_good:
	mov	eax, 1

.end:
	pop	esi

	mov	ebp, esp
	pop	ebp
	ret

; condition_c
; arg(1) - pointer to string
; arg(2) - string length
; return:
;	eax - result(true - 1, false - 0)
condition_c:
	push	ebp
	mov	ebp, esp
	
	push	esi

	mov	esi, [arg(1)]

	;check first char
	lodsb
	cmp	al, 'A'
	jb	.end_bad
	cmp	al, 'Z'
	ja	.end_bad

	mov	ecx, [arg(2)]
	;check last char
	cmp	ecx, 'a'
	jb	.end_bad
	cmp	ecx, 'z'
	ja	.end_bad
	
.end_good:
	mov	eax, 1
	jmp	.end
.end_bad:
	mov	eax, 0
	jmp	.end
.end:
	pop	esi

	mov	ebp, esp
	pop	ebp
	ret

; condition_d
; arg(1) - pointer to string
; return:
;	eax - result(true - 1, false - 0)
condition_d:
	push	ebp
	mov	ebp, esp
	
	push	esi

	mov	esi, [arg(1)]
	xor	ecx, ecx
	mov	cl, [esi]	;first char
.lp:
	lodsb

	;if eol
	cmp	al, 0
	je	.end_good

	;if cur ch != first ch
	cmp	al, cl
	jne	.end_bad

	jmp	.lp

.end_good:
	mov	eax, 1
	jmp	.end
.end_bad:
	mov	eax, 0
	jmp	.end
.end:
	pop	esi

	mov	ebp, esp
	pop	ebp
	ret
; main:
; arg(0) - program name
; arg(1) - pointer to first str
; arg(2) - pointer to second str
; ...
; locals:
; locals(0) - cur length str
_start:
	mov	ebp, esp
	sub	esp, 4

	mov	esi, [ebp]	;argc

	;if argc <= 1
	cmp	esi, 1
	jbe	.end
	
	mov	ebx, 1		;counter for loop
.lp:
	mov	edi, [arg(ebx)]	;cur pointer to str

	;get length to ecx
	push	edi
	call	get_length_str
	add	esp, 4
	mov	[local(0)], ecx

	;check a)
	push	edi
	call	condition_a
	add	esp, 4
	cmp	eax, 1
	je	.print_arg

	;check b)
	push	edi
	call	condition_b
	add	esp, 4
	cmp	eax, 1
	je	.print_arg
	
	;check c)
	push	dword [local(0)]
	push	edi
	call	condition_c
	add	esp, 4
	cmp	eax, 1
	je	.print_arg

	;check d)
	push	edi
	call	condition_d
	add	esp, 4
	cmp	eax, 1
	je	.print_arg

	jmp	.continue
.print_arg:
	push	ebx
	push	esi

	;syscall write
	;print str
	mov	edx, [local(0)]
	mov	ecx, edi
	mov	ebx, 1
	mov	eax, 4
	int	80h

	;syscall write
	;print '\n'
	push	10
	mov	edx, 1
	mov	ecx, esp
	mov	ebx, 1
	mov	eax, 4
	int	80h
	add	esp, 4

	pop	edx
	pop	ebx
.continue:
	inc	ebx
	cmp	ebx, esi
	je	.lp_end
	
	jmp	.lp

.lp_end:

.end:
	sys_exit
