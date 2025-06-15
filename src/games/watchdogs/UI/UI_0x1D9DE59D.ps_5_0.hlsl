#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[21];
}
cbuffer cb0 : register(b0){
  float4 cb0[39];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb1[3].xy + cb0[35].xy;
  r0.xy = -r0.xy * float2(0.5,0.5) + v2.xy;
  r0.xy = cb1[3].zw * r0.xy;
  r0.x = t1.Sample(s1_s, r0.xy).w;
  if (r0.x >= 0.1) discard;
  r0.y = t0.Sample(s0_s, v1.xy).y;
  r0.x = 1;
  r1.xyzw = v0.xyzw * r0.xxxy;
  r0.y = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xzw = v0.xyz * r0.xxx + -r0.yyy;
  r0.xyz = cb1[20].zzz * r0.xzw + r0.yyy;
  r1.xyz = cb0[38].www * r0.xyz;
  o0.xyzw = cb1[1].xyzw * r1.xyzw;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  return;
}