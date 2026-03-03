.include "../consts/soc_control.inc" once

; function: soc_power_off() -> void
; @clobbers: R2, R3
soc_power_off:
    LDI     R2, #SOC_POWER_CTRL
    LDI     R3, #SOC_PWR_OFF 
    STB     [R2], R3
    RET

; function: soc_reset() -> void
; @clobbers: R2, R3
soc_reset:
    LDI     R2, #SOC_POWER_CTRL
    LDI     R3, #SOC_RESET 
    STB     [R2], R3
    RET

; function: get_installed_mem() -> uint32
; @clobbers: R1 (ret), R2
get_installed_mem:
    LDI     R2, #SOC_INFO_MEM
    LDW     R1, [R2]
    RET