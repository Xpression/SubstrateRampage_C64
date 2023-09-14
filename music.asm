*=music_load "Music"
.import binary "music.bin"	// <- import is used for importing files (binary, source, c64 or text)	

music_init:
	lda #$00
	jsr music_load

music_irq:
	jsr music_play
	rts