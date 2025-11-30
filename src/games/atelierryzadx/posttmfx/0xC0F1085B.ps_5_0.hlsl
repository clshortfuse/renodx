#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:48 2025

cbuffer _Globals : register(b0)
{
  float4 f4ColorRate : packoffset(c0);
}

SamplerState smplScene_s : register(s0);
SamplerState smplCapture_s : register(s1);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplCapture_Tex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  PostTmFxSampleScene(r0.xyz, true);

  r0.w = 1;
  r1.xyzw = f4ColorRate.xyzw * r0.xyzw;
  r0.x = -r0.w * f4ColorRate.w + 1;
  r1.xyzw = r1.xyzw * r1.wwww;
  r2.xyzw = smplCapture_Tex.Sample(smplCapture_s, v1.xy).xyzw;
  o0.xyzw = r2.xyzw * r0.xxxx + r1.xyzw;
  return;
}