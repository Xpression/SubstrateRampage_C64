player_health:  
    .byte 0
status_txt:     
    .byte $53,$53,$53; .text "            score: 000             xx"
status_col:     
    .byte $02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$0b,$0b


init_status:
    lda #$03
    sta player_health

    ldx #$00
!init_status:
    lda status_txt, x
    sta $0400, x
    lda status_col, x
    sta $d800, x
    inx
    cpx #$28
    bne !init_status-
    rts


inc_score:
    inc $0418           // increment first digit
    lda $0418           // read new digit back
    cmp #$3a            // compare to petscii after '9'
    bne !inc_score+     // if no overflow, jump to return

    lda #$30            // we overflowed, so load '0'
    sta $0418           // and store in first digit

    inc $0417           // increment second digit
    lda $0417           // read new digit back
    cmp #$3a            // compare to petscii after '9'
    bne !inc_score+     // if no overflow, jump to return

    lda #$30            // we overflowed, so load '0'
    sta $0417           // and store in second digit

    inc $0416           // increment third digit
    lda $0416           // read new digit back
    cmp #$3a            // compare to petscii after '9'
    bne !inc_score+     // if no overflow, jump to return

    lda #$30            // we overflowed, so load '0'
    sta $0416           // and store in second digit
!inc_score:
    rts


draw_status:
    jsr draw_health
    jsr draw_frame
    rts

draw_frame:
    lda #$0b
    sta $d826
    sta $d827

    lda frame_hi
    sta $0426
    lda frame_lo
    sta $0427
    rts

draw_health:
    lda #$0b // set all hearts to gray
    sta $d800
    sta $d801
    sta $d802
    
    lda #$02 // recolor available life
    ldx player_health
    cpx #$01
    beq !draw_health++
    cpx #$02
    beq !draw_health+
    sta $d802
!draw_health:
    sta $d801
!draw_health:
    sta $d800
    rts
