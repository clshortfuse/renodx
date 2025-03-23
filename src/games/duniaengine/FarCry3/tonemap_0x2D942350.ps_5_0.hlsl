#include "../common.hlsl"

Texture3D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[40];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s1_s, v2.xy).xyz;
  r1.xyz = t1.Sample(s2_s, v1.zw).xyz;
  r0.xyz = r1.xyz * cb0[38].xxx * injectedData.fxBloom + r0.xyz;
  r0.rgb = applyUserTonemapFC3(r0.rgb, t2, s0_s);
  r0.rgb = renodx::math::SignSqrt(r0.rgb);
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r2.xyz = float3(1,1,1) + -cb0[39].xyz;
  r1.xyz = -r1.xyz * r2.xyz + float3(1,1,1);
  r2.xyz = cb0[39].xyz * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0.5,0.5,0.5));
  r0.xyz = r0.xyz ? float3(1,1,1) : 0;
  r1.xyz = -r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  o0.w = renodx::color::y::from::BT709(r0.rgb);
  o0.xyz = PostToneMapScale(r0.rgb);
  return;
}