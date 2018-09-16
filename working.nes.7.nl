$C5BB#jump-table#
$DECC#write-simon-state(+x)#
$DEBD#write-simon-state#
$DEC6#set-simon-state-jump(+x)#
$DECA#set-simon-state-walk(+x)#
$D390#.. set simon state to knockbac#
$FF0A#set-and-return#
$D37E#} .. has set Y to direction#
$D36F#set-knockback#
$D372#.. if facing {#
$D36A#set-simon-xspeed#
$D381#.. set yspeed to FD.80 {#
$D388#}#
$DD87#set-simon-image(a)#
$FF08#return#
$D395#.. > continue knocback#
$FF03#compare facing to enemy's#
$D362#set-simon-yspeed#
$FF12#custom-iframe-reduction#
$FF20#decrement#
$FF1B#set0#
$FEFA#custom-knockback-hit#
$FF24#hit-while-attacking#
$C5D9#add-with-spillover (A->$X;X+1)#
$C5E3#subtract A+1 w/spill from $X#
