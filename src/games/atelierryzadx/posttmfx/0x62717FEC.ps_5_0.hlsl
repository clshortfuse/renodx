#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:42 2025

cbuffer _Globals : register(b0)
{
  float4 ColorRate : packoffset(c0);
  float2 ColorRangeCenterUV : packoffset(c1);
  float2 EllipseUVAxisLength : packoffset(c1.z);
  float2 ColorGradationWidth : packoffset(c2);
  int IsInside : packoffset(c2.z);
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

  r0.xy = -ColorRangeCenterUV.xy + v1.xy;
  r0.zw = -ColorGradationWidth.xy + EllipseUVAxisLength.xy;
  r0.xyzw = r0.xyzw * r0.xyzw;
  r1.xy = r0.xy / r0.zw;
  r0.w = r1.x + r1.y;
  r0.w = cmp(r0.w < 1);
  if (r0.w != 0) {
    r0.w = IsInside ? ColorRate.w : 0;
  } else {
    r1.xy = EllipseUVAxisLength.xy * EllipseUVAxisLength.xy;
    r0.xyz = r0.xyz / r1.xyx;
    r0.x = r0.x + r0.y;
    r0.y = cmp(1 < r0.x);
    r1.y = IsInside ? 0 : ColorRate.w;
    r0.x = r0.x + -r0.z;
    r0.z = 1 + -r0.z;
    r0.x = r0.x / r0.z;
    r0.z = ColorRate.w * r0.x;
    r0.x = 1 + -r0.x;
    r0.x = ColorRate.w * r0.x;
    r0.x = IsInside ? r0.x : r0.z;
    r0.w = r0.y ? r1.y : r0.x;
  }
  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  PostTmFxSampleScene(r0.xyz, true);

  r1.xyz = ColorRate.xyz + -r0.xyz;

  //o0.xyz = saturate(r0.www * r1.xyz + r0.xyz);
  o0.xyz = r0.www * r1.xyz + r0.xyz;

  PostTmFxOutput(o0.xyz, true);

  o0.w = 1;
  return;
}