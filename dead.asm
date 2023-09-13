dead:
    jsr do_fade

    lda #$00
    sta $d020 // border
    sta $d021 // background
    sta $0286 // cursor
    jsr draw_dead

    ldx #$ff
dead_wait_x:

    ldy #$ff
dead_wait_y:
    dey
    cpy $ff
    bne dead_wait_y

    dex 
    cpx $ff
    bne dead_wait_x

    jmp menu


dead0:  .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
dead1:  .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
dead2:  .text "                                        "
        .text "01234567890123 game  over 78901234567890"
        .text "                                        "
        .text "                                        "
        .text "                                        "
dead3:  .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
dead4:  .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "
        .text "                                        "


draw_dead:
    ldx #$00

!draw_dead:
    lda dead0, x
    sta $0400, x
    lda dead1, x
    sta $04c8, x
    lda dead2, x
    sta $0590, x
    lda dead3, x
    sta $0658, x
    lda dead4, x
    sta $0720, x

    inx
    cpx #$c8
    bne !draw_dead-
    rts
