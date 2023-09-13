
.label speed_bump = $5001

// This is a table used for storing object speeds in x- and y-direction
// This allows us to set speeds for player/enemies, and later read back
// those values when we want to move them
.label object_speeds = $500a 
*=object_speeds "Sprite Data One" 
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
	jsr init_sprite_one
	jsr init_sprite_two
	jsr init_sprite_three

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

wait:
	lda speed_bump
	cmp #$ff
	beq wait

	jmp game_loop

game_over:
	jmp menu

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
	lda #$05 // Green
	sta $d020
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

	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr decrement_sprite_position

	rts

handle_down_pressed:
	//lda #$04 // purple
	//sta $d020

	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	lda #$03
	sta sprite_step_buf
	jsr increment_sprite_position

	rts
