#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 14:11:13 2025
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
// 3Dmigoto declarations
#define cmp -
void main(
    float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = cmp(v0.yx < float2(0, 0));
  r0.zw = cmp(float2(1, 1) < v0.yx);
  r0.x = (int)r0.z | (int)r0.x;
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = (int)r0.w | (int)r0.x;
  if (r0.x != 0) {
    o0.xyzw = float4(0, 0, 0, 1);
    return;
  }
  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  // Removed saturate()
  o0.xyzw = r0.xyzw;

  return;
}
