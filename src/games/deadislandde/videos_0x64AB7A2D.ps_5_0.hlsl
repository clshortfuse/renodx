#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v1.xy).x;
  r0.x = -0.5 + r0.x;
  r0.xy = float2(0.391000003,2.01799989) * r0.xx;
  r0.z = t0.Sample(s0_s, v1.xy).x;
  r0.z = -0.0625 + r0.z;
  r0.x = r0.z * 1.16400003 + -r0.x;
  r0.y = r0.z * 1.16400003 + r0.y;
  r1.z = log2(r0.y);
  r0.y = t2.Sample(s2_s, v1.xy).x;
  r0.y = -0.5 + r0.y;
  r0.x = -r0.y * 0.813000023 + r0.x;
  r0.y = 1.59599996 * r0.y;
  r0.y = r0.z * 1.16400003 + r0.y;
  r1.x = log2(r0.y);
  r1.y = log2(r0.x);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = cb0[0].xyz + -r0.xyz;
  o0.xyz = cb0[0].www * r1.xyz + r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    o0.xyz = saturate(o0.xyz);
  } else {
    o0.xyz = max(0.f, o0.xyz);
  }
  o0.xyz = PostToneMapScale(o0.xyz);
  o0.w = 1;
  return;
}