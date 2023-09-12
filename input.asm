.label joystick_buf = $5000
.label joystick_fire = $5001
.label joystick_left = $5002
.label joystick_right = $5003
.label joystick_up = $5004
.label joystick_down = $5004

// this subroutine gets called during IRQ setup, with interrupts disabled
input_init:
	lda #$00
	sta joystick_buf
	rts

// this subroutine gets called on IRQ
input_irq:
	lda $dc00
	sta joystick_buf
	rts

// Checks whether fire is pressed. Populates joystick_fire with 0xff if fire button hit, 0x00 otherwise
fire_pressed:

	lda #$00
	sta joystick_fire

	lda joystick_buf
	and #$10 // Only care about the fifth bit (fire button)
	cmp #$10
	beq fret

fpressed:
	lda #$ff
	sta joystick_fire

fret:
	rts

// Checks whether left is pressed. Populates joystick_left with 0xff if left button hit, 0x00 otherwise
left_pressed:

	lda #$00
	sta joystick_left

	lda joystick_buf
	and #$04 // Only care about the fifth bit (fire button)
	cmp #$04
	beq lret

lpressed:
	lda #$ff
	sta joystick_left

lret:
	rts

// Checks whether right is pressed. Populates joystick_right with 0xff if right button hit, 0x00 otherwise
right_pressed:

	lda #$00
	sta joystick_right

	lda joystick_buf
	and #$08 // Only care about the fifth bit (fire button)
	cmp #$08
	beq rret

rpressed:
	lda #$ff
	sta joystick_right

rret:
	rts

// Checks whether up is pressed. Populates joystick_up with 0xff if up button hit, 0x00 otherwise
up_pressed:

	lda #$00
	sta joystick_up

	lda joystick_buf
	and #$01 // Only care about the fifth bit (fire button)
	cmp #$01
	beq uret

upressed:
	lda #$ff
	sta joystick_up

uret:
	rts

// Checks whether down is pressed. Populates joystick_down with 0xff if down button hit, 0x00 otherwise
down_pressed:

	lda #$00
	sta joystick_down

	lda joystick_buf
	and #$02 // Only care about the fifth bit (fire button)
	cmp #$02
	beq dret

dpressed:
	lda #$ff
	sta joystick_down

dret:
	rts
