#include "./shared.h"

SamplerState PointSampler_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : UV0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(PointSampler_s, v2.xy).xyzw;
  // o0.xyzw = v1.xyzw * r0.xyzw;

  if (RESOURCE_TAG == MAIN_RESOURCE_TAG) {
    o0 = v1 * r0;
    o0 = 0;
  } else {
    o0 = lerp(v1 * r0, saturate(saturate(v1) * saturate(r0)), CUSTOM_BLOOM_FIX);
  }
  return;
}