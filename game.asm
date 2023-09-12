game:
	// Reset border color variable to black
	lda #$00
	sta $d020

	// Check if joystick pressed
	lda joystick_buf
	and #$10 // Only care about the fifth bit (fire button)
	cmp #$10
	beq game

	// set border green color only if joystisk hit
	lda #$05
	sta $d020

	ldx #$ff
wait:
	dex
	cpx #$ff
	bne wait
    jmp game

game_over:
	jmp menu
