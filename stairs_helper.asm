; sets varX to -varX if (varW & trbl).
    diag_flip:
        LDA varW
        AND #$2
        BNE diag_flip_rts
    ; perfom flip
    diag_flip_prf_x:
        SEC
        LDA #$0
        SBC varZ
        STA varZ
        LDA #$0
        SBC varX
        STA varX
    diag_flip_rts:
        RTS
        
    ; compress dx into varZ masked with 0xfc.
    ; this clobbers varZ, varX.
    diag_compress_x:
        LDA varZ
        LSR
        AND #$78
        STA varZ
        ROL varX
        ROL varZ
        RTS
        
    ; return value is in carry bit:
    ; SEC -- varZ < varBL,X or varBL,X not set.
    ; CLC -- varZ >= varBL,X (and varBL,X set)
    diag_compare_x:
        LDX varW
        LDA varBL,X
        BEQ sec_rts
        AND #$fc ; ignore the two data bits
        CMP varZ ; compare with varZ's (compressed) value.
        RTS
    sec_rts:
        SEC
    stairs_rts:
        RTS