// This is a table used for storing object speeds in x- and y-direction
// This allows us to set speeds for player/enemies, and later read back
// those values when we want to move them

frame_counter:
	.byte 0
boost_counter:
	.byte 0

object_speeds:
	.byte 0, 0 // Player x-speed at 0x500a, Player y-speed at 0x500b
	.byte %10000001, %10000001 // Enemy 1 x-speed at 0x500c, Enemy y-speed at 0x500d
	.byte %10000001, %00000000 // ...
	.byte %10000010, %00000010
	.byte 0, 0
	.byte 0, 0
	.byte 0, 0
	.byte 0, 0


// The game entry point
game:
	jsr clear_screen
	jsr init_stars	
	jsr init_status
	jsr init_sprite_one
	jsr init_sprite_two
	jsr init_sprite_three
	jsr init_sprite_four

	lda #$ff

	// Debounce
	ldx #$ff
	ldy #$ff
debounce_outer:
debounce:
	dex
	cpx #$00
	bne debounce

	dey
	cpy #$00
	bne debounce_outer

// The game loop
game_loop:
	inc frame_counter	
	
	lda frame_counter
	and #$0f
	cmp #$0f
	bcc !game_loop+
	jsr inc_score
!game_loop:

	jsr draw_status
	jsr move_stars

	jsr dec_player_shield 	// reduce the shield of a player every game loop
	lda player_health       // if the player is out of health, then trigger
	cmp #$00				// system cleanup and the game over sequence
	beq game_over

	// Decrease boost counter if greater than or equal to one
	lda boost_counter
	cmp #$01
	bcc skip_boost_counter_dec

	dec boost_counter

skip_boost_counter_dec:

	lda #$ff
	sta speed_bump

	// Check input and act on it
	// hitting left or right will update speed in x-dir, so clear it first
	lda #$00
	sta object_speeds

	jsr joy2_check
	ldx #$ff

	// Apply gravity to the player
	jsr apply_gravity

	////// Move player /////////
	jsr handle_player_roof_collision
	jsr handle_player_rw_collision
	jsr handle_player_lw_collision
	jsr handle_player_floor_collision

	lda #$00
	sta sprite_num_buf
	jsr move_object

move_enemies:

	// Move enemy one
	lda #$01
	sta sprite_num_buf
	jsr move_object

	// Move enemy two
	lda #$02
	sta sprite_num_buf
	jsr move_object

	// Move enemy three
	lda #$03
	sta sprite_num_buf
	jsr move_object

	// Move enemy four
	lda #$04
	sta sprite_num_buf
	jsr move_object

	// Player collision
	jsr cmp_player_collision
	bne no_collision
	jsr dec_player_health


no_collision:

// Busy wait on speed bump
wait:
	lda speed_bump
	cmp #$ff
	beq wait

	jmp game_loop

game_over:
	lda #%00000000 // disable all sprites by clearing all bits in
	sta $d015      // the sprite enable register
	jmp dead

clear_screen:
	lda #$00 	// Load black color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)
	
	lda #$20
	ldx #$00
!clear_screen:
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	dex
	bne !clear_screen-
	rts

// Subroutine for handling joystick 2 input
joy2_check:
	jsr cmp_joy2_left
	bne !joy2_check+
	jsr handle_left_pressed

!joy2_check:  
	jsr cmp_joy2_right
	bne !joy2_check+
	jsr handle_right_pressed

!joy2_check:
	jsr cmp_joy2_up
	bne !joy2_check+
	jsr handle_up_pressed

!joy2_check:
	jsr cmp_joy2_down
	bne !joy2_check+
	jsr handle_down_pressed

!joy2_check:
	jsr cmp_joy2_fire
	bne !joy2_check+
	jsr handle_fire_pressed

!joy2_check:

	rts


// Routines for acting on input from Joystick
handle_fire_pressed:

	// Need some sort of debounce on fire press!!??
	lda boost_counter
	cmp #$01
	bcs hfp_exit

	jsr boost_player_speed

	// Configure boost counter
	lda #$1			// <--- 1 frame delay
	sta boost_counter

hfp_exit:
	rts

