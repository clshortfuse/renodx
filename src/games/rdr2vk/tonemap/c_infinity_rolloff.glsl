#ifndef SRC_GAMES_RDR2_C_INFINITY_ROLLOFF_GLSL_
#define SRC_GAMES_RDR2_C_INFINITY_ROLLOFF_GLSL_

#include "../common.glsl"

vec3 CInfinityRollOffDivideSafe(vec3 numerator, vec3 denominator) {
  return vec3(
      DivideSafe(numerator.x, denominator.x, 0.0),
      DivideSafe(numerator.y, denominator.y, 0.0),
      DivideSafe(numerator.z, denominator.z, 0.0));
}

float CInfinityRollOffDivideSafe(float numerator, float denominator) {
  return DivideSafe(numerator, denominator, 0.0);
}

// Identity through anchor; approaches peak asymptotically.
// Requires anchor < peak and compression_strength >= 1.
#define C_INFINITY_ROLLOFF_GENERATOR(T)                                                              \
  T CInfinityRollOff(T color, T peak, T anchor, float compression_strength) {                        \
    T shoulder_range = peak - anchor;                                                                \
    T distance_from_anchor = max(color - anchor, T(0.0));                                            \
    T inverse_position = shoulder_range * (T(1.0) / (compression_strength * distance_from_anchor));  \
    T flat_weight = exp2(-inverse_position);                                                         \
    T response_denominator = fma(T(compression_strength), inverse_position, flat_weight);            \
    return fma(shoulder_range, T(1.0) / response_denominator, min(color, anchor));                   \
  }                                                                                                  \
  T CInfinityRollOff(T color, T peak) {                                                              \
    return CInfinityRollOff(color, peak, T(0.18), 1.5);                                              \
  }                                                                                                  \
  T CInfinityRollOff(T color, T peak, T anchor) {                                                    \
    return CInfinityRollOff(color, peak, anchor, 1.5);                                               \
  }                                                                                                  \
  T CInfinityRollOff(T color, T peak, T anchor, float compression_strength, T clip) {                \
    T shoulder_range = peak - anchor;                                                                \
    T clip_range = clip - anchor;                                                                    \
    T clipped_distance = min(max(color - anchor, T(0.0)), clip_range);                               \
    T remaining_distance = clip_range - clipped_distance;                                            \
    T numerator = shoulder_range * remaining_distance;                                               \
    T denominator = abs(clip - peak) * clipped_distance;                                             \
    T inverse_position = CInfinityRollOffDivideSafe(numerator, denominator);                         \
    T flat_weight = exp2(-inverse_position / compression_strength);                                  \
    T transition = clipped_distance * flat_weight / (clip_range * (flat_weight + inverse_position)); \
    return fma(peak - clip, transition, min(color, clip));                                           \
  }

C_INFINITY_ROLLOFF_GENERATOR(float)
C_INFINITY_ROLLOFF_GENERATOR(vec3)

#undef C_INFINITY_ROLLOFF_GENERATOR

float CInfinityRollOffComputeMaxChannelScale(
    vec3 color, float peak, float anchor, float compression_strength) {
  vec3 absolute_color = abs(color);
  float max_channel = max(absolute_color.x, max(absolute_color.y, absolute_color.z));
  float new_max = CInfinityRollOff(max_channel, peak, anchor, compression_strength);
  return max_channel != 0.0 ? new_max / max_channel : 1.0;
}

float CInfinityRollOffComputeMaxChannelScale(vec3 color, float peak) {
  return CInfinityRollOffComputeMaxChannelScale(color, peak, 0.18, 1.5);
}

float CInfinityRollOffComputeMaxChannelScale(vec3 color, float peak, float anchor) {
  return CInfinityRollOffComputeMaxChannelScale(color, peak, anchor, 1.5);
}

float CInfinityRollOffComputeMaxChannelScale(
    vec3 color, float peak, float anchor, float compression_strength, float clip) {
  vec3 absolute_color = abs(color);
  float max_channel = max(absolute_color.x, max(absolute_color.y, absolute_color.z));
  float new_max = CInfinityRollOff(max_channel, peak, anchor, compression_strength, clip);
  return max_channel != 0.0 ? new_max / max_channel : 1.0;
}

vec3 CInfinityRollOffMaxChannel(vec3 color, float peak, float anchor, float compression_strength) {
  return color * CInfinityRollOffComputeMaxChannelScale(color, peak, anchor, compression_strength);
}

vec3 CInfinityRollOffMaxChannel(vec3 color, float peak) {
  return CInfinityRollOffMaxChannel(color, peak, 0.18, 1.5);
}

vec3 CInfinityRollOffMaxChannel(vec3 color, float peak, float anchor) {
  return CInfinityRollOffMaxChannel(color, peak, anchor, 1.5);
}

vec3 CInfinityRollOffMaxChannel(vec3 color, float peak, float anchor, float compression_strength, float clip) {
  return color * CInfinityRollOffComputeMaxChannelScale(color, peak, anchor, compression_strength, clip);
}

#endif  // SRC_GAMES_RDR2_C_INFINITY_ROLLOFF_GLSL_