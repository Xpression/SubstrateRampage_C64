stars_col: 
    .byte $2d,$50,$3a,$48,$33,$40,$37,$3a,$30
stars_row:
    .byte $00,$03,$05,$09,$0c,$0f,$12,$14,$17
stars_speed:
    .byte %00000001,%00000010,%00000011
    .byte %00000001,%00000010,%00000011
    .byte %00000001,%00000010,%00000011
row_address:
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
current_star:
    .byte $00


init_stars:
    ldx #$00
    sta current_star

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
    lda #$00
    sta current_star
    jsr move_current

    inc current_star
    jsr move_current

    inc current_star
    jsr move_current

    inc current_star
    jsr move_current

    inc current_star
    jsr move_current

    inc current_star
    jsr move_current

    inc current_star
    jsr move_current
    rts

move_current:
    ldx current_star
    lda frame_counter
    and stars_speed,x
    bne !move_current+
    rts

!move_current:
    lda stars_row,x
    asl                 // multiply by 2 since addresses are 2-bytes 
    tax
    lda row_address,x   // bring row address into free zero page bytes:
    sta $00fb           // https://www.c64-wiki.com/wiki/Zeropage
    inx
    lda row_address,x   // to enable indirect-indexed addressing:
    sta $00fc           // https://www.c64-wiki.com/wiki/Indirect-indexed_addressing

    ldx current_star
    dec stars_col,x
    lda stars_col,x
    cmp #$ff            // check if x has underflowed
    bne !move_current+

reset_current:
    lda #$2d            // reset col to outside of screen
    sta stars_col,x

    lda stars_row,x     // reset row to something "random"
    clc
    adc #$13
    cmp #$18
    bcc !next_row+
    clc
    sbc #$18
!next_row:
    sta stars_row,x
    rts

!move_current:
    ldy stars_col,x
    cpy #$28
    bcs !next_char+

    lda #BLACK
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_current+
    cpy #$28            // compare this position to screen width
    bcs !next_char+     // http://www.6502.org/tutorials/compare_beyond.html 
    lda #DARK_GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_current+
    cpy #$28
    bcs !next_char+
    lda #GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_current+
    cpy #$28
    bcs !next_char+
    lda #LIGHT_GRAY
    sta ($fb),y

!next_char:
    dey
    cpy #$ff
    beq !move_current+
    cpy #$28
    bcs !next_char+
    lda #WHITE
    sta ($fb),y

!next_char:
!move_current:
    rts
