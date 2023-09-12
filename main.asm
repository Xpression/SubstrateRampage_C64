:BasicUpstart2(start)
* = $4000 "Main Program"

#import "menu.asm"
#import "game.asm"
#import "music.asm"

start:
	jsr setup_irq
	jmp *

setup_irq:  
	lda #$00
	sta $d020
	sta $d021
	lda #$00
	jsr music_init
	sei
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

	cli
	rts

//----------------------------------------------------------
main_irq:  		
	jsr music_irq
	jsr game_irq
	rti
