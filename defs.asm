; ------------------------------------------------------------------------------
; memory address values
ENUM $0

; ------------------------------------------------------------------------------
button_A EQU $F1 ; ??
button_pressed EQU $F5
button_down EQU $F7
; ------------------------------------------------------------------------------
; player properties
player_air_xspeed EQU $6d
player_facing EQU $420

player_energy EQU $80
player_iframes EQU $4f8

player_xspeed EQU $6d
player_xspeed_frac EQU $6c

player_vspeed EQU $36c
player_vspeed_frac EQU $37e

player_y EQU $324
player_x EQU $348

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
player_state EQU $3d8

; stores state when also attacking
player_substate EQU $390

; image index
player_image EQU $300

; ------------------------------------------------------------------------------
; world properties
world_hour EQU $86

; 0: town
; 1: castle
; 2: forest and caves
; 3: cemetary
world_region EQU $30

; area in region
; this number together with the region determines actual area.
world_region_area EQU $50

; macro-tileset -- comes from world_region
world_chunkset EQU $64

; points to bank 2 area struct
;   1 byte: width (in screens)
;   1 byte: height (in screens)
;   Then an array of length 4 * width * height bytes. The first
;   half of this array is pointers to the tile chunk data for each screen.
;   The second half of the array is pointers of currently unknown meaning.
world_area_tile_ptr EQU $70

; half-inclusive range of terrain data.
terrain_start EQU $520
terrain_end EQU $6F0

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