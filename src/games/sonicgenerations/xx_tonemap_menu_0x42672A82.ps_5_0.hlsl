#include "./shared.h"

cbuffer cbGlobalsPS : register(b0)
{
  float4 g_MtxInvProjection[4] : packoffset(c4);
  float4 g_MiddleGray_Scale_LuminanceLow_LuminanceHigh : packoffset(c150);
  float4 g_DepthOfFieldFocusNearFarRange : packoffset(c151);
  float4 g_dofLerpScaleBias[2] : packoffset(c152);
}

cbuffer cbGlobalsShared : register(b1)
{
  uint g_Booleans : packoffset(c0);
  uint g_Flags : packoffset(c0.y);
  float g_AlphaThreshold : packoffset(c0.z);
}

SamplerState s0_s_s : register(s0);
SamplerState s1_s_s : register(s1);
SamplerState s4_s_s : register(s4);
Texture2D<float4> s0 : register(t0); // render
Texture2D<float4> s1 : register(t1); // depth
Texture2D<float4> s4 : register(t4); // scenegray


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD8,
  float4 v10 : TEXCOORD9,
  float4 v11 : TEXCOORD10,
  float4 v12 : TEXCOORD11,
  float4 v13 : TEXCOORD12,
  float4 v14 : TEXCOORD13,
  float4 v15 : TEXCOORD14,
  float4 v16 : TEXCOORD15,
  float4 v17 : COLOR0,
  float4 v18 : COLOR1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float4 o3 : SV_Target3)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -g_DepthOfFieldFocusNearFarRange.w + g_DepthOfFieldFocusNearFarRange.x;
  r0.yz = g_MtxInvProjection[1].zw * v1.yy;
  r0.yz = v1.xx * g_MtxInvProjection[0].zw + r0.yz;
  r0.w = s1.Sample(s1_s_s, v2.xy).x;
  r0.yz = r0.ww * g_MtxInvProjection[2].zw + r0.yz;
  r0.yz = g_MtxInvProjection[3].zw + r0.yz;
  r0.z = 1 / r0.z;
  r0.z = min(3.40282347e+38, r0.z);
  r0.w = r0.z * r0.y;
  r0.x = max(-r0.w, r0.x);
  r1.x = r0.z * r0.y + r0.x;
  r0.x = -g_DepthOfFieldFocusNearFarRange.y + r0.x;
  r0.x = 1 / r0.x;
  r0.x = min(3.40282347e+38, r0.x);
  r0.x = saturate(r1.x * r0.x);
  r1.x = g_DepthOfFieldFocusNearFarRange.w + g_DepthOfFieldFocusNearFarRange.x;
  r0.w = min(r1.x, -r0.w);
  r1.x = r0.y * -r0.z + -r0.w;
  r0.y = r0.y * -r0.z + -g_DepthOfFieldFocusNearFarRange.x;
  r0.y = cmp(r0.y >= 0);
  r0.z = g_DepthOfFieldFocusNearFarRange.z + -r0.w;
  r0.z = 1 / r0.z;
  r0.z = min(3.40282347e+38, r0.z);
  r0.z = saturate(r0.z * r1.x);
  r0.x = r0.y ? r0.z : r0.x;
  r0.xyz = saturate(r0.xxx * g_dofLerpScaleBias[0].yzw + g_dofLerpScaleBias[1].yzw);
  r0.x = 1 + -r0.x;
  r0.x = min(r0.x, r0.y);
  r0.x = r0.z + r0.x;
  r0.y = -g_AlphaThreshold + r0.x;
  o0.w = r0.x;
  r0.x = cmp(r0.y < 0);
  r0.y = g_Flags & 1;
  r0.y = cmp((int)r0.y != 0);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) discard;
  r0.x = s4.Sample(s4_s_s, float2(0.5,0.5)).x;
  r0.x = 0.00100000005 + r0.x;
  r0.x = 1 / r0.x;
  r0.x = min(3.40282347e+38, r0.x);
  r0.x = g_MiddleGray_Scale_LuminanceLow_LuminanceHigh.x * r0.x;
  r0.yzw = s0.Sample(s0_s_s, v2.xy).xyz;

  o0.xyz = lerp(1.f, r0.xxx, injectedData.fxAutoExposure) * r0.yzw;

  return;
}