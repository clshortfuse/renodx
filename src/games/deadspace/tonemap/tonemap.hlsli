#include "../../../shaders/tonemap/psychov/test17.hlsl"
#include "../common.hlsli"

namespace renodx_custom {
namespace tonemap {
namespace aces {

renodx::tonemap::aces::ODTConfig CreateODTConfig(
    float min_y,
    float max_y,
    float mid_y,
    bool stable_peak_exp_shift = false,
    float exp_shift_max_reference = 1000.f,
    float exp_shift_min_reference = 0.0001f) {
  renodx::tonemap::aces::ODTConfig config = renodx::tonemap::aces::CreateODTConfig(min_y, max_y);

  if (mid_y != 4.8f) {
    renodx::tonemap::aces::ODTConfig exp_shift_config;

    // derive exp-shift from a fixed reference curve so peak changes are stable
    const bool use_stable_reference =
        stable_peak_exp_shift && (exp_shift_max_reference != max_y || exp_shift_min_reference != min_y);
    if (use_stable_reference) {
      exp_shift_config = renodx::tonemap::aces::CreateODTConfig(exp_shift_min_reference, exp_shift_max_reference);
    } else {
      exp_shift_config = config;
    }
    float exp_shift = log2(renodx::tonemap::aces::InvSSTS(mid_y, exp_shift_config)) - log2(0.18f);
    float shift_log10 = exp_shift * log10(2.f);

    config.y_min.x -= shift_log10;
    config.y_mid.x -= shift_log10;
    config.y_max.x -= shift_log10;
  }

  return config;
}

}  // namespace aces
}  // namespace tonemap
}  // namespace renodx

float3 ApplyConeBleaching(
    float3 lms_cones,
    float3 adaptive_white_lms,
    float bleaching_intensity,
    float mid_gray = 0.18f,
    float troland_scale = 4.f,
    float half_bleach_trolands = 20000.f) {
  if (bleaching_intensity == 0.f) return lms_cones;

  const float REFERENCE_WHITE_NITS = 203.f;
  float3 mid_gray_lms = adaptive_white_lms * mid_gray;
  float3 lms_cones_adapted = renodx::math::DivideSafe(lms_cones, mid_gray_lms, 0.f.xxx);
  float3 current_adaptive_state_adapted = 1.f.xxx;

  float3 stimulus_trolands = max(current_adaptive_state_adapted, 0.f) * mid_gray * REFERENCE_WHITE_NITS * troland_scale;
  float3 availability = 1.f.xxx / (1.f.xxx + stimulus_trolands / half_bleach_trolands);
  availability = lerp(1.f.xxx, availability, bleaching_intensity);

  float y = lms_cones_adapted.x + lms_cones_adapted.y;
  float white_y = current_adaptive_state_adapted.x + current_adaptive_state_adapted.y;
  float3 white_at_y = current_adaptive_state_adapted * renodx::math::DivideSafe(y, white_y, 0.f);
  float3 delta = (lms_cones_adapted - white_at_y) * availability;
  return (white_at_y + delta) * mid_gray_lms;
}

float3 ApplyToneMap(float3 untonemapped_ap1) {
  const float ACES_MIN = 0.0001f;
  const float ACES_MID = 15.232879f;
  const float ACES_DIFFUSE = ACES_MID * 10.f;

  float diffuse_white = ACES_DIFFUSE;
  if (OVERRIDE_GAME_BRIGHTNESS != 0.f) {
    diffuse_white = RENODX_DIFFUSE_WHITE_NITS;
  }

  float aces_min = ACES_MIN / diffuse_white;
  float aces_max = (RENODX_PEAK_WHITE_NITS / diffuse_white);

  const float EXP_SHIFT_REFERENCE_MAX = 10000.f;
  const float EXP_SHIFT_REFERENCE_MIN = 0.0001f;

  renodx::tonemap::aces::ODTConfig odt_config = renodx_custom::tonemap::aces::CreateODTConfig(
      aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

  float3 tonemapped_ap1;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {
    tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, odt_config);
  } else {
    const float3 AP1_WHITE = renodx::color::lms::from::AP1(1.f);
    float3 untonemapped_lms = renodx::color::lms::from::AP1(untonemapped_ap1);
    // untonemapped_lms = ApplyConeBleaching(untonemapped_lms, AP1_WHITE, 1.f, 0.18f, 4.f, 4000.f);

    float3 untonemapped_lms_normalized = untonemapped_lms / AP1_WHITE;
    float3 tonemapped_lms_normalized = renodx::tonemap::aces::ODTToneMap(untonemapped_lms_normalized, odt_config) / ACES_DIFFUSE;
    float3 tonemapped_lms = max(0, tonemapped_lms_normalized * AP1_WHITE);

    const float MID_GRAY_IN = 0.18f;
    const float MID_GRAY_OUT = 0.10f;
    {  // gamut compression
      float3 current_adaptive_state_lms = AP1_WHITE * MID_GRAY_IN;
      float3 desired_background_state_lms = AP1_WHITE * MID_GRAY_OUT;

      float3 source_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
          untonemapped_lms_normalized * AP1_WHITE,
          current_adaptive_state_lms);

      float3 display_scaled_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
          tonemapped_lms,
          desired_background_state_lms);

      {
        float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
        float3 mb_display_target = renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
        float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f);

        float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
        float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;

        float src2 = dot(source_offset, source_offset);
        float display_tgt2 = dot(display_target_offset, display_target_offset);

        if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
          float target_radius = sqrt(display_tgt2);
          float2 source_dir = source_offset * rsqrt(src2);
          float2 display_target_dir = display_target_offset * rsqrt(display_tgt2);

          float restore_weight = 0.5f;

          float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
          float blended_len2 = dot(blended_dir, blended_dir);
          blended_dir = (blended_len2 > 1e-7f) ? (blended_dir * rsqrt(blended_len2)) : display_target_dir;

          float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
          float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);

          display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
        }
      }

      display_scaled_relative_weighted = renodx::tonemap::psychov::psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          desired_background_state_lms,
          renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
          1.f);

      tonemapped_lms = renodx::color::macleod_boynton::UnweighLMS(
          renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(display_scaled_relative_weighted, desired_background_state_lms));
    }

    tonemapped_ap1 = renodx::color::ap1::from::LMS(tonemapped_lms) * ACES_DIFFUSE;
  }
  tonemapped_ap1 = max(0, tonemapped_ap1);

  tonemapped_ap1 /= ACES_DIFFUSE;  // normalize so diffuse white is at 1.0

  tonemapped_ap1 *= diffuse_white;

  tonemapped_ap1 /= EXP_SHIFT_REFERENCE_MAX;

  return tonemapped_ap1;
}
