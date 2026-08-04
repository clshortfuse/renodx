#include "../common.hlsli"

/// Identity through anchor; generalized Naka-Rushton above it.
/// Monotonic and C2 at the anchor for valid ranges and power > 1.
#define APPLYNAKARUSHTON_GENERATOR(T)                                               \
  T ApplyNakaRushton(T color, T peak, T anchor, float compression_power) {          \
    T shoulder_range = peak - anchor;                                               \
    T distance_from_anchor = max(color - anchor, (T)0.f);                           \
    T position = distance_from_anchor / shoulder_range;                             \
    T response_scale = pow(                                                         \
        (T)1.f + pow(position, compression_power),                                  \
        -rcp(compression_power));                                                   \
    return mad(distance_from_anchor, response_scale, color - distance_from_anchor); \
  }

/// Maps white_clip to peak and remains flat above it.
/// Monotonic and C2 at the anchor and clip for valid ranges and power > 1.
#define APPLYNAKARUSHTON_CLIP_GENERATOR(T)                                               \
  T ApplyNakaRushton(T color, T peak, T anchor, float compression_power, T white_clip) { \
    T shoulder_range = peak - anchor;                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                \
    T input_range = white_clip - anchor;                                                 \
    T clipped_distance = min(distance_from_anchor, input_range);                         \
    T clip_position = clipped_distance / input_range;                                    \
    T position = clipped_distance / shoulder_range;                                      \
    T warp_base = (T)1.f - clip_position * clip_position * clip_position;                \
    T response_scale = pow(                                                              \
        warp_base * warp_base * warp_base + pow(position, compression_power),            \
        -rcp(compression_power));                                                        \
    return mad(clipped_distance, response_scale, color - distance_from_anchor);          \
  }

APPLYNAKARUSHTON_GENERATOR(float)
APPLYNAKARUSHTON_GENERATOR(float3)
APPLYNAKARUSHTON_CLIP_GENERATOR(float)
APPLYNAKARUSHTON_CLIP_GENERATOR(float3)
#undef APPLYNAKARUSHTON_GENERATOR
#undef APPLYNAKARUSHTON_CLIP_GENERATOR

/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHOREDCUBICSHOULDER_GENERATOR(T)                                                       \
  T ApplyAnchoredCubicShoulder(T color, T peak, T anchor, float compression_strength) {               \
    T shoulder_range = peak - anchor;                                                                 \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                             \
    T weighted_distance = compression_strength * distance_from_anchor;                                \
    T response_numerator = distance_from_anchor * (shoulder_range + weighted_distance);               \
    T response_denominator = mad(                                                                     \
        shoulder_range, shoulder_range, weighted_distance * (shoulder_range + distance_from_anchor)); \
    return mad(shoulder_range, response_numerator / response_denominator,                             \
               color - distance_from_anchor);                                                         \
  }

/// Returns the conservative minimum clip required to preserve concavity.
#define CALCULATEMINIMUMANCHOREDCUBICSHOULDERCLIP_GENERATOR(T)    \
  T CalculateMinimumAnchoredCubicShoulderClip(T peak, T anchor) { \
    return mad((T)2.5f, peak - anchor, anchor);                   \
  }

/// Identity through anchor; reaches peak at clip, then remains flat.
/// Monotonic, concave down, and C2 when clip meets the calculated minimum.
#define APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(T)                                                                        \
  T ApplyAnchoredCubicShoulder(                                                                                             \
      T color, T peak, T anchor, float compression_strength, T clip) {                                                      \
    T shoulder_range = peak - anchor;                                                                                       \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                                   \
    T input_range = clip - anchor;                                                                                          \
    T clipped_distance = min(distance_from_anchor, input_range);                                                            \
    T clip_position = clipped_distance / input_range;                                                                       \
    T clip_position_squared = clip_position * clip_position;                                                                \
    T clip_position_cubed = clip_position_squared * clip_position;                                                          \
    T residual_weight = (T)1.f - clip_position_cubed * mad(clip_position, mad((T)6.f, clip_position, (T) - 15.f), (T)10.f); \
    T weighted_distance = compression_strength * clipped_distance;                                                          \
    T response_numerator = clipped_distance * (shoulder_range + weighted_distance);                                         \
    T remaining_distance = shoulder_range * mad(compression_strength - 1.f, clipped_distance, shoulder_range);              \
    T response_denominator = mad(residual_weight, remaining_distance, response_numerator);                                  \
    return mad(shoulder_range, response_numerator / response_denominator,                                                   \
               color - distance_from_anchor);                                                                               \
  }

APPLYANCHOREDCUBICSHOULDER_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_GENERATOR(float3)
CALCULATEMINIMUMANCHOREDCUBICSHOULDERCLIP_GENERATOR(float)
CALCULATEMINIMUMANCHOREDCUBICSHOULDERCLIP_GENERATOR(float3)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float3)
#undef APPLYANCHOREDCUBICSHOULDER_GENERATOR
#undef CALCULATEMINIMUMANCHOREDCUBICSHOULDERCLIP_GENERATOR
#undef APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR

bool ComposeUIAndSceneSCRGB(float3 scene_color, float4 ui_color_gamma, inout float4 output_color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color_gamma = max(0, ui_color_gamma);
  float ui_alpha = ui_color_gamma.a;

  if (RENODX_GAMMA_CORRECTION_UI == 0.f) {
    ui_color_gamma.rgb = renodx::color::gamma::Encode(renodx::color::srgb::Decode(ui_color_gamma.rgb));
  }

  // Defer display mapping to compositing because PostProcessToneMap applies adjustments after tonemapping.
  const float MID_GRAY = 0.18f;
  const float PEAK_RATIO = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  const float COMPRESSION_POWER = 1.3f;
  const float CLIP = 100.f;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {  // BT.709
    scene_color = ApplyAnchoredCubicShoulder(scene_color, PEAK_RATIO, MID_GRAY, COMPRESSION_POWER);
  } else {  // LMS
    float3 scene_lms = renodx::color::lms::from::BT709(scene_color);
    const float3 ANCHOR_LMS = renodx::color::lms::from::BT2020(MID_GRAY);
    const float3 PEAK_LMS = renodx::color::lms::from::BT2020(PEAK_RATIO);
    const float3 CLIP_LMS = renodx::color::lms::from::BT2020(CLIP);
    scene_lms = ApplyAnchoredCubicShoulder(scene_lms, PEAK_LMS, ANCHOR_LMS, COMPRESSION_POWER);

    scene_color = renodx::color::bt709::from::LMS(scene_lms);
  }

  // Rescale that reference so 1.0 represents the configured diffuse white.
  scene_color *= RENODX_DIFFUSE_WHITE_NITS;

  // Blend UI and scene color in gamma space, then convert back to linear space.
  scene_color /= RENODX_GRAPHICS_WHITE_NITS;
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color);
  float3 composited_color_gamma = mad(scene_color_gamma, 1.f - ui_alpha, ui_color_gamma.rgb);
  float3 composited_color = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color *= RENODX_GRAPHICS_WHITE_NITS;

  output_color = float4(composited_color / 80.f, ui_alpha);
  return true;
}
