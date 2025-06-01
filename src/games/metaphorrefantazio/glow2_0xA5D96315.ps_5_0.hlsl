// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:26 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer GFD_PSCONST_SYSTEM : register(b0)
{
  float2 resolution : packoffset(c0);
  float2 resolutionRev : packoffset(c0.z);
  float4x4 mtxView : packoffset(c1);
  float4x4 mtxInvView : packoffset(c5);
  float4x4 mtxProj : packoffset(c9);
  float4x4 mtxInvProj : packoffset(c13);
  float4 invProjParams : packoffset(c17);
}

SamplerState baseSampler_s : register(s0);
Texture2D<float4> baseTexture : register(t0);
Texture2D<float4> viewSpaceDepthTexture : register(t9);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : BINORMAL0,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float2 v4 : TEXCOORD0,
  float w4 : TEXCOORD3,
  float4 v5 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 untonemapped;
  
  r0.xy = v5.xy / v5.ww;
  r0.xy = float2(1,1) + r0.xy;
  r0.x = resolution.x * r0.x;
  r0.y = -r0.y * 0.5 + 1;
  r1.y = resolution.y * r0.y;
  r1.x = 0.5 * r0.x;
  r0.xy = (int2)r1.xy;
  r0.zw = float2(0,0);
  r0.x = viewSpaceDepthTexture.Load(r0.xyz).x;
  r0.x = -w4.x + r0.x;
  r0.x = saturate(0.0149999997 * r0.x);
  r1.xyzw = baseTexture.Sample(baseSampler_s, v4.xy).xyzw;
  /* r0.yzw = log2(abs(r1.xyz)); */
  r1.w = v2.w * r1.w;
  /* r0.yzw = float3(2.20000005,2.20000005,2.20000005) * r0.yzw;
  r0.yzw = exp2(r0.yzw); */

  r0.yzw = renodx::color::gamma::Decode(r1.rgb);

  r1.xyz = v2.xyz + r0.yzw;
  r1.xyzw = v3.xyzw * r1.xyzw;
  r0.x = r1.w * r0.x + 0.000500000024;
  o0.xyz = r1.xyz;
  o0.w = min(1, r0.x);
  return;
}