IFDEF CHECK_STAIRS_ENABLED

include "stairs_helper.asm"

jmp_to_stair_loop_end:
    JMP stair_loop_end

stair_checking_subroutine_b2:
    ; can latch onto stairs above this;
    ; actually, this has to be exactly 8 as currently written.
    epsilon=#$8
    
    LDY #$FF ; after the following INY, this will be 0.
    stair_loop_begin_yinc:
        INY
        ; load stair data low-byte
        LDA (world_stairs_ptr),Y
        TAX
    check_ff_end_marker:
        ; check if byte is 0xff
        INX
        BEQ jmp_to_stair_loop_end
        DEX
        
    zero_inloop_vars:
        LDA #$0
        STA varW
        ; after ASL twice, byte is $00 and carry is set.
        LDA #$40
        STA varYY
        STA varX
        
        ; get high byte for stairs
        INY
        LDA (world_stairs_ptr),Y
        
    stair_loop_calc_y:
        ; multiply by 8
        ASL
        ROL varW ; varW = is flipped?
        ASL
        ROL varYY
        ASL
        ROL varYY
        STA varY
        
        ; carry is 1 because varYY=#$40 initially.
        
    stair_loop_calc_dy:
        ; calculate y difference (player_y - y)
        ; carry is set by above logic.
        LDA varPY
        SBC varY
        STA varY
        LDA varPY2
        SBC varYY
        STA varYY
        
    stair_loop_calc_x:
        TXA ; retrieves low byte for stairs.
        ; calculate x (low byte)
        ; multiply by 8, crop top bit
        ASL
        ROL varW ; varW = (trbl << 1) | (upward)
        ASL
        ROL varX
        ASL
        ROL varX
        STA varZ
        
        ; varZ:varX now stores x position of stair.
        
    stair_loop_calc_dx:
        ; x - player_x
        ; carry is set by above logic.
        SBC varPX
        STA varZ
        LDA varX
        SBC varPX2
        STA varX
        
        ; flip x depending on diagonal
        JSR diag_flip
        
    stair_loop_calc_dydx:
        ; dy-dx
        SEC
        LDA varY
        SBC varZ
        TAX
        ; varD now stores dy-dx (low byte)
        
    stair_loop_check_dydx:
        ; check that 0 <= dy-dx < 0x100
        ; (check high byte)
        LDA varYY
        SBC varX
        BNE jmp_stair_loop_begin_yinc
        
        ; check that dy-dx < epsilon
        TXA
        CMP #epsilon ; epsilon; come back to this later.
        BCS jmp_stair_loop_begin_yinc ;  y-x >= epsilon

        ; ~~ check for other intercepting stairs ~~
        ; flip dx to match stair's direction
        
    stair_loop_check_intercepts:
    
        ; flip x if upward stair.
        LDA varW
        AND #$1
        BEQ +
        JSR diag_flip_prf_x
        
        ; dx positive or negative?
      + LDX varX
        BMI stair_negx
        
        ; what to do depends on positive vs negative.
        
        ; positive: we can potentially land on this stair.
    stair_posx:
        CPX #$2 ; ignore stairs 0x200 or farther away.
        BCS stair_loop_begin_yinc
        JSR diag_compress_x
        JSR diag_compare_x
        BCC stair_loop_begin_yinc
        
    store_xpos_set:
        ; store x position in varBL,X
        ; or'd with #$3 to mark (a) set, and (b) yes landing. 
        LDA varZ
        ORA #$3
        ; (X is varW, set in diag_compare_x)
        STA varBL,X
        
    jmp_stair_loop_begin_yinc:
        JMP stair_loop_begin_yinc
        
    stair_negx:
        ; get absolute value of dx, then compress it
        JSR diag_flip_prf_x
        
        ; abort if 0x200 or greater, as above.
        LDA varX
        CMP #$2
        BCS jmp_stair_loop_begin_yinc
        
        JSR diag_compress_x
        
        ; swap direction to consider opposite for downward/upward
        LDA varW
        EOR #$1
        STA varW
        
        JSR diag_compare_x
        BCC jmp_stair_loop_begin_yinc
        
    store_xpos_nset:
        
        ; store x position in varBL,X
        ; or'd with #$1 to mark (a) set, and (b) not landing. 
        LDA varZ
        ORA #$1
        
        ; (X is varW, set in diag_compare_x)
        STA varBL,X
        ; next loop (BNE guaranteed.)
        BNE jmp_stair_loop_begin_yinc
    
stair_loop_end:
    PLA ; return bank
    JMP bankswitch
   
ENDIF