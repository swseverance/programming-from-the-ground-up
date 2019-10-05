# as -g -o build/power.o ch4/power.s && ld -o build/power build/power.o && ./build/power

.section .data

.equ SYS_exit, 60

.section .text

.global _start

# calculates 2^3 + 5^2
_start:
    push $3
    push $2
    call power
    add $16, %rsp           # pop 2 & 3 off the stack
    push %rax               # push result of 2^3 onto the stack
    push $2
    push $5
    call power
    add $16, %rsp           # pop 5 & 2 off the stack
    add (%rsp), %rax        # add 2^3 to 5^2
    add $8, %rsp            # pop result of 2^3 off the stack
    mov %rax, %rdi          # move result into rdi to check via `echo $?`
    mov $SYS_exit, %rax
    syscall

.type power, @function
power:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp        # make room for local variable
    mov 16(%rbp), %rbx  # put first argument into rbx   (ex: 2 in 2^3)
    mov 24(%rbp), %rcx  # put second argument into rcx  (ex: 3 in 2^3)
    mov %rbx, -8(%rbp)  # write result to local variable

power_loop_start:
    cmp $1, %rcx        # if power == 1 then we're done
    je end_power
    mov -8(%rbp), %rax  # move current result into rax
    imul %rbx, %rax
    mov %rax, -8(%rbp)  # move result back into local variable
    dec %rcx
    jmp power_loop_start

end_power:
    mov -8(%rbp), %rax  # mov local variable into rax
    mov %rbp, %rsp
    pop %rbp
    ret
