# as -g -o build/helloworld-lib.o ch8/helloworld-lib.s && ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o build/helloworld-lib build/helloworld-lib.o -lc && ./build/helloworld-lib

.section .data

helloworld:
    .ascii "hello world\n"

.section .text

.global _start

_start:
    push $helloworld
    call printf

    push $0
    call exit

