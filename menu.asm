menu_flash_pos:
	.byte $00
	
menu_flash_delay:
	.byte $00

menu:
	lda #$00
	sta next_song
	jsr change_song

	// Make screen black and text white
	lda #$01 	// Load white color
	sta $d020	// Store color on border (0xd020)
	sta $d021	// Store color on background (0xd021)
	sta $0286	// Store color on cursor (0x0286)

	jsr draw_menu

	lda #$00
	sta menu_flash_pos
	sta menu_flash_delay

menu_loop:
	jsr menu_flash
	jsr cmp_joy2_fire
	bne menu_loop
	jmp game


// ------------------------------------------------------------
menu_flash:
	// wait a little
	inc menu_flash_delay
	lda menu_flash_delay
	cmp #$40
	beq !menu_flash+
	rts

!menu_flash:
	lda #$00
	sta menu_flash_delay

	// load index of char to flash
	ldx menu_flash_pos

!menu_flash:
	// increment color value, rotate at $10
	ldy $d9ba, x
	iny
	cpy #$10
	bne !menu_flash+
	ldy #$00
!menu_flash:
	tya
	sta $d9ba, x

	// move to next char to flash
	inx
	cpx #$24 // 36 char wide
	bne !menu_flash+
	ldx #$00
!menu_flash:
	txa
	sta menu_flash_pos
	rts


// ------------------------------------------------------------
menu0:
.byte $20,$20,$20,$20,$20,$62,$62,$62,$62,$62,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$62,$62,$62,$20,$20,$62,$62,$62,$20,$20,$62,$20,$20,$62,$61,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$e1,$62,$62,$20,$a0,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$e1,$a0,$20,$62,$a0,$e1,$a0,$20,$62,$a0,$e1,$a0,$20,$a0,$a0,$61,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$a0,$a0,$20,$20,$a0,$a0,$20,$20,$20,$20,$62,$a0,$e2,$62,$20,$20,$a0,$a0,$e2,$20,$20,$a0,$a0,$e2,$20,$e1,$a0,$61,$e1,$a0,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$a0,$a0,$61,$20,$e1,$a0,$61,$e1,$61,$e1,$a0,$61,$20,$e1,$61,$e1,$a0,$20,$20,$20,$e1,$a0,$20,$20,$20,$20,$e1,$a0,$e2,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$e2,$e2,$e2,$20,$20,$e2,$e2,$e2,$20,$20,$e2,$a0,$62,$e2,$20,$20,$e2,$20,$20,$20,$20,$e2,$20,$20,$20,$20,$20,$e2,$20,$20,$20,$20,$20,$20,$20,$20

menu1:
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$62,$62,$62,$62,$20,$20,$20,$20,$20,$62,$62,$62,$20,$20,$20,$62,$62,$62,$62,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$e1,$a0,$20,$e2,$a0,$20,$a0,$a0,$20,$e2,$62,$20,$a0,$20,$a0,$a0,$20,$20,$a0,$a0,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$e1,$a0,$e2,$e2,$a0,$62,$e1,$a0,$20,$e1,$e2,$e2,$62,$20,$e1,$a0,$20,$20,$e1,$a0,$61,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$a0,$a0,$62,$20,$e1,$a0,$e1,$a0,$61,$e1,$a0,$20,$a0,$61,$a0,$a0,$20,$20,$a0,$a0,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$e2,$e2,$e2,$e2,$20,$e2,$e2,$e2,$20,$e2,$20,$20,$e2,$e2,$e2,$e2,$e2,$e2,$20,$20,$20,$20,$20,$20

menu2:	.text "                                        "
        .text "           press fire button!           "
      	.text "                                        "
    	.text "O                                      P"
		.text " UCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCI "
menu3:  .text " B                                    B "
		.text " B                                    B "
	    .text " B                                    B "
	    .text " B   microsoft hackathon - sep 2023   B "
	    .text " B      jakarl, jogron, simonhul      B "
menu4:	.text " B                                    B "
	    .text " B                                    B "
	    .text " B                                    B "
	    .text " JCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCK "
	    .text "L                                      "; .byte $7a

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

    lda #$00
    sta $d800, x
    sta $d8c8, x
    sta $d990, x
    sta $da58, x
    sta $db20, x

	inx
	cpx #$c8
	bne !draw_menu-
	rts
