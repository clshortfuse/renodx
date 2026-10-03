#ifndef SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_
#define SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_

#include "./shared.h"

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
    float3 original_graded) {
  const bool saturation_is_original = game_saturation == 1.f
                                      || (CUSTOM_GAME_GRADE_SATURATION == 1.f
                                          && CUSTOM_GAME_SATURATION_SPACE == CUSTOM_SATURATION_SPACE_BT709_NATIVE);
  if (saturation_is_original
      && CUSTOM_GAME_GRADE_LIFT == 1.f
      && CUSTOM_GAME_GRADE_GAMMA == 1.f
      && CUSTOM_GAME_GRADE_GAIN == 1.f) {
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
          CUSTOM_GAME_SATURATION_SPACE),
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
  const float3 game_gamma = saturate(
      exp2(log2(contrasted / white_point) * scaled_inverse_gamma));
  const float3 scaled_lift = game_lift * CUSTOM_GAME_GRADE_LIFT;
  const float3 scaled_gain = lerp(
      float3(1.f, 1.f, 1.f),
      game_gain,
      CUSTOM_GAME_GRADE_GAIN);
  return lerp(scaled_lift, scaled_gain, game_gamma) * white_point;
}

#endif  // SRC_GAMES_ORDEROFTHESINKINGSTAR_COLORGRADE_HLSLI_