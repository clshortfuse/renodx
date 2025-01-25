#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[31];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.w * 2 + -1;
  r0.y = 1 + -abs(r0.x);
  r0.x = saturate(r0.x * 3.40282347e+38 + 0.5);
  r0.x = r0.x * 2 + -1;
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.yzw = r2.xyz * r1.xxx;
  o0.w = r2.w;
  if (injectedData.fxNoise > 0.f) {
    r0.gba = renodx::color::srgb::EncodeSafe(r0.gba);
    r0.gba = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r0.yzw;
    r0.gba = renodx::color::srgb::DecodeSafe(r0.gba);
  }
  o0.rgb = r0.gba;
  return;
}
