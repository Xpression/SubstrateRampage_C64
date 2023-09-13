dead:
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


// game over logo generated by tool at:
// https://patorjk.com/software/taag/#p=display&h=0&v=0&f=Bloody&t=game%20over
//
// then manually converted into characters and colors from:
// https://sta.c64.org/cbm64scr.html
// https://www.c64-wiki.com/wiki/Color

dead_txt_0:
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$62,$a0,$a0,$a0,$a0,$20,$20,$62,$62,$62,$20,$20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$62,$20,$62,$a0,$a0,$a0,$66,$66,$a0,$a0,$a0,$a0,$a0,$20,$20,$20
.byte $20,$20,$20,$a0,$a0,$66,$20,$e2,$a0,$66,$66,$a0,$a0,$a0,$a0,$62,$20,$20,$20,$20,$66,$a0,$a0,$66,$e2,$a0,$e2,$20,$a0,$a0,$66,$66,$a0,$20,$20,$20,$e2,$20,$20,$20
.byte $20,$20,$66,$a0,$a0,$66,$62,$62,$62,$66,$66,$a0,$a0,$20,$20,$e2,$a0,$62,$20,$20,$66,$a0,$a0,$20,$20,$20,$20,$66,$a0,$a0,$66,$66,$a0,$a0,$a0,$20,$20,$20,$20,$20

dead_txt_1:
.byte $20,$20,$66,$66,$a0,$20,$20,$a0,$a0,$66,$66,$a0,$a0,$62,$62,$62,$62,$a0,$a0,$20,$66,$a0,$a0,$20,$20,$20,$20,$66,$a0,$a0,$20,$66,$66,$a0,$20,$20,$62,$20,$20,$20
.byte $20,$20,$66,$66,$66,$a0,$a0,$a0,$e2,$66,$20,$66,$a0,$20,$20,$20,$66,$a0,$a0,$66,$66,$a0,$a0,$66,$20,$20,$20,$66,$a0,$a0,$66,$66,$66,$a0,$a0,$a0,$a0,$66,$20,$20
.byte $20,$20,$20,$66,$66,$20,$20,$20,$66,$20,$20,$66,$66,$20,$20,$20,$66,$66,$a0,$66,$66,$20,$66,$66,$20,$20,$20,$66,$20,$20,$66,$66,$66,$20,$66,$66,$20,$66,$20,$20
.byte $20,$20,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$66,$66,$20,$66,$66,$20,$20,$66,$20,$20,$20,$20,$20,$20,$66,$20,$66,$20,$66,$20,$20,$66,$20,$20
.byte $20,$20,$66,$20,$66,$20,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20

dead_txt_2:
.byte $20,$20,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$20,$66,$20,$20,$66,$20,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$66,$20,$20,$66,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$66,$a0,$a0,$a0,$a0,$a0,$20,$20,$20,$a0,$a0,$66,$20,$20,$20,$a0,$66,$66,$a0,$a0,$a0,$a0,$a0,$20,$20,$a0,$a0,$e2,$a0,$a0,$a0,$20,$20,$20,$20,$20
.byte $20,$20,$20,$66,$a0,$a0,$66,$20,$20,$a0,$a0,$66,$66,$a0,$a0,$66,$20,$20,$20,$a0,$66,$66,$a0,$20,$20,$20,$e2,$20,$66,$a0,$a0,$20,$66,$20,$a0,$a0,$66,$20,$20,$20
.byte $20,$20,$20,$66,$a0,$a0,$66,$20,$20,$a0,$a0,$66,$20,$66,$a0,$a0,$20,$20,$a0,$66,$66,$66,$a0,$a0,$a0,$20,$20,$20,$66,$a0,$a0,$20,$66,$62,$a0,$20,$66,$20,$20,$20

dead_txt_3:
.byte $20,$20,$20,$66,$a0,$a0,$20,$20,$20,$a0,$a0,$66,$20,$20,$66,$a0,$a0,$20,$a0,$66,$66,$66,$66,$a0,$20,$20,$62,$20,$66,$a0,$a0,$e2,$e2,$a0,$62,$20,$20,$20,$20,$20
.byte $20,$20,$20,$66,$20,$a0,$a0,$a0,$a0,$66,$66,$66,$20,$20,$20,$66,$e2,$a0,$66,$20,$20,$66,$66,$a0,$a0,$a0,$a0,$66,$66,$a0,$a0,$66,$20,$66,$a0,$a0,$66,$20,$20,$20
.byte $20,$20,$20,$66,$20,$66,$66,$66,$66,$66,$66,$20,$20,$20,$20,$66,$20,$a0,$66,$20,$20,$66,$66,$20,$66,$66,$20,$66,$66,$20,$66,$66,$20,$66,$66,$66,$66,$20,$20,$20
.byte $20,$20,$20,$20,$20,$66,$20,$66,$20,$66,$66,$20,$20,$20,$20,$66,$20,$66,$66,$20,$20,$20,$66,$20,$66,$20,$20,$66,$20,$20,$66,$66,$20,$66,$20,$66,$66,$20,$20,$20
.byte $20,$20,$20,$66,$20,$66,$20,$66,$20,$66,$20,$20,$20,$20,$20,$20,$20,$66,$66,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$66,$66,$20,$20,$20,$66,$20,$20,$20,$20

dead_txt_4:
.byte $20,$20,$20,$20,$20,$20,$20,$66,$20,$66,$20,$20,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$66,$20,$20,$66,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$66,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

