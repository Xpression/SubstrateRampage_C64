stars_x: 
    .byte $00
stars_y: 
    .word $dbc0

col_address:
    .word $d800
    .word $d828
    .word $d850
    .word $d878
    .word $d8a0
    .word $d8c8
    .word $d8f0
    .word $d918
    .word $d940
    .word $d968
    .word $d990
    .word $d9b8
    .word $d9e0
    .word $da08
    .word $da30
    .word $da58
    .word $da80
    .word $daa8
    .word $dad0
    .word $daf8
    .word $db20
    .word $db48
    .word $db70
    .word $db98
    .word $dbc0


init_stars:
    lda #$00
    sta stars_x

    ldx #$00

!init_stars:
    lda #$a0
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x

    lda #$00
    sta $d800, x
    sta $d900, x
    sta $da00, x
    sta $db00, x

    dex
    bne !init_stars-
    rts


move_stars:
    dec stars_x
    ldx stars_x
    cpx #$ff            // check if x has underflowed
    bne !move_stars+    
    ldx #$2d            // reset at screen width
    stx stars_x

!move_stars:
    cpx #$28
    bcs !next_char+
    lda #BLACK
    sta $dbc0,x

!next_char:
    dex
    cpx #$ff
    beq !move_stars+
    cpx #$28            // compare this position to screen width
    bcs !next_char+     // http://www.6502.org/tutorials/compare_beyond.html 
    lda #DARK_GRAY
    sta $dbc0,x

!next_char:
    dex
    cpx #$ff
    beq !move_stars+
    cpx #$28
    bcs !next_char+
    lda #GRAY
    sta $dbc0,x

!next_char:
    dex
    cpx #$ff
    beq !move_stars+
    cpx #$28
    bcs !next_char+
    lda #LIGHT_GRAY
    sta $dbc0,x

!next_char:
    dex
    cpx #$ff
    beq !move_stars+
    cpx #$28
    bcs !next_char+
    lda #WHITE
    sta $dbc0,x

!next_char:
!move_stars:
    rts
