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
  o0.xyzw = v1.xyzw * r0.xyzw;
  if (RESOURCE_TAG == 36.f) {
    // o0.rgb = 2.f;
  }
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(o0.rgb);
  }
  o0.a = saturate(o0.a);
  return;
}