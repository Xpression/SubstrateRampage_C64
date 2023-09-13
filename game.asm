game:
	// Reset border color variable to black
	lda #$00
	sta $d020

	jsr joy2_check

	ldx #$ff
wait:
	dex
	cpx #$ff
	bne wait
    jmp game

game_over:
	jmp menu





joy2_check:
	jsr cmp_joy2_left
	bne !joy2_check+
	lda #$05 // Green
	sta $d020

!joy2_check:  
	jsr cmp_joy2_right
	bne !joy2_check+
	lda #$06 // blue
	sta $d020

!joy2_check:
	jsr cmp_joy2_up
	bne !joy2_check+
	lda #$07 // yellow
	sta $d020

!joy2_check:
	jsr cmp_joy2_down
	bne !joy2_check+
	lda #$08 // orange
	sta $d020

!joy2_check:
	jsr cmp_joy2_fire
	bne !joy2_check+
	lda #$04 // purple
	sta $d020

!joy2_check:	
	rts
