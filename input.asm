joy2_buf:
	.byte $00

// this subroutine gets called on IRQ
input_irq:
	lda $dc00
	eor #$ff
	sta joy2_buf
	rts

cmp_joy2_left:
	lda joy2_buf
	and #$04 
	cmp #$04 
	rts

cmp_joy2_right:
	lda joy2_buf
	and #$08 
	cmp #$08 
	rts

cmp_joy2_up:
	lda joy2_buf
	and #$01 
	cmp #$01 
	rts

cmp_joy2_down:
	lda joy2_buf
	and #$02 
	cmp #$02 
	rts

cmp_joy2_fire:
	lda joy2_buf
	and #$10 
	cmp #$10 
	rts
