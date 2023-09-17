*=$3000 "Sprites" 
	// Sprite one at $3000			
	.byte %01111111,%11111111,%11100000
	.byte %10001111,%00000000,%10010000
	.byte %10001110,%00000110,%10001000
	.byte %10001110,%00000110,%10001100
	.byte %10001110,%00000110,%10001110
	.byte %10001111,%00000000,%10001111
	.byte %10000111,%11111111,%00001110
	.byte %10000000,%00000000,%00001100
	.byte %10000000,%00000000,%00001000
	.byte %10000111,%11111100,%00001000
	.byte %10011000,%00000011,%10001000
	.byte %10100000,%00000010,%10001000
	.byte %10100000,%00000010,%10001000
	.byte %10011000,%00000100,%10001000
	.byte %10001111,%11111000,%10001000
	.byte %10001000,%00000000,%10001000
	.byte %10001011,%11111110,%10001000
	.byte %10001000,%00000000,%10001000
	.byte %10101011,%11111110,%10101000
	.byte %10001000,%00000000,%10001000
	.byte %01111111,%11111111,%11110000
	.byte $00

	// Sprite two at $3040			
	.byte %00000001,%11000111,%00000000
	.byte %00000010,%01001000,%10000000
	.byte %00000100,%10010011,%10011110
	.byte %00000101,%00010100,%00100001
	.byte %00000100,%10111111,%11001101
	.byte %00110010,%11111111,%11010011
	.byte %01001001,%11111111,%11100000
	.byte %10110111,%11111111,%11110000
	.byte %11001101,%11111111,%11110000
	.byte %00001001,%11111111,%11110000
	.byte %00001000,%00000000,%00000000
	.byte %11001001,%11111111,%11110000
	.byte %10110101,%11111111,%11110000
	.byte %01001011,%11111111,%11110000
	.byte %00110001,%11111111,%11100000
	.byte %00000010,%11111111,%11010011
	.byte %00000101,%10111111,%11001101
	.byte %00000101,%00010100,%00100001
	.byte %00000100,%10010011,%10011110
	.byte %00000010,%01001000,%10000000
	.byte %00000001,%11000111,%00000000
	.byte %11111111
	
	// Sprite three at $3080			
	.byte %00001111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00111111,%11111111,%11111000
	.byte %00110111,%11111111,%11011000
	.byte %01110011,%11111111,%10011100
	.byte %01100001,%11111111,%00001100
	.byte %01100000,%11111110,%00001100
	.byte %01100000,%11111110,%00001100
	.byte %01110000,%01111100,%00011100
	.byte %00110000,%00111000,%00011000
	.byte %00011100,%01111100,%01110000
	.byte %00000111,%11101111,%11000000
	.byte %00000011,%11000111,%10000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%11111110,%00000000
	.byte %00000000,%10101010,%00000000
	.byte %00111100,%00000000,%01111000
	.byte %01001010,%10101010,%10100100
	.byte %10010010,%11111110,%10010010
	.byte %10010010,%11111110,%10010010
	.byte %10010000,%01111100,%00010010
	.byte %11111111

// These should be set if we exceed x == 255
sprite_x_overflow_flags:
	.byte 0, 0, 0, 0, 0, 0, 0, 0

// Some buffers for working with x-coordinates
sprite_x_hi:
	.byte 0
sprite_x_lo:
	.byte 0

// Subroutine that sets a sprites x-position.
// 'sprite_num_buf' contains the 0-indexed sprite number [0-7]
// 'sprite_x_hi' contains the high byte, will always be 0x01 or 0x00
// 'sprite_x_lo' contains the low byte, will range 0x00 to 0xff
set_sprite_x_position:

	// if the high byte != 0x00, set the overflow flag for the given sprite
	lda sprite_x_hi
	cmp #$0
	beq no_overflow

	ldx sprite_num_buf
	lda #$01
	sta sprite_x_overflow_flags, x

	// also set the extra bit that the VIC II uses for this sprite (0xD010)
	jsr set_vic_overflow

	// and then continue with the lsbs
	jmp ssxp_lsb


no_overflow:
	// Clear the overflow flag
	ldx sprite_num_buf
	lda #$00
	sta sprite_x_overflow_flags, x

	// Clear the extra bit the VIC II uses for this rpite (0xD010)
	jsr clear_vic_overflow

