#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:38 2025

cbuffer _Globals : register(b0)
{
  float4 f4StartColor : packoffset(c0);
  float4 f4EndColor : packoffset(c1);
  float fColorRate : packoffset(c2);
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = f4EndColor.xyzw + -f4StartColor.xyzw;
  r0.xyzw = fColorRate * r0.xyzw + f4StartColor.xyzw;
  r1.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  PostTmFxSampleScene(r1.xyz, true);

  o0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = 1;
  return;
}