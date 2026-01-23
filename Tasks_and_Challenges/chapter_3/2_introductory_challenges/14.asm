%include "stud_io.inc"
global _start

_start:
	xor	ecx, ecx	;cur longest word len
	xor	ebx, ebx	;cur word len
	xor	esi, esi	;last word len
.main_lp:
	GETCHAR
	
	;if end of file
	cmp	eax, -1
	je	.eof_situation

	;if end of line
	cmp	eax, 10
	je	.print_inf
	
	cmp	eax, ' '
	je	.process_word_len
	
	inc	ebx	
	jmp	.main_lp

.process_word_len:
	;if cur word len is zero
	test	ebx, ebx
	jz	.main_lp
	
	mov	esi, ebx
	;if longest word len < cur word len
	cmp	ecx, ebx
	ja	.exit_f
	mov	ecx, ebx

.exit_f:
	xor	ebx, ebx
	jmp	.main_lp

.print_inf:
	;if no words in line
	jecxz	.main_lp

	;check last word be process
	test	ebx, ebx
	jz	.lp
	mov	esi, ebx

	;if longest word len < cur word len
	cmp	ecx, ebx
	ja	.lp
	mov	ecx, ebx
	
.lp:
	PUTCHAR	'*'
	loop	.lp
	PUTCHAR	10

	mov	ecx, esi
.lp2:
	PUTCHAR	'*'
	loop	.lp2
	PUTCHAR	10
	
	xor	ecx, ecx
	xor	ebx, ebx
	xor	esi, esi
	jmp	.main_lp

.eof_situation:
	;if no words in line
	test	ecx, ecx
	jz	.exit
	
	PUTCHAR	10

	;check last word be process
	test	ebx, ebx
	jz	.lp3
	mov	esi, ebx

	;if longest word len < cur word len
	cmp	ecx, ebx
	ja	.exit_f
	mov	ecx, ebx
	
.lp3:
	PUTCHAR	'*'
	loop	.lp3
	PUTCHAR	10

	mov	ecx, esi
.lp4:
	PUTCHAR	'*'
	loop	.lp4
	PUTCHAR	10
	
	xor	ecx, ecx
	xor	ebx, ebx
	xor	esi, esi

.exit:
	FINISH
