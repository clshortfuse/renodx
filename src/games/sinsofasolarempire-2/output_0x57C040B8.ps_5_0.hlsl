// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 21:56:27 2025

#include "./shared.h"

Texture2D<float3> ColorTex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float3 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // linear to sRGB gamma encoding conversion.

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = ColorTex.Load(r0.xyz).xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(r0.xyz < float3(0.00313080009,0.00313080009,0.00313080009));
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  o0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  return;
}