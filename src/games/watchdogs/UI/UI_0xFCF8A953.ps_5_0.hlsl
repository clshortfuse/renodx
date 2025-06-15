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

  r0.x = t0.Sample(s0_s, v1.xy).y;
  r1.w = r0.x;
  r1.x = 1;
  r2.xyzw = v0.xyzw * r1.xxxw;
  r0.y = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyz = v0.xyz * r1.xxx + -r0.yyy;
  r2.xyz = cb0[20].zzz * r1.xyz + r0.yyy;
  r1.xyzw = cb0[1].xyzw * r2.xyzw;
  r2.xyzw = r2.xyzw * cb0[1].xyzw + cb0[0].xyzw;
  o0.xyzw = (r0.x > 0) ? r2.xyzw : r1.xyzw;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  return;
}