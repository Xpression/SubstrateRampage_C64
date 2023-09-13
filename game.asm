
// The game entry point
game:
	jsr init_sprite_one

// The game loop
game_loop:
	// Reset border color variable to black
	lda #$00
	sta $d020
	
// Section for checking input and acting on it
	jsr joy2_check

//chk_f_pressed:
//	// Check if fire button pressed
//	jsr fire_pressed
//	lda joystick_fire
//	cmp #$ff
//	bne chk_l_pressed
//	jsr handle_fire_pressed
//
//chk_l_pressed:
//	jsr left_pressed
//	lda joystick_left
//	cmp #$ff
//	bne chk_r_pressed
//	jsr handle_left_pressed
//
//chk_r_pressed:
//	jsr right_pressed
//	lda joystick_right
//	cmp #$ff
//	bne chk_d_pressed
//	jsr handle_right_pressed
//
//chk_d_pressed:
//	jsr down_pressed
//	lda joystick_down
//	cmp #$ff
//	bne chk_u_pressed
//	jsr handle_down_pressed
//
//chk_u_pressed:
//	jsr up_pressed
//	lda joystick_up
//	cmp #$ff
//	bne input_check_complete
//	jsr handle_up_pressed
//
//input_check_complete:
// Section end

	ldx #$ff
wait:
	dex
	cpx #$ff
	bne wait
    jmp game_loop

game_over:
	jmp menu

// Subroutine for handling joystick 2 input
joy2_check:
	jsr cmp_joy2_left
	bne !joy2_check+
	//lda #$05 // Green
	//sta $d020
	jsr handle_left_pressed

!joy2_check:  
	jsr cmp_joy2_right
	bne !joy2_check+
	//lda #$06 // blue
	//sta $d020
	jsr handle_right_pressed

!joy2_check:
	jsr cmp_joy2_up
	bne !joy2_check+
	//lda #$07 // yellow
	//sta $d020
	jsr handle_up_pressed

!joy2_check:
	jsr cmp_joy2_down
	bne !joy2_check+
	//lda #$08 // orange
	//sta $d020
	jsr handle_down_pressed

!joy2_check:
	jsr cmp_joy2_fire
	bne !joy2_check+
	//lda #$04 // purple
	//sta $d020
	jsr handle_fire_pressed

!joy2_check:	
	rts


// Routines for acting on input from Joystick
handle_fire_pressed:
	lda #$05 // Green
	sta $d020
	rts

handle_left_pressed:
	lda #$06 // blue
	sta $d020
	rts

handle_right_pressed:
	lda #$07 // yellow
	sta $d020

	lda #$00
	sta sprite_num_buf
	sta sprite_dir_buf
	jsr increment_sprite_position

	rts

handle_up_pressed:
	lda #$08 // orange
	sta $d020

	lda #$00
	sta sprite_num_buf
	lda #$01
	sta sprite_dir_buf
	jsr increment_sprite_position

	rts

handle_down_pressed:
	lda #$04 // purple
	sta $d020
	rts

