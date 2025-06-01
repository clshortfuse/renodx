#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri May 30 01:01:38 2025

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    out float4 o0: SV_Target0) {
  o0.xyzw = v1.xyzw;

  if (CUSTOM_GODRAY_SHADER_DRAWN_COUNT || CUSTOM_LUTBUILDER_SHADER_DRAWN) {
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }

  return;
}
