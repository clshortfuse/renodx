#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 14:18:19 2025
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
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v1.w * -2 + 1;
  r0.yz = v3.xy / v3.ww;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.x = r1.z * r0.x + v1.w;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.x = saturate(r2.w * r0.x + r1.y);
  r0.yzw = v1.xyz * r2.xyz;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = r0.x;

  o0.a = saturate(o0.a);
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = lerp(max(0, o0.rgb), saturate(o0.rgb), CUSTOM_BLOOM_CLIP);
  }
  return;
}
