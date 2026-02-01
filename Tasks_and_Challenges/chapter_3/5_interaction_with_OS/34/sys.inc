%macro sys_exit 0-1 0
	mov	ebx, %1
	mov	eax, 1
	int 	80h
%endmacro

%define arg(n) ebp+(4*n)+4
%define local(n) ebp-(4*n)
