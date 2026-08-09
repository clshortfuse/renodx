#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = r0.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = r0.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb1[0].yyy * r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.xyz = r0.www + -r0.xyz;
  r0.w = 1 + -cb1[0].x;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  o0.xyz = cb1[0].zzz * r0.xyz;
  o0.w = 1;
  return;
}