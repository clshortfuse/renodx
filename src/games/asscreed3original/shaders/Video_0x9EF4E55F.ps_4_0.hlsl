// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 18:56:48 2026

cbuffer _Globals : register(b0)
{
  float4x4 g_WorldViewProj : packoffset(c0);
  float4 tor : packoffset(c4);
  float4 tog : packoffset(c5);
  float4 tob : packoffset(c6);
  float4 g_BinkConsts : packoffset(c7);
}

SamplerState tex0_s : register(s0);
Texture2D<float4> tex0 : register(t0);


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

  r0.xyzw = tex0.Sample(tex0_s, v1.xy).xyzw;
  o0.xyz = r0.zyx;
  o0.w = g_BinkConsts.w;
  return;
}