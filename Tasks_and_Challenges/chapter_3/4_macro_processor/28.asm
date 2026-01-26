%include "stud_io.inc"
global _start

;%1 init value
;%2 step
;%3 count
%macro init_mem 3
	%assign	val %1
	%rep %3
		dd	val
		%assign val val+%2
	%endrep
%endmacro

section .data

buf	init_mem 1, 2, 10
buf_len	equ	$-buf

section .text
_start:
	FINISH
