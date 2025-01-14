#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 11 03:31:50 2025

cbuffer CB_PS_PostWaves : register(b7) {
  float4 cWaveTerms : packoffset(c0);
  float4 cWaveClamp : packoffset(c1);
}

SamplerState sSceneTexPoint_s : register(s0);
SamplerState sWaveOffset_s : register(s1);
Texture2D<float4> sWaveOffset : register(t0);
Texture2D<float4> sSceneTexPoint : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;

  r0.y = dot(v1.zw, cWaveClamp.zw);
  r0.x = 0.5;
  r0.x = sWaveOffset.Sample(sWaveOffset_s, r0.xy).x;
  r0.x = r0.x * 2 + -1;
  r0.xy = r0.xx * cWaveTerms.xx + v1.zw;
  r0.xy = max(float2(0, 0), r0.xy);
  r0.xy = min(cWaveClamp.xx, r0.xy);
  r0.zw = v1.zw + -r0.xy;
  r0.xy = cWaveClamp.zw * r0.zw + r0.xy;
  o0.xyzw = sSceneTexPoint.Sample(sSceneTexPoint_s, r0.xy).xyzw;

  if (RENODX_TONE_MAP_SONAR && RENODX_TONE_MAP_TYPE == 2.f) {
    o0.rgb = renodx::tonemap::frostbite::BT709(o0.rgb, 1.f);
  } else if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(o0.rgb);
  }

  return;
}
