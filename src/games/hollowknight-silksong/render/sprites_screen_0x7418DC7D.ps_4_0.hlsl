#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 14:18:18 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyz = r0.xyz * v1.xyz + float3(-0.5, -0.5, -0.5);
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = -r1.xyz * float3(2, 2, 2) + float3(1, 1, 1);
  r2.xy = v3.xy / v3.ww;
  r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r1.xyz = r2.xyz / r1.xyz;
  r2.xyz = float3(1, 1, 1) + -r2.xyz;
  r3.xyz = r0.xyz + r0.xyz;
  r2.xyz = r2.xyz / r3.xyz;
  r2.xyz = float3(1, 1, 1) + -r2.xyz;
  r0.xyz = cmp(float3(0.5, 0.5, 0.5) < r0.xyz);
  o0.w = r0.w;
  o0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  o0.a = saturate(o0.a);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = lerp(max(0, o0.rgb), saturate(o0.rgb), CUSTOM_BLOOM_CLIP);
  }
  return;
}
