.section .data

.equ EXIT_SUCCESS, 0
.equ SYS_exit, 60

.section .text

.global _start

_start:
    mov $SYS_exit, %rax
    mov $EXIT_SUCCESS, %rdi
    syscall
