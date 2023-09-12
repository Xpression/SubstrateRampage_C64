.label joystick_buf = $5000
.label tmp = $5001

// this subroutine gets called during IRQ setup, with interrupts disabled
input_init:
	lda #$00
	sta joystick_buf
	rts

// this subroutine gets called on IRQ
input_irq:
	rts
