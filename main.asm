:BasicUpstart2(start)
* = $4000 "Main Program"

#import "game.asm"
#import "input.asm"
#import "menu.asm"
#import "music.asm"

start:
	jsr music_init
	jsr input_init
	
	jsr setup_irq
	jmp menu

setup_irq:  
	sei 			// disable interrupts

	lda #$35
	sta $01
	lda #<main_irq
	sta $fffe
	lda #>main_irq
	sta $ffff
	lda #$1b
	sta $d011
	lda #$80
	sta $d012
	lda #$81
	sta $d01a
	lda #$7f
	sta $dc0d
	sta $dd0d

	lda $dc0d
	lda $dd0d
	lda #$ff
	sta $d019

	cli 			// enable interrupts
	rts 			// return from subroutine

//----------------------------------------------------------
main_irq:  		
	pha 		// push a, x, and y to stack
	txa 		// 
	pha 		// 
	tya			// 
	pha 		// 

	lda #$ff 	// acknowledge all interrupts
	sta	$d019   //

	jsr music_irq
	jsr input_irq

	pla 		// pop y, x, and a from stack
	tay 		// 
	pla 		//
	tax	 		//
	pla 		// 
	
	rti 		// return from interrupt handler
