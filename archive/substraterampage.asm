.filenamespace substrateRampage
:BasicUpstart2(start)


// Entry point
* = $4000
start:
	// Make screen black and text white
	lda #$02 	// Load Red  (2) into accumulator
	sta $d020	// Store Red in border collor address (0xd020)
	lda #$00    // Load Black  (0) into accumulator
	sta $d021	// Also store black in background color address (0xd021)
	lda #$01	// Load color white (1) into accumulator
	sta $0286	// Store white into cursor color address (0x0286)

	// Clear the screen and jump to draw routine
	jsr $e544		// call (jump sub routine = jsr) screen function to clear screen
	jsr draw_text	// call (jump sub routine = jsr) draw text routine
	jmp *			//

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