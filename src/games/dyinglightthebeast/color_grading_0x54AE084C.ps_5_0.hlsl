#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Sep 20 01:06:20 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    linear noperspective float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.xyz = r1.xyz + r0.xyz;
  o0.w = r1.w;

  o0.rgb = GradingCorrectBlack(r0.rgb, o0.rgb, r1.rgb);

  o0.rgb = lerp(r0.rgb, o0.rgb, RENODX_COLOR_GRADE_STRENGTH);

  return;
}
