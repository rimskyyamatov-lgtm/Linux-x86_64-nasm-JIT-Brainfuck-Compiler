# Linux-x86_64-nasm-JIT-Brainfuck-Compiler
This is a Braunfuck JIT compiler written in nasm for Linux x86_64.


How to run
Compile
nasm -f elf64 bfc.asm -o bfc.o

Link
ld bfc.o -o bfc

Execute
./bfc filename
