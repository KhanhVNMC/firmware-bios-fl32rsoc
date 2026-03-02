.include "mmio_basic.inc" once

.define SOC_CTRL_BASE       #MMIO_BASE ; first device

;;; REGISTERS
; control the SoC platform power
.define SOC_POWER_CTRL      #SOC_CTRL_BASE
; installed memory and usable memory, in bytes (READONLY)
.define SOC_INFO_MEM        #SOC_CTRL_BASE + 0x04

; CPU vendor brand (16 chars) (READONLY)
.define SOC_CPU_VENDOR      #SOC_CTRL_BASE + 0xF0
.define SOC_CPU_VENDOR_LEN  16
; CPU steppings (1 byte)
.define SOC_CPU_STEPPINGS   #SOC_CPU_VENDOR + #SOC_CPU_VENDOR_LEN
; CPU brand string (48 bytes)
.define SOC_CPU_BRAND_STR   #SOC_CPU_STEPPINGS + 1
.define SOC_CPU_BRAND_LEN   48

;;; CONTROLS
.define SOC_PWR_OFF         1 << 0
.define SOC_RESET           1 << 1