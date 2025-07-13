#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Thu Apr 24 13:09:31 2025

cbuffer _Globals : register(b0)
{
  float4 g_TAA : packoffset(c0);
  float4 trackgenHeightScaleOffset : packoffset(c1);
  float4x4 prevRelativeViewProj : packoffset(c2);
  float3 prevEyePos : packoffset(c6);
  float4 TLightDepthArrayIDim : packoffset(c7);
  float3 DiffuseColour : packoffset(c8);
  float Alpha : packoffset(c8.w);
  float4 Phong : packoffset(c9);
  float4 _uiDirection1 : packoffset(c10);
  float4 _uiColour1 : packoffset(c11);
  float4 _uiDirection2 : packoffset(c12);
  float4 _uiColour2 : packoffset(c13);
  float4 _uiAmbient : packoffset(c14);
  float4 _GlobalParams1 : packoffset(c15);
  float4 colorParams : packoffset(c16);
}

cbuffer RenderTargetConstantBuffer : register(b2)
{
  float4 viewportDimensions : packoffset(c0);
  float4 msaaParams : packoffset(c1);
}

SamplerState TDiffuseMapSampler_s : register(s0);
Texture2D<float4> TDiffuseMap : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  linear centroid float4 v1 : TEXCOORD0,
  linear centroid float4 v2 : TEXCOORD1,
  linear centroid float4 v3 : TEXCOORD2,
  float3 v4 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -9.99999975e-006 + v3.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  TDiffuseMap.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.x = r0.x / r0.y;
  r0.y = viewportDimensions.x / viewportDimensions.y;
  r0.z = r0.y / r0.x;
  r0.x = r0.x / r0.y;
  r0.xy = min(float2(1,1), r0.xz);
  r0.z = 1 + -r0.y;
  r0.z = 0.5 * r0.z;
  r1.x = v1.w * r0.y + r0.z;
  r0.y = 1 + -r0.x;
  r0.y = 0.5 * r0.y;
  r1.y = v2.w * r0.x + r0.y;
  r0.xyz = TDiffuseMap.Sample(TDiffuseMapSampler_s, r1.xy).xyz;
  r0.xyz = v3.xyz * r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = colorParams.xxx * r0.xyz;
  // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  r0.rgb = renodx::color::gamma::EncodeSafe(r0.rgb);
  o0.rgb = max(0, r0.rgb);
  o0.w = v3.w;
  return;
}