global _start

section .bss
tape resb 30000
program resb 131072
stack resq 8192

section .text

_start:

mov rbx,rsp
mov rax,[rbx]
cmp rax,2
jl exit

mov rdi,[rbx+16]
mov rax,2
xor rsi,rsi
xor rdx,rdx
syscall
cmp rax,0
jl exit
mov r12,rax

mov rax,0
mov rdi,r12
mov rsi,program
mov rdx,131072
syscall
mov r13,rax

mov rax,3
mov rdi,r12
syscall

mov rax,9
xor rdi,rdi
mov rsi,1048576
mov rdx,7
mov r10,34
mov r8,-1
xor r9,r9
syscall
mov r15,rax
mov r14,rax

mov rbx,program
lea r12,[program+r13]
xor r11,r11

compile:

cmp rbx,r12
jge compile_done

mov al,[rbx]

cmp al,'>'
je c_r

cmp al,'<'
je c_l

cmp al,'+'
je c_inc

cmp al,'-'
je c_dec

cmp al,'.'
je c_out

cmp al,','
je c_in

cmp al,'['
je c_lb

cmp al,']'
je c_rb

next:
inc rbx
jmp compile

c_r:
mov byte [r14],0x49
mov byte [r14+1],0xff
mov byte [r14+2],0xc5
add r14,3
jmp next

c_l:
mov byte [r14],0x49
mov byte [r14+1],0xff
mov byte [r14+2],0xcd
add r14,3
jmp next

c_inc:
mov byte [r14],0x41
mov byte [r14+1],0xfe
mov byte [r14+2],0x45
mov byte [r14+3],0x00
add r14,4
jmp next

c_dec:
mov byte [r14],0x41
mov byte [r14+1],0xfe
mov byte [r14+2],0x4d
mov byte [r14+3],0x00
add r14,4
jmp next

c_out:

mov byte [r14],0x48
mov byte [r14+1],0xc7
mov byte [r14+2],0xc0
mov dword [r14+3],1

mov byte [r14+7],0x48
mov byte [r14+8],0xc7
mov byte [r14+9],0xc7
mov dword [r14+10],1

mov byte [r14+14],0x4c
mov byte [r14+15],0x89
mov byte [r14+16],0xee

mov byte [r14+17],0x48
mov byte [r14+18],0xc7
mov byte [r14+19],0xc2
mov dword [r14+20],1

mov byte [r14+24],0x0f
mov byte [r14+25],0x05

add r14,26
jmp next

c_in:

mov byte [r14],0x48
mov byte [r14+1],0x31
mov byte [r14+2],0xc0

mov byte [r14+3],0x48
mov byte [r14+4],0x31
mov byte [r14+5],0xff

mov byte [r14+6],0x4c
mov byte [r14+7],0x89
mov byte [r14+8],0xee

mov byte [r14+9],0x48
mov byte [r14+10],0xc7
mov byte [r14+11],0xc2
mov dword [r14+12],1

mov byte [r14+16],0x0f
mov byte [r14+17],0x05

add r14,18
jmp next

c_lb:

mov byte [r14],0x41
mov byte [r14+1],0x80
mov byte [r14+2],0x7d
mov byte [r14+3],0x00
mov byte [r14+4],0x00

mov byte [r14+5],0x0f
mov byte [r14+6],0x84
mov dword [r14+7],0

mov [stack+r11*8],r14
inc r11
add r14,11
jmp next

c_rb:

dec r11
mov rax,[stack+r11*8]

mov byte [r14],0x41
mov byte [r14+1],0x80
mov byte [r14+2],0x7d
mov byte [r14+3],0x00
mov byte [r14+4],0x00

mov byte [r14+5],0x0f
mov byte [r14+6],0x85

mov rdx,rax
add rdx,11
sub rdx,r14
sub rdx,11
mov dword [r14+7],edx

add r14,11

mov rdx,r14
sub rdx,rax
sub rdx,11
mov dword [rax+7],edx

jmp next

compile_done:

mov byte [r14],0xc3

mov r13,tape

call r15

exit:
mov rax,60
xor rdi,rdi
syscall
