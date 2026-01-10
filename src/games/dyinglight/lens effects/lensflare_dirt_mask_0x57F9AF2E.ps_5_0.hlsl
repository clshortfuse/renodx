#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:44:37 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.zw * v1.zw;
  r0.xy = -r0.xy * r0.xy + float2(1, 1);
  r0.x = r0.x * r0.y;
  r0.y = cmp(r0.x < 0);
  if (r0.y != 0) discard;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  if (CUSTOM_CLAMP_LENS_FLARE) {
    r1.rgb = renodx::tonemap::ExponentialRollOff(r1.rgb, 1.f, 4.f);
  }

  r0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;
  o0.xyz = cb0[0].xyz * r0.xyz;
  return;
}
