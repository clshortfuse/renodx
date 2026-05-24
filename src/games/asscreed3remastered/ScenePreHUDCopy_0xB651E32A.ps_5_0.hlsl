// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:22 2026

#include "./common.hlsli"

SamplerState s0_s : register(s0);
Texture2D<float4> s0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = s0.Sample(s0_s, v1.xy).xyzw;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.xyz = ApplyAC3RChromaticAberrationEncoded(o0.xyz, v1.xy, s0, s0_s);
  }

  return;
}
