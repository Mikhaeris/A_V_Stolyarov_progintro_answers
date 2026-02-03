%include "syscalls.inc"

global openf_or_die
global get_length_str
global atoi

extern exit_with_msg

; in:
;	[arg(1)] - file name ptr
;	[arg(2)] - mode
;	[arg(3)] - err msg
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
