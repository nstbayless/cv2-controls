; ------------------------------------------------------------------------------
; memory address values
ENUM $0

; ------------------------------------------------------------------------------
BASE $F1
button_A:
 ; ??
BASE $F5
button_pressed:

BASE $F7
; 1: right
; 2: left
; 4: down
; 8: up
; 10: 
; 20: 
; 40: 
; 80:
button_down:

; ------------------------------------------------------------------------------
; player properties
BASE $6d
player_air_xspeed:

; 0 -- left
; 1 -- right
BASE $420
player_facing:

BASE $468
; 0: diagonal top-left to bottom-right
; 1: diagonal top-right to bottom-left
player_stair_direction:

BASE $47a
; when this reaches 0, pause climbing the stair.
player_stair_timer:

BASE $80
player_energy:

BASE $4f8
player_iframes:


BASE $6d
player_xspeed:

BASE $6c
player_xspeed_frac:

BASE $36c
player_yspeed:

BASE $37e
player_yspeed_frac:


BASE $324
player_y:

BASE $336
player_y_frac:

BASE $348
player_x:

BASE $35A
player_x_frac:


; Player Action State
; 0: standing
; 1: walking
; 2: jumping
; 3: crouching
; 4: attacking
; 5: falling
; 6: knockback
; 7: stair find
; 9: stair stand
; A: stair walk
BASE $3d8
player_state:


; stores state when also attacking
BASE $390
player_substate:


; image index
BASE $300
player_image:

; ------------------------------------------------------------------------------
BASE $53
camera_x:

; high bit of camera_x
BASE $54
camera_x_screen:

; ranges from 0 to 224 half-inclusive
BASE $56
camera_y:

; measures increments of 224 of camera_y
BASE $57
camera_y_screen:

; ------------------------------------------------------------------------------
; world properties
BASE $86
world_hour:


; 0: town
; 1: castle
; 2: forest and caves
; 3: cemetary
BASE $30
world_region:


; area in region
; this number together with the region determines actual area.
BASE $50
world_region_area:


; macro-tileset -- comes from world_region
BASE $64
world_chunkset:


; points to bank 2 area struct
;   1 byte: width (in screens)
;   1 byte: height (in screens)
;   Then an array of length 4 * width * height bytes. The first
;   half of this array is pointers to the tile chunk data for each screen.
;   The second half of the array is pointers of currently unknown meaning.
BASE $70
world_area_tile_ptr:

; points to array of FF-terminated 2-byte stair data
; *in bank 2*
; stair data as follows:
; first byte ---
;   bit 7: is the stair upward?
;   bits 0-6: x position of stair div 8
; second byte ---
;   bit 7: is the stair diagonal trbl?
;   bits 0-6: y position of stair div 8
BASE $72
world_stairs_ptr:


; half-inclusive range of terrain data.
BASE $520
terrain_start:

BASE $6F0
terrain_end:


; ------------------------------------------------------------------------------
; graphics

; Starting at $230 is a list of sprites. Each byte is 4 bytes: Y, subimage, palette | flipped, X.

; ------------------------------------------------------------------------------
; enemies

; $3b4 or $3ba seems to store list of enemies. Ends at $3ba5 inclusive.
; 3: pacing skeleton
; 4: fire-breathing fish man
; 6: werewolf
; 13 jumping werewolf
; 2A: NPC man with short black hair and boots
; 2E: NPC in cloak. Eery.
; 35: NPC with cane
; 37: powerup / heart

; ------------------------------------------------------------------------------
; temporary variables
varPX=$02
varPX2=$03
varPY=$00
varPY2=$01
;varD=$93
;varD2=$94
varBL=$95
varBR=$96
varTL=$97
varTR=$98
varZ=$4
varX=$5
varY=$7
varYY=$8
varW=$9

ENDE