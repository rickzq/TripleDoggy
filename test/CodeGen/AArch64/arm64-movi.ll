; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-eabi | FileCheck %s

;==--------------------------------------------------------------------------==
; Tests for MOV-immediate implemented with ORR-immediate.
;==--------------------------------------------------------------------------==

; 64-bit immed with 32-bit pattern size, rotated by 0.
define i64 @test64_32_rot0() nounwind {
; CHECK-LABEL: test64_32_rot0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #30064771079
; CHECK-NEXT:    ret
  ret i64 30064771079
}

; 64-bit immed with 32-bit pattern size, rotated by 2.
define i64 @test64_32_rot2() nounwind {
; CHECK-LABEL: test64_32_rot2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-4611686002321260541
; CHECK-NEXT:    ret
  ret i64 13835058071388291075
}

; 64-bit immed with 4-bit pattern size, rotated by 3.
define i64 @test64_4_rot3() nounwind {
; CHECK-LABEL: test64_4_rot3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-1229782938247303442
; CHECK-NEXT:    ret
  ret i64 17216961135462248174
}

; 64-bit immed with 64-bit pattern size, many bits.
define i64 @test64_64_manybits() nounwind {
; CHECK-LABEL: test64_64_manybits:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #4503599627304960
; CHECK-NEXT:    ret
  ret i64 4503599627304960
}

; 64-bit immed with 64-bit pattern size, one bit.
; FIXME: Prefer movz, so it prints as "mov".
define i64 @test64_64_onebit() nounwind {
; CHECK-LABEL: test64_64_onebit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr x0, xzr, #0x4000000000
; CHECK-NEXT:    ret
  ret i64 274877906944
}

; 32-bit immed with 32-bit pattern size, rotated by 16.
; FIXME: Prefer "movz" instead (so we print as "mov").
define i32 @test32_32_rot16() nounwind {
; CHECK-LABEL: test32_32_rot16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w0, wzr, #0xff0000
; CHECK-NEXT:    ret
  ret i32 16711680
}

; 32-bit immed with 2-bit pattern size, rotated by 1.
define i32 @test32_2_rot1() nounwind {
; CHECK-LABEL: test32_2_rot1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #-1431655766
; CHECK-NEXT:    ret
  ret i32 2863311530
}

;==--------------------------------------------------------------------------==
; Tests for MOVZ with MOVK.
;==--------------------------------------------------------------------------==

define i32 @movz() nounwind {
; CHECK-LABEL: movz:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #5
; CHECK-NEXT:    ret
  ret i32 5
}

define i64 @movz_3movk() nounwind {
; CHECK-LABEL: movz_3movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #22136
; CHECK-NEXT:    movk x0, #43981, lsl #16
; CHECK-NEXT:    movk x0, #4660, lsl #32
; CHECK-NEXT:    movk x0, #5, lsl #48
; CHECK-NEXT:    ret
  ret i64 1427392313513592
}

define i64 @movz_movk_skip1() nounwind {
; CHECK-LABEL: movz_movk_skip1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1126236160
; CHECK-NEXT:    movk x0, #5, lsl #32
; CHECK-NEXT:    ret
  ret i64 22601072640
}

define i64 @movz_skip1_movk() nounwind {
; CHECK-LABEL: movz_skip1_movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #4660
; CHECK-NEXT:    movk x0, #34388, lsl #32
; CHECK-NEXT:    ret
  ret i64 147695335379508
}

; FIXME: Prefer "mov w0, #2863311530; lsl x0, x0, #4"
; or "mov x0, #-6148914691236517206; and x0, x0, #45812984480"
define i64 @orr_lsl_pattern() nounwind {
; CHECK-LABEL: orr_lsl_pattern:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #43680
; CHECK-NEXT:    movk x0, #43690, lsl #16
; CHECK-NEXT:    movk x0, #10, lsl #32
; CHECK-NEXT:    ret
  ret i64 45812984480
}

; FIXME: prefer "mov x0, #-16639; lsl x0, x0, #24"
define i64 @mvn_lsl_pattern() nounwind {
; CHECK-LABEL: mvn_lsl_pattern:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #16777216
; CHECK-NEXT:    movk x0, #65471, lsl #32
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
  ret i64 -279156097024
}

; FIXME: prefer "mov w0, #-63; movk x0, #31, lsl #32"
; or "mov x0, #137438887936; movk x0, #65473"
define i64 @mvn32_pattern() nounwind {
; CHECK-LABEL: mvn32_pattern:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #65473
; CHECK-NEXT:    movk x0, #65535, lsl #16
; CHECK-NEXT:    movk x0, #31, lsl #32
; CHECK-NEXT:    ret
  ret i64 137438953409
}

