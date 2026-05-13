// ---- Created with 3Dmigoto v1.3.16 on Tue May 12 20:25:19 2026

cbuffer _Globals : register(b0)
{
  float2 g_ZoomFactor : packoffset(c0);
  float4 g_ScrRatVerOffDiaMulMinSat : packoffset(c1);
  float4 g_GodFacBriFacDisPowDisFac : packoffset(c2);
  float4 g_Color : packoffset(c3);
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);


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

  r0.xyzw = s0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * float3(10,10,10) + g_ScrRatVerOffDiaMulMinSat.www;
  r1.xyzw = s1.Sample(s1_s, v1.xy).xyzw;
  r0.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyz = r1.xyz + -r0.www;
  o0.xyz = r0.xyz * r1.xyz + r0.www;
  o0.w = 1;
  return;
}