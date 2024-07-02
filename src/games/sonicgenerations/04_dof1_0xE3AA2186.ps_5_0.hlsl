#include "./shared.h"


cbuffer cbGlobalsPS : register(b0)
{
  float4 g_CameraNearFarAspect : packoffset(c25);
  float4 g_Param2 : packoffset(c168);
  float4 g_Param3 : packoffset(c169);
}

cbuffer cbGlobalsShared : register(b1)
{
  uint g_Booleans : packoffset(c0);
  uint g_Flags : packoffset(c0.y);
  float g_AlphaThreshold : packoffset(c0.z);
}

SamplerState g_Source_s_s : register(s0);
SamplerState g_SourceLow_s_s : register(s1);
SamplerState s2_s_s : register(s2);
SamplerState s3_s_s : register(s3);
Texture2D<float4> g_Source : register(t0); // render
Texture2D<float4> g_SourceLow : register(t1); // dof
Texture2D<float4> s2 : register(t2);  // dof low
Texture2D<float4> s3 : register(t3);  // bloom


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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_Flags & 1;
  r0.x = cmp((int)r0.x != 0);
  r0.y = 1 + -g_AlphaThreshold;
  r0.y = cmp(r0.y < 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) discard;
  r0.x = 1 / g_CameraNearFarAspect.z;
  r0.x = min(3.40282347e+38, r0.x);
  r1.xy = g_Param2.xy + -v1.xy;
  r1.z = r1.y * r0.x;
  r0.x = dot(r1.xz, r1.xz);
  r0.x = sqrt(r0.x);
  r0.x = 1 / r0.x;
  r0.x = min(3.40282347e+38, r0.x);
  r0.yz = r0.xx * r1.xz;
  r0.x = 1 / r0.x;
  r0.x = min(3.40282347e+38, r0.x);
  r0.x = -g_Param2.w + r0.x;
  r0.w = 1 / g_Param3.x;
  r0.w = min(3.40282347e+38, r0.w);
  r0.x = r0.w * r0.x;
  r0.x = max(-1, r0.x);
  r0.w = -1 + r0.x;
  r0.x = 1.57079637 * r0.x;
  r0.x = cos(r0.x);
  r0.w = cmp(r0.w >= 0);
  r0.x = r0.w ? -4.37113883e-08 : r0.x;
  r0.yz = r0.yz * r0.xx;
  r0.x = r0.x * g_Param3.w + 1;
  r0.yz = r0.yz * g_Param3.yy + v1.xy;
  r1.xyzw = g_SourceLow.Sample(g_SourceLow_s_s, r0.yz).xyzw;
  r0.yzw = g_Source.Sample(g_Source_s_s, r0.yz).xyz;
  r2.x = -0.996078432 + r1.w;
  r2.x = r2.x * -255 + 1;
  r2.y = 0.996078432 + -r1.w;
  r2.y = cmp(r2.y >= 0);
  r1.w = r2.y ? r1.w : r2.x;
  r1.xyz = r1.xyz + -r0.yzw;
  r1.w = g_Param3.z * r1.w;
  r0.yzw = r1.www * r1.xyz * injectedData.fxDoF + r0.yzw;
  r1.xyzw = s2.Sample(s2_s_s, v1.xy).xyzw;
  r1.xyz = r1.xyz + -r0.yzw;
  r0.yzw = r1.www * r1.xyz * injectedData.fxDoF + r0.yzw;
  r1.xyz = s3.Sample(s3_s_s, v1.xy).xyz;
  o0.xyz = r0.yzw * r0.xxx + r1.xyz * injectedData.fxBloom;



  o0.w = 1;
  return;
}