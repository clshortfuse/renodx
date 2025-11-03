#include "../shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:45:00 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v1.xy).y;  // multiplying this increases the strength of lens dirt
  r0.y = t1.Sample(s1_s, v1.zw).y;  // multplying this increases the strength of radial lens flare

  if (CUSTOM_CLAMP_LENS_FLARE) {
    r0.xy = renodx::tonemap::ExponentialRollOff(r0.y, 0.f, 1.0f);
  }

  o0.w = saturate(r0.y + r0.x);
  r0.xyz = t2.Sample(s2_s, v2.xy).xyz;
  o0.xyz = r0.xyz;

  o0.w *= CUSTOM_LENS_FLARE_2;
  return;
}
