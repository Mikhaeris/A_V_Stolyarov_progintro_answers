%include "stud_io.inc"
global _start

%macro bigif 0-*
	cmp eax, 1
	jb %%skip
	cmp eax, %0
	ja %%skip
	%assign n 1
	%rep %0
		cmp eax, n
		je %1
		%assign n n+1
		%rotate 1
	%endrep
	%%skip
%endmacro

section .text
_start:
	FINISH