; FIXME: prefer "mov w0, #-63; movk x0, #17, lsl #32"
define i64 @mvn32_pattern_2() nounwind {
; CHECK-LABEL: mvn32_pattern_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #65473
; CHECK-NEXT:    movk x0, #65535, lsl #16
; CHECK-NEXT:    movk x0, #17, lsl #32
; CHECK-NEXT:    ret
  ret i64 77309411265
}

;==--------------------------------------------------------------------------==
; Tests for MOVN with MOVK.
;==--------------------------------------------------------------------------==

define i64 @movn() nounwind {
; CHECK-LABEL: movn:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-42
; CHECK-NEXT:    ret
  ret i64 -42
}

define i64 @movn_skip1_movk() nounwind {
; CHECK-LABEL: movn_skip1_movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-60876
; CHECK-NEXT:    movk x0, #65494, lsl #32
; CHECK-NEXT:    ret
  ret i64 -176093720012
}

;==--------------------------------------------------------------------------==
; Tests for ORR with MOVK.
;==--------------------------------------------------------------------------==
; rdar://14987673

define i64 @orr_movk1() nounwind {
; CHECK-LABEL: orr_movk1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 72056498262245120
}

define i64 @orr_movk2() nounwind {
; CHECK-LABEL: orr_movk2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982650836746496
}

define i64 @orr_movk3() nounwind {
; CHECK-LABEL: orr_movk3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #32
; CHECK-NEXT:    ret
  ret i64 72020953688702720
}

define i64 @orr_movk4() nounwind {
; CHECK-LABEL: orr_movk4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    ret
  ret i64 72056494543068845
}

; rdar://14987618
define i64 @orr_movk5() nounwind {
; CHECK-LABEL: orr_movk5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 -71777214836900096
}

define i64 @orr_movk6() nounwind {
; CHECK-LABEL: orr_movk6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982647117578496
}

define i64 @orr_movk7() nounwind {
; CHECK-LABEL: orr_movk7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982646575268096
}

define i64 @orr_movk8() nounwind {
; CHECK-LABEL: orr_movk8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982646575276371
}

; rdar://14987715
define i64 @orr_movk9() nounwind {
; CHECK-LABEL: orr_movk9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1152921435887370240
; CHECK-NEXT:    movk x0, #65280
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 1152921439623315200
}

define i64 @orr_movk10() nounwind {
; CHECK-LABEL: orr_movk10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1152921504606846720
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 1152921504047824640
}

define i64 @orr_movk11() nounwind {
; CHECK-LABEL: orr_movk11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-4503599627370241
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    movk x0, #65535, lsl #32
; CHECK-NEXT:    ret
  ret i64 -4222125209747201
}

define i64 @orr_movk12() nounwind {
; CHECK-LABEL: orr_movk12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-4503599627370241
; CHECK-NEXT:    movk x0, #57005, lsl #32
; CHECK-NEXT:    ret
  ret i64 -4258765016661761
}

define i64 @orr_movk13() nounwind {
; CHECK-LABEL: orr_movk13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #17592169267200
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2401245434149282131
}

; rdar://13944082
define i64 @g() nounwind {
; CHECK-LABEL: g:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x0, #2
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
entry:
  ret i64 -281474976710654
}

; FIXME: prefer "mov x0, #-549755813888; movk x0, 2048, lsl #16"
define i64 @orr_movk14() nounwind {
; CHECK-LABEL: orr_movk14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #134217728
; CHECK-NEXT:    movk x0, #65408, lsl #32
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
  ret i64 -549621596160
}

; FIXME: prefer "mov x0, #549755813887; movk x0, #63487, lsl #16"
define i64 @orr_movk15() nounwind {
; CHECK-LABEL: orr_movk15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #65535
; CHECK-NEXT:    movk x0, #63487, lsl #16
; CHECK-NEXT:    movk x0, #127, lsl #32
; CHECK-NEXT:    ret
  ret i64 549621596159
}

; FIXME: prefer "mov x0, #2147483646; orr x0, x0, #36028659580010496"
define i64 @orr_movk16() nounwind {
; CHECK-LABEL: orr_movk16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #36028659580010496
; CHECK-NEXT:    movk x0, #65534
; CHECK-NEXT:    movk x0, #32767, lsl #16
; CHECK-NEXT:    ret
  ret i64 36028661727494142
}

; FIXME: prefer "mov x0, #-1099511627776; movk x0, #65280, lsl #16"
define i64 @orr_movk17() nounwind {
; CHECK-LABEL: orr_movk17:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #0
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
  ret i64 -1095233437696
}

; FIXME: prefer "mov x0, #72340172838076673; and x0, x0, #2199023255296"
define i64 @orr_movk18() nounwind {
; CHECK-LABEL: orr_movk18:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72340172838076673
; CHECK-NEXT:    movk x0, #256
; CHECK-NEXT:    movk x0, #0, lsl #48
; CHECK-NEXT:    ret
  ret i64 1103823438080
}