ssxp_lsb:

	// This is where we set the LSB for the sprite
	lda sprite_num_buf
	asl // multiply by two
	tax 

	// Store the LSB 
	lda sprite_x_lo
	sta $d000, x

ssxp_exit:
	rts

// 'sprite_num_buf' contains the 0-indexed sprite number [0-7]
set_vic_overflow:
	lda sprite_num_buf
	cmp #$00
	bne sb_one

	lda $d010
	ora #%00000001
	sta $d010
	jmp svo_exit

sb_one:
	cmp #$01
	bne sb_two

	lda $d010
	ora #%00000010
	sta $d010
	jmp svo_exit

sb_two:
	cmp #$02
	bne sb_three

	lda $d010
	ora #%00000100
	sta $d010
	jmp svo_exit

sb_three:
	cmp #$03
	bne sb_four

	lda $d010
	ora #%00001000
	sta $d010
	jmp svo_exit

sb_four:
	cmp #$04
	bne sb_five

	lda $d010
	ora #%00010000
	sta $d010
	jmp svo_exit

sb_five:
	cmp #$05
	bne sb_six

	lda $d010
	ora #%00100000
	sta $d010
	jmp svo_exit

sb_six:
	cmp #$06
	bne sb_seven

	lda $d010
	ora #%01000000
	sta $d010
	jmp svo_exit

sb_seven:
	cmp #$07
	bne svo_exit

	lda $d010
	ora #%10000000
	sta $d010

svo_exit:
	rts

// 'sprite_num_buf' contains the 0-indexed sprite number [0-7]
clear_vic_overflow:
	lda sprite_num_buf
	cmp #$00
	bne cb_one

	lda $d010
	and #%11111110
	sta $d010
	jmp cvo_exit

cb_one:
	cmp #$01
	bne cb_two

	lda $d010
	and #%11111101
	sta $d010
	jmp cvo_exit

cb_two:
	cmp #$02
	bne cb_three

	lda $d010
	and #%11111011
	sta $d010
	jmp cvo_exit

cb_three:
	cmp #$03
	bne cb_four

	lda $d010
	and #%11110111
	sta $d010
	jmp cvo_exit

cb_four:
	cmp #$04
	bne cb_five

	lda $d010
	and #%11101111
	sta $d010
	jmp cvo_exit

cb_five:
	cmp #$05
	bne cb_six

	lda $d010
	and #%11011111
	sta $d010
	jmp cvo_exit

cb_six:
	cmp #$06
	bne cb_seven

	lda $d010
	and #%10111111
	sta $d010
	jmp cvo_exit

cb_seven:
	cmp #$07
	bne cvo_exit

	lda $d010
	and #%01111111
	sta $d010

cvo_exit:
	rts


init_sprite_one:

	// Clear the overflow flag
	lda #$00
	sta sprite_x_overflow_flags

	// Set pointer to sprite one data
	lda #$0c0 // 0x3000 / 0x40 => 0xc0
	sta sprite_one

	// Enable sprite one
	lda #%00000001
	sta $d015 // sprite enable register

	// Set position of sprite one
	lda #$18 	// 0x80 = 128 decimal
	sta $d000	// sprite one position x
	sta $d001	// sprite one position y

	rts

init_sprite_two:
	// Set pointer to two one data
	lda #$0c1 // 0x3040 / 0x40 => 0xc1
	sta sprite_two

	// Enable sprite two
	lda $d015
	ora #%00000010
	sta $d015 // sprite enable register

	// Set position of sprite two

	// x-coordina - overflow
	lda #$01
	sta sprite_num_buf
	lda #$40 
	sta sprite_x_lo
	lda #$01
	sta sprite_x_hi
	jsr set_sprite_x_position

	lda #$50 	
	sta $d003	// sprite two position y

	rts

init_sprite_three:
	// Set pointer to two one data
	lda #$0c2 // 0x3080 / 0x40 => 0xc2
	sta sprite_three

	// Enable sprite three
	lda $d015
	ora #%00000100
	sta $d015 // sprite enable register

	// Set position of sprite three

	// Set position of sprite three (zero-indexed)
	// x-coordina - overflow
	lda #$02
	sta sprite_num_buf
	lda #$40 
	sta sprite_x_lo
	lda #$01
	sta sprite_x_hi
	jsr set_sprite_x_position

	lda #$b0 	
	sta $d005	// sprite two position y

	rts

