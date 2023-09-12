.label joystick_buf = $5000

// this subroutine gets called during IRQ setup, with interrupts disabled
input_init:
	lda #$ff
	sta joystick_buf
	rts

// this subroutine gets called on IRQ
input_irq:
	lda $dc00
	sta joystick_buf
	rts
