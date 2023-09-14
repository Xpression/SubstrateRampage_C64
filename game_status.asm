player_health:  
    .byte 0
player_shield:
    .byte 0
status_txt:     
    .byte $53,$53,$53; .text "            score: 000             xx"
status_col:     
    .byte $02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$0b,$0b
shield_txt:     
    .text "shield: "
    .byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
    .byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0


init_status:
    lda #$03
    sta player_health

    ldx #$00
!init_status:
    lda status_txt, x
    sta $0400, x
    lda status_col, x
    sta $d800, x

    lda shield_txt, x
    sta $07c0, x
    lda #$00
    sta $dbc0, x

    inx
    cpx #$28
    bne !init_status-
    rts


dec_player_shield:
    ldx player_shield           // only decrease the shield counter
    cpx #$00                    // if it is non-zero to avoid any
    beq !upd_player_shield+     // glitch that could cause invuln
    dec player_shield
!upd_player_shield:
    rts


dec_player_health:
    ldx player_shield           // if the player has an active shield
    cpx #$00                    // then ignore the call to reduce the
    bne !dec_player_health+     // health of the player

    ldx player_health           // avoid decrement player health if it
    cpx #$00                    // is already at $00 to avoid any 
    beq !dec_player_health+     // glitch that can cause invuln

    dec player_health           // reduce the health of the player and
    lda #$28                    // give the player a short shield
    sta player_shield
!dec_player_health:
    rts


cmp_player_alive:
    lda player_health
    eor #$ff
    cmp #$00
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
    jsr draw_shield
    jsr draw_health
    jsr draw_frame
    rts


draw_shield:
    ldx #$00

    lda #$01
!draw_shield:
    cpx player_shield
    beq !draw_shield+
    sta $dbc0, x
    inx
    jmp !draw_shield-

!draw_shield:
    lda #$00
!draw_shield:
    sta $dbc0, x
    inx
    cpx #$28
    bne !draw_shield-
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
    cpx #$00
    beq !draw_health+++
    cpx #$01
    beq !draw_health++
    cpx #$02
    beq !draw_health+
    sta $d802
!draw_health:
    sta $d801
!draw_health:
    sta $d800
!draw_health:
    rts
