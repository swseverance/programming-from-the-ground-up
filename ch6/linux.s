# system call numbers
.equ SYS_EXIT, 60
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# common status codes
.equ END_OF_FILE, 0
