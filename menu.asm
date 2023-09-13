menu:
	jsr do_fade

	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)
	sta $0286	// Store color on cursor (0x0286)

	jsr draw_menu

menu_loop:
	jsr menu_flash
	jsr cmp_joy2_fire
	bne menu_loop
	jmp game


// ------------------------------------------------------------
menu_flash:
	ldx #$02

!menu_flash:
	ldy $d9b8, x
	iny
	cpy #$10
	bne !menu_flash+
	ldy #$00
!menu_flash:
	tya
	sta $d9b8, x

	inx
	cpx #$24
	bne !menu_flash--
	rts


// ------------------------------------------------------------
menu0:	.text "O                                      P"
	    .text " UCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCI "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text "                                      B "
menu1:	.text " B s u b s t r a t e    r a m p a g e   "
 		.text " B                                    B "
	    .text "     microsoft hackathon - sep 2023   B "
	    .text "        jakarl, jogron, simonhul      B "
	    .text "                                        "
menu2:	.text "                                      B "
        .text "           press fire button!         B "
    	.text " B                                      "
     	.text " B                                      "
      	.text "                                        "
menu3:   .text "                                        "
		.text " B                                      "
	    .text " B                                      "
	    .text " B                                      "
	    .text " B                                    B "
menu4:	.text "                                        "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text " JCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCK "
	    .text "L                                      "; .byte $7a
	    //    "0123456789012345678901234567890123456789"

draw_menu:
	ldx #$00

!draw_menu:
	lda menu0, x
	sta $0400, x
	lda menu1, x
	sta $04c8, x
	lda menu2, x
	sta $0590, x
	lda menu3, x
	sta $0658, x
	lda menu4, x
	sta $0720, x

	inx
	cpx #$c8
	bne !draw_menu-
	rts
