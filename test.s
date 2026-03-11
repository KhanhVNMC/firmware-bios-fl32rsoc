.include "consts/ps2_keyboard.inc" once

@text
; function: proc_test_keyboard() -> void
; @clobbers: RAX, RBX, RCX, RDX
; Note: this function never returns
proc_test_keyboard:
    ; poll the status register
    ldi rax, #PS2_KBD_STATUS
    ldw rax, [rax]
    andi rax, #PS2_DATA_READY ; check if data is ready
    cmp rax, rzero
    jeq proc_test_keyboard ; if not ready, keep polling
data_ready:
    ldi rax, #PS2_KBD_DATA ; read the char
    ldw rbx, [rax] ; store in rbx for later use
    ; check if it's a UP code (high bit set)
    mov rcx, rbx
    andi rcx, 0x80  
    cmp  rcx, rzero ; if zero, it's a down code, otherwise it's a up code
    jeq proc_test_keyboard ; if it's a key release, ignore and keep polling
    ; echo the char back to console
    call console_puts_int
    ldi rbx, ' ' ; space
    call console_putc
    jmp proc_test_keyboard
