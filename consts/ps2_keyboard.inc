.include "mmio_basic.inc" once

.define PS2_KBD_BASE   #MMIO_BASE + (4096 * 2) ; fourth device (never changes) 

;; REGISTERS
; write a char to the uart console
.define PS2_KBD_STATUS  #PS2_KBD_BASE
.define PS2_KBD_DATA    #PS2_KBD_BASE + 0x04
.define PS2_KBD_CONTROL #PS2_KBD_BASE + 0x08

;; STATUS
.define PS2_DATA_READY     1 << 0
.define PS2_DATA_OVERFLOW  1 << 1

;; CONTROL
.define PS2_ENABLE_READY_IRQ    1 << 0
.define PS2_DATA_OVERFLOW_CLEAR 1 << 1