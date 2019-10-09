# as -g -o build/add-year.o ch6/add-year.s && as -g -o build/read-record.o ch6/read-record.s && as -g -o build/write-record.o ch6/write-record.s && ld -o build/add-year build/add-year.o build/read-record.o build/write-record.o && ./build/add-year

.include "ch6/linux.s"
.include "ch6/record-def.s"

.section .data

input_filename:
    .ascii "ch6/test.dat\0"

output_filename:
    .ascii "ch6/testout.dat\0"

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
    mov $input_filename, %rdi
    mov $0, %rsi
    mov $0666, %rdx
    syscall
    push %rax       # push input file descriptor onto stack

    # open ch6/testout.dat
    mov $SYS_OPEN, %rax
    mov $output_filename, %rdi
    mov $0101, %rsi
    mov $0666, %rdx
    syscall
    push %rax       # push output file descriptor onto stack

loop_begin:
    # invoke read_record function
    push INPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call read_record
    add $16, %rsp       # pop function args off of stack

    cmp $RECORD_SIZE, %rax
    jne loop_end

    incq RECORD_BUFFER + RECORD_AGE  # increment the age

    push OUTPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call write_record
    add $16, %rsp        

    jmp loop_begin

loop_end:
    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
