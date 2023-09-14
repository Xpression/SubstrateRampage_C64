*=music_load "Music"
.var music = LoadSid("music.sid")
.fill music.size, music.getData(i)	

music_init:
	ldx #$00
	ldy #$00
	lda #music.startSong-1
	jsr music.init	

music_irq:
	jsr music.play
	rts