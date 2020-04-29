	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;	Line-buffered output functions    ;;
	;;  (Alex Moore, April 2020)		  ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	SECTION .data
SYS_write:	equ	1

bstored:	dq	0	; no. bytes in buffer
	
	
	SECTION .bss
	%define	BLEN	10
	
pbuff:	resb	BLEN 		; output buffer

	SECTION .text
	GLOBAL lbprintc
	;;
	;;	lbprintc(char) - print single char to STDOUT
	;; 
lbprintc:
	push rbp
	mov rbp, rsp

	mov rcx, qword [bstored]
	mov byte [pbuff+rcx], al
	inc rcx
	
	cmp al, 10		; check for newline
	je lbprintc_write	
	cmp rcx, BLEN		; check if buffer is full
	jne lbprintc_done	

lbprintc_write:			; flush buffer
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	mov rdx, rcx
	syscall
	mov rcx, 0

lbprintc_done:
	mov qword [bstored], rcx
	pop rbp
	ret


	GLOBAL lbprints
	;;
	;;	lbprints(char *) - print null-terminated string to STDOUT
	;; 			
lbprints:
	push rbp
	mov rbp, rsp
	push rbx

	lea rbx, [rax] 			; argument string 
	mov rcx, qword [bstored]	; buffer occupancy
buff_loop:
	mov al, byte [rbx]
	inc rbx
	cmp al, 0
	je lbprints_done		; no more bytes to read

	mov byte [pbuff+rcx], al
	inc rcx
	
	cmp al, 10		; check for newline
	je lbprints_write	
	cmp rcx, BLEN		; check if buffer is full
	jne buff_loop		
	
lbprints_write:			; flush buffer
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	mov rdx, rcx
	syscall

	;; rbx is preserved across function calls, so safe
	;; to loop back. rcx is NOT, but we don't care

	mov rcx, 0
	jmp buff_loop
	
lbprints_done:
	mov qword [bstored], rcx
	pop rbx
	pop rbp
	ret
	
	GLOBAL lbflush
	;;
	;;	bflush(void) - flush output buffer
	;; 
lbflush:
	push rbp
	mov rbp, rsp

	mov rdx, qword [bstored]
	cmp rdx, 0
	je lbflush_done

	mov rax, SYS_write
	mov rdi, 1
	mov rsi, pbuff
	syscall

	mov qword [bstored], 0 	; reset no. bytes stored

lbflush_done:	
	pop rbp
	ret
