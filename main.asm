:BasicUpstart2(start)
* = $4000 "Main Program"

#import "game.asm"
#import "input.asm"
#import "menu.asm"
#import "music.asm"
#import "graphics.asm"

start:
	jsr music_init
	jsr input_init
	jsr setup_irq
	jmp menu

setup_irq:  
	sei 			// disable irq while configuring

	lda #$35 		// RAM visible at $A000-$BFFF and $E000-$FFFF
	sta $01  		// I/O area visible at $D000-$DFFF

	lda #<main_irq 	// store address of irq subroutine
	sta $fffe
	lda #>main_irq
	sta $ffff

	lda #$1b 		// configure screen-based interrupts
	sta $d011 		
	lda #$80
	sta $d012  		
	lda #$81 		
	sta $d01a 		

	lda #$7f 		// setup interrupt control
	sta $dc0d 		
	sta $dd0d 		

	lda $dc0d 		// read and ack current interrupt state
	lda $dd0d
	lda #$ff
	sta $d019 		

	cli 			// re-enable irq signals
	rts 

//----------------------------------------------------------
main_irq:  		
	pha 		// push a, x, and y to stack
	txa 		// 
	pha 		// 
	tya			// 
	pha 		// 

	jsr music_irq
	jsr input_irq

	lda #$ff 	// acknowledge all interrupts
	sta	$d019   //

	pla 		// pop y, x, and a from stack
	tay 		// 
	pla 		//
	tax	 		//
	pla 		// 
	
	rti 		// return from interrupt handler
