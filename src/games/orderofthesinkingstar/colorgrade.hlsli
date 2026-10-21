#ifndef SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_
#define SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_

#include "./shared.h"

// CUSTOM: Bend RGB channel-magnitude positions toward an N2 soft-clip reference.
// clip_point must be positive and in the same units as source; it is not an
// output ceiling. Transfers channel positions, applies lift/gain, then restores
// the unbent grade's relative luminance. No output-mode policy lives here.
// Identity lift/gain and scale allow use without a game-specific grade.
float3 SinkingStarApplyClipBend(
    float3 source,
    float clip_point,
    float strength = 1.f,
    float3 lift = float3(0.f, 0.f, 0.f),
    float3 gain = float3(1.f, 1.f, 1.f),
    float output_scale = 1.f) {
  const float3 magnitude = abs(source);
  const float3 reference = renodx::tonemap::neutwo::PerChannel(magnitude / clip_point);
  const float reference_min = renodx::math::Min(reference);
  const float reference_range = renodx::math::Max(reference) - reference_min;
  const bool reference_is_neutral = reference_range == 0.f;

  // Rescale uses ordinary division. A zero-based interval makes the fallback
  // denominator exactly 1, regardless of the neutral reference magnitude.
  const float safe_reference_range = renodx::math::Select(reference_is_neutral, 1.f, reference_range);
  float3 transferred = renodx::math::Rescale(
      reference - reference_min,
      0.f,
      safe_reference_range,
      renodx::math::Min(magnitude),
      renodx::math::Max(magnitude));

  transferred = renodx::math::CopySign(transferred, source);
  transferred = renodx::math::Select(reference_is_neutral, source, transferred);
  const float3 bent = lerp(source, transferred, saturate(strength));
  const float3 original_grade = lerp(lift, gain, source) * output_scale;
  const float3 bent_grade = lerp(lift, gain, bent) * output_scale;

  // Compute Y from raw graded RGB, not channel magnitudes.
  const float original_y = renodx::color::y::from::BT709(original_grade);
  const float bent_y = renodx::color::y::from::BT709(bent_grade);
  if (original_y > 0.f && bent_y > 0.f) {
    return bent_grade * (original_y / bent_y);
  }
  return original_grade;
}

float3 SinkingStarApplySaturation(
    float3 color,
    float relative_luminance,
    float saturation_scale,
    float saturation_space) {
  if (saturation_scale == 1.f) return color;

  if (saturation_space == CUSTOM_SATURATION_SPACE_OKLAB) {
    float3 oklab = renodx::color::oklab::from::BT709(color);
    oklab.yz *= saturation_scale;
    return renodx::color::bt709::from::OkLab(oklab);
  }

  if (saturation_space == CUSTOM_SATURATION_SPACE_LMS_D65) {
    const float3 d65_lms = renodx::color::lms::from::BT709(float3(1.f, 1.f, 1.f));
    const float3 relative_lms = renodx::math::DivideSafe(
        renodx::color::lms::from::BT709(color),
        d65_lms,
        0.f);
    float3 mb = renodx::color::macleod_boynton::from::LMS(relative_lms);
    if (mb.z > 1e-7f && !any(isnan(mb)) && !any(isinf(mb))) {
      const float2 d65_mb = renodx::color::macleod_boynton::from::LMS(float3(1.f, 1.f, 1.f)).xy;
      mb.xy = d65_mb + (mb.xy - d65_mb) * saturation_scale;
      return renodx::color::bt709::from::LMS(
          renodx::color::lms::from::MacLeodBoynton(mb) * d65_lms);
    }
  }

  return lerp(relative_luminance, color, saturation_scale);
}

float3 SinkingStarApplyCustomColorGrade(
    float3 input_color,
    float relative_luminance,
    float game_saturation,
    float contrast,
    float white_point,
    float3 game_inverse_gamma,
    float3 game_lift,
    float3 game_gain,
    float3 original_graded,
    float contrast_input_offset = 0.f) {
  // CUSTOM: Output-mode policy only: bypass the game's grade clamp for HDR.
  const bool use_unclipped_grade = RENODX_PEAK_WHITE_NITS > 0.f
                                   && RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA;
  const bool saturation_is_original = game_saturation == 1.f
                                      || (CUSTOM_GAME_GRADE_SATURATION == 1.f
                                          && CUSTOM_GAME_SATURATION_SPACE == CUSTOM_SATURATION_SPACE_BT709_NATIVE);
  if (saturation_is_original
      && CUSTOM_GAME_GRADE_LIFT == 1.f
      && CUSTOM_GAME_GRADE_GAMMA == 1.f
      && CUSTOM_GAME_GRADE_GAIN == 1.f
      && !use_unclipped_grade) {
    return original_graded;
  }

  const float saturation_scale = lerp(
      1.f,
      game_saturation,
      CUSTOM_GAME_GRADE_SATURATION);
  const float3 saturated = max(
      SinkingStarApplySaturation(
          input_color,
          relative_luminance,
          saturation_scale,
          CUSTOM_GAME_SATURATION_SPACE)
          + (use_unclipped_grade ? contrast_input_offset : 0.f),
      float3(0.f, 0.f, 0.f));
  const float3 contrasted = max(
      exp2(
          contrast * (log2(saturated) + 1.717856764793396f)
          - 1.717856764793396f)
          - 0.0010000000474974513f,
      float3(0.f, 0.f, 0.f));
  const float3 scaled_inverse_gamma = lerp(
      float3(1.f, 1.f, 1.f),
      game_inverse_gamma,
      CUSTOM_GAME_GRADE_GAMMA);
  // CUSTOM: Extend the authored grade above white point before HDR tonemapping.
  // Vanilla/Off retains the original bounded interpolation coordinate.
  const float3 game_gamma = exp2(log2(contrasted / white_point) * scaled_inverse_gamma);
  const float3 scaled_lift = game_lift * CUSTOM_GAME_GRADE_LIFT;
  const float3 scaled_gain = lerp(
      float3(1.f, 1.f, 1.f),
      game_gain,
      CUSTOM_GAME_GRADE_GAIN);
  if (use_unclipped_grade) {
    // CUSTOM: Copy N2's channel-magnitude positions, retaining magnitude endpoints
    // and original signs; N2's whitening is not transferred.
    if (CUSTOM_GAME_GRADE_HUE_CLIP > 0.f) {
      // white_point was normalized to 1 before gamma; bend in that same domain.
      return SinkingStarApplyClipBend(
          game_gamma,
          1.f,
          CUSTOM_GAME_GRADE_HUE_CLIP,
          scaled_lift,
          scaled_gain,
          white_point);
    }
    return lerp(scaled_lift, scaled_gain, game_gamma) * white_point;
  } else {
    return lerp(scaled_lift, scaled_gain, saturate(game_gamma)) * white_point;
  }
}

#endif  // SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_