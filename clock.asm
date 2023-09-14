wait_frames_hi:
    lda frame_hi
    ldx frame_lo
    adc wait_frames
!wait_frames_hi:
    cmp frame_hi
    bne !wait_frames_hi-
!wait_frames_hi:
    cpx frame_lo
    bne !wait_frames_hi-
    rts


wait_frames_lo:
    lda frame_lo
    adc wait_frames
!wait_frames_lo:
    cmp frame_lo
    bne !wait_frames_lo-
    rts
