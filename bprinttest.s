	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; 	Test routine for bprints, bprintc ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	SECTION .data
SYS_exit:	equ	60

	
teststr1:	db	"testing 123 testing 123 testing 123", 10, 0
teststr2:	db	0
	
	SECTION .text
	EXTERN bprints, bprintc, bflush ; from bprint.s
	
	GLOBAL _start
_start:
	mov rax, teststr1	; check string longer than buffer
	call bprints
	call bflush

	mov rax, teststr2	; check empty string
	call bprints
	call bflush

	mov rax, "a"		
	call bprintc
	mov rax, "b"
	call bprintc
	mov rax, "c"
	call bprintc
	mov rax, 0xa
	call bprintc
	call bflush

	mov rax, SYS_exit
	mov rdi, 0
	syscall
