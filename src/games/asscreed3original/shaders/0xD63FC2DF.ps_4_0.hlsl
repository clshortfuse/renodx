// ---- Created with 3Dmigoto v1.3.16 on Tue May 12 20:15:43 2026

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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = v1.y * g_ScrRatVerOffDiaMulMinSat.x + g_ScrRatVerOffDiaMulMinSat.y;
  r0.x = v1.x;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = g_ScrRatVerOffDiaMulMinSat.z * r0.x;
  r0.x = log2(r0.x);
  r0.x = g_GodFacBriFacDisPowDisFac.z * r0.x;
  r0.x = exp2(r0.x);
  r0.yzw = g_Color.xyz + -r0.xxx;
  r0.yzw = -g_GodFacBriFacDisPowDisFac.yyy + r0.yzw;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r1.xy * r0.xx;
  r1.xy = r1.xy * g_GodFacBriFacDisPowDisFac.ww + v1.xy;
  r2.xyzw = s1.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = s0.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = r2.xyz + r0.yzw;
  o0.xyz = r1.xyz * g_GodFacBriFacDisPowDisFac.xxx + r0.xyz;
  o0.w = 1;
  return;
}