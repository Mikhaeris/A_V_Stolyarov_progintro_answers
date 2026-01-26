%include "stud_io.inc"
global _start

%macro fill_mem_by_str 1
	%strlen length %1
	%assign i 1
	%rep length
		%substr curr_ch %1 i
		dd curr_ch
		%assign i i+1
	%endrep
%endmacro

section .text
_start:
	FINISH
