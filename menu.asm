menu:
	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$00	// Load black color
	sta $0286	// Store color on cursor (0x0286)

	// Clear the screen and jump to draw routine 
	//jsr $e544		// call screen function to clear screen	
	jsr draw_text	// call (jump sub routine = jsr) draw text routine

menu_loop:
	lda joystick_buf
	and #$10 // Only care about the fifth bit (fire button)
	cmp #$10
	beq menu_loop


	lda #$00 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$01	// Load black color
	sta $0286	// Store color on cursor (0x0286)
	jmp game


msg:
	.text "           substrate rampage next!      "

draw_text:
	ldx #$00		// Place color white in x register

draw_loop:
	lda msg, x		// Load message into accumulator
	sta $05e0, x
	inx				//Increment x
	cpx #$28 		// Compare contents of x register to 0x28 = 40 in decicmal
	bne draw_loop	// Branch not equal, back to loop
	rts
