#include "./shared.h"

struct KingdomOptions {
  float3 gamma;
  float vignette;
  float3 bloom;
};

// Credits to Pumbo
float3 RestoreLuminance(float3 targetColor, float sourceColorLuminance, bool safe = false) {
  float targetColorLuminance = renodx::color::y::from::BT709(targetColor);
  if (safe) {
    return targetColor * renodx::math::SafeDivision(max(sourceColorLuminance, 0.0), max(targetColorLuminance, 0.0), 0);  // Return zero if dividing by zero
  }
  return targetColor * renodx::math::SafeDivision(sourceColorLuminance, targetColorLuminance, 1);  // Return one if dividing by zero
}

// Deprecated
float3 Tonemap(float3 sdrColor, float3 untonemapped) {
  float3 outputColor = sdrColor;

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    // This is the SDR color after LUT
    outputColor = renodx::color::srgb::DecodeSafe(outputColor);
    outputColor = renodx::draw::ToneMapPass(untonemapped, outputColor);
    outputColor = renodx::draw::RenderIntermediatePass(outputColor);
  }

  return outputColor;
}

void ModifyOptions(inout KingdomOptions options) {
  options.vignette = 1.f;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    options.gamma = float3(1, 1, 0);
    options.bloom = options.bloom * CUSTOM_BLOOM;
  }
}
