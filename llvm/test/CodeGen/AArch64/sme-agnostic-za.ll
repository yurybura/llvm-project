; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mattr=+sme2 < %s | FileCheck %s

target triple = "aarch64"

declare i64 @private_za_decl(i64)
declare i64 @agnostic_decl(i64) "aarch64_za_state_agnostic"

; No calls. Test that no buffer is allocated.
define i64 @agnostic_caller_no_callees(ptr %ptr) nounwind "aarch64_za_state_agnostic" {
; CHECK-LABEL: agnostic_caller_no_callees:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x0, [x0]
; CHECK-NEXT:    ret
  %v = load i64, ptr %ptr
  ret i64 %v
}

; agnostic-ZA -> private-ZA
;
; Test that a buffer is allocated and that the appropriate save/restore calls are
; inserted for calls to non-agnostic functions and that the arg/result registers are
; preserved by the register allocator.
define i64 @agnostic_caller_private_za_callee(i64 %v) nounwind "aarch64_za_state_agnostic" {
; CHECK-LABEL: agnostic_caller_private_za_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-32]! // 16-byte Folded Spill
; CHECK-NEXT:    str x19, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    mov x8, x0
; CHECK-NEXT:    bl __arm_sme_state_size
; CHECK-NEXT:    sub sp, sp, x0
; CHECK-NEXT:    mov x19, sp
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    bl __arm_sme_save
; CHECK-NEXT:    mov x0, x8
; CHECK-NEXT:    bl private_za_decl
; CHECK-NEXT:    mov x1, x0
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    bl __arm_sme_restore
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    bl __arm_sme_save
; CHECK-NEXT:    mov x0, x1
; CHECK-NEXT:    bl private_za_decl
; CHECK-NEXT:    mov x1, x0
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    bl __arm_sme_restore
; CHECK-NEXT:    mov x0, x1
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldr x19, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    ldp x29, x30, [sp], #32 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %res = call i64 @private_za_decl(i64 %v)
  %res2 = call i64 @private_za_decl(i64 %res)
  ret i64 %res2
}

; agnostic-ZA -> agnostic-ZA
;
; Should not result in save/restore code.
define i64 @agnostic_caller_agnostic_callee(i64 %v) nounwind "aarch64_za_state_agnostic" {
; CHECK-LABEL: agnostic_caller_agnostic_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    bl agnostic_decl
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %res = call i64 @agnostic_decl(i64 %v)
  ret i64 %res
}

; shared-ZA -> agnostic-ZA
;
; Should not result in lazy-save or save of ZT0
define i64 @shared_caller_agnostic_callee(i64 %v) nounwind "aarch64_inout_za" "aarch64_inout_zt0" {
; CHECK-LABEL: shared_caller_agnostic_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    bl agnostic_decl
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %res = call i64 @agnostic_decl(i64 %v)
  ret i64 %res
}
