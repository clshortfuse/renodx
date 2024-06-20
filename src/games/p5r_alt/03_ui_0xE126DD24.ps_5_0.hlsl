#include "./shared.h"
#include "../../shaders/color.hlsl"

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, out float4 o0 : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyzw;
  o0.xyzw = r0.xyzw;
  // o0 = saturate(o0);
  switch (injectedData.uiState) {
    default:
    case UI_STATE__NONE:
      break;
    case UI_STATE__MIN_ALPHA:
      o0.a = 1.f;
      break;
    case UI_STATE__MAX_ALPHA:
      o0.a = 0.f;
      break;
  }
  // o0 = float4(1,0,1,0);
  return;
}
