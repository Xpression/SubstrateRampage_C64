stars_x: .byte $00
stars_y: .byte $10


init_stars:
    lda #$00
    sta stars_x

    ldx #$00

!init_stars:
    lda #$91
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
    ldx #$28            // reset at screen width
    stx stars_x
!move_stars:
    lda #BLACK
    sta $d990,x

    dex
    cpx #$ff
    beq !next_char++++
    lda #DARK_GRAY
    sta $d990,x
!next_char:

    dex
    cpx #$ff
    beq !next_char+++
    lda #GRAY
    sta $d990,x
!next_char:

    dex
    cpx #$ff
    beq !next_char++
    lda #LIGHT_GRAY
    sta $d990,x
!next_char:

    dex
    cpx #$ff
    beq !next_char+
    lda #WHITE
    sta $d990,x
!next_char:

    rts
