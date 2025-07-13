#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jun  1 22:25:15 2025

cbuffer GammaConsts : register(b1)
{
  float g_fGamma : packoffset(c0);
}

SamplerState g_xTrilinearWrap_s : register(s4);
Texture2D<float4> g_xTexture : register(t0);


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

  r0.xyz = g_xTexture.Sample(g_xTrilinearWrap_s, v1.xy).xyz;
  
  o0.rgb = r0.rgb;
  return;
  
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = g_fGamma * r0.xyz;
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = r0.xyz * float3(12.9200001,12.9200001,12.9200001) + -r1.xyz;
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? float3(1,1,1) : 0;
  o0.xyz = r0.xyz * r2.xyz + r1.xyz;
  o0.w = 1;
  return;
}