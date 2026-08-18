#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 23:30:03 2026
// RenoDX UI white controlled version

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

float3 ApplyRenoDXUIWhite(float3 color)
{
  color = max(color, 0.0f);

  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return saturate(color);
  }

  float ui_scale = max(RENODX_GRAPHICS_WHITE_NITS, 1.0f) / 203.0f;

  return color * ui_scale;
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;

  r0.y = _texture_s0.Sample(_sampler_s0_s, v1.xy).y;
  r0.x = 1.0f;

  o0.xyzw = r0.xxxy * g_ConstColor.xyzw + g_ConstColorAdd.xyzw;

  o0.rgb = saturate(o0.rgb);

  return;
}