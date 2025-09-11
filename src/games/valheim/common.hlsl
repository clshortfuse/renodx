#include "./shared.h"

float3 LutDecode(float3 color) {
    color = renodx::color::pq::Decode(color, 100.f);
    color = renodx::color::bt709::from::BT2020(color);
    return color;
}

float3 LutEncode(float3 color) {
    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, 100.f);
    return color;
}

// float3 Tonemap(float3 color) {
//   renodx::draw::Config config = renodx::draw::BuildConfig();
//   config.tone_map_type = 2;  // ACES
//   config.peak_white_nits = 10000.f;
//   config.diffuse_white_nits = 80.f;
//   config.graphics_white_nits = 80.f;
//   float3 outputColor = renodx::draw::ToneMapPass(color, config);
//   return outputColor;
// }

float3 UpgradeTonemap(float3 untonemapped, float3 tonemapped_bt709) {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.tone_map_type = 2; // ACES
  config.peak_white_nits = 10000.f;
  config.diffuse_white_nits = 80.f;
  config.graphics_white_nits = 80.f;
  config.tone_map_per_channel = 1.f;

  float3 outputColor;
  outputColor = renodx::draw::ToneMapPass(untonemapped, config);
  return outputColor;
}

float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

// float3 CustomPerChannelCorrection(float3 untonemapped, float3 tonemapped_bt709) {
//   return renodx::draw::ApplyPerChannelCorrection(
//       untonemapped,
//       tonemapped_bt709,
//       CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION,
//       CUSTOM_SCENE_GRADE_HUE_CORRECTION,
//       CUSTOM_SCENE_GRADE_SATURATION_CORRECTION,
//       CUSTOM_SCENE_GRADE_HUE_SHIFT);
// }

float3 CustomUpgradeToneMap(float3 untonemapped, float3 tonemapped_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0) {
    return saturate(tonemapped_bt709);
  }
  else {
      return renodx::tonemap::UpgradeToneMap(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped), tonemapped_bt709, CUSTOM_LUT_STRENGTH, 1.f);
    }
}