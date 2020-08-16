IFDEF CHECK_STAIRS_ENABLED

stair_checking_subroutine:
    IFDEF CATCH_STAIRS
        ; fall through if holding down
        LDA button_down
        AND #$04
        BNE pre_stairs3_rts
    ENDIF

    IFDEF LATCH_STAIRS
        ; fall through unless holding up
        LDA button_down
        AND #$08
        BEQ pre_stairs3_rts
    ENDIF
    
    ; pass through stairs when rising.
    LDA player_yspeed
    BMI pre_stairs3_rts
    
    ; calculate player X and Y position
calc_px:
    CLC
    LDA player_x
    ADC camera_x
    STA varPX
    LDA #$0
    ADC camera_x_screen
    STA varPX2
calc_py:
    ; this stores the y coords in varPY:varPY2
    LDX #$0
    JSR calc_object_y_position
    
    ; clear the temporary store.
    LDA #$0
    STA varBL
    STA varBR
    STA varTR
    STA varTL
    
    ; bankswitch ----
    LDA #>return_from_stair_checking_subroutine
    PHA
    LDA #<return_from_stair_checking_subroutine-1
    PHA
    LDA #$3 ; return bank (this bank)
    PHA
    LDA #>stair_checking_subroutine_b2
    PHA
    LDA #<stair_checking_subroutine_b2-1
    PHA
    LDA #$2 ; destination bank
    
    JMP bankswitch
    
    ; end bankswitch ----

return_from_stair_checking_subroutine:
    
    
    ; ~~ check if any varBL,X set and marked as catching ~~
    LDX #$0

    mincheck_loop_start:
        LDA varBL,X
        TAY
        AND #$1 ; was this one set?
        BEQ mincheck_loop_next
        TYA
        AND #$2 ; was this one marked catching?
        BEQ mincheck_loop_next
        
    stair_check_butterzone:
        ; found a successful match -- This is the butterzone.
        ; (a true stair collision)
        
        ; set stair direction
        TXA
        LSR
        AND #$1
        STA player_stair_direction
        
        ; modify player y to be exactly on stair.
        SEC 
        
        LDY varPX
        
        ; "swap" (negate) x if trbl
        TXA
        AND #$2
        ; (temporarily set to JMP for debug purposes)
        BNE +
        
        ; swap x (calc 0x10 - x)
        SEC
        LDA #$10
        SBC varPX
        TAY
        
      + TYA
        SEC
        STA varBL ; we'll use this later.
        SBC varPY
        
        ; A now holds player_x-player_y
        AND #$7
        ; A now holds (player_x-player_y) % 8
        BEQ +
        SEC
        SBC #$8
        ; A now holds (player_x-player_y) % 8 [nonpositive equivalence class]
        
      + CLC
        ADC player_y
        
        ; if player would end up out of bounds, abort.
        CMP #10
        BCC mincheck_loop_end
        CMP #$E0
        BCS mincheck_loop_end
        
        STA player_y
        
        ; don't do the remainder of the jump update,
        ; since gravity will affect yspeed.
        PLA
        PLA
        PLA
        PLA
        
        ; sets some flags which are probably important.
        LDA player_facing
        BEQ +
        JSR player_step_9_press_right
        BEQ ++ ; guaranteed
      + JSR player_step_9_press_left
     ++ JSR player_step10_set_sprite
        ; set on stairs
        
        LDA varBL ; player x [or -player x, depending on direction]
        AND #$7
        BEQ set_stair_standing
        
        ; adjust player stair timer to end at correct spot.
        ASL
        STA varBL
        LDA player_stair_timer
        SEC
        SBC varBL
        STA player_stair_timer
        
      zero_fraccoord:
        LDA #$0
        STA player_x_frac
        STA player_y_frac
        RTS
        
    mincheck_loop_next:
        INX
        CPX #$4
        BNE mincheck_loop_start
    mincheck_loop_end:
        RTS
    
    set_stair_standing:
      LDA #$9
      STA player_state
      
      ; zero speed and fractional coordinates
      LDA #$0
      STA player_yspeed
      STA player_yspeed_frac
      STA player_xspeed
      STA player_xspeed_frac
      BNE zero_fraccoord ; guaranteed
    
    
ENDIF