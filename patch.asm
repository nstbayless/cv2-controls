; Build instructions: please se README_BUILD.md

INCLUDE "pre.asm"

INCLUDE "defs.asm"

; addresses

; free space in banks
BANK1_FREE = $b7ac
BANK3_FREE = $b74c

; ------------------------------------------------------------------------------
BANK 0
BASE $8000

ifndef BISQWIT
    FROM $ABE2
        JSR custom_flicker_draw_code
endif

; ------------------------------------------------------------------------------
BANK 1
BASE $8000

; injection in knockback code.
FROM $8844
    LDA player_state
    CMP #$09 ; is on stairs?
    BMI +
    LDA player_energy
    BEQ +
    JMP continue_knockback
    +
    JMP label_y

ifdef BISQWIT

    FROM $864D
        JSR custom_iframe_tick
        
    FROM $86F9
    label_aa:
        
    FROM BANK1_FREE
    
    custom_iframe_tick:
        DEX
        STX player_iframes
        TXA
        CMP #$80
        BNE +
        LDX #$00
        STX player_iframes
        +
        JMP label_aa
        
    include "flicker.asm"
    
    BANK1_FREE = $

else

    ; iframe reduction
    FROM $8648
    inject_iframe_reduction:
        JSR custom_iframes_reduction
        NOP
        NOP
        NOP
        NOP
        NOP

endif

FROM BANK1_FREE
label_y:
    LDA player_state
    CMP #$04 ; attacking
    BEQ ++
    LDY #$00
    ; compare enemy's x position and player's x position
    LDA player_x,X
    CMP player_x
    BCC +
    INY
    +
    STY player_facing
    JMP set_player_knockback
    
    ++
    LDA #$09 ; is on stairs?
    STA player_state
    JMP continue_knockback
        
ifndef BISQWIT
    custom_iframes_reduction:
        LDA player_iframes
        BEQ +
        CMP #$80
        BNE ++
        +
        LDA #$01
        STA player_iframes
        ++
        DEC player_iframes
        RTS
endif

; ------------------------------------------------------------------------------
BANK 3
BASE $8000
    
; --------------------------------------
; player step dispatch?
FROM $81c4

; player jump table
FROM $81dc
    dw #custom_stairs
    dw #custom_stairs

FROM $86E8:
    ; when walking off a cliff, enter jump state (2) 
    ; instead of fall state (5).
    ; normally this would be #$05.
    LDA #$02

FROM $86ED:
;  a*Y:A**
check_tile:

FROM $88D9
do_jump:

FROM $89CA
    
jmp_to_custom_jump_logic:
    JMP custom_jump_logic
    
player_step_jump:
    LDA $F5
    AND #$40
    BEQ jmp_to_custom_jump_logic

FROM $89D6
player_jump_logic:

FROM $8A52
player_step_A_stair_walk:

FROM $8AD9
player_step_9_stair_stand:

; knockback injection -- jump to custom jump code.
FROM $8A16
BNE jmp_to_custom_jump_logic

FROM $AADC
draw_player:

; -----------------------------------------------------
; custom functions
FROM BANK3_FREE

custom_jump_helper:
    LDX #$01
    LDY player_facing
    LDA button_down
    AND #$03 ; holding left and/or right?
    BEQ air_neutral_direction
    LSR
    BCC air_left_tilt
    STX player_air_xspeed
    STX player_facing
    BEQ air_right_tilt

air_left_tilt:
    DEX
    STX player_facing
    DEX
    STX player_air_xspeed
    BNE air_right_tilt

air_neutral_direction:
    DEX
    STX player_air_xspeed

air_right_tilt:
    LDA button_down
    AND #$80
    BNE no_vcancel
    JSR should_v_cancel
    BPL no_vcancel
    
vcancel:
    ; set player yspeed to 0.
    LDA #$00
    STA player_yspeed
    LDA #$00
    STA player_yspeed_frac

no_vcancel:
    LDA player_state
    CMP #$02 ; is jumping? (and not attacking)
    BEQ jmp_to_jump_logic
    ; reset facing if player is attacking
    STY player_facing
jmp_to_jump_logic:
    JMP player_jump_logic

custom_jump_logic:
    LDA player_state
    CMP #$06 ; is knockback?
    BNE zero_fracxspeed_then_custom_jump
    LDA player_yspeed
    BPL zero_fracxspeed_then_custom_jump
    BMI jmp_to_jump_logic

custom_stairs:
    LDA player_iframes
    CMP #$80
    BPL custom_stair_logic
    CMP #$20
    BPL hitstun

custom_stair_logic: 
    ; player can jump from the stairs.
    LDA button_pressed
    AND #$80 ; jump button pressed?
    BNE do_jump_from_stairs
jmp_to_player_step_stair:
    ; jump to the appropriate step handler (9 or A)
    LDA player_state
    CMP #$09 ; is on stairs?
    BNE jmp_to_player_step_A_stair_walk
    JMP player_step_9_stair_stand

jmp_to_player_step_A_stair_walk:
    JMP player_step_A_stair_walk

do_jump_from_stairs:
    ; zero the xspeed (for some reason) and then jump.
    LDA #$00
    STA player_air_xspeed
    STA player_xspeed_frac
    JMP do_jump
    
hitstun:
    BEQ end_hitstun
force_hitstun:
    ; zero the x- and y-speed. (stair stun.)
    LDA #$00
    LDY #$00
    JSR set_player_xspeed
    JSR set_player_yspeed
    RTS

end_hitstun:
    ; stop being hitstunned.
    LDA player_state
    CMP #$09 ; is on stairs?
    BEQ force_hitstun
    
    ; if was moving, restore movement.
    LDX #$00
    LDA player_image
    CMP #$08
    BMI restore_yspeed
    DEX

restore_yspeed:
    STX player_yspeed
    LDA #$80
    STA player_yspeed_frac
    STA player_xspeed_frac
    LDX #$00
    LDA player_facing
    BNE restore_xspeed
    DEX

restore_xspeed:
    STX player_air_xspeed
    BNE jmp_to_player_step_A_stair_walk

zero_fracxspeed_then_custom_jump:
    LDA #$00
    STA player_xspeed_frac
    JMP custom_jump_helper

is_vcancel_candidate:
    ; is the player rising and not inside of a tile?
    LDA player_yspeed
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
    JSR vcancel_check_cutscene
    TAX
    PLA
    TAY
    TXA
    RTS

; check cutscene, and if not a cutscene, check vcancel candidate.
vcancel_check_cutscene:
    LDA $04ED
    CMP #$FF
    BNE is_vcancel_candidate
    LDA $04A4
    CMP #$01
    BNE is_vcancel_candidate
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

;draw player conditional on iframe parity.
ifndef BISQWIT
    include "flicker.asm"
endif