init_sprite_four:
	// Set pointer to two one data
	lda #$0c1 // 0x30c0 / 0x40 => 0xc3
	sta sprite_four

	// Enable sprite four
	lda $d015
	ora #%00001000
	sta $d015 // sprite enable register

	// Set position of sprite four (zero-indexed)
	// x-coordina - overflow
	lda #$03
	sta sprite_num_buf
	lda #$58 
	sta sprite_x_lo
	lda #$01
	sta sprite_x_hi
	jsr set_sprite_x_position

	// y-coordinate
	lda #$b0
	sta $d007	// sprite two position y

	rts

// Subroutine that increments a sprites position.
// 'sprite_num_buf' contains the 0-indexed sprite number [0-7]
// 'sprite_dir_buf' contains the direction (x == 0x00, y == 0x01) the sprite postion should be incremented
// 'sprite_step_buf' contains the step that a sprite should be decremented
increment_sprite_position:

	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf
	tax

	and #%00000001
	cmp #%00000001
	beq inc_y_coordinate // we are incrementing a y-coordinate, so only care about single byte coordinates

	///// Need to convert to hi and lo

	// if overflow is set for this sprite, it should still be set since we are incrementing
	// in that case we can do simple increment of low and store that
	ldy sprite_num_buf
	lda sprite_x_overflow_flags, y
	cmp #$01
	beq inc_lo

	// If overflow is not set, we need to check whether we are are crossing the boundary of 255 and have to set it

	// Find diff between 0xff and current value - this is how many pixels are left until overflow
	lda #$ff
	sec
	sbc $d000, x // diff is now in A-reg

	// if step we should increment with is smaller than this diff, we should keep overflow flag at 0 and increment LSB
	cmp sprite_step_buf
	bcs inc_lo

	// Otherwise, we are crossing the boundary. We should set the hi bit and bring use the overflowed value as LSB
	lda #$01
	sta sprite_x_hi

	// Increment the LSBs
	lda $d000, x
	clc
	adc sprite_step_buf
	sta sprite_x_lo

	// Set the value
	jsr set_sprite_x_position

	jmp inc_spos_exit

inc_lo:
	// Keep the overflow flag
	ldy sprite_num_buf
	lda sprite_x_overflow_flags, y
	sta sprite_x_hi

	// Increment the LSBs
	lda $d000, x
	clc
	adc sprite_step_buf
	sta sprite_x_lo
	
	// Set the value
	jsr set_sprite_x_position

	jmp inc_spos_exit
	
inc_y_coordinate:

	// load the value of the given sprite's y coordinate
	lda $d000, x
	clc
	adc sprite_step_buf

	sta $d000, x
	
inc_spos_exit:
	rts

// Subroutine that decrements a sprites position.
// 'sprite_num_buf' contains the 0-indexed sprite number [0-7]
// 'sprite_dir_buf' contains the direction (x == 0x00, y == 0x01) the sprite postion should be decremented
// 'sprite_step_buf' contains the step that a sprite should be decremented
decrement_sprite_position:

	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf
	tax

	and #%00000001
	cmp #%00000001
	beq dec_y_coordinate // we are decrementing a y-coordinate, so only care about single byte coordinates

	// We are decrementing in x-direction
	// Need to handle the hi- and lo- states correctly
	// This means checking whether or not we will underflow the LSBs. If so, we need to flip the 
	// overflow bit. Otherwise, it should be kept as is.
	lda $d000, x
	cmp sprite_step_buf
	bcc will_cross_zero // step is larger than distance to underflow

	// We can keep the hi-bit as is
	ldy sprite_num_buf
	lda sprite_x_overflow_flags, y
	sta sprite_x_hi

	jmp dec_lo

will_cross_zero:
	
	// Must flip MSB
	ldy sprite_num_buf
	lda sprite_x_overflow_flags, y
	eor #%00000001
	sta sprite_x_hi

dec_lo:

	// Decrement the LSB-component
	lda $d000, x
	sec
	sbc sprite_step_buf
	sta sprite_x_lo

	// Set the value
	jsr set_sprite_x_position

	jmp dec_spos_exit

dec_y_coordinate:
	// load the value of the given sprite's x or y coordinate
	lda $d000, x
	sec
	sbc sprite_step_buf

	sta $d000, x

dec_spos_exit:
	rts

cmp_player_collision:
	lda $d01e // read hardware sprite-sprite collision register
    and #$01  // mask to player only
    cmp #$01  // check collision
    rts
