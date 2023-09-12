*=$1000 "Music"
.label music_load =*		// <- You can define label with any value (not just at the current pc position as in 'music_init:') 
.label music_play =*+3		// <- and that is useful here
.import binary "music.bin"	// <- import is used for importing files (binary, source, c64 or text)	

music_init:
	lda #$00
	jsr music_load

music_irq:
	jsr music_play
	rts