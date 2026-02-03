%define arg(n) ebp+(4*n)+4
%define local(n) ebp-(4*n)

; %1 - code
%macro sys_exit 0-1 0
	push	ebx

	mov	ebx, %1
	mov	eax, 1
	int 	80h

	pop	ebx
%endmacro

; %1 - file name ptr
; %2 - flags
%macro sys_open 2
	push	ebx

	push	dword %1
	push	dword %2
	mov	edx, 0666q
	pop	ecx
	pop	ebx
	mov	eax, 5
	int	80h

	pop	ebx
%endmacro

; %1 - file descriptor
%macro sys_close 1
	push	ebx

	mov	ebx, %1
	mov	eax, 6
	int	80h

	pop	ebx
%endmacro

; %1 - file descriptor
; %2 - buf ptr
; %3 - count
%macro sys_read 3
	push	ebx

	push	dword %1
	push	dword %2
	push	dword %3
	pop	edx
	pop	ecx
	pop	ebx
	mov	eax, 3
	int	80h

	pop	ebx
%endmacro

; %1 - file descriptor
; %2 - buf ptr
; %3 - count
%macro sys_write 3
	push	ebx

	push	dword %1
	push	dword %2
	push	dword %3
	pop	edx
	pop	ecx
	pop	ebx
	mov	eax, 4
	int	80h

	pop	ebx
%endmacro
