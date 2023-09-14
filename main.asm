:BasicUpstart2(start)
* = $4000 "Main Program"

#import "dead.asm"
#import "game.asm"
#import "graphics.asm"
#import "input.asm"
#import "menu.asm"
#import "music.asm"

start:
	jsr init
	jmp menu

init:
	// disable irq while configuring
	sei 		
	
	// RAM visible at $A000-$BFFF and $E000-$FFFF
	// I/O area visible at $D000-$DFFF	
	lda #$35
	sta $01  

	jsr music_init
	jsr input_init
	jsr setup_irq

	// read and ack current interrupt state
	lda $dc0d 		
	lda $dd0d
	lda #$ff
	sta $d019 		

	// re-enable irq signals
	cli 
	rts


setup_irq:  
	// store address of irq subroutine
	lda #<main_irq 	
	sta $fffe
	lda #>main_irq
	sta $ffff

	// configure screen-based interrupts
	lda #$1b 		
	sta $d011 		
	lda #$80
	sta $d012  		
	lda #$81 		
	sta $d01a 		

	// setup interrupt control
	lda #$7f 		
	sta $dc0d 		
	sta $dd0d 		

	// return
	rts 

//----------------------------------------------------------
main_irq:  		
	// push a, x, and y to stack
	pha		
	txa
	pha
	tya
	pha

	jsr music_irq
	jsr input_irq

	lda #$00
	sta speed_bump

	//.label frame_counter = $5002
	ldy frame_counter
	iny 
	sty frame_counter


	// acknowledge all interrupts
	lda #$ff 		
	sta	$d019

	// pop y, x, and a from stack
	pla
	tay
	pla
	tax
	pla
	
	// return from interrupt handler
	rti 		
