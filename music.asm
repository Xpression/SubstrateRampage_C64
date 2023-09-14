*=$1000 "Music"
.var music = LoadSid("music_main.sid")
.fill music.size, music.getData(i)	

music_init:
	ldx #$00
	ldy #$00
	lda #music.startSong-1
	jsr music.init	

music_irq:
	jsr music.play
	rts