; ------------------------------------------------------------------------------
; memory address values
ENUM $0

MACRO DEF a b
    BASE x
    b: db #$0
ENDM

MACRO DEFW a b
    BASE x
    b: dw #$0
ENDM

; ------------------------------------------------------------------------------
DEF $F1 button_A ; ??
DEF $F5 button_pressed
DEF $F7 button_down
; ------------------------------------------------------------------------------
; player properties
DEF $6d player_air_xspeed
DEF $420 player_facing

DEF $80 player_energy
DEF $4f8 player_iframes

DEF $6d player_xspeed
DEF $6c player_xspeed_frac

DEF $36c player_vspeed
DEF $37e player_vspeed_frac

DEF $324 player_y
DEF $348 player_x

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
DEF $3d8 player_state

; stores state when also attacking
DEF $390 player_substate

; image index
DEF $300 player_image

; ------------------------------------------------------------------------------
; world properties
DEF $86 world_hour

; 0: town
; 1: castle
; 2: forest and caves
; 3: cemetary
DEF $30 world_region

; area in region
; this number together with the region determines actual area.
DEF $50 world_region_area

; macro-tileset -- comes from world_region
DEF $64 world_chunkset

; points to bank 2 area struct
;   1 byte: width (in screens)
;   1 byte: height (in screens)
;   Then an array of length 4 * width * height bytes. The first
;   half of this array is pointers to the tile chunk data for each screen.
;   The second half of the array is pointers of currently unknown meaning.
DEFW $70 world_area_tile_ptr

; half-inclusive range of terrain data.
DEFW $520 terrain_start
DEFW $6F0 terrain_end

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

ENDE