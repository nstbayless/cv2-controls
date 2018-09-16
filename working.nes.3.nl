$8723#simon-step-stand#
$89CD#simon-step-jump#
$9CF4#custom jump#
$9D02#right#
$9D09#left#
$9D12#neutral-x#
$9D15#2: v-cancel#
$81C4#simon-dispatch#
$9D2A#pre-return#
$86E0#set-falling?#
$877A#clear-simon-speed(?)#
$89A8#simon-step-attack#
$89CA#jmp-to-custom-jump-logic#
$89D6#..jump-logic (base)#
$892E#possibly-switch-states#
$9D34#return#
$9D31#fixed-facing-if-attacking#
$8A0E#simon-step-knockback#
$9D37#custom-jump-switch#
$8AD9#simon-step-stair-stand#
$8A52#simon-step-stair-walk#
$88D9#do-jump#
$857B#simon-check-environment#
$9D70#hitstun#
$9D4A#custom stairjumping#
$9D51#check input#
$9D7D#un-hitstun#
$9D84#if was moving, restore movemen#
$9D89#yspeed...#
$9D96#xspeed..#
$9D46#custom stairjumping#
$805B#.. set xspeed#
$806F#+xspeed#
$9DA4#zero fracxspd then custom jump#
$8594#falling-check-ground#
$8599#.. loop (X) start#
$85AD#if x < 0x12 continue#
$8512#[OFFRAME] subroutine start#
$8597#.. check NPCs: X in [6..0x11]#
$8632#.. --> END OF loop#
$86FF#subroutine ? axy:Ay |X#
$86ED#check tile a*Y:A**#
$8640#// X might always be 12 here#
$85B4#.. A<-1 then $85BE#
$85B8#.. A<-2 then $85BE#
$85BC#.. A<-0 then $85BE#
$85BE#.. A<<1 then $85BF#
$85BF#.. FOUND#
$8595#on-ground-check-ground#
$8588#.. $93 <- 0/1: fall|knckb|jmp#
$85FA#.. on the ground and FOUND#
$85C8#.. in the air and FOUND#
$85D0#.. FOUND and positive yspeed#
$85AC#.. --> CONTINUE loop#
$8684#.. check environment grounded#
$867E#.. return#
$863B#.. check env, yspd > 0#
$8655#.. hit ground?#
$9DAB#should v-cancel?#
$9D7C#.. return#
$9DBF#.. return#
$9DC0#should v-cancel? (wrapper)#
