#include "./UI.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 16 00:55:41 2026

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: COLOR0,
    out float4 o0: SV_Target0) {
  o0.xyzw = v1.xyzw;

  o0 = FinalizeUI(o0);
  return;
}
