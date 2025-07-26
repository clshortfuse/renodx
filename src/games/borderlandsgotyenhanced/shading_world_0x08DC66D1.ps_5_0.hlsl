#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Jul 24 18:12:23 2025

cbuffer _Globals : register(b0)
{
  float4 HFilterDiagCoeff : packoffset(c0);
  float4 HFilterAxisCoeff : packoffset(c1);
  float4 VFilterDiagCoeff : packoffset(c2);
  float4 VFilterAxisCoeff : packoffset(c3);
  float4 MiscParameters : packoffset(c4);
  float4 RenderTargetSize : packoffset(c5);
  float4 DiagOffsetAB : packoffset(c6);
  float4 DiagOffsetCD : packoffset(c7);
  float4 AxisOffsetAB : packoffset(c8);
  float4 AxisOffsetCD : packoffset(c9);
}

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float4 DynamicScale : packoffset(c2);
}

SamplerState SceneDepthTextureSampler_s : register(s0);
Texture2D<float4> SceneDepthTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float2 v4 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (shader_injection.cell_shading == 0) {
    discard;
  } else {
  r0.x = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v2.xy).x;
  r0.x = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.x = max(1.00000001e-07, r0.x);
  r0.x = 1 / r0.x;
  r1.x = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v2.zw).x;
  r1.x = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = max(1.00000001e-07, r1.x);
  r0.y = 1 / r1.x;
  r1.x = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v3.xy).x;
  r1.x = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = max(1.00000001e-07, r1.x);
  r0.z = 1 / r1.x;
  r1.x = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v3.zw).x;
  r1.x = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = max(1.00000001e-07, r1.x);
  r0.w = 1 / r1.x;
  r1.x = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v4.xy).x;
  r1.x = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = max(1.00000001e-07, r1.x);
  r1.x = 1 / r1.x;
  r0.xyzw = max(r1.xxxx, r0.xyzw);
  r0.xyzw = r0.xyzw + -r1.xxxx;
  r0.xyzw = r0.xyzw / r1.xxxx;
  r2.xyzw = VFilterAxisCoeff.xyzw * r0.xyzw;
  r0.xyzw = HFilterAxisCoeff.xyzw * r0.xyzw;
  r1.y = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v0.xy).x;
  r1.y = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = max(1.00000001e-07, r1.y);
  r3.x = 1 / r1.y;
  r1.y = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v0.zw).x;
  r1.y = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = max(1.00000001e-07, r1.y);
  r3.y = 1 / r1.y;
  r1.y = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v1.xy).x;
  r1.y = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = max(1.00000001e-07, r1.y);
  r3.z = 1 / r1.y;
  r1.y = SceneDepthTexture.Sample(SceneDepthTextureSampler_s, v1.zw).x;
  r1.y = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = max(1.00000001e-07, r1.y);
  r3.w = 1 / r1.y;
  r3.xyzw = max(r3.xyzw, r1.xxxx);
  r3.xyzw = r3.xyzw + -r1.xxxx;
  r1.xyzw = r3.xyzw / r1.xxxx;
  r2.xyzw = r1.xyzw * VFilterDiagCoeff.xyzw + r2.xyzw;
  r0.xyzw = r1.xyzw * HFilterDiagCoeff.xyzw + r0.xyzw;
  r0.x = dot(r0.xyzw, float4(1,1,1,1));
  r0.y = dot(r2.xyzw, float4(1,1,1,1));
  r0.y = r0.y * r0.y;
  r0.x = r0.x * r0.x + r0.y;
  r0.x = sqrt(r0.x);
  r0.x = min(1, r0.x);
  r0.x = max(9.99999975e-05, r0.x);
  r0.x = log2(r0.x);
  r0.x = MiscParameters.z * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.xyz = max(float3(0,0,0), r0.xxx);
  r0.w = cmp(0.956862748 < r0.z);
  o0.xyz = r0.xyz;
  o0.w = r0.w ? 0 : 1;
  }
  return;
}