#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / cb0[3].zz;
  r0.xyzw = t2.Sample(s3_s, r0.xy).xyzw;
  r0.x = saturate(r0.x);
  r0.y = 1 + -r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = saturate(r1.xyz);
  }
  r1.w = saturate(r1.w);
  r2.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r0.z = dot(r2.xxx, float3(0.219999999,0.707000017,0.0710000023));
  r0.w = dot(r2.yyy, float3(0.219999999,0.707000017,0.0710000023));
  r0.x = r0.w < r0.z ? r0.y : r0.x;
  r0.y = 1 / cb0[4].y;
  r0.z = -0.5 + r2.z;
  r0.z = cb0[4].y * 0.5 + r0.z;
  r0.y = saturate(r0.y * r0.z);
  r0.x = r0.x < r0.y ? r2.y : r2.x;
  r0.y = 0;
  r0.xyzw = t3.Sample(s2_s, r0.xy).xyzw;
  r0.xyzw = r0.xyzw + -r1.xyzw;
  o0.xyzw = cb0[4].xxxx * r0.xyzw + r1.xyzw;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}