#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Thu Apr 24 13:23:22 2025

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
  float GaussBlurWidth : packoffset(c15);
  float GaussBlurHeight : packoffset(c15.y);
  float4 _GlobalParams1 : packoffset(c16);
  float4 colorParams : packoffset(c17);
}

cbuffer RenderTargetConstantBuffer : register(b2)
{
  float4 viewportDimensions : packoffset(c0);
  float4 msaaParams : packoffset(c1);
}

SamplerState TGaussBlurSourceSampler_s : register(s0);
Texture2D<float4> TGaussBlurSource : register(t0);
Texture2D<float4> TGaussBlurKernel : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  linear centroid float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  linear centroid float4 v3 : TEXCOORD2,
  float3 v4 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  TGaussBlurSource.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = viewportDimensions.xy / viewportDimensions.yx;
  r1.xy = r0.xy / r0.yx;
  r0.zw = r0.zw / r1.xy;
  r0.zw = min(float2(1,1), r0.zw);
  r0.zw = v1.xy * r0.zw + float2(1,1);
  r0.z = 0.5 * r0.z;
  r0.w = -r0.w * 0.5 + 1;
  r1.xy = float2(GaussBlurWidth, GaussBlurHeight) / r0.xy;
  r2.xy = r1.xy * r0.zw;
  r0.y = 1 / r0.y;
  r1.yzw = float3(0,0,0);
  r0.x = 0;
  r3.xyz = float3(0,0,0);
  r1.x = 0;
  while (true) {
    r0.z = cmp((int)r1.x >= 9);
    if (r0.z != 0) break;
    r0.zw = TGaussBlurKernel.Load(r1.xyz).xy;
    r2.zw = r0.ww * r0.xy + r2.xy;
    r4.xyz = TGaussBlurSource.Sample(TGaussBlurSourceSampler_s, r2.zw).xyz;
    r2.zw = -r0.ww * r0.xy + r2.xy;
    r5.xyz = TGaussBlurSource.Sample(TGaussBlurSourceSampler_s, r2.zw).xyz;
    r4.xyz = r5.xyz + r4.xyz;
    r3.xyz = r0.zzz * r4.xyz + r3.xyz;
    r1.x = (int)r1.x + 1;
  }
  r0.x = -9.99999975e-006 + v3.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  // r0.xyz = log2(r3.xyz);
  // r0.xyz = colorParams.xxx * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  // o0.rgb = renodx::color::gamma::DecodeSafe(r3.xyz, 1.f);
  o0.rgb = r3.xyz;
  o0.w = v3.w;
  return;
}