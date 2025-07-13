#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jun  1 17:08:53 2025

cbuffer CopyToDestConsts : register(b7)
{
  float4 g_xMulAddConsts : packoffset(c0);
  float4 g_xGamma : packoffset(c1);
}

SamplerState g_xFilteredClamp_s : register(s5);
Texture2D<float4> g_xSourceTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * g_xMulAddConsts.xy + g_xMulAddConsts.zw;
  r0.xyz = g_xSourceTexture.Sample(g_xFilteredClamp_s, r0.xy).xyz;
  
  //r0.xyz = log2(abs(r0.xyz));
  //r0.xyz = g_xGamma.xxx * r0.xyz;
  //o0.xyz = exp2(r0.xyz);

  o0.rgb = r0.rgb;
  
  o0.w = 1;
  return;
}