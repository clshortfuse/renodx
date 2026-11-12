#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 23:30:03 2026
// Generic texture/UI shader - no UI white scale

#ifndef RENODX_GRAPHICS_WHITE_NITS
#define RENODX_GRAPHICS_WHITE_NITS 203.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE
#define RENODX_TONE_MAP_TYPE 1.0f
#endif

cbuffer _Globals : register(b0)
{
  float4 g_ConstColor : packoffset(c128);
  float4 g_ConstColorAdd : packoffset(c129);
  float4 g_TextBlurWeights : packoffset(c12);
  float4x4 g_WorldViewProj : packoffset(c0);
  float4x4 g_WorldView : packoffset(c4);
  float4x4 g_World : packoffset(c8);
  float4x4 g_Proj : packoffset(c84);
}

SamplerState _sampler_s0_s : register(s0);
Texture2D<float4> _texture_s0 : register(t0);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;

  r0.xyzw = _texture_s0.Sample(_sampler_s0_s, v1.xy).xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw * g_ConstColor.xyzw + g_ConstColorAdd.xyzw;

  r0.xyzw = saturate(r0.xyzw);
  o0.xyzw = r0.xyzw;
  return;
}