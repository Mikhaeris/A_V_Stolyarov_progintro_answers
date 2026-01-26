%include "stud_io.inc"
global _start

%define IB_WORD
%macro fill_mem_by_str 1
	%strlen length %1

	%ifdef IB_WORD
		%define %%data_dir dw
	%elifdef IB_DOUBLE_WORD
		%define %%data_dir dd
	%elifdef IB_QUAD_WORD
		%define %%data_dir dq
	%else
		%error "Please define IB_WORD or IB_DOUBLE_WORD or IB_QUAD_WORD"
		%define %%data_dir
	%endif

	%ifnempty %%data_dir
		%assign i 1
		%rep length
			%substr curr_ch %1 i
			%%data_dir curr_ch
			%assign i i+1
		%endrep
	%endif
%endmacro

section .data
	fill_mem_by_str "ABC"
section .text
_start:
	FINISH
