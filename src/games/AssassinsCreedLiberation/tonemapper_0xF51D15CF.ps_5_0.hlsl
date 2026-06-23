#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 21:15:57 2026
// RenoDX exposure / tonemap replacement
// SDR path: original ACES fitted tonemap.
// HDR path: RenoDX HDR tonemap with SDR low/mid-grey preservation.

SamplerState _sampler_Scene_s : register(s0);
SamplerState _sampler_Exposure_s : register(s1);

Texture2D<float4> _texture_Scene : register(t0);
Texture2D<float4> _texture_Exposure : register(t1);

#ifndef RENODX_APPLY_FILM_GRAIN_IN_TONEMAPPER
#define RENODX_APPLY_FILM_GRAIN_IN_TONEMAPPER 1
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

float3 RestoreSDRLowMidGreys(float3 hdrColor, float3 sdrReference)
{
#if RENODX_HDR_SDR_MID_GREY_RESTORE
  hdrColor = max(hdrColor, 0.0f);
  sdrReference = max(sdrReference, 0.0f);

  float hdrY = renodx::color::y::from::BT709(hdrColor);
  float sdrY = renodx::color::y::from::BT709(sdrReference);

  if (hdrY <= 0.000001f || sdrY <= 0.000001f)
  {
    return hdrColor;
  }

  float midMask = 1.0f - smoothstep(
    RENODX_HDR_SDR_MID_GREY_START,
    RENODX_HDR_SDR_MID_GREY_END,
    sdrY
  );

  float blackMask = 1.0f - smoothstep(0.0f, 0.08f, sdrY);

  float strength = saturate(RENODX_HDR_SDR_MID_GREY_STRENGTH);
  strength += blackMask * saturate(RENODX_HDR_SDR_BLACK_EXTRA_STRENGTH);
  strength = saturate(strength);

  float amount = midMask * strength;

  float targetY = min(hdrY, sdrY);
  float restoredY = lerp(hdrY, targetY, amount);

  float maxDarkenY = hdrY * (1.0f - saturate(RENODX_HDR_SDR_MID_GREY_MAX_DARKEN) * amount);
  restoredY = max(restoredY, maxDarkenY);

  hdrColor *= restoredY / max(hdrY, 0.000001f);

  return max(hdrColor, 0.0f);
#else
  return hdrColor;
#endif
}

float3 ApplyRenoDXSceneTonemapNoUIPass(float3 sceneColor, float2 coords)
{
  sceneColor = max(sceneColor, 0.0f);

  float3 sdrReference = GameACESFittedTonemap(sceneColor);

  sceneColor = PreTonemapSliders(sceneColor);

  float3 hdrColor = HDRDisplayMap(sceneColor);

  hdrColor = RestoreSDRLowMidGreys(
    hdrColor,
    sdrReference
  );

  hdrColor = PostTonemapSliders(hdrColor);

#if RENODX_APPLY_FILM_GRAIN_IN_TONEMAPPER
  hdrColor = renodx::effects::ApplyFilmGrain(
    hdrColor,
    coords,
    CUSTOM_RANDOM,
    CUSTOM_FILM_GRAIN_STRENGTH * 0.03f
  );
#endif

  return renodx::color::gamma::EncodeSafe(max(hdrColor, 0.0f));
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float3 sceneColor = _texture_Scene.Sample(_sampler_Scene_s, v1.xy).xyz;
  float exposure = _texture_Exposure.Sample(_sampler_Exposure_s, float2(0.0f, 0.0f)).x;

  sceneColor = max(sceneColor, 0.0f) * exposure;

  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    float3 sdrColor = GameACESFittedTonemap(sceneColor);

    o0.rgb = EncodeSRGBSafeLocal(sdrColor);
    o0.a = 1.0f;
    return;
  }

  o0.rgb = ApplyRenoDXSceneTonemapNoUIPass(sceneColor, v1.xy);
  o0.a = 1.0f;
  return;
}