dead_col_0:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$00,$01,$01,$01,$01,$0f,$0f,$01,$01,$01,$01,$01,$00,$00,$00
.byte $00,$00,$00,$01,$01,$0c,$00,$01,$01,$0c,$0c,$01,$01,$01,$01,$01,$00,$00,$00,$00,$0f,$01,$01,$0c,$01,$01,$01,$00,$01,$01,$0c,$0f,$01,$00,$00,$00,$01,$00,$00,$00
.byte $00,$00,$0c,$01,$01,$0b,$01,$01,$01,$0b,$0c,$01,$01,$00,$00,$01,$01,$01,$00,$00,$0f,$01,$01,$00,$00,$00,$00,$0f,$01,$01,$0b,$0c,$01,$01,$01,$00,$00,$00,$00,$00

dead_col_1:
.byte $00,$00,$0b,$0f,$01,$00,$00,$01,$01,$0f,$0b,$01,$01,$01,$01,$01,$01,$01,$01,$00,$0c,$01,$01,$00,$00,$00,$00,$0c,$01,$01,$00,$0c,$0f,$01,$00,$00,$01,$00,$00,$00
.byte $00,$00,$0b,$0c,$0f,$01,$01,$01,$01,$0c,$00,$0f,$01,$00,$00,$00,$0f,$01,$01,$0c,$0c,$01,$01,$0c,$00,$00,$00,$0b,$01,$01,$0c,$0b,$0c,$01,$01,$01,$01,$0c,$00,$00
.byte $00,$00,$00,$0b,$0c,$00,$00,$00,$0c,$00,$00,$0c,$0c,$00,$00,$00,$0f,$0c,$01,$0b,$0b,$00,$0c,$0b,$00,$00,$00,$0b,$00,$00,$0b,$0b,$0b,$00,$0c,$0b,$00,$0b,$00,$00
.byte $00,$00,$00,$00,$0b,$00,$00,$00,$0b,$00,$00,$00,$0c,$00,$00,$00,$0c,$0c,$00,$0b,$0b,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$0b,$00,$0b,$00,$0b,$00,$00,$0b,$00,$00
.byte $00,$00,$0b,$00,$0b,$00,$00,$00,$0b,$00,$00,$00,$0b,$00,$00,$00,$0c,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00

dead_col_2:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$0b,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$0c,$01,$01,$01,$01,$01,$00,$00,$00,$01,$01,$0c,$00,$00,$00,$01,$0f,$0f,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$00
.byte $00,$00,$00,$0c,$01,$01,$0c,$00,$00,$01,$01,$0c,$0f,$01,$01,$0b,$00,$00,$00,$01,$0c,$0f,$01,$00,$00,$00,$01,$00,$0f,$01,$01,$00,$0c,$00,$01,$01,$0c,$00,$00,$00
.byte $00,$00,$00,$0c,$01,$01,$0b,$00,$00,$01,$01,$0c,$00,$0f,$01,$01,$00,$00,$01,$0c,$0b,$0c,$01,$01,$01,$00,$00,$00,$0f,$01,$01,$00,$0b,$01,$01,$00,$0c,$00,$00,$00

dead_col_3:
.byte $00,$00,$00,$0c,$01,$01,$00,$00,$00,$01,$01,$0b,$00,$00,$0c,$01,$01,$00,$01,$0b,$0b,$0c,$0f,$01,$00,$00,$01,$00,$0c,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$00
.byte $00,$00,$00,$0b,$00,$01,$01,$01,$01,$0f,$0c,$0b,$00,$00,$00,$0c,$01,$01,$0b,$00,$00,$0b,$0c,$01,$01,$01,$01,$0c,$0b,$01,$01,$0f,$00,$0c,$01,$01,$0c,$00,$00,$00
.byte $00,$00,$00,$0b,$00,$0c,$0b,$0c,$0b,$0c,$0b,$00,$00,$00,$00,$0b,$00,$01,$0b,$00,$00,$0b,$0b,$00,$0c,$0b,$00,$0b,$0b,$00,$0c,$0f,$00,$0b,$0c,$0f,$0b,$00,$00,$00
.byte $00,$00,$00,$00,$00,$0b,$00,$0c,$00,$0c,$0b,$00,$00,$00,$00,$0b,$00,$0b,$0b,$00,$00,$00,$0b,$00,$0b,$00,$00,$0b,$00,$00,$0b,$0c,$00,$0b,$00,$0c,$0b,$00,$00,$00
.byte $00,$00,$00,$0b,$00,$0b,$00,$0b,$00,$0c,$00,$00,$00,$00,$00,$00,$00,$0b,$0b,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$0b,$0b,$00,$00,$00,$0b,$00,$00,$00,$00

dead_col_4:
.byte $00,$00,$00,$00,$00,$00,$00,$0b,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$0b,$00,$00,$0b,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

draw_dead:
    ldx #$00

!draw_dead:
    lda dead_txt_0, x
    sta $0400, x
    lda dead_col_0, x
    sta $d800, x

    lda dead_txt_1, x
    sta $04c8, x
    lda dead_col_1, x
    sta $d8c8, x

    lda dead_txt_2, x
    sta $0590, x
    lda dead_col_2, x
    sta $d990, x

    lda dead_txt_3, x
    sta $0658, x
    lda dead_col_3, x
    sta $da58, x

    lda dead_txt_4, x
    sta $0720, x
    lda dead_col_4, x
    sta $db20, x

    inx
    cpx #$c8
    bne !draw_dead-
    rts
