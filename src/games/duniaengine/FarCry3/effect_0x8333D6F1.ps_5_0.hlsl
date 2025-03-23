#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(1 >= cb0[6].z);
  r0.x = r0.x ? 1.000000 : 0;
  r0.yz = saturate(v1.xy);
  r1.xy = v1.xy + -r0.yz;
  r0.xy = r0.xx * r1.xy + r0.yz;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyz = cb0[5].xyz * r0.xyz;
  r1.w = saturate(cb0[5].w * r0.w + cb0[8].x);
  r0.xyzw = float4(-1,-1,-1,-1) + r1.xyzw;
  r0.xyzw = r1.wwww * r0.xyzw + float4(1,1,1,1);
  r1.xyzw = t1.Sample(s1_s, v1.zw).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}