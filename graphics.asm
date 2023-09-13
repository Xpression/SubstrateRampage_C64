.label sprite_one = $07f8
.label sprite_two = $07f9
.label sprite_three = $07fa
.label sprite_four = $07fb
.label sprite_five = $07fc
.label sprite_six = $07fd
.label sprite_seven = $07fe
.label sprite_eight = $07ff

.label sprite_data_one = $3000

*=sprite_data_one "Sprite Data One" 
			.byte %00000000, %11111111, %00000000 	
		 	.byte %00000001, %11111111, %10000000 	
		 	.byte %00000011, %11111111, %11000000 	
		 	.byte %00000111, %11111111, %11100000 	
		 	.byte %00001111, %11111111, %11110000 	
		 	.byte %00011111, %11111111, %11111000 	
		 	.byte %00111111, %11111111, %11111100 	
		 	.byte %01111111, %11111111, %11111110 	
		 	.byte %00000000, %11111111, %11111100 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
		 	.byte %00000000, %11111111, %00000000 	
			.byte $00
			// Sprite data two at 0x3040
			
			.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111	
			.byte %11111111
			

			// Sprite three at 0x3040
			
			.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111 	
		 	.byte %11111111, %11111111, %11111111	
			.byte %11111111

.label sprite_num_buf = $5005
.label sprite_dir_buf = $5006

init_sprite_one:
	// Set pointer to sprite one data
	lda #$0c0 // 0x3000 / 0x40 => 0xc0
	sta sprite_one

	// Enable sprite one
	lda #%00000001
	sta $d015 // sprite enable register

	// Set position of sprite one
	lda #$80 	// 0x80 = 128 decimal
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
// Memory address 0x5005 contains the 0-indexed sprite number [0-7]
// Memory address 0x5006 contains the direction (x == 0x00, y == 0x01) the sprite postion should be incremented
increment_sprite_position:

	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf
	tax

	// load the value of the given sprite's x or y coordinate
	ldy $d000, x

	// Increment the value
	iny

	// store the incremented value back
	tya
	sta $d000, x

	rts

// Subroutine that decrements a sprites position.
// Memory address 0x5005 contains the 0-indexed sprite number [0-7]
// Memory address 0x5006 contains the direction (x == 0x00, y == 0x01) the sprite postion should be incremented
decrement_sprite_position:

	// Find the offset of the sprite number and transfer to x-reg
	lda sprite_num_buf
	asl // multiply by two
	clc
	adc sprite_dir_buf
	tax

	// load the value of the given sprite's x or y coordinate
	ldy $d000, x

	// decrement the value
	dey

	// store the incremented value back
	tya
	sta $d000, x

	rts

is_player_sprite_collision:

	lda $D01E //;Read hardware sprite/sprite collision
    and #$1
    cmp #$1
	beq collision
    rts

collision:
	inc $D020
	dex
	cpx #$ff
	bne collision

nocollision:
	rts