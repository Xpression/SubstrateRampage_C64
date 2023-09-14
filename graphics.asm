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

init_sprite_one:
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
	lda #$50 	
	sta $d002	// sprite two position x
	sta $d003	// sprite two position y

	rts

init_sprite_three:
	// Set pointer to two one data
	lda #$0c2 // 0x3080 / 0x40 => 0xc2
	sta sprite_three

	// Enable sprite two
	lda $d015
	ora #%00000100
	sta $d015 // sprite enable register

	// Set position of sprite three
	lda #$b0 	
	sta $d004	// sprite two position x
	sta $d005	// sprite two position y

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

	// load the value of the given sprite's x or y coordinate
	lda $d000, x
	clc
	adc sprite_step_buf

	sta $d000, x

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

	// load the value of the given sprite's x or y coordinate
	lda $d000, x
	sec
	sbc sprite_step_buf

	sta $d000, x

	rts

cmp_player_collision:
	lda $d01e // read hardware sprite-sprite collision register
    and #$01  // mask to player only
    cmp #$01  // check collision
    rts
