; Build instructions: please se README_BUILD.md

INCLUDE "pre.asm"

INCLUDE "defs.asm"

; location of some usable space in the different banks
BANK3_FREE = $b74c

ifndef BISQWIT
    BANK7_FREE = $bb00
else
    BANK7_FREE = $b800
endif

; ------------------------------------------------------------------------------
BANK 0
BASE $8000

FROM $ABE2
    JSR custom_flicker_draw_code

; ------------------------------------------------------------------------------
BANK 1
BASE $8000

ifdef BISQWIT

    FROM $864E
        db #>custom_flicker_draw_code
        db #<custom_flicker_draw_code
        
    FROM $86F9
    label_aa:
        
    FROM $B7AC
    custom_flicker_draw_code:
        DEX
        STX player_iframes
        TXA
        CMP #$80
        BNE +
        LDX #$00
        STX player_iframes
        +
        JMP label_aa
        
else

    FROM $8648
        JSR custom_iframes_reduction
        NOP
        NOP
        NOP
        NOP
        NOP
    
    FROM $8844
        LDA player_state
        CMP #$09
        BMI label_x
        LDA $80
        BEQ label_x
        JMP continue_knockback

    label_x:
        JMP label_y

endif

; ------------------------------------------------------------------------------
BANK 3
BASE $8000
    
; --------------------------------------
; player step dispatch?
FROM $81c4

; player jump table
FROM $81dc
    dw #custom_jump
    dw #custom_jump

FROM $86E8:
    ; normally this would be #$05.
    LDA #$02

FROM $86ED:
;  a*Y:A**
check_tile:

FROM $88D9
do_jump:

FROM $89CA
    -
    JMP label_o
    LDA $F5
    AND #$40
    BEQ -

FROM $89D6
jump_logic:

FROM $8A52
player_step_A_stair_walk:

FROM $8AD9
player_step_9_stair_stand:

; ??????????????????????????
FROM $8A16
BNE $89CA

FROM $AADC
draw_player:

; -----------------------------------------------------
; custom functions
FROM BANK3_FREE

custom_jump_helper:
    LDX #$01
    LDY player_facing
    LDA button_down
    AND #$03
    BEQ label_a
    LSR A
    BCC label_b
    STX player_air_xspeed
    STX player_facing
    BEQ label_c

label_b:
    DEX
    STX player_facing
    DEX
    STX player_air_xspeed
    BNE label_c

label_a:
    DEX
    STX player_air_xspeed

label_c:
    LDA button_down
    AND #$80
    BNE label_d
    JSR should_v_cancel
    BPL label_d
    LDA #$00
    STA player_vspeed
    LDA #$00
    STA player_vspeed_frac

label_d:
    LDA player_state
    CMP #$02
    BEQ label_e
    STY player_facing

label_e:
    JMP jump_logic

label_o:
    LDA player_state
    CMP #$06
    BNE label_p
    LDA player_vspeed
    BPL label_p
    BMI label_e
    db #$ff

custom_jump:
    LDA player_iframes
    CMP #$80
    BPL label_f
    CMP #$20
    BPL label_z

label_f:
    LDA button_pressed
    AND #$80
    BEQ label_g
    BNE label_h
    NOP

label_g:
    LDA player_state
    CMP #$09
    BNE label_i
    JMP player_step_9_stair_stand

label_i:
    JMP player_step_A_stair_walk

label_h:
    LDA #$00
    STA player_air_xspeed
    STA player_xspeed_frac
    JMP do_jump
    
label_z:
    BEQ label_j

label_k:
    LDA #$00
    LDY #$00
    JSR set_player_xspeed
    JSR set_player_yspeed
    RTS

label_j:
    LDA player_state
    CMP #$09
    BEQ label_k
    LDX #$00
    LDA player_image
    CMP #$08
    BMI label_l
    DEX

label_l:
    STX player_vspeed
    LDA #$80
    STA player_vspeed_frac
    STA player_xspeed_frac
    LDX #$00
    LDA player_facing
    BNE label_m
    DEX

label_m:
    STX player_air_xspeed
    BNE label_i

label_p:
    LDA #$00
    STA player_xspeed_frac
    JMP custom_jump_helper

label_n:
    LDA player_vspeed
    BPL label_rts
    LDY #$10
    JSR check_tile
    CMP #$01
    BPL label_rts
    CMP #$02
    BPL label_rts
    LDA #$FF
label_rts:
    RTS
    
should_v_cancel:
    TYA
    PHA
    JSR label_q
    TAX
    PLA
    TAY
    TXA
    RTS

label_q:
    LDA $04ED
    CMP #$FF
    BNE label_n
    LDA $04A4
    CMP #$01
    BNE label_n
    RTS

; ------------------------------------------------------------------------------
BANK 7
BASE $C000

; sets iframes on spawn(?)
FROM $C546
    db #$f8

FROM $D36A:
set_player_xspeed:

FROM $D362:
set_player_yspeed:

FROM $D36F:
set_player_knockback:

FROM $D395:
continue_knockback:

; ----------------------------------------------------
FROM $FEFA

label_y:
    LDA player_state
    CMP #$04 ; attacking
    BEQ label_r
    LDY #$00
    LDA player_x,X
    CMP player_x
    BCC label_u
    INY

label_u:
    STY player_facing
    JMP set_player_knockback
    
custom_iframes_reduction:
    LDA player_iframes
    BEQ label_t
    CMP #$80
    BNE label_s

label_t:
    LDA #$01
    STA player_iframes

label_s:
    DEC player_iframes
    RTS

label_r:
    LDA #$09 ; stair-find
    STA player_state
    JMP continue_knockback

; ----------------------------------------------------
FROM $FFA5

;draw Simon conditional on iframe parity.
ifndef BISQWIT
    custom_flicker_draw_code:
        LDA player_iframes
        AND #$01
        BNE label_v

    label_w:
        JMP draw_player

    label_v:
        LDA player_state
        NOP
        NOP
        NOP
        NOP
        AND #$80
        BNE label_w
        RTS
endif