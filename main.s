@text
; this is the most deranged entry point i've ever seen
_start: JMP _main

.include "console.s" once

@data
test_string .asciz "Hello World And Fuck Myself"
@text

;; ========== ABI Definition ==========
;; R1 - return value / pointer
;; R2 to R9   - arg[0..7] (CALLER-SAVED; VOLATILE)
;; R10 to R20 - callee-saved regs (non-volatile)
;; R21 to R24 - reserved but can be used for anything (temporaries)
;; ====================================

; bios global entrypoint
_main:
    LDI   RSP, 0xFFFFF ; just a bare stack to get stuff started
    CALL  vga_hw_init

    LEA   R2, $test_string
    LDI   R3, 11
    CALL  console_puts
    JMP   spin

    KILL

test:
    LEA   R15, $test_string
    print:
        LDB     R2, [R15]
        CMP     R2, RZERO
        JEQ     out
        CALL    console_putc
        ADDI    R15, 1
        JMP     print
    out:
    CALL console_backspace
    spin: JMP spin
    RET ; tough luck bud