#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:47 2025

cbuffer _Globals : register(b0)
{
  float4 f4ColorRate : packoffset(c0);
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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  PostTmFxSampleScene(r0.xyz, true);

  r0.w = 1;
  o0.xyzw = f4ColorRate.xyzw * r0.xyzw;
  return;
}