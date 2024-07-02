#include "./p5r.h"

cbuffer GFD_PSCONST_HDR : register(b11) {
  float middleGray : packoffset(c0);
  float adaptedLum : packoffset(c0.y);
  float bloomScale : packoffset(c0.z);
  float starScale : packoffset(c0.w);
}

SamplerState opaueSampler_s : register(s0);
SamplerState bloomSampler_s : register(s1);
SamplerState starSampler_s : register(s2);
Texture2D<float4> opaueTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> starTexture : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 hdrColor, sdrColor;

  r0.xyz = bloomTexture.Sample(bloomSampler_s, v1.xy).xyz;
  r1.xyz = starTexture.Sample(starSampler_s, v1.xy).xyz;
  r2.xyz = opaueTexture.Sample(opaueSampler_s, v1.xy).xyz;
  r3.w = 1;

  hdrColor = r2.xyz;
  sdrColor = saturate(hdrColor);

  r1.xyz = starScale * r1.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = bloomScale * r0.xyz;
  r3.xyz = r1.xyz + r0.xyz;
  o0.xyzw = r3.xyzw;

  float3 lutColor = r3.xyz;
  o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, lutColor, 1.f);
  o0.rgb = max(0, o0.rgb);

  return;
}