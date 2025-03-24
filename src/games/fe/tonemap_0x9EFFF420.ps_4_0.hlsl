#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r0.x = cb0[8].y / r0.x;
  r0.x = min(cb0[8].w, r0.x);
  r0.x = max(cb0[8].z, r0.x);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.zxy);
  o0.w = r1.w;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = cb0[3].xxx * r0.xyz;
  float3 untonemapped = r0.gbr;
  r0.rgb = applyUserTonemap(untonemapped, t2, s1_s, cb0[6].xyz);
  o0.xyz = renodx::color::srgb::EncodeSafe(r0.rgb);
  return;
}