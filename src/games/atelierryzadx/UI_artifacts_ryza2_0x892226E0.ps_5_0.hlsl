#include "./common.hlsl"
// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 11:58:26 2025

cbuffer _Globals : register(b0)
{
  float2 vScreenInfo : packoffset(c0) = {0.00052083336,0.00092592591};
}

SamplerState __smpsEffect_s : register(s1);
Texture2D<float4> sScene : register(t0);
Texture2D<float4> sEffect : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.xy = floor(v0.xy);
  r0.xy = (int2)r1.xy;
  r1.xy = float2(0.5,0.5) + r1.xy;
  r1.xy = vScreenInfo.xy * r1.xy;
  r1.xyzw = sEffect.Sample(__smpsEffect_s, r1.xy).xyzw;
  r0.xyz = sScene.Load(r0.xyz).xyz;
  r0.xyz = r0.xyz * r1.www + r1.xyz;

  o0.w = 1;
  o0.rgb = renodx::math::SignPow(r0.rgb, 0.454545468);
  return;

  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = float3(2.49263,2.49263,2.49263) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}