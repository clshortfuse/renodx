#include "../common.hlsli"

float3 ComputePeakCompressionRolloff(
    float3 color,
    float3 anchor,
    float3 peak,
    float anchor_luminance,
    float peak_luminance) {
  static const float REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
  static const float REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
  static const float MIN_AUTO_COMPRESSION = 1.f;

  float peak_over_anchor_luminance = peak_luminance / anchor_luminance;
  float reference_one_side_range_log10 = REFERENCE_SIMULTANEOUS_RANGE_LOG10 / REFERENCE_CENTERED_RANGE_SIDE_COUNT;
  float actual_above_adaptation_range_log10 = log10(peak_over_anchor_luminance);
  float compression_power = max(reference_one_side_range_log10 / actual_above_adaptation_range_log10, MIN_AUTO_COMPRESSION);

  float3 peak_over_anchor = peak / anchor;
  float3 powered_peak_over_anchor = pow(peak_over_anchor, compression_power);
  float3 compression_white_offset = powered_peak_over_anchor - 1.f;
  float3 compression_exponent = compression_power * powered_peak_over_anchor / compression_white_offset;
  float3 compression_input = pow(max(color / anchor, 0.f), compression_exponent);
  float3 compression_rolloff = pow(compression_input / (compression_input + compression_white_offset), rcp(compression_power));

  return renodx::math::Select(color >= anchor, compression_rolloff, color / peak);
}

bool ComposeUIAndSceneSCRGB(float3 scene_color, float4 ui_color_gamma, inout float4 output_color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color_gamma = max(0, ui_color_gamma);
  float ui_alpha = ui_color_gamma.a;

  if (RENODX_GAMMA_CORRECTION_UI == 0.f) {
    ui_color_gamma.rgb = renodx::color::gamma::Encode(renodx::color::srgb::Decode(ui_color_gamma.rgb));
  }

  // Defer display mapping to compositing because PostProcessToneMap applies adjustments after tonemapping.
  static const float MID_GRAY = 0.18f;
  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {  // BT.709
    float3 mid_gray = MID_GRAY.xxx;
    float3 peak = peak_ratio.xxx;
    scene_color = peak * ComputePeakCompressionRolloff(scene_color, mid_gray, peak, MID_GRAY, peak_ratio);
  } else {  // LMS
    float3 scene_lms = renodx::color::lms::from::BT709(scene_color);
    float3 mid_gray_lms = renodx::color::lms::from::BT709(MID_GRAY.xxx);
    float3 peak_lms = renodx::color::lms::from::BT2020(peak_ratio.xxx);
    scene_lms = peak_lms * ComputePeakCompressionRolloff(scene_lms, mid_gray_lms, peak_lms, renodx::color::yf::from::LMS(mid_gray_lms), renodx::color::yf::from::LMS(peak_lms));
    scene_color = renodx::color::bt709::from::LMS(scene_lms);
  }

  // The game stores scene color with 1.0 representing 250 nits.
  // Rescale that reference so 1.0 represents the configured diffuse white.
  scene_color *= RENODX_DIFFUSE_WHITE_NITS;

  // blend UI and scene color in gamma space, then convert back to linear space
  scene_color /= RENODX_GRAPHICS_WHITE_NITS;
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color);
  float3 composited_color_gamma = ui_color_gamma.rgb + scene_color_gamma * (1.0 - ui_alpha);
  float3 composited_color = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color *= RENODX_GRAPHICS_WHITE_NITS;

  output_color = float4(composited_color / 80.f, ui_alpha);
  return true;
}
