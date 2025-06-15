#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = v0.xyzw * r0.xyzw;
  r2.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = v0.xyz * r0.xyz + -r2.xxx;
  r1.xyz = cb0[20].zzz * r0.xyz + r2.xxx;
  r2.xyzw = cb0[0].xyzw + r1.xyzw;
  o0.xyzw = (r0.w > 0) ? r2.xyzw : r1.xyzw;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  return;
}