.include "ch6/record-def.s"
.include "ch6/linux.s"

# stack local variables
.equ ST_READ_BUFFER, 16
.equ ST_FILEDES, 24

.section .text

.global read_record
.type read_record, @function
read_record:
    push %rbp
    mov %rsp, %rbp

    push %rbx
    mov ST_FILEDES(%rbp), %rdi
    mov ST_READ_BUFFER(%rbp), %rsi
    mov $RECORD_SIZE, %rdx
    mov $SYS_READ, %rax
    syscall
    pop %rbx
    
    mov %rbp, %rsp
    pop %rbp
    ret
