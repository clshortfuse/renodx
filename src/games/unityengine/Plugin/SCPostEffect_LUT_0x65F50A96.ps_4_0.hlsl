#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[32];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyzw = r0.xyzw * float4(-2,-2,-2,-2) + float4(1,1,1,1);
  r0.xyzw = cb0[31].xxxx * r1.xyzw + r0.xyzw;
  r1.xyz = handleUserLUT(r0.xyz, t1, s1_s, cb0[29].xyz, 0, true);
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = cb0[29].www * r1.xyz + r0.xyz;
  o0.w = r0.w;
  return;
}