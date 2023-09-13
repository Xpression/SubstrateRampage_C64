menu:
	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$00	// Load black color
	sta $0286	// Store color on cursor (0x0286)

	// Clear the screen and jump to draw routine 
	//jsr $e544		// call screen function to clear screen	
	jsr clear_screen
	jsr draw_text	// call (jump sub routine = jsr) draw text routine

menu_loop:
	jsr cmp_joy2_fire
	bne menu_loop


	lda #$00 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$01	// Load black color
	sta $0286	// Store color on cursor (0x0286)
	jmp game


clear_screen:
	lda #$20
	ldx #$00
clr_loop:
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	dex
	bne clr_loop
	rts

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
