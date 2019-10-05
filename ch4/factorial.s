# as -g -o build/factorial.o ch4/factorial.s && ld -o build/factorial build/factorial.o && ./build/factorial

.section .data

.equ SYS_exit, 60

.section .text

.global _start

# calculates 5!
_start:
    push $5
    call factorial
    add $8, %rsp            # pop 5 off the stack
    mov %rax, %rdi          # move result into rdi to check via `echo $?`
    mov $SYS_exit, %rax
    syscall

.type factorial, @function
factorial:
    push %rbp
    mov %rsp, %rbp

    mov 16(%rbp), %rax
    cmp $1, %rax
    je end_factorial
    dec %rax
    push %rax
    call factorial
    pop %rbx
    inc %rbx
    imul %rbx, %rax

end_factorial:
    mov %rbp, %rsp
    pop %rbp
    ret