handle_left_pressed:

	// Update this to set player x-speed to negative one (MSB set and LSB 0001)
	lda #%10000001
	sta object_speeds
	rts

handle_right_pressed:

	// Update this to set player speed to positive one (MSB clear and LSB 0001)
	lda #$01
	sta object_speeds
	rts

handle_up_pressed:
	rts

handle_down_pressed:
	rts

apply_gravity:

	// Every ~0.25 second we should apply gravity, adding to negative speed
	lda frame_counter
	and #$0c //0x0c == 12
	bne skip_grav

	// load the speed. If it is negative - i.e., moving upwards - (uppermost bit 1) we should apply gravity.
	ldx #$01
	lda object_speeds, x
	and #%10000000
	cmp #%10000000
	beq grav

	// It is positive (uppermost bit not set). Check if the lower bits has reached max positive speed (3).
	// If so we can skip gravity acceleration
	lda object_speeds, x
	cmp #$03
	bcs skip_grav

grav:
	// We should apply gravity
	// this is done by *incrementing the speed* 
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	sta sprite_step_buf
	jsr increment_speed

skip_grav:

	rts


boost_player_speed:
	
	// We are boosting the player speed upwards, so start by decrementing the actual speed
	// Memory address 0x5005 contains the 0-indexed object number [0-7]
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	lda #$01				// <--- The boost speed
	sta sprite_step_buf
	jsr decrement_speed

	// We have max cap on speed upwards of 4
	ldx #$01
	lda object_speeds, x
	and #$01111111
	cmp #$04
	bcc boost_exit

	// Speed upwards exceeds 10, so override it back to 5 with MSB set
	ldx #$01
	lda #%10000100
	sta object_speeds, x

boost_exit:
	rts






// Subroutine that increments speed of an object. Manages flipping of MSB in case 0 border is crossed
// 'sprite_num_buf' contains the 0-indexed object number [0-7]
// 'sprite_dir_buf' contains the direction (x == 0x00, y == 0x01) the speed should be incremented
// 'sprite_step_buf' contains the step that a speed should be incremented
increment_speed:

	// Load the current speed of the object
	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf
	tax

	lda object_speeds, x

	// If it is positive (MSB not set), we can simply increment with the step
	and #%10000000
	cmp #%10000000
	bne si

	// turns out it was negative (MSB set)
	// We first mask of the MSB and check whether the step will take us to- or across zero
	lda object_speeds, x
	and #%01111111

	cmp sprite_step_buf
	bcc icz					// use BCC to branch if the contents of the accumulator is less than that of the memory address
							
	// If it wont, then we decrement the LSBs and keep the MSB set
	sec
	sbc sprite_step_buf
	ora #%10000000
	sta object_speeds, x
	jmp ise

	// If it does, then we first need to decrement to zero using the LSB of object speed, 
	// The remainder is the new positive speed with MSB cleared
icz:
	sta tmp // store the LSB speed in tmp
	lda sprite_step_buf
	sec
	sbc tmp
	sta object_speeds, x
	jmp ise

// simple increment
si:
	lda object_speeds, x
	clc
	adc sprite_step_buf
	sta object_speeds, x

// exit
ise:
	rts


// Subroutine that decrements speed of an object. Manages flipping of MSB in case 0 border is crossed
// 'sprite_num_buf' contains the 0-indexed object number [0-7]
// 'sprite_dir_buf' contains the direction (x == 0x00, y == 0x01) the speed should be decremented
// 'sprite_step_buf' contains the step that a speed should be decremented
decrement_speed:

	// Load the current speed of the object
	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf 
	tax

	lda object_speeds, x

	// If it is negative (MSB set) we increment the LSBs and keep the MSB
	and #%10000000
	cmp #%10000000
	beq inc_lsb_keep_msb
	
	// turns out it was positive (MSB clear)
	// We first mask of the msb and check whether the step will tak us to- or across zero
	lda object_speeds, x
	and #%01111111

	cmp sprite_step_buf
	bcc dcz 		// use BCC to branch if the contents of the accumulator is less than that of the memory address

	// if it wont, we can simply decrement it
	sec
	sbc sprite_step_buf
	sta object_speeds, x
	jmp dse

