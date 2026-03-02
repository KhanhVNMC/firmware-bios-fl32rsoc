.include "consts/soc_control.inc" once
.include "consts/hw_timer.inc" once
.include "consts/uart_console.inc" once
.include "consts/vga_graphics.inc" once

@data
test_string .asciz "Hello World And Fuck Myself"
@text

;; ========== ABI Definition ==========
;; R1 - return value / pointer
;; R2 to R9   - arg[0..7] (CALLER-SAVED; VOLATILE)
;; R10 to R20 - callee-saved regs (non-volatile)
;; R21 to R24 - reserved but can be used for anything (temporaries)
;; ====================================

test:
    LDI   RSP, 0xFFFFF
    CALL  init_vga
    LEA   R15, $test_string
    print:
        LDB     R2, [R15]
        CMP     R2, RZERO
        JEQ     spin
        CALL    vga_putc
        ADDI    R15, 1
        JMP     print
    spin: JMP spin

; function: init_vga() -> void
; @clobbers: R2, R3
init_vga:
    ; switch the screen ON first
    LDI     R2, #VGA_VIDEO_CONTROL
    LDI     R3, 0b01 ; VBLANKIRQ|ENABLE
    STW     [R2], R3
    ; change the video mode to TEXT (0x00)
    LDI     R2, #VGA_VIDEO_MODE
    STW     [R2], RZERO
    ; enable the blinking cursor
    LDI     R2, #VGA_CURSOR_CONTROL
    LDI     R3, 0b011 ; FULLBLOCK|BLINK|ENABLE
    STW     [R2], R3
    RET

; the standard character format
; no blinking|no underline|black background|white foreground
.define STD_CHAR_FORMAT (0 << 25) | (0 << 24) | (0 << 16) | (15 << 8)
.define LINEBREAK       10 ; yes, the \n

; function: vga_putc(char c) -> void
; @clobbers: R2 (arg0), R3, R4, R5, R6
vga_putc:
    ; copy to R6 for format char 
    MOV     R6, R2
    CMPI    R6, #LINEBREAK ; check for linebreaks
    JEQ     write_newline
    write_normal_char:
        ; read cursor position to determine where to write
        LDI     R3, #VGA_CURSOR_POS
        LDI     R4, #VGA_TEXT_VRAM_BASE
        LDW     R5, [R3]  ; now R5 holds the cursor pos
        ; format the character (OR'ing with the std template)
        ORI     R6, #STD_CHAR_FORMAT
        SHLI    R5, 2 ; R4 + (R5 * 4)
        ADD     R4, R4, R5 ; now R4 holds abs the pos to write
        ; write the char and push cursor forward
        STW     [R4], R6
        SHRI    R5, 2 ; R5 /= 4
        ADDI    R5, 1 ; inc
        STW     [R3], R5 ; writeback
        JMP     end
    write_newline:
        ; reset column to (x)
        LDI     R3, #VGA_CURSOR_X
        STW     [R3], RZERO
        ; move down 1 line
        LDI     R3, #VGA_CURSOR_Y 
        LDW     R4, [R3]
        ADDI    R4, 1 ; move down by 1
        STW     [R3], R4
        ; note: dont worry about X,Y and POS desyncing, they
        ; are backed by the same X, Y registers
        JMP     end
    end:
        RET


    