.include "mmio_basic.inc" once

.define UART_CONSOLE_BASE   #MMIO_BASE + (4096 * 2) ; third device (never changes) 

;; REGISTERS
; write a char to the uart console
.define UART_CONSOLE_CHAR   #UART_CONSOLE_BASE 
; writes a word (a number) to the UART console
.define UART_CONSOLE_WORD   #UART_CONSOLE_BASE + 0x04
; readonly. UART status
.define UART_CONSOLE_STATUS #UART_CONSOLE_BASE + 0x08

;; STATUS
.define UART_CONSOLE_READY  0x1