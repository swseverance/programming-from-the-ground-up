# as -g -o build/printf-example.o ch8/printf-example.s && ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o build/printf-example build/printf-example.o -lc && ./build/printf-example

.section .data

firststring:
    .ascii "Hello! %s is a %s who loves the number %d\n\0"
name:
    .ascii "Jonathan\0"
personstring:
    .ascii "person\0"
numberloved:
    .long 3

.equ EXIT, 60

.section .text

.globl _start
    
_start:
    mov $firststring, %rdi
    mov $name, %rsi
    mov $personstring, %rdx
    mov numberloved, %rcx
    call  printf
    
    mov $0, %rdi
    call  exit
