	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; 	Fully-buffered output functions	;;
	;; (Alex Moore, April 2020)		;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	SECTION .data
SYS_write:	equ	1

bstored:	dq	0 	; no. bytes in buffer
	
	
	SECTION .bss
	%define	BLEN	10
	
pbuff:	resb	BLEN 		; output buffer

	SECTION .text
	
	GLOBAL bprintc
	;;
	;;	bprintc(char) - print single char to STDOUT
	;;
bprintc:
	push rbp
	mov rbp, rsp

	mov rcx, qword [bstored]
	mov byte [pbuff+rcx], al
	inc rcx
	cmp rcx, BLEN
	jne bprintc_done

	;; buffer full, write to stdout
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	mov rdx, BLEN
	syscall
	mov rcx, 0

bprintc_done:
	mov qword [bstored], rcx
	pop rbp
	ret


	GLOBAL bprints
	;;
	;; 	bprints(char *) - print null-terminated string to STDOUT
	;; 
bprints:
	push rbp
	mov rbp, rsp
	push rbx
	
	lea rbx, [rax] 			; argument string
	mov rcx, qword [bstored]	; buffer occupancy
buff_loop:
	mov al, byte [rbx]
	inc rbx
	cmp al, 0
	je bprints_done		; no more bytes to read

	mov byte [pbuff+rcx], al
	inc rcx
	cmp rcx, BLEN
	jne buff_loop

	;; write to stdout
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	mov rdx, rcx
	syscall

	;; rbx is preserved across function calls, so safe
	;; to loop back. rbx is NOT, but we don't care

	mov rcx, 0
	jmp buff_loop
	
bprints_done:
	mov qword [bstored], rcx
	pop rbx
	pop rbp
	ret
	
	GLOBAL bflush
	;;
	;;	bflush(void) - flush output buffer
	;; 
bflush:
	push rbp
	mov rbp, rsp

	mov rdx, qword [bstored]
	cmp rdx, 0
	je bflush_done

	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	syscall

	mov qword [bstored], 0 	; reset no. bytes stored

bflush_done:	
	pop rbp
	ret
