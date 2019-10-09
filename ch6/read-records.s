# as -g -o build/read-record.o ch6/read-record.s && as -g -o build/read-records.o ch6/read-records.s && as -g -o build/count-chars.o ch6/count-chars.s && ld -o build/read-records build/read-records.o build/read-record.o build/count-chars.o && ./build/read-records

.include "ch6/linux.s"
.include "ch6/record-def.s"

.section .data

filename:
    .ascii "ch6/test.dat\0"

newline:
    .ascii "\n\0"

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

    push %rax       # push input file descriptor onto stack
    push $STDOUT    # push output file descriptor onto stack

record_read_loop:
    # invoke read_record function
    push INPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call read_record
    add $16, %rsp       # pop function args off of stack

    cmp $RECORD_SIZE, %rax
    jne finished_reading

    push $RECORD_FIRSTNAME + RECORD_BUFFER
    call count_chars
    add $8, %rsp        

    mov %rax, %rdx                      # count of chars to print
    mov $RECORD_BUFFER, %rsi
    mov OUTPUT_DESCRIPTOR(%rbp), %rdi
    mov $SYS_WRITE, %rax
    syscall

    mov $1, %rdx                      # count of chars to print
    mov $newline, %rsi
    mov OUTPUT_DESCRIPTOR(%rbp), %rdi
    mov $SYS_WRITE, %rax
    syscall

    jmp record_read_loop

finished_reading:
    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
