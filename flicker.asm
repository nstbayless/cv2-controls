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