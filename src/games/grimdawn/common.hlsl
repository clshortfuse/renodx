#include "./shared.h"

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

float3 CustomTonemap(float3 untonemapped, float3 sdr_color) {
  float3 outputColor = sdr_color;
  if (RENODX_TONE_MAP_TYPE != 0.f && CUSTOM_TONE_MAP_CONFIGURATION == 0) {
    outputColor = renodx::draw::ToneMapPass(untonemapped, sdr_color, ToneMapMaxCLL(untonemapped));
  }
  else {
    outputColor = renodx::draw::ToneMapPass(untonemapped);
  }
  return outputColor;
}

float3 CustomTonemapIntermediate(float3 untonemapped, float3 sdr_color) {
    float3 outputColor = CustomTonemap(untonemapped, sdr_color);
    return renodx::draw::RenderIntermediatePass(outputColor);
}

float3 CustomTonemapGamma(float3 untonemapped, float3 sdr_color) {
  float3 outputColor = CustomTonemap(untonemapped, sdr_color);
  return renodx::color::srgb::EncodeSafe(outputColor);
}