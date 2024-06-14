#include "../../shaders/color.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jun 13 16:15:39 2024
Texture2D<float4> t6 : register(t6);

SamplerState s11_s : register(s11);

cbuffer cb2 : register(b2)
{
  float4 cb2[14];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD4,
  float4 v3 : COLOR0,
  float4 v4 : COLOR1,
  float3 v5 : TEXCOORD1,
  uint v6 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t6.Sample(s11_s, v1.xy).xyzw;
  r1.xyzw = log2(r0.xyzw);
  r1.xyzw = float4(2.20000005,2.20000005,2.20000005,2.20000005) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r2.x = cmp(cb0[1].y == 0.000000);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r0.xyz = cb0[1].www * r0.xyz;
  r1.xyzw = cb2[13].wwww * r0.xyzw;
  r2.x = cmp(cb0[1].x != 0.000000);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  o0.w = cb0[1].z * r0.w;
  o0.xyz = saturate(r0.xyz);  //  o0.xyz = r0.xyz;

  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  
  return;
}