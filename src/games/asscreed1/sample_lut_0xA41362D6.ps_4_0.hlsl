#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:49 2025

cbuffer SCB_CommonPostEffect : register(b9) {
  float3 g_PreLutScale : packoffset(c0);
  float3 g_PreLutOffset : packoffset(c1);
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
Texture2D<float4> texture0 : register(t0);
Texture3D<float4> texture1 : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  o0.w = 0;

  float3 untonemapped = texture0.Sample(s0_s, v1.xy).rgb;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = lerp(saturate(untonemapped), texture1.Sample(s1_s, untonemapped * g_PreLutScale.xyz + g_PreLutOffset.xyz).rgb, RENODX_COLOR_GRADE_STRENGTH);
  } else {
    untonemapped = renodx::color::gamma::Decode(max(0, untonemapped), 2.2f);
    float3 tonemapped_sdr = ToneMapMaxCLL(untonemapped, 0.5f, 1.f, 100.f);
    float3 graded_sdr = renodx::color::gamma::Decode(
        texture1.Sample(s1_s, renodx::color::gamma::Encode(tonemapped_sdr, 2.2f) * g_PreLutScale.xyz + g_PreLutOffset.xyz).rgb,
        2.2f);

    float3 upgraded = renodx::tonemap::UpgradeToneMap(untonemapped, tonemapped_sdr, graded_sdr, RENODX_COLOR_GRADE_STRENGTH);

    o0.xyz = renodx::color::gamma::EncodeSafe(upgraded, 2.2f);
  }

  o0.rgb = ToneMapAndRenderIntermediatePass(o0.rgb, v1.xy);

  return;
}
