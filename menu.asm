menu:
	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)

	lda #$00	// Load black color
	sta $0286	// Store color on cursor (0x0286)

	jsr draw_mbg
	jsr draw_mfg

menu_loop:
	jsr cmp_joy2_fire
	bne menu_loop

	jmp game


mfg:	.text "           press fire button!           "
draw_mfg:
	ldx #$00

!draw_mfg:
	lda mfg, x
	sta $0608, x
	inx
	cpx #$28
	bne !draw_mfg-
	rts


mbg0:	.text "O                                      P"
	    .text " UCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCI "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text "                                      B "
mbg1:	.text " B s u b s t r a t e    r a m p a g e   "
 		.text " B                                    B "
	    .text "     microsoft hackathon - sep 2023   B "
	    .text "        jakarl, jogron, simonhul      B "
	    .text "                                        "
mbg2:	.text "                                      B "
	 	.text "                                      B "
    	.text " B                                      "
     	.text " B                                      "
      	.text "           press fire button!           "
mbg3:   .text "                                        "
		.text " B                                      "
	    .text " B                                      "
	    .text " B                                      "
	    .text " B                                    B "
mbg4:	.text "                                        "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text " JCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCK "
	    .text "L                                      "; .byte $7a
	    //    "0123456789012345678901234567890123456789"

draw_mbg:
	ldx #$00

!draw_mbg:
	lda mbg0, x
	sta $0400, x
	lda mbg1, x
	sta $04c8, x
	lda mbg2, x
	sta $0590, x
	lda mbg3, x
	sta $0658, x
	lda mbg4, x
	sta $0720, x

	inx
	cpx #$c8
	bne !draw_mbg-
	rts
