#include "./shared.h"

/// Applies a customized version of RenoDRT tonemapper that tonemaps down to 1.0.
/// This function is used to compress HDR color to SDR range for use alongside `UpgradeToneMap`.
///
/// @param lutInputColor The color input that needs to be tonemapped.
/// @return The tonemapped color compressed to the SDR range, ensuring that it can be applied to SDR color grading with `UpgradeToneMap`.
float3 renoDRTSmoothClamp(float3 untonemapped) {
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
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 1u;
  renodrt_config.per_channel = false;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);

  float HDRBlendFactor = lerp(1.f, renodrt_config.mid_gray_value, saturate(1.f));
  renoDRTColor = lerp(untonemapped, renoDRTColor, saturate(untonemapped / HDRBlendFactor));

  return renoDRTColor;
}

float3 ApplyToneMap(float3 color_post_process, float3 color_hdr, float3 color_sdr) {
  if (RENODX_TONE_MAP_TYPE) {
    // upgradetonemap
    color_post_process = renodx::math::SignPow(color_post_process, 2.2f);
    color_post_process = renodx::color::bt709::clamp::BT2020(color_post_process);
    color_post_process = renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, color_post_process, RENODX_COLOR_GRADE_STRENGTH);

    // user color grading
    color_post_process = renodx::color::grade::UserColorGrading(
        color_post_process,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT,
        0.f);

    color_post_process = renodx::color::bt2020::from::BT709(color_post_process);
    if (RENODX_TONE_MAP_TYPE == 2.f) {  // exponential rolloff
      const float peak_white = max(1.f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
      const float shoulder = peak_white;
      color_post_process = renodx::tonemap::ExponentialRollOff(color_post_process, shoulder, peak_white);
    }
    color_post_process = max(0, color_post_process);  // clamp to BT.2020
    color_post_process = renodx::color::bt709::from::BT2020(color_post_process);
    color_post_process *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color_post_process = renodx::math::SignPow(color_post_process, 1.f / 2.2f);
  } else {
    color_post_process = saturate(color_post_process);
    color_post_process = pow(color_post_process, 2.2f);
    color_post_process *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color_post_process = pow(color_post_process, 1.f / 2.2f);
  }
  return color_post_process;
}

float4 ClampUI(float4 ui_texture) {
  ui_texture = saturate(ui_texture);
  return ui_texture;
}