inc_lsb_keep_msb:
	//.break
	lda object_speeds, x
	and #%01111111
	//.break
	clc
	adc sprite_step_buf
	//.break
	ora #%10000000
	//.break
	sta object_speeds, x
	//.break
	jmp dse

dcz:
	// We crossed zero, so we first need to decrement to zero using the LSB of object speed, 
	// The remainder is the new negative speed with MSB cleared
	sta tmp // store the LSB speed in tmp
	lda sprite_step_buf
	sec
	sbc tmp

	// So we need to set the MSB
	ora #%10000000
 
	sta object_speeds, x

// exit
dse:
	rts


// Subroutine that moves an object.
// 'sprite_num_buf' contains the 0-indexed object number [0-7]
move_object:

	// Load the current y-speed of the object
	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc #$01 
	tax

	lda object_speeds, x

	// If it is positive (MSB not set), we should increment sprite position
	and #%10000000
	cmp #%10000000
	bne object_y_speed_positive
	
	//otherwise, decrement sprite position
	lda #$01
	sta sprite_dir_buf
	lda object_speeds, x

	// Populate sprite step buf with LSBs only
	and #%01111111
	sta sprite_step_buf
	jsr decrement_sprite_position
	jmp object_x_movement

object_y_speed_positive:

	lda #$01
	sta sprite_dir_buf
	lda object_speeds, x

	// Populate sprite step buf with LSBs only
	and #%01111111
	sta sprite_step_buf
	jsr increment_sprite_position

	// Move player in x-direction

object_x_movement:
	
	// Load the current x-speed of the object
	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	tax

	lda object_speeds, x

	// If it is positive, we should increment sprite position
	and #%10000000
	cmp #%10000000
	bne object_x_speed_positive

	//otherwise, decrement sprite position
	lda #$00
	sta sprite_dir_buf
	lda object_speeds, x

	// Populate sprite step buf with LSBs only
	and #%01111111
	sta sprite_step_buf
	jsr decrement_sprite_position
	jmp move_object_exit

object_x_speed_positive:

	lda #$00
	sta sprite_dir_buf
	lda object_speeds, x

	// Populate sprite step buf with LSBs only
	and #%01111111
	sta sprite_step_buf
	jsr increment_sprite_position

move_object_exit:
	rts

handle_player_roof_collision:

	// Player cannot move out of the screen at top
	lda $d001
	cmp #$33
	bcc hit_roof

	jmp hprc_exit

hit_roof:
	lda #$33
	sta $d001

	// Set vertical speed to zero
	ldx #$01
	lda #$00
	sta object_speeds, x

hprc_exit:
	rts

handle_player_rw_collision:

	// If the overflow bit is not set, then we are not hitting the right wall
	lda sprite_x_overflow_flags
	cmp #$00
	beq hprwc_exit

	// flag is set, check if we have hit border

	// Player cannot move out of the screen to the right
	lda $d000
	cmp #$3f
	bcs hit_rw

	jmp hprwc_exit

hit_rw:
	lda #$3e // inside the screen
	sta $d000

	// Set horizontal speed to zero
	lda #$00
	sta object_speeds

hprwc_exit:
	rts

handle_player_lw_collision:

	// If the overflow flag is set, then we are not hitting the left wall
	lda sprite_x_overflow_flags
	cmp #$01
	beq hplwc_exit

	// Player cannot move out of the screen to the left
	lda $d000
	cmp #$18
	bcc hit_lw

	jmp hplwc_exit

hit_lw:
	lda #$19 // inside the screen
	sta $d000

	// Set vertical speed to zero
	lda #$00
	sta object_speeds

hplwc_exit:
	rts

handle_player_floor_collision:

	// Player cannot move out of the screen at the bottom
	lda $d001
	cmp #$e6
	bcs hit_floor

	jmp hpfc_exit

hit_floor:
	lda #$e5 // inside the screen
	sta $d001

	// Flip the vertical speed 
	ldx #$01
	lda object_speeds, x
	ora #%10000000
	sta object_speeds, x

	// This costs one life
	jsr dec_player_health

hpfc_exit:
	rts