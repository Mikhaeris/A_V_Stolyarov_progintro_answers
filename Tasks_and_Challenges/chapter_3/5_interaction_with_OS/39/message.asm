%include "syscalls.inc"
section .data

global msg_help
global msg_errsrc
global exit_with_msg

helpmsg		db "Usage: <src>", 10
helplen		equ $-helpmsg
err1msg		db "Couldn't open source file for reading", 10
err1len		equ $-err1msg

msg_array	dd helpmsg, helplen, err1msg, err1len

msg_help	equ 0
msg_errsrc	equ 1

section .text

; in:
;	eax - message_id
exit_with_msg:
	sys_write 1, [msg_array + eax*8], [msg_array + eax*8 + 4]
	sys_exit 1
