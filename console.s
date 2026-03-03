.include "drivers/vga_driver.s" once

; the standard character format
; no blinking|no underline|black background|white foreground
.define STD_CHAR_FORMAT (0 << 25) | (0 << 24) | (0 << 16) | (15 << 8)
.define LINEBREAK       10 ; yes, the \n

@text
; function: console_putc(char c) -> void
; @clobbers: R2 (arg0), R3, R4, R5, R6
console_putc:
    ; copy to R6 for format char 
    MOV     R6, R2
    CMPI    R6, #LINEBREAK ; check for linebreaks
    JEQ     _write_newline
    _write_normal_char:
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
        JMP     _end
    _write_newline:
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
        JMP     _end
    _end:
        RET

; function: console_backspace() -> void
; @clobbers: R2, R3
console_backspace:
    LDI     R2, #VGA_CURSOR_POS
    LDW     R3, [R2] ; current cursor position (not on any char)
    CMP     R3, RZERO
    JEQ     _finish ; cursor at 0, dont do anything
    _backspace:
        ; moves the cursor back by one
        ADDI    R3, -1
        STW     [R2], R3
        ; writes the empty char at the current location
        LDI     R2, #VGA_TEXT_VRAM_BASE
        SHLI    R3, 2 ; R2 + (R3 * 4)
        ADD     R2, R2, R3 ; now R2 holds abs the pos to delete
        STW     [R2], RZERO ; 0 == nothing
        JMP     _finish
    _finish:
        RET

; function: console_puts(char* c, size_t len) -> void
; @clobbers: R2 (arg0), R3 (arg1), R4, R5, R6, R7, R8
console_puts:
    MOV     R7, R2 ; pointer to text
    MOV     R8, R3
    _loop:
        ; for (i = R3; i >= 0; i--)
        CMP     R8, RZERO
        JEQ     __finish
        ; load next char to R2
        LDB     R2, [R7]
        CALL    console_putc
        ; update counter
        ADDI    R7, 1
        ADDI    R8, -1
        JMP     _loop
    __finish:
        RET