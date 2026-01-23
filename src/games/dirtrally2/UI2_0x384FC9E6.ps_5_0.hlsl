#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Thu Apr 24 13:51:15 2025

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

  r0.x = v1.w;
  r0.y = v2.w;
  r0.xyzw = TDiffuseMap.Sample(TDiffuseMapSampler_s, r0.xy).xyzw;
  r1.x = v3.w * r0.w + -9.99999975e-006;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xyz = v3.xyz * v3.www;
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = v3.w * r0.w;
  o0.w = r0.w;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = colorParams.xxx * r0.xyz;
  // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  // r0.rgb = renodx::color::gamma::EncodeSafe(r0.rgb, 1.f);
  o0.rgb = max(0, r0.rgb);
  return;
}