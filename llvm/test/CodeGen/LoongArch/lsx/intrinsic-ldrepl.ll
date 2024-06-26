; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lsx < %s | FileCheck %s

declare <16 x i8> @llvm.loongarch.lsx.vldrepl.b(ptr, i32)

define <16 x i8> @lsx_vldrepl_b(ptr %p, i32 %b) nounwind {
; CHECK-LABEL: lsx_vldrepl_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vldrepl.b $vr0, $a0, 1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i8> @llvm.loongarch.lsx.vldrepl.b(ptr %p, i32 1)
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.loongarch.lsx.vldrepl.h(ptr, i32)

define <8 x i16> @lsx_vldrepl_h(ptr %p, i32 %b) nounwind {
; CHECK-LABEL: lsx_vldrepl_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vldrepl.h $vr0, $a0, 2
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i16> @llvm.loongarch.lsx.vldrepl.h(ptr %p, i32 2)
  ret <8 x i16> %res
}

declare <4 x i32> @llvm.loongarch.lsx.vldrepl.w(ptr, i32)

define <4 x i32> @lsx_vldrepl_w(ptr %p, i32 %b) nounwind {
; CHECK-LABEL: lsx_vldrepl_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vldrepl.w $vr0, $a0, 4
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i32> @llvm.loongarch.lsx.vldrepl.w(ptr %p, i32 4)
  ret <4 x i32> %res
}

declare <2 x i64> @llvm.loongarch.lsx.vldrepl.d(ptr, i32)

define <2 x i64> @lsx_vldrepl_d(ptr %p, i32 %b) nounwind {
; CHECK-LABEL: lsx_vldrepl_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vldrepl.d $vr0, $a0, 8
; CHECK-NEXT:    ret
entry:
  %res = call <2 x i64> @llvm.loongarch.lsx.vldrepl.d(ptr %p, i32 8)
  ret <2 x i64> %res
}
