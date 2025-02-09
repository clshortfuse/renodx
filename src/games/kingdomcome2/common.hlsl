#include "./shared.h"

// Credits to Pumbo
float3 RestoreLuminance(float3 targetColor, float sourceColorLuminance, bool safe = false) {
  float targetColorLuminance = renodx::color::y::from::BT709(targetColor);
  if (safe) {
    return targetColor * renodx::math::SafeDivision(max(sourceColorLuminance, 0.0), max(targetColorLuminance, 0.0), 0);  // Return zero if dividing by zero
  }
  return targetColor * renodx::math::SafeDivision(sourceColorLuminance, targetColorLuminance, 1);  // Return one if dividing by zero
}

float3 Tonemap(float3 sdrColor, float3 untonemapped) {
  float3 outputColor = sdrColor;
  if (CUSTOM_FAKE_HDR > 0.f) {
    float normalizationPoint = 1.f;  // Found empyrically
    float mixedSceneColorLuminance = renodx::color::y::from::BT709(untonemapped) / normalizationPoint;
    float fakeHDRIntensity = 0.5;
    mixedSceneColorLuminance = mixedSceneColorLuminance > 1.0 ? pow(mixedSceneColorLuminance, 1.0 + fakeHDRIntensity) : mixedSceneColorLuminance;
    untonemapped = RestoreLuminance(untonemapped, mixedSceneColorLuminance * normalizationPoint);
  }

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    // This is the SDR color after LUT
    outputColor = renodx::color::srgb::DecodeSafe(outputColor);
    outputColor = renodx::draw::ToneMapPass(untonemapped, outputColor);
    outputColor = renodx::draw::RenderIntermediatePass(outputColor);
  }

  return outputColor;
}

void ModifySettings(inout float3 gamma) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    gamma = float3(1, 1, 0);
  }
}
  