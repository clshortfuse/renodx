#ifndef RENODX_ELITEDANGEROUS_COMMON_HLSLI_
#define RENODX_ELITEDANGEROUS_COMMON_HLSLI_

#include "./shared.h"

float3 GameScaleAndGrain(float3 color, float2 screen_position) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color = renodx::effects::ApplyFilmGrain(
      color,
      screen_position,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.03f,
      1.f);

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color = renodx::color::bt2020::from::BT709(color);
    color = min(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    color = renodx::color::bt709::from::BT2020(color);
  }
#endif

  color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

float3 GameScale(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

float3 FinalizeOutput(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, RENODX_GRAPHICS_WHITE_NITS);

  return color;
}

/// Identity through anchor to every derivative; then approaches peak
/// monotonically and concave down. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(T)                                                      \
  T ApplyAnchoredCInfinityShoulder(T color, T peak, T anchor, float compression_strength) {                \
    T shoulder_range = peak - anchor;                                                                      \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                  \
    T flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));                 \
    T response_denominator = mad(distance_from_anchor, flat_weight, shoulder_range);                       \
    return mad(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor); \
  }

APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float)
APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float3)
#undef APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR

float ApplyAnchoredCInfinityShoulderMaxChannelScale(float3 color, float peak, float anchor, float compression_strength) {
  float max_channel = renodx::math::Max(abs(color));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_max, max_channel, 1.f);
}

#endif  // RENODX_ELITEDANGEROUS_COMMON_HLSLI_