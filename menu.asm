menu:
	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$00	// Load black color
	sta $0286	// Store color on cursor (0x0286)

	jsr clear_screen
	jsr draw_text


menu_loop:
	jsr cmp_joy2_fire
	bne menu_loop

	lda #$00 	// Load black color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$01	// Load white color
	sta $0286	// Store color on cursor (0x0286)
	jmp game


clear_screen:
	lda #$20
	ldx #$00

clr_loop:
	// $0400 - $07e7 is screen ram for characters to display
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	dex
	bne clr_loop
	rts


msg0:	.text "O                                      P"
	    .text " UCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCI "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text "                                      B "
msg1:	.text " B s u b s t r a t e    r a m p a g e   "
 		.text " B                                    B "
	    .text "     microsoft hackathon - sep 2023   B "
	    .text "        jakarl, jogron, simonhul      B "
	    .text "                                        "
msg2:   .text "                                      B "
	 	.text "                                      B "
    	.text " B                                      "
     	.text " B                                      "
      	.text "                                        "
msg3:  	.text "                                        "
		.text " B                                      "
	    .text " B                                      "
	    .text " B                                      "
	    .text " B                                    B "
msg4:	.text "                                        "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text " JCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCK "
	    .text "L                                      "; .byte $7a
	    //    "0123456789012345678901234567890123456789"

draw_text:
	ldx #$00

draw_loop:
	lda msg0, x
	sta $0400, x
	lda msg1, x
	sta $04c8, x
	lda msg2, x
	sta $0590, x
	lda msg3, x
	sta $0658, x
	lda msg4, x
	sta $0720, x

	inx
	cpx #$c8
	bne draw_loop
	rts
