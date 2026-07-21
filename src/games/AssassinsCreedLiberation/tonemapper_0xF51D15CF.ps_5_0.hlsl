#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 21:15:57 2026
// Fixed RenoDX exposure pass
//
// Fix:
//   This pass NO LONGER applies HDRDisplayMap / Psycho / PostTonemapSliders
//   in HDR modes.
//   It only applies exposure and forwards scene color to the later LUT/final
//   tonemap pass.
//
// Result:
//   Prevents double tonemapping.
//   The later LUT/final pass is now the only HDR tonemapper.

SamplerState _sampler_Scene_s : register(s0);
SamplerState _sampler_Exposure_s : register(s1);

Texture2D<float4> _texture_Scene : register(t0);
Texture2D<float4> _texture_Exposure : register(t1);

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV22
#define RENODX_TONE_MAP_TYPE_PSYCHOV22 22.0f
#endif

float3 EncodeSRGBSafeLocal(float3 color)
{
  color = max(color, 0.0f);

  float3 low = color * 12.92f;
  float3 high = pow(color, 1.0f / 2.4f) * 1.055f - 0.055f;

  float3 useHigh = step(float3(0.0031308f, 0.0031308f, 0.0031308f), color);
  return lerp(low, high, useHigh);
}

float3 GameACESFittedTonemap(float3 color)
{
  float3 aces;

  aces.x = dot(float3(0.597190022f, 0.354579985f, 0.0482299998f), color);
  aces.y = dot(float3(0.0759999976f, 0.908339977f, 0.0156599991f), color);
  aces.z = dot(float3(0.0284000002f, 0.133829996f, 0.837769985f), color);

  float3 numerator = aces * (aces + 0.0245785993f) - 0.0000905370034f;
  float3 denominator = aces * (aces * 0.983729005f + 0.432951003f) + 0.238080993f;

  float3 mapped = numerator / max(denominator, 0.000001f);

  float3 output;
  output.x = dot(float3(1.60475004f, -0.531080008f, -0.0736699998f), mapped);
  output.y = dot(float3(-0.102080002f, 1.10812998f, -0.00604999997f), mapped);
  output.z = dot(float3(-0.00326999999f, -0.0727600008f, 1.07602f), mapped);

  return saturate(output);
}

bool IsRenoDRTMode()
{
  return abs(RENODX_TONE_MAP_TYPE - renodx::draw::TONE_MAP_TYPE_RENO_DRT) < 0.5f;
}

bool IsPsychoV22Mode()
{
  return abs(RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_PSYCHOV22) < 0.5f;
}

bool IsCustomHDRMode()
{
  return IsRenoDRTMode() || IsPsychoV22Mode();
}

float3 SafeFinite3(float3 color)
{
  color = (color == color) ? color : 0.0f.xxx;
  return clamp(color, 0.0f.xxx, 65504.0f.xxx);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float3 sceneColor = _texture_Scene.Sample(_sampler_Scene_s, v1.xy).xyz;
  float exposure = _texture_Exposure.Sample(_sampler_Exposure_s, float2(0.0f, 0.0f)).x;

  sceneColor = SafeFinite3(sceneColor);
  exposure = (exposure == exposure) ? exposure : 1.0f;
  exposure = clamp(exposure, 0.0f, 65504.0f);

  sceneColor *= exposure;
  sceneColor = SafeFinite3(sceneColor);

  // Vanilla / SDR path:
  // Keep the original ACES fitted tonemap here because the next LUT pass expects
  // SDR gamma input when not using the custom HDR path.
  if (!IsCustomHDRMode())
  {
    float3 sdrColor = GameACESFittedTonemap(sceneColor);

    o0.rgb = EncodeSRGBSafeLocal(sdrColor);
    o0.a = 1.0f;
    return;
  }

  // HDR path:
  // Important: do NOT call PreTonemapSliders, HDRDisplayMap, PostTonemapSliders,
  // or film grain here.
  //
  // This pass only forwards exposure-applied scene color to the next pass.
  // The next LUT/final pass will do the actual RenoDX/PsychoV22 tonemap.
  o0.rgb = renodx::color::gamma::EncodeSafe(sceneColor);
  o0.a = 1.0f;
  return;
}