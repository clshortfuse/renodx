#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.zz;
  r0.x = t0.Sample(s0_s, r0.xy).y;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r1.xyzw = v0.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  return;
}