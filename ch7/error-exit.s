.include "ch6/linux.s"

.equ ST_ERROR_CODE, 16
.equ ST_ERROR_MSG, 24

.global error_exit
.type error_exit, @function
error_exit:
    push %rbp
    mov %rsp, %rbp

    # write out the error code
    mov ST_ERROR_CODE(%rbp), %rsi
    push %rsi
    call count_chars
    pop %rsi
    mov %rax, %rdx          
    mov $STDERR, %rdi
    mov $SYS_WRITE, %rax
    syscall

    # write out the error message
    mov ST_ERROR_MSG(%rbp), %rsi
    push %rsi
    call count_chars
    pop %rsi
    mov %rax, %rdx          
    mov $STDERR, %rdi
    mov $SYS_WRITE, %rax
    syscall

    mov $SYS_EXIT, %rax
    mov $1, %rdi
    syscall
