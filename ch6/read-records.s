.include "ch6/linux.s"
.include "ch6/record-def.s"

.section .data

filename:
    .ascii "ch6/test.dat\0"

.section .bss

.lcomm RECORD_BUFFER, RECORD_SIZE

.section .text

.global _start

_start:
    .equ INPUT_DESCRIPTOR, -8
    .equ OUTPUT_DESCRIPTOR, -16

    mov %rsp, %rbp

    # open ch6/test.dat
    mov $SYS_OPEN, %rax
    mov $filename, %rdi
    mov $0, %rsi
    mov $0666, %rdx
    syscall

finished_reading:
    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
