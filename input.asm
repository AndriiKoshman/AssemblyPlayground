section .data
userMsg db 'Please enter any digits'
lenUserMsg equ $ - userMsg
dispMsg db 'Your input: '
lenDsipMsg equ $ - dispMsg

section .bss
num resb 5

section .text
global _start

_start:
mov eax, 4
mov ebx, 1
mov ecx, userMsg
mov edx, lenUserMsg
int 80h

mov eax, 3
mov ebx, 2
mov ecx, num
mov edx, 5
int 80h

mov eax, 4
mov ebx, 1
mov ecx, dispMsg
mov edx, lenDsipMsg
int 80h

mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 5
int 80h

mov eax, 1
mov ebx, 0
int 80h
