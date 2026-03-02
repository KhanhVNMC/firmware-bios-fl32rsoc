.include "mmio_basic.inc" once

.define HW_TIMER_BASE       #MMIO_BASE + 4096 ; second device (never changes) 

;;; REGISTERS
; to get the full range (64bit), HI<<32|LO
.define HW_TIMER_COUNT_LO   #HW_TIMER_BASE
.define HW_TIMER_COUNT_HI   #HW_TIMER_BASE + 0x04
; fire an IRQ every n microseconds
.define HW_TIMER_COMPARE    #HW_TIMER_BASE + 0x08
; control this device
.define HW_TIMER_CONTROL    #HW_TIMER_BASE + 0x0C

;;; CONTROLS
; enable timer counting
.define TIMER_CTRL_ENABLE        1 << 0 
; allow timer to raise IRQ 
.define TIMER_CTRL_IRQ_ENABLE    1 << 1
; auto-reload after IRQ 
.define TIMER_CTRL_PERIODIC      1 << 2

; W1C: acknowledge / clear pending IRQ
.define TIMER_CTRL_IRQ_ACK       1 << 3
; W1C: reset timer to power-on state 
.define TIMER_CTRL_RESET         1 << 4