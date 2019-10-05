# as -g -o build/toupper.o ch5/toupper.s && ld -o build/toupper build/toupper.o && ./build/toupper ch5/input.txt ch5/output.txt

.section .data

# system call numbers
.equ SYS_OPEN,  2
.equ SYS_WRITE, 1
.equ SYS_READ,  0
.equ SYS_CLOSE, 3
.equ SYS_EXIT,  60

# options for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101    # create, write-only, truncate

# end of file result status
.equ END_OF_FILE, 0

.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# stack positions
.equ ST_SIZE_RESERVE, 16
.equ ST_FD_IN, 0
.equ ST_FD_OUT, 8
.equ ST_ARGC, 16
.equ ST_ARGV_0, 24
.equ ST_ARGV_1, 32
.equ ST_ARGV_2, 40

.global _start

_start:
    sub $ST_SIZE_RESERVE, %rsp  # allocate space on the stack
    mov %rsp, %rbp

open_files:
open_fd_in:
    mov ST_ARGV_1(%rbp), %rdi   # address of input filename
    mov $O_RDONLY, %rsi
    mov $SYS_OPEN, %rax
    syscall

store_fd_in:
    mov %rax, ST_FD_IN(%rbp)

open_fd_out:
    mov ST_ARGV_2(%rbp), %rdi           # address of output filename
    mov $0666, %rdx                     # perms
    mov $O_CREAT_WRONLY_TRUNC, %rsi
    mov $SYS_OPEN, %rax
    syscall

store_fd_out:
    mov %rax, ST_FD_OUT(%rbp)

read_loop_begin:
    mov ST_FD_IN(%rbp), %rdi   # file descriptor of input file
    mov $BUFFER_DATA, %rsi     # address of buffer
    mov $BUFFER_SIZE, %rdx     # count of characters to read
    mov $SYS_READ, %rax
    syscall
    cmp $0, %rax
    jle end_loop

continue_read_loop:
    push $BUFFER_DATA
    push %rax                   # number characters read from input file
    call convert_to_upper
    pop %rax                    # pop off number of characters
    add $8, %rsp                # pop off buffer address

    mov ST_FD_OUT(%rbp), %rdi   # file descriptor of output file
    mov $BUFFER_DATA, %rsi
    mov %rax, %rdx               # number of characters to write
    mov $SYS_WRITE, %rax
    syscall
    jmp read_loop_begin

end_loop:
    mov ST_FD_IN(%rbp), %rdi        # close input file
    syscall

    mov ST_FD_OUT(%rbp), %rdi       # close output file
    syscall
    
    mov $0, %rdi
    mov $SYS_EXIT, %rax
    syscall

# function convert_to_upper

# constants

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

# stack positions

.equ ST_BUFFER_LEN, 16
.equ ST_BUFFER, 24

convert_to_upper:
    push %rbp
    mov %rsp, %rbp
    mov ST_BUFFER(%rbp), %rax
    mov ST_BUFFER_LEN(%rbp), %rbx
    mov $0, %rdi
    cmp $0, %rbx
    je end_convert_loop

convert_loop:
    mov (%rax,%rdi,1), %cl  # lower byte of rcx
    cmp $LOWERCASE_A, %cl
    jl next_byte
    cmp $LOWERCASE_Z, %cl
    jg next_byte
    add $UPPER_CONVERSION, %cl
    mov %cl, (%rax,%rdi,1)

next_byte:
    inc %rdi
    cmp %rdi, %rbx
    jne convert_loop

end_convert_loop:
    mov %rbp, %rsp
    pop %rbp
    ret
