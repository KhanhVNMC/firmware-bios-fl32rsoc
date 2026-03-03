@text
; this is the most deranged entry point i've ever seen
_start: JMP _main

.include "console.s" once
.include "drivers/soc_platform.s" once

@data
bios_brand_str_1  .ascii "Virtual SoC - ReferenceBIOS v1.00PC, FL32R Ref. System"
bios_brand_str_2  .ascii "Copyright (C) 2026, Why Are You Reading This"
bios_brand_str_3  .ascii "DEMO SYS-E SOC-PLT BIOS Revision 0"

cpu_model_str     .ascii "Main Processor: "
memory_str        .ascii "Installed Memory: "
memory_unit       .ascii " bytes"

end_message       .ascii "Press DEL to *not* enter SETUP, F8 to *not* Enter Boot Menu"  
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
    ; print header & branding
    LEA   R2, $bios_brand_str_1
    LDI   R3, length($bios_brand_str_1)
    CALL  console_puts
    LDI   R2, 0x10 
    CALL  console_putc ; newline
    LEA   R2, $bios_brand_str_2
    LDI   R3, length($bios_brand_str_2)
    CALL  console_puts
    LDI   R2, 0x10 
    CALL  console_putc ; newline
    CALL  console_putc ; newline
    LEA   R2, $bios_brand_str_3
    LDI   R3, length($bios_brand_str_3)
    CALL  console_puts
    LDI   R2, 0x10
    CALL  console_putc ; newline
    CALL  console_putc ; newline

    ; print CPU info
    LEA   R2, $cpu_model_str
    LDI   R3, length($cpu_model_str)
    CALL  console_puts
    LDI   R2, #SOC_CPU_BRAND_STR
    LDI   R3, 48
    CALL  console_puts
    LDI   R2, 0x10 
    CALL  console_putc ; newline
    ; print MEMORY info
    LEA   R2, $memory_str
    LDI   R3, length($memory_str)
    CALL  console_puts
    CALL  get_installed_mem
    MOV   R2, R1
    CALL  console_puts_int
    LEA   R2, $memory_unit
    LDI   R3, length($memory_unit)
    CALL  console_puts

    ; finish basic info
    LDI   R2, 0x10 
    CALL  console_putc ; newline
    CALL  console_putc ; newline

    LEA   R2, $end_message
    LDI   R3, length($end_message)
    CALL  console_puts

    JMP   spin
    KILL

test:
    LEA   R15, $cpu_model_str
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