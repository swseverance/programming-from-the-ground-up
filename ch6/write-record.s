.include "record-def.s"
.include "linux.s"

# stack local variables
.equ ST_READ_BUFFER, 16
.equ ST_FILEDES, 24

.section .text

.global write_record
.type, @function
write_record:
    push %rbp
    mov %rsp, %rbp

    push %rbx
    mov ST_FILEDES(%rbp), %rdi
    mov ST_READ_BUFFER(%rbp), %rsi
    mov $RECORD_SIZE, %rdx
    mov $SYS_WRITE, %rax
    syscall
    pop %rbx
    
    mov %rbp, %rsp
    pop %rbp
    ret