#include "./p5r.h"

cbuffer GFD_PSCONST_HDR : register(b11) {
  float middleGray : packoffset(c0);
  float adaptedLum : packoffset(c0.y);
  float bloomScale : packoffset(c0.z);
  float starScale : packoffset(c0.w);
  float3 gradeColor : packoffset(c1);
  float elapsedTime : packoffset(c1.w);
  float threshold : packoffset(c2);
  float exposure1 : packoffset(c2.y);
  float exposure2 : packoffset(c2.z);
  float interpolate : packoffset(c2.w);
  float paramA : packoffset(c3);
  float paramB : packoffset(c3.y);
  float paramCB : packoffset(c3.z);
  float paramDE : packoffset(c3.w);
  float paramDF : packoffset(c4);
  float paramEperF : packoffset(c4.y);
  float paramF_White : packoffset(c4.z);
}

SamplerState opaueSampler_s : register(s0);
SamplerState bloomSampler_s : register(s1);
SamplerState starSampler_s : register(s2);
Texture2D<float4> opaueTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> starTexture : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
                float2 v1 : TEXCOORD0,
                            out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 hdrColor, sdrColor;

  r0.xyz = bloomTexture.Sample(bloomSampler_s, v1.xy).xyz;
  r1.xyz = starTexture.Sample(starSampler_s, v1.xy).xyz;
  r2.xyz = opaueTexture.Sample(opaueSampler_s, v1.xy).xyz;
  r4.w = 1;

  hdrColor = r2.xyz;
  sdrColor = saturate(hdrColor);

  r3.xyz = gradeColor.xyz * r2.xyz;
  r3.xyz = exposure2 * r3.xyz;
  r5.xyz = paramA * r3.xyz;
  r5.xyz = paramCB + r5.xyz;
  r5.xyz = r5.xyz * r3.xyz;
  r5.xyz = paramDE + r5.xyz;
  r6.xyz = paramA * r3.xyz;
  r6.xyz = paramB + r6.xyz;
  r3.xyz = r6.xyz * r3.xyz;
  r3.xyz = paramDF + r3.xyz;
  r3.xyz = r5.xyz / r3.xyz;
  r5.xyz = -paramEperF;
  r3.xyz = r5.xyz + r3.xyz;
  r3.xyz = r3.xyz / paramF_White;
  r3.xyz = max(float3(0, 0, 0), r3.xyz);
  r3.xyz = min(float3(1, 1, 1), r3.xyz);
  r5.xyz = -r2.xyz;
  r3.xyz = r5.xyz + r3.xyz;
  r3.xyz = interpolate * r3.xyz;
  r2.xyz = r3.xyz + r2.xyz;

  r1.xyz = starScale * r1.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = bloomScale * r0.xyz;
  r4.xyz = r1.xyz + r0.xyz;
  o0.xyzw = r4.xyzw;

  float3 lutColor = r4.xyz;
  o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, lutColor, 1.f);
  o0.rgb = max(0, o0.rgb);

  return;
}