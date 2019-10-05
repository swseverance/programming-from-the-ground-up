# as -g -o build/count-chars.o ch6/count-chars.s

.type count_chars, @function
.global count_chars

# input: address of string
# output: number of characters in string (excluding null byte)
.equ STRING_ADDRESS, 16

count_chars:
    push %rbp
    mov %rsp, %rbp

    mov STRING_ADDRESS(%rbp), %rax   # address of string
    mov $0, %rdi

count_chars_loop:
    mov (%rax, %rdi, 1), %bl         # move character to lower byte of rbx register
    cmp $0, %bl
    je count_chars_end
    inc %rdi
    jmp count_chars_loop

count_chars_end:
    mov %rbp, %rsp
    pop %rbp
    
    mov %rdi, %rax
    ret
