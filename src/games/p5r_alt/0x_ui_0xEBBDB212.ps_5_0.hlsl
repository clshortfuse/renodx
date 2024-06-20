#include "./shared.h"

cbuffer GFD_PSCONST_DOF : register(b12) {
  float focalPlane : packoffset(c0);
  float nearBlurPlane : packoffset(c0.y);
  float farBlurPlane : packoffset(c0.z);
  float farBlurLimit : packoffset(c0.w);
  float nearRangeRev : packoffset(c1);
  float farRangeRev : packoffset(c1.y);
  float blurScale : packoffset(c1.z);
}

cbuffer GFD_PSCONST_SAMPLE_OFFSETS : register(b13) {
  float4 sampleOffsets[16] : packoffset(c0);
  float4 sampleWeights[16] : packoffset(c16);
}

SamplerState sampler0_s : register(s0);
SamplerState sampler1_s : register(s1);
Texture2D<float4> texture0 : register(t0);
Texture2D<float4> texture1 : register(t1);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, r2, r3, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texture1.Sample(sampler1_s, v1.xy).xyzw;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[0].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[0].xyz * r1.xyz;
  r1.xyz = r1.xyz;
  r2.xy = v1.xy;
  r2.zw = sampleOffsets[1].xy;
  r3.xy = r2.xy + r2.zw;
  r1.w = texture1.Sample(sampler1_s, r3.xy).w;
  r1.w = blurScale * r1.w;
  r2.zw = r2.zw * r1.ww;
  r2.xy = r2.xy + r2.zw;
  r2.xyz = texture0.Sample(sampler0_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = sampleWeights[1].xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xy = v1.xy;
  r2.zw = sampleOffsets[2].xy;
  r3.xy = r2.xy + r2.zw;
  r1.w = texture1.Sample(sampler1_s, r3.xy).w;
  r1.w = blurScale * r1.w;
  r2.zw = r2.zw * r1.ww;
  r2.xy = r2.xy + r2.zw;
  r2.xyz = texture0.Sample(sampler0_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = sampleWeights[2].xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xy = v1.xy;
  r2.zw = sampleOffsets[3].xy;
  r3.xy = r2.xy + r2.zw;
  r1.w = texture1.Sample(sampler1_s, r3.xy).w;
  r1.w = blurScale * r1.w;
  r2.zw = r2.zw * r1.ww;
  r2.xy = r2.xy + r2.zw;
  r2.xyz = texture0.Sample(sampler0_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = sampleWeights[3].xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xy = v1.xy;
  r2.zw = sampleOffsets[4].xy;
  r3.xy = r2.xy + r2.zw;
  r1.w = texture1.Sample(sampler1_s, r3.xy).w;
  r1.w = blurScale * r1.w;
  r2.zw = r2.zw * r1.ww;
  r2.xy = r2.xy + r2.zw;
  r2.xyz = texture0.Sample(sampler0_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = sampleWeights[4].xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xy = v1.xy;
  r2.zw = sampleOffsets[5].xy;
  r3.xy = r2.xy + r2.zw;
  r1.w = texture1.Sample(sampler1_s, r3.xy).w;
  r1.w = blurScale * r1.w;
  r2.zw = r2.zw * r1.ww;
  r2.xy = r2.xy + r2.zw;
  r2.xyz = texture0.Sample(sampler0_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = sampleWeights[5].xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r0.xyz;
  r0.xyz = sampleWeights[6].xyz * r0.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[7].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[7].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[8].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[8].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[9].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[9].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[10].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[10].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[11].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[11].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.zw = sampleOffsets[12].xy;
  r2.xy = r1.xy + r1.zw;
  r2.x = texture1.Sample(sampler1_s, r2.xy).w;
  r2.x = blurScale * r2.x;
  r1.zw = r2.xx * r1.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyz = texture0.Sample(sampler0_s, r1.xy).xyz;
  r1.xyz = r1.xyz;
  r1.xyz = sampleWeights[12].xyz * r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.w = r0.w;
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
