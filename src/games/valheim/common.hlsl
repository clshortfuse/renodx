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

float3 NeutralSDRYLerp(float3 color) {
  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  return color;
}

float3 CustomUpgradeToneMap(float3 untonemapped, float3 tonemapped_bt709, float3 neutral_sdr) {
  if (RENODX_TONE_MAP_TYPE == 0) {
    return saturate(tonemapped_bt709);
  }
  else {
    return renodx::tonemap::UpgradeToneMap(untonemapped, neutral_sdr, tonemapped_bt709, CUSTOM_LUT_STRENGTH, 1.f);
  }
}