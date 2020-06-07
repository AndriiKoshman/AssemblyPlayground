SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

%macro print 2
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, %1
  mov edx, %2
  int 0x80
%endmacro

%macro input 2
  mov eax, SYS_READ
  mov ebx, STDIN
  mov ecx, %1
  mov edx, %2
  int 0x80
%endmacro

segment .data
   msg1 db "Введите цифру a: ", 0xA,0xD
   len1 equ $- msg1

   msg2 db "Введите вторую цифру j: ", 0xA,0xD
   len2 equ $- msg2

   msg3 db "Введите третью цифру k: ", 0xA,0xD
   len3 equ $- msg3

   msg4 db "Результат за формулой b = a * j - j^2 / (k + 2) равен: b = "
   len4 equ $- msg4
   lf db 0x0A

segment .bss
   a resd 1
   j resd 1
   k resd 1
   res resb 2
   res_len resb 1

section .text
   global _start    ;нужно объявить для использования gcc

_start:             ;указания точки входа для компоновщика
   print msg1, len1
   input a, 2

   print msg2, len2
   input j, 2

   print msg3, len3
   input k, 2

   ; b = a * j - j^2 / (k + 2)
   mov al, [a]
   sub al, '0'    ; вычитаем ascii '0' для конвертации её в десятичную цифру

   mov bl, [j]
   sub bl, '0'    ; вычитаем ascii '0' для конвертации её в десятичную цифру

   mov dl, [k]
   sub dl, '0'   ; вычитаем ascii '0' для конвертации её в десятичную цифру

   mul bl         ; a * j
   push eax       ; store a * j in stack
   mov al, bl     ; move j to al
   mul al         ; j^2
   add dl, 2      ; k + 2
   div dl         ; j^2 / (k + 2)
   mov ebx, eax   ; move j^2 / (k +2) to ebx
   pop eax        ; restore a * j from stack to eax
   sub eax, ebx   ; a * j - j^2

   ; Convert the number to a string
   mov edi, res                ; Argument: Address of the target string
   call int2str                ; Get the digits of EAX and store it as ASCII
   sub edi, res                ; EDI (pointer to the terminating NULL) - pointer to sum = length of the string
   mov [res_len], edi

   ; печатаем сумму
   print msg4, len4
   print res, [res_len]
   print lf, 1

exit:
   mov eax, SYS_EXIT
   xor ebx, ebx
   int 0x80

   int2str:    ; Converts an positive integer in EAX to a string pointed to by EDI
       xor ecx, ecx
       mov ebx, 10
       .LL1:                   ; First loop: Save the remainders
       xor edx, edx            ; Clear EDX for div
       div ebx                 ; EDX:EAX/EBX -> EAX Remainder EDX
       push dx                 ; Save remainder
       inc ecx                 ; Increment push counter
       test eax, eax           ; Anything left to divide?
       jnz .LL1                ; Yes: loop once more

       .LL2:                   ; Second loop: Retrieve the remainders
       pop dx                  ; In DL is the value
       or dl, '0'              ; To ASCII
       mov [edi], dl           ; Save it to the string
       inc edi                 ; Increment the pointer to the string
       loop .LL2               ; Loop ECX times

       mov byte [edi], 0       ; Termination character
       ret
