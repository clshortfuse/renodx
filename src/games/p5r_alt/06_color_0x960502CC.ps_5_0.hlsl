#include "./shared.h"

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float4 clearColor : packoffset(c0);
  float2 resolution : packoffset(c1);
  float2 resolutionRev : packoffset(c1.z);
}

SamplerState t_color_sampler_s : register(s0);
SamplerState t_weight_sampler_s : register(s1);
Texture2D<float4> t_color : register(t0);
Texture2D<float4> t_weight : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy;
  r1.xyzw = v2.xyzw;
  r0.z = 0;
  r2.xz = t_weight.SampleLevel(t_weight_sampler_s, r0.xy, r0.z).xz;
  r2.xz = r2.xz;
  r0.z = 0;
  r2.y = t_weight.SampleLevel(t_weight_sampler_s, r1.zw, r0.z).y;
  r2.y = r2.y;
  r0.z = 0;
  r2.w = t_weight.SampleLevel(t_weight_sampler_s, r1.xy, r0.z).w;
  r2.w = r2.w;
  r0.z = dot(r2.xyzw, float4(1, 1, 1, 1));
  r0.z = cmp(r0.z < 9.99999975e-06);
  if (r0.z != 0) {
    r0.z = 0;
    r1.xyzw = t_color.SampleLevel(t_color_sampler_s, r0.xy, r0.z).xyzw;
  } else {
    r0.z = cmp(r2.z < r2.w);
    r0.w = -r2.z;
    r3.x = r0.z ? r2.w : r0.w;
    r0.z = cmp(r2.x < r2.y);
    r0.w = -r2.x;
    r3.y = r0.z ? r2.y : r0.w;
    r0.z = -r3.x;
    r0.z = max(r3.x, r0.z);
    r0.w = -r3.y;
    r0.w = max(r3.y, r0.w);
    r0.z = cmp(r0.w < r0.z);
    if (r0.z != 0) {
      r3.y = 0;
    } else {
      r3.x = 0;
    }
    r0.zw = resolutionRev.xy * r3.xy;
    r0.xy = r0.xy + r0.zw;
    r0.z = 0;
    r1.xyzw = t_color.SampleLevel(t_color_sampler_s, r0.xy, r0.z).xyzw;
  }
  o0.xyzw = r1.xyzw;
  switch (injectedData.uiState) {
    default:
    case UI_STATE__NONE:
      break;
    case UI_STATE__MIN_ALPHA:
      o0.a = 1.f;
      break;
    case UI_STATE__MAX_ALPHA:
      o0.a = 0.f;
      break;
  }
  return;
}
