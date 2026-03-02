.include "../consts/vga_graphics.inc" once

@text
; function: vga_init() -> void
; @clobbers: R2, R3
vga_hw_init:
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