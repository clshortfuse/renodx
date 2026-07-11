#include "./shared.h"

// Order = Lutbuilder -> Godray -> PostEffect

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 NeutralSDRYOrMaxCH(float3 linear_color) {
  [branch]
  if (DEBUG_MAX_CH == 0.f) {  // Y TM
    return saturate(renodx::tonemap::renodrt::NeutralSDR((linear_color)));
  } else {  // Max CH
    return saturate(linear_color * ComputeReinhardSmoothClampScale(linear_color, 0.5f));
  }
}

// Lutbuilder Start

float3 UpgradeToneMapAP1(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
  if (GODRAY_EXIST != 0.f || POSTFX_EXIST != 0.f) {
    return renodx::draw::ComputeUntonemappedGraded(untonemapped_bt709, tonemapped_bt709, NeutralSDRYOrMaxCH(untonemapped_bt709));
    // return float3(1, 1, 1);
  } else {
    return renodx::draw::ToneMapPass(untonemapped_bt709, tonemapped_bt709, NeutralSDRYOrMaxCH(untonemapped_bt709));
    // return float3(1, 0, 1);
  }
}

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 color = UpgradeToneMapAP1(untonemapped_ap1, tonemapped_bt709);
  color = renodx::draw::RenderIntermediatePass(color);
  color *= 1.f / 1.05f;
  return float4(color, 1);
}

// Lutbuilder end

float3 ToGamma(float3 color) {
  [branch]
  if (RENODX_TONE_MAP_TYPE) {
    float3 input_color = color;
    float3 linear_color = renodx::draw::InvertIntermediatePass(input_color);
    // float3 sdr_color = saturate(renodx::tonemap::renodrt::NeutralSDR((linear_color)));
    float3 sdr_color = NeutralSDRYOrMaxCH(linear_color);
    float3 gamma_color = renodx::color::srgb::Encode(sdr_color);

    color = gamma_color;
  } else {
    color = color;
  }
  return color;
}
