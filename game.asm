game:
	// Reset border color variable to black
	lda #$00
	sta $d020

	
// Section for checking input and acting on it
chk_f_pressed:
	// Check if fire button pressed
	jsr fire_pressed
	lda joystick_fire
	cmp #$ff
	bne chk_l_pressed
	jsr handle_fire_pressed

chk_l_pressed:
	jsr left_pressed
	lda joystick_left
	cmp #$ff
	bne chk_r_pressed
	jsr handle_left_pressed

chk_r_pressed:
	jsr right_pressed
	lda joystick_right
	cmp #$ff
	bne chk_d_pressed
	jsr handle_right_pressed

chk_d_pressed:
	jsr down_pressed
	lda joystick_down
	cmp #$ff
	bne chk_u_pressed
	jsr handle_down_pressed

chk_u_pressed:
	jsr up_pressed
	lda joystick_up
	cmp #$ff
	bne input_check_complete
	jsr handle_up_pressed

input_check_complete:
// Section end

	ldx #$ff
wait:
	dex
	cpx #$ff
	bne wait
    jmp game

game_over:
	jmp menu


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
	rts

handle_up_pressed:
	lda #$08 // orange
	sta $d020
	rts

handle_down_pressed:
	lda #$04 // purple
	sta $d020
	rts

