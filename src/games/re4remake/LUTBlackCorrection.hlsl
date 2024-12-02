#include "./shared.h"

/// Adjusts gamma based on luminance using the guidelines from ITU BT.2408.
/// At `gammaAdjustmentFactor` = 1.15, it works well to preserve the appearance of
/// shadows and midtones at 100 cd/m2 while scaling the SDR nominal peak white to 203 cd/m2.
/// See: https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2408-7-2023-PDF-E.pdf Section 5.1.3.2
/// @param linearColor The color to adjust.
/// @param gammaAdjustmentFactor Factor to adjust the gamma.
/// @return The color with adjusted gamma.
float3 AdjustGammaOnLuminance(float3 linearColor, float gammaAdjustmentFactor) {
  if (gammaAdjustmentFactor == 1.f) return linearColor;
  // Calculate the original luminance
  float originalLuminance = renodx::color::y::from::BT709(abs(linearColor));

  // Adjust luminance only if it is less than or equal to 1
  float adjustedLuminance = originalLuminance > 1.0 ? originalLuminance : renodx::color::gamma::Encode(originalLuminance, 1 / gammaAdjustmentFactor);

  // Recombine the colors with the adjusted luminance
  if (originalLuminance == 0) return float3(0, 0, 0);  // Prevent division by zero
  return linearColor * (adjustedLuminance / originalLuminance);
}

/// Applies a modified `renodx::lut::Sample` that accounts for only black level correction,
/// leaving peak white untouched as LUTs are already HDR, ensuring no highlight impact.
/// @param color_input Input color to apply the LUT to.
/// @param lut_texture The LUT texture.
/// @param lut_config Configuration for LUT sampling.
/// @return Color output after applying LUT correction.
float3 LUTBlackCorrection(float3 color_input, Texture3D lut_texture, renodx::lut::Config lut_config) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  if (lut_config.scaling != 0) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(0.18f, lut_config), lut_config, lut_texture);
    float3 unclamped = renodx::lut::Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        1.f,  // set peak to 1 so it doesn't touch highlights
        renodx::lut::GammaInput(color_input, lutInputColor, lut_config));
    float3 recolored = renodx::lut::RecolorUnclamped(color_output, renodx::lut::LinearUnclampedOutput(unclamped, lut_config));
    color_output = lerp(color_output, recolored, lut_config.scaling);
  }
  color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  if (lut_config.strength != 1.f) {
    color_output = lerp(color_input, color_output, lut_config.strength);
  }
  return color_output;
}

/// Applies a customized version of RenoDRT tonemapper that tonemaps down to 1.0.
/// This function is used to compress HDR color to SDR range for use alongside `UpgradeToneMap`.
///
/// @param lutInputColor The color input that needs to be tonemapped.
/// @return The tonemapped color compressed to the SDR range, ensuring that it can be applied to SDR color grading with `UpgradeToneMap`.
float3 renoDRTSmoothClamp(float3 lutInputColor) {
  renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.025f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  // renodrt_config.hue_correction_source = renodx::tonemap::uncharted2::BT709(untonemapped);
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 2u;
  renodrt_config.per_channel = false;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(lutInputColor, renodrt_config);

  return lerp(lutInputColor, renoDRTColor, saturate(renodx::color::y::from::BT709(lutInputColor) / renodrt_config.mid_gray_value));
}
