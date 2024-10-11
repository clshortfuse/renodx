// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:23 2024
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

SamplerState diffuseSampler_s : register(s0);
SamplerState displacementSampler_s : register(s1);
Texture2D<float4> diffuseTexture : register(t0);
Texture2D<float4> displacementTexture : register(t1);
Texture2D<float4> viewSpaceDepthTexture : register(t9);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : COLOR1,
  float2 v3 : TEXCOORD0,
  float2 w3 : TEXCOORD1,
  float v4 : TEXCOORD2,
  float w4 : TEXCOORD4,
  float4 v5 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = displacementTexture.Sample(displacementSampler_s, w3.xy).x;
  r0.x = -v4.x + r0.x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
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
  r1.xyzw = diffuseTexture.Sample(diffuseSampler_s, v3.xy).xyzw;
  r2.xyz = v1.xyz + r1.xyz;
  r2.w = v1.w * r1.w;
  r1.xyzw = v2.xyzw * r2.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  // o0.xyz = scaleLuminance(r1.xyz);
  return;
}