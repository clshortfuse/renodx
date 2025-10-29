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

  float3 input = texture0.Sample(s0_s, v1.xy).rgb;

  // LUT offsets and grading are combined, so we separate them
  // game always uses 16x16x16 LUTs
  float3 untonemapped_gamma = (((input * g_PreLutScale.xyz + g_PreLutOffset.xyz) - 0.03125) / 0.9375);

  float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = texture1.Sample(s1_s, untonemapped_gamma * 0.9375 + 0.03125).rgb;
    o0.rgb = renodx::color::gamma::DecodeSafe(max(0, o0.rgb));
    o0.rgb = lerp(saturate(untonemapped), o0.rgb, RENODX_COLOR_GRADE_STRENGTH);
    o0.rgb = renodx::color::gamma::EncodeSafe(max(0, o0.rgb));
  } else {
    
    renodx::lut::Config lut_config = CreateLUTConfig(s1_s);
    const float scale = ComputeReinhardSmoothClampScale(untonemapped, 0.7f, 1.f, 40.f);

    const float3 color_hdr = untonemapped;
    const float3 color_sdr = color_hdr * scale;
    const float3 color_sdr_graded = Sample(texture1, lut_config, color_sdr);

    float3 color_final = color_sdr_graded / scale;

    o0.xyz = renodx::color::gamma::EncodeSafe(color_final, 2.2f);
  }

  o0.rgb = ToneMapAndRenderIntermediatePass(o0.rgb, v1.xy);

  return;
}
