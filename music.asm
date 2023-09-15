*=$1000 "Song1"
.var music_menu = LoadSid("menu.sid")
.fill music_menu.size, music_menu.getData(i)	

*=$2000 "Song2"
.var music_game = LoadSid("dead.sid")
.fill music_game.size, music_game.getData(i)	

/*
.var music_dead = LoadSid("dead.sid")
.fill music_dead.size, music_dead.getData(i)	
*/

song_playing: 
	.byte $ff
next_song:
	.byte $0


music_irq:
	lda song_playing
	adc #$30
	sta $0428
	lda #$04
	sta $d828

	lda song_playing
	cmp #$00
	bne !music_irq+
	jsr music_menu.play
	rts
!music_irq:
	cmp #$01
	bne !music_irq+
	jsr music_game.play
	rts
!music_irq:
	//jsr music_dead.play
	rts


change_song:
	ldx #$00
	ldy #$00

	lda next_song
	cmp #$00
	bne !change_song+
	lda #music_menu.startSong-1
	jsr music_menu.init		
	jmp song_changed

!change_song:
	cmp #$01
	bne !change_song+
	lda #music_game.startSong-1
	jsr music_game.init		
	jmp song_changed

!change_song:
	//lda #music_dead.startSong-1
	//jsr music_dead.init		
	jmp song_changed

song_changed:
	lda next_song
	sta song_playing
	rts
		


