	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; 	Test routine for lbprints, lbprintc ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	SECTION .data
SYS_exit:	equ	60

teststr1:	db	"testing 123 testing 123 testing 123", 0xa, 0
teststr2:	db	"testing 321 testing 321 testing 321", 0
teststr3:	db	0
	

	SECTION .text
	EXTERN lbprints, lbprintc, lbflush ; from lbprint.s
	
	GLOBAL _start
_start:
	mov rax, teststr1 	; check string with newline
	call lbprints

	mov rax, teststr2 	; check string without newline
	call lbprints
	call lbflush

	mov rax, teststr3	; check empty string
	call lbprints
	call lbflush

	mov rax, 0xa
	call lbprintc

	mov rax, "a"
	call lbprintc
	mov rax, "b"
	call lbprintc
	mov rax, "c"
	call lbprintc
	mov rax, 0xa
	call lbprintc

	mov rax, SYS_exit
	mov rdi, 0
	syscall
