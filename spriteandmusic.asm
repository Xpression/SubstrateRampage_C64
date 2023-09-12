BasicUpstart2(start)			// <- This creates a basic sys line that can start your program



.label joystick_buf = $5000
.label tmp = $5001

//----------------------------------------------------------
//----------------------------------------------------------
//					Simple IRQ
//----------------------------------------------------------
//----------------------------------------------------------
			* = $4000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling at 0x4000
start:		lda #$00
			sta $d020
			sta $d021
			lda #$00
			jsr music_init

			sei 			// Set Interrupt Flag, disabling interrupts until cleared again
			lda #$35 		// 0b110101
			sta $01			// RAM visible at $A000-$BFFF and $E000-$FFFF.  I/O area visible at $D000-$DFFF.
			lda #<irq1		// lower part of ISR address
			sta $fffe		// Store it in right memory address
			lda #>irq1		// upper part of ISR address
			sta $ffff 		// Store it in right memory address
			lda #$1b		// 0b11011
			sta $d011 		// Write to screen control register - vertical raster scroll on?, screen height = 24 rows, screen on normal contents are visible, bitmap mode
			lda #$80		// 0b10000000
			sta $d021 		// Write the above value to generate interrupts at raster line 7 (8th bit) 
			lda #$01//#$81		// 0b00000001
			sta $d01a		// Write the above value to interrupt control register (D01A) - raster interrupt enabled (why is 8th bit set? try turning it off! It works!)
			lda #$7f		// 0b01111111
			sta $dc0d		// Write the above value to interrupt control ans status register, this effectively enables all interrupts
			sta $dd0d		// More interrupt controls, this effectively enables all non maskable interrupts

			lda $dc0d		// Read these interrupt registers
			lda $dd0d		// Read these interrupt registers
			lda #$ff
			sta $d019		// Write to interrupt status register, acknowledging all interrupts


			// Some setup
			lda #$00
			sta joystick_buf

			cli				// Clear inerrupt flag, so that we again will start responding to interrupts



loop:		
			// Reset border color variable to black
			lda #$00
			sta tmp

			// Check if joystick pressed
			lda joystick_buf
			and #$10 // Only care about the fifth bit (fire button)
			cmp #$10
			beq no_input

			// set border green color only if joystisk hit
			lda  #$05
			sta tmp

no_input:

			jmp loop			// infinte while

			lda #$05 	// Load color black (0) into accumulator
			sta $d020	// Store black in border collor address (0xd020)
			sta $d021	// Also store black in background color address (0xd021)


//----------------------------------------------------------
irq1:  		pha			// Push a onto the stack
			txa 		// Transfer x to a
			pha			// push a
			tya         // transfer y to a
			pha 		// push a

			// Read joystick
			lda $dc00
			sta joystick_buf

			lda #$ff 	
			sta	$d019	// Write to interrupt status register, acknowledging all interrupts



			//SetBorderColor(RED)			// <- This is how macros are executed
			//jsr music_play
			//SetBorderColor(BLACK)		// <- There are predefined constants for colors

			SetBorderColor2()			// <- This is how macros are executed
			jsr music_play
			//SetBorderColor2()		// <- There are predefined constants for colors

			pla 	// pop stack into a
			tay     // transfer a to y  (restore y)
			pla     // pop stack into a
			tax     // transfer a to x (restore x)
			pla     // pop stack into a 
			rti     // Return from interrupt
			
//----------------------------------------------------------
			*=$1000 "Music"
			.label music_init =*			// <- You can define label with any value (not just at the current pc position as in 'music_init:')  <---- Does this do anything? It should not, right?
			.label music_play =*+3			// <- and that is useful here
			.import binary "ode to 64.bin"	// <- import is used for importing files (binary, source, c64 or text)	
			//.import binary "srn-c64-01.sid"

//----------------------------------------------------------
// A little macro
.macro SetBorderColor(color) {		// <- This is how macros are defined
	lda #color
	sta $d020
}

.macro SetBorderColor2() {		// <- This is how macros are defined
	lda tmp
	sta $d020
}
