
#ifndef RENODX_SHADERS_TONEMAP_C_INFINITY_ROLLOFF_HLSL_
#define RENODX_SHADERS_TONEMAP_C_INFINITY_ROLLOFF_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace tonemap {

/// Identity through anchor with a C-infinity join.
/// The original overload approaches peak asymptotically.
/// The clipped overload maps clip to peak, then remains flat.
/// Clipped compression is concave down; expansion is convex.
/// Requires anchor < peak, compression_strength >= 1, and anchor < clip when clipping.
#define C_INFINITY_ROLLOFF_GENERATOR(T)                                                                 \
  T CInfinityRollOff(T color, T peak, T anchor = 0.18f, float compression_strength = 1.5f) {            \
    T shoulder_range = peak - anchor;                                                                   \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                               \
    T inverse_position = shoulder_range * rcp(compression_strength * distance_from_anchor);             \
    T flat_weight = exp2(-inverse_position);                                                            \
    T response_denominator = mad(compression_strength, inverse_position, flat_weight);                  \
    return mad(shoulder_range, rcp(response_denominator), min(color, anchor));                          \
  }                                                                                                     \
                                                                                                        \
  T CInfinityRollOff(T color, T peak, T anchor, float compression_strength, T clip) {                   \
    T shoulder_range = peak - anchor;                                                                   \
    T clip_range = clip - anchor;                                                                       \
    T clipped_distance = min(max(color - anchor, (T)0.f), clip_range);                                  \
    T remaining_distance = clip_range - clipped_distance;                                               \
    T inverse_position = renodx::math::DivideSafe(                                                      \
        shoulder_range * remaining_distance, abs(clip - peak) * clipped_distance, (T)0.f);              \
    T flat_weight = exp2(-inverse_position * rcp(compression_strength));                                \
    T transition = clipped_distance * flat_weight * rcp(clip_range * (flat_weight + inverse_position)); \
    return mad(peak - clip, transition, min(color, clip));                                              \
  }

C_INFINITY_ROLLOFF_GENERATOR(float)
C_INFINITY_ROLLOFF_GENERATOR(float3)

#undef C_INFINITY_ROLLOFF_GENERATOR

namespace c_infinity_rolloff {

/// Returns a ratio-preserving RGB scale by rolling off the largest absolute channel.
float ComputeMaxChannelScale(float3 color, float peak, float anchor = 0.18f, float compression_strength = 1.5f) {
  float max_channel = renodx::math::Max(abs(color));
  float new_max = renodx::tonemap::CInfinityRollOff(max_channel, peak, anchor, compression_strength);
  return max_channel != 0.f ? new_max / max_channel : 1.f;
}

/// Returns a ratio-preserving RGB scale with a finite clip.
float ComputeMaxChannelScale(float3 color, float peak, float anchor, float compression_strength, float clip) {
  float max_channel = renodx::math::Max(abs(color));
  float new_max = renodx::tonemap::CInfinityRollOff(max_channel, peak, anchor, compression_strength, clip);
  return max_channel != 0.f ? new_max / max_channel : 1.f;
}

/// Compresses the largest absolute channel toward peak while preserving RGB ratios.
float3 MaxChannel(float3 color, float peak, float anchor = 0.18f, float compression_strength = 1.5f) {
  return color * ComputeMaxChannelScale(color, peak, anchor, compression_strength);
}

/// Maps the largest absolute channel toward peak at clip while preserving RGB ratios.
float3 MaxChannel(float3 color, float peak, float anchor, float compression_strength, float clip) {
  return color * ComputeMaxChannelScale(color, peak, anchor, compression_strength, clip);
}

}  // namespace c_infinity_rolloff
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_C_INFINITY_ROLLOFF_HLSL_
