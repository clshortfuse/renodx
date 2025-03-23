#include "../common.hlsl"

Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[39];
}

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
  r1.xyzw = t1.Sample(s3_s, v2.xy).xyzw;
  r0.xyz = r1.www * r0.xyz + r1.xyz;
  r1.xyz = t2.Sample(s2_s, v1.zw).xyz;
  r0.xyz = r1.xyz * cb0[38].xxx * injectedData.fxBloom + r0.xyz;
  r0.rgb = applyUserTonemapFC3(r0.rgb, t3, s0_s);
  o0.w = renodx::color::y::from::BT709(r0.rgb);
  o0.xyz = PostToneMapScale(r0.xyz);
  return;
}