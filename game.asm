
.label speed_bump = $5001
.label frame_counter = $5002
.label tmp = $5003

// This is a table used for storing object speeds in x- and y-direction
// This allows us to set speeds for player/enemies, and later read back
// those values when we want to move them
.label object_speeds = $500a 
*=object_speeds "Object Speed" 
	.byte 0, 0 // Player x-speed at 0x500a, Player y-speed at 0x500b
	.byte 1, 1 // Enemy 1 x-speed at 0x500c, Enemy y-speed at 0x500d
	.byte 2, 2 // ...
	.byte 0, 0
	.byte 0, 0
	.byte 0, 0
	.byte 0, 0
	.byte 0, 0


// The game entry point
game:
	jsr clear_screen
	jsr init_sprite_one
	jsr init_sprite_two
	jsr init_sprite_three
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

	lda #$ff
	sta speed_bump

	// Reset border color variable to black
	lda #$00
	sta $d020
	
	// Check input and act on it
	jsr joy2_check
	ldx #$ff


	// Move player in y-direction
	jsr apply_gravity

	// Get player y-speed
	ldx #$01
	lda object_speeds, x

	// If it is positive (MSB not set), we should increment sprite position
	and #%10000000
	cmp #%10000000
	bne hola

	//otherwise, decrement sprite position
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	ldx #$01
	lda object_speeds, x
	sta sprite_step_buf
	jsr decrement_sprite_position

hola:
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	ldx #$01
	lda object_speeds, x
	sta sprite_step_buf
	jsr increment_sprite_position

	// Move enemy one
	lda #$01
	sta sprite_num_buf
	// First x-direction
	lda #$00
	sta sprite_dir_buf
	ldx #$02
	lda object_speeds, x
	sta sprite_step_buf
	jsr decrement_sprite_position
	// Then y-direction
	lda #$01
	sta sprite_dir_buf
	ldx #$03
	lda object_speeds, x
	sta sprite_step_buf
	jsr decrement_sprite_position

	// Move enemy two
	lda #$02
	sta sprite_num_buf
	// First x-direction
	lda #$00
	sta sprite_dir_buf
	ldx #$04
	lda object_speeds, x
	sta sprite_step_buf
	jsr decrement_sprite_position
	// Then y-direction
	lda #$01
	sta sprite_dir_buf
	ldx #$05
	lda object_speeds, x
	sta sprite_step_buf
	jsr increment_sprite_position

	jsr is_player_sprite_collision

// Busy wait on speed bump
wait:
	lda speed_bump
	cmp #$ff
	beq wait

	jmp game_loop

game_over:
	// TODO: clean up
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

	// Need some sort of debounce on fire press

	lda #$05 // Green
	sta $d020

	// Increment y-speed for player
	ldx #$01
	lda object_speeds, x
	clc
	adc #$01 // increase speed by 10
	sta object_speeds, x

	rts

handle_left_pressed:
	//lda #$06 // blue
	//sta $d020

	lda #$00
	sta sprite_num_buf
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr decrement_sprite_position

	rts

handle_right_pressed:
	//lda #$07 // yellow
	//sta $d020

	lda #$00
	sta sprite_num_buf
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr increment_sprite_position

	rts

handle_up_pressed:
	//lda #$08 // orange
	//sta $d020

	/*
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr decrement_sprite_position
	*/
	rts

handle_down_pressed:
	//lda #$04 // purple
	//sta $d020

	/*
	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr increment_sprite_position
	*/
	rts

apply_gravity:

	// Every 0.5 second we should apply gravity, adding to negative speed
	lda frame_counter
	and #$19 // 25 = 0x19
	bne skip_grav

	// load the speed. If it is negative - i.e., moving upwards - (uppermost bit 1) we should apply gravity.
	ldx #$01
	lda object_speeds, x
	and #%10000000
	cmp #%10000000
	beq grav

	// It is positive (uppermost bit not set). Check if the lower bits has reached max positive speed (5).
	// If so we can skip grivity acceleration
	lda object_speeds, x
	cmp #$05
	beq skip_grav

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


// Subroutine that increments speed of an object. Manages flipping of MSB in case 0 border is crossed
// Memory address 0x5005 contains the 0-indexed object number [0-7]
// Memory address 0x5006 contains the direction (x == 0x00, y == 0x01) the speed should be incremented
// Memory address 0x5007 contains the step that a speed should be incremented/decremented
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
// Memory address 0x5005 contains the 0-indexed object number [0-7]
// Memory address 0x5006 contains the direction (x == 0x00, y == 0x01) the speed should be incremented
// Memory address 0x5007 contains the step that a speed should be incremented/decremented
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
	
	
/*
	bne sd

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

// simple decrement
sd:
	lda object_speeds, x
	sec
	sbc sprite_step_buf
	sta object_speeds, x
*/
// exit
dse:
	rts


