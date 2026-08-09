#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = float3(1.59375,0.390625,1.984375) * r1.yxx;
  r0.y = r0.w * 1.15625 + -r0.y;
  r0.xz = r0.ww * float2(1.15625,1.15625) + r0.xz;
  r2.xz = float2(-0.872539997,-1.06861997) + r0.xz;
  r0.x = -r1.y * 0.8125 + r0.y;
  r2.y = 0.531369984 + r0.x;
  r0.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  o0.xyz = max(0.f, o0.xyz);
  return;
}