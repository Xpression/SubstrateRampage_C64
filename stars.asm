stars_col: 
    .byte $00
stars_row:
    .byte $18

row_address:
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
    sta stars_col

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
    lda stars_row
    asl 
    tax
    lda row_address,x   // bring row address into free zero page bytes:
    sta $00fb           // https://www.c64-wiki.com/wiki/Zeropage
    inx
    lda row_address,x   // to enable indirect-indexed addressing:
    sta $00fc           // https://www.c64-wiki.com/wiki/Indirect-indexed_addressing

    dec stars_col         
    ldy stars_col         
    cpy #$ff            // check if x has underflowed
    bne !move_stars+    
    ldy #$2d            // reset at screen width
    sty stars_col
    rts

!move_stars:
    cpy #$28
    bcs !next_char+

    lda #BLACK
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_stars+
    cpy #$28            // compare this position to screen width
    bcs !next_char+     // http://www.6502.org/tutorials/compare_beyond.html 
    lda #DARK_GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_stars+
    cpy #$28
    bcs !next_char+
    lda #GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_stars+
    cpy #$28
    bcs !next_char+
    lda #LIGHT_GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_stars+
    cpy #$28
    bcs !next_char+
    lda #WHITE
    sta ($fb),y

!next_char:
!move_stars:
    rts
