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

SamplerState colorSampler_s : register(s0);
SamplerState depthSampler_s : register(s1);
Texture2D<float4> colorTexture : register(t0);
Texture2D<float4> depthTexture : register(t1);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = colorTexture.Sample(colorSampler_s, v1.xy).xyz;
  r0.xyz = r0.xyz;
  r0.w = depthTexture.Sample(depthSampler_s, v1.xy).x;
  r0.w = r0.w;
  r1.x = cmp(r0.w < focalPlane);
  if (r1.x != 0) {
    r1.x = -r0.w;
    r1.x = focalPlane + r1.x;
    r1.x = nearRangeRev * r1.x;
    r1.x = max(0, r1.x);
    r1.w = min(1, r1.x);
  } else {
    r1.x = -focalPlane;
    r0.w = r1.x + r0.w;
    r0.w = farRangeRev * r0.w;
    r0.w = max(0, r0.w);
    r1.w = min(farBlurLimit, r0.w);
  }
  r0.xyz = r0.xyz;
  r1.w = r1.w;
  o0.xyz = r0.xyz;
  o0.w = r1.w;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
