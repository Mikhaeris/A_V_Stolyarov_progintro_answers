%include "syscalls.inc"

global msg_help
global msg_errsrc
global msg_errdst
global msg_errnum
global exit_with_msg

section		.data

helpmsg		db "Usage: num", 10
helplen		equ $-helpmsg
err1msg		db "Couldn't open source file for reading", 10
err1len		equ $-err1msg
err2msg		db "Couldn't open destination file for writing", 10
err2len		equ $-err2msg
err3msg		db "Bad number!", 10
err3len		equ $-err3msg

msg_array	dd helpmsg, helplen, err1msg, err1len, err2msg, err2len, err3msg, err3len

msg_help	equ 0
msg_errsrc	equ 1
msg_errdst	equ 2
msg_errnum	equ 3

section .text

; in:
;	eax - message_id
exit_with_msg:
	sys_write 1, [msg_array + eax*8], [msg_array + eax*8 + 4]
	sys_exit 1
