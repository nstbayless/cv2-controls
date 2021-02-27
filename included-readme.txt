#### Castlevania II Improved Controls ####

This hack modernizes the control scheme of Castlevania 2 to make it less frustrating to people
used to tighter controls as in Symphony of the Night and Mega Man. It primarily allows the player
greater control while jumping and on stairs.


############## Instructions ##############

Two versions are included:
* CV2-controls.ips
	- This is the basic version of the hack that should be applied to a standard ROM.
	- It should be compatible with several other hacks, but not with Bisqwit's retranslation + map hack.
	    Compatability includes: 
	      * Simon’s Redaction: https://www.romhacking.net/hacks/868/
		  * Annoyance Fixes: https://www.romhacking.net/hacks/912
		  * Game Over Penalty Reduction: http://www.romhacking.net/hacks/4135/
	
* CV2-controls-bisqwit-compat.ips
    - This version is only compatible with Bisqwit's retranslation + map hack,
	    located at https://www.romhacking.net/hacks/1032/
	- do NOT apply this unless Bisqwit's retranslation is already applied.
	- Compatible only with version 2.9.9.1 of the retranslation (released 2020-07-01).
	
Use Lunar IPS or similar to apply the hack to your Castlevania 2 ROM file. 
https://fusoya.eludevisibility.org/lips/
	

############# Included Files #############
	
- README.txt (this file)
- CV2-controls.ips (see above)
- CV2-controls-bisqwit.ips (see above)
	
	
################ Changes #################

Complete list of changes:

    Enables the player to control their x-velocity in mid-air while jumping (including while jump-attacking).
    When releasing the jump button, Simon immediately starts falling again; this allows the player to
	    make smaller hops if desired.
    After being knocked back, the player regains control after a split second and can angle their fall.
    When walking off an edge, the player retains control instead of dropping straight down.
    The player can jump off of stairs at any point in the climb. (However, it is still impossible to land
	    on stairs, so be careful jumping from long flights of stairs over pits.)
    If the player is struck by an enemy while climbing stairs, they will not be knocked off the stairs. This
	    is the same as the behaviour in Castlevania 1 and 3.
    Simon blinks rapidly after getting hit, as in Castlevania 1 and 3.


############### Licensing #################

Feel free to use or modify this hack, but be sure to
include a link to the original hack:
https://www.romhacking.net/hacks/4150/

No other crediting is necessary, but if you wish you may credit
the author (NaOH).

If the hack is modified and distributed, please be sure
to note that it is not the original version of the hack
and that it was modified by someone other than the
original author.