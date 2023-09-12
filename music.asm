*=$1000 "Music"
.label music_init =*		// <- You can define label with any value (not just at the current pc position as in 'music_init:') 
.label music_play =*+3		// <- and that is useful here
.import binary "music.bin"	// <- import is used for importing files (binary, source, c64 or text)	


music_irq:
	pha
	txa
	pha
	tya
	pha
	lda #$ff
	sta	$d019

	jsr music_play

	pla
	tay
	pla
	tax
	pla
	rts