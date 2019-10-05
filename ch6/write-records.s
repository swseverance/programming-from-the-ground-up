# as -g -o build/write-record.o ch6/write-record.s && as -g -o build/write-records.o ch6/write-records.s && ld -o build/write-records build/write-records.o build/write-record.o && ./build/write-records

.include "ch6/linux.s"
.include "ch6/record-def.s"

.section .data

record1:
    .ascii "Fredrick\0"
    .rept 31 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "Bartlett\0"
    .rept 31 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209 #Padding to 240 bytes
    .byte 0
    .endr

    .quad 45

record2:
    .ascii "Marilyn\0"
    .rept 32 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "Taylor\0"
    .rept 33 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203 #Padding to 240 bytes
    .byte 0
    .endr

    .quad 29

record3:
    .ascii "Derrick\0"
    .rept 32 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "McIntire\0"
    .rept 31 #Padding to 40 bytes
    .byte 0
    .endr

    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206 #Padding to 240 bytes
    .byte 0
    .endr

    .quad 36

file_name:
    .ascii "ch6/test.dat\0"

.equ FILE_DESCRIPTOR, -8

.global _start

_start:
    mov %rsp, %rbp

    # open the file
    mov $SYS_OPEN, %rax
    mov $file_name, %rdi
    mov $0101, %rsi         # create if it doesn't exist, and open for writing
    mov $0666, %rdx
    syscall

    push %rax               # push file descriptor onto the stack

    # write record1
    push FILE_DESCRIPTOR(%rbp)
    push $record1
    call write_record
    add $16, %rsp


    # write record2
    push FILE_DESCRIPTOR(%rbp)
    push $record2
    call write_record
    add $16, %rsp


    # write record3
    push FILE_DESCRIPTOR(%rbp)
    push $record3
    call write_record
    add $16, %rsp

    # close the file
    pop %rdi
    mov $SYS_CLOSE, %rax
    syscall

    # exit the program
    mov $0, %rdi
    mov $SYS_EXIT, %rax
    syscall
