.label sprite_one = $07f8
.label sprite_two = $07f9
.label sprite_three = $07fa
.label sprite_four = $07fb
.label sprite_five = $07fc
.label sprite_six = $07fd
.label sprite_seven = $07fe
.label sprite_eight = $07ff

.label sprite_data_one = $3000

*=sprite_data_one "Sprite Data" 
			.byte %00000000, %11111111, %00000000 	
		 	.byte %00000001, %11111111, %10000000 	
		 	.byte %00000011, %11111111, %11000000 	
		 	.byte %00000111, %11111111, %11100000 	
		 	.byte %00001111, %11111111, %11110000 	
		 	.byte %00011111, %11111111, %11111000 	
		 	.byte %00111111, %11111111, %11111100 	
		 	.byte %00000011, %11111111, %11000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
		 	.byte %00000000, %00000000, %00000000 	
			.byte $00


init_sprite_one:
	// Set pointer to sprite one data
	lda #$0c0
	sta sprite_one

	// Enable sprite one
	lda #$01
	sta $d015 // sprite enable register

	// Set position of sprite one
	lda #$80 	// 0x80 = 128 decimal
	sta $d000	// sprite one position x
	sta $d001	// sprite one position y

	rts

// x-register contains sprite number
// y-register contains direction: x = 0x00, y = 0x01
//increment_sprite_position:

	//sty $2999
	
	// Find the offset of the sprite number
	//txa       // Load first operand into the accumulator.
	//cld        // Clear the carry flag so it does not get added into the result
	//adc $2999      // Add the other operand
	//tax ///sta x      // Store the operand back to x

	// load the value of the given sprite's x or y coordinate
	//ldy sprite_one, x

	// Increment the value
	//iny

	// store the incremented value back
	//tya
	//sta sprite_one, x

//	rts




