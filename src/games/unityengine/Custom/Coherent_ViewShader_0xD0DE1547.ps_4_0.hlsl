#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy * float2(1,-1) + float2(0,1);
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  return;
}