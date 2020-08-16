ifdef USEBASE
    INCLUDE "inc-base.asm"
else
    INCNES "base.nes"
endif

; ignore the base while generating the patch.
CLEARPATCH

; macros
SEEK EQU SEEKABS
SKIP EQU SKIPREL

MACRO SUPPRESS
    ENUM $
ENDM
ENDSUPPRESS EQU ENDE

MACRO SKIPTO pos
    if ($ >= 0)
        SKIP pos - $
        
        ; just to be safe.
        if ($ != pos)
            ERROR "failed to skipto."
        endif
    endif
ENDM
FROM EQU SKIPTO

MACRO BANK bank
    SEEK (bank * $4000) + $10
ENDM

CATCH_STAIRS=1

ifdef CATCH_STAIRS
    CHECK_STAIRS_ENABLED=1
endif
ifdef LATCH_STAIRS
    CHECK_STAIRS_ENABLED=1
endif