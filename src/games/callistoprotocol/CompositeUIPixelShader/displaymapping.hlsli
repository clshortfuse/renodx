#include "../common.hlsli"

/// Identity through anchor; generalized Naka-Rushton above it.
/// Monotonic and C2 at the anchor for valid ranges and power > 1.
#define APPLYNAKARUSHTON_GENERATOR(T)                                                           \
  T ApplyNakaRushton(T color, T peak, T anchor, float compression_power) {                      \
    T shoulder_range = peak - anchor;                                                           \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                       \
    T position = distance_from_anchor / shoulder_range;                                         \
    T response_scale = pow((T)1.f + pow(position, compression_power), -rcp(compression_power)); \
    return mad(distance_from_anchor, response_scale, color - distance_from_anchor);             \
  }

/// Maps white_clip to peak and remains flat above it.
/// Monotonic and C2 at the anchor and clip for valid ranges and power > 1.
#define APPLYNAKARUSHTON_CLIP_GENERATOR(T)                                                                                 \
  T ApplyNakaRushton(T color, T peak, T anchor, float compression_power, T white_clip) {                                   \
    T shoulder_range = peak - anchor;                                                                                      \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                                  \
    T input_range = white_clip - anchor;                                                                                   \
    T clipped_distance = min(distance_from_anchor, input_range);                                                           \
    T clip_position = clipped_distance / input_range;                                                                      \
    T position = clipped_distance / shoulder_range;                                                                        \
    T warp_base = (T)1.f - clip_position * clip_position * clip_position;                                                  \
    T response_scale = pow(warp_base * warp_base * warp_base + pow(position, compression_power), -rcp(compression_power)); \
    return mad(clipped_distance, response_scale, color - distance_from_anchor);                                            \
  }

APPLYNAKARUSHTON_GENERATOR(float)
APPLYNAKARUSHTON_GENERATOR(float3)
APPLYNAKARUSHTON_CLIP_GENERATOR(float)
APPLYNAKARUSHTON_CLIP_GENERATOR(float3)
#undef APPLYNAKARUSHTON_GENERATOR
#undef APPLYNAKARUSHTON_CLIP_GENERATOR

/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Zero strength is Neutwo; higher values
/// increase highlight compression. Requires anchor < peak and compression_strength >= 0.
#define APPLYANCHOREDNEUTWOSHOULDER_GENERATOR(T)                                         \
  T ApplyAnchoredNeutwoShoulder(T color, T peak, T anchor, float compression_strength) { \
    T shoulder_range = peak - anchor;                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                \
    T position = distance_from_anchor / shoulder_range;                                  \
    T position_three_halves = position * sqrt(position);                                 \
    T response_denominator_squared = mad(                                                \
        compression_strength, position_three_halves, mad(position, position, (T)1.f));   \
    T response = position * rsqrt(response_denominator_squared);                         \
    return mad(shoulder_range, response, color - distance_from_anchor);                  \
  }

/// Identity through anchor; reaches peak at clip, then remains flat.
/// The joins at the anchor and clip are C2 continuous for valid ranges.
#define APPLYANCHOREDNEUTWOSHOULDER_CLIP_GENERATOR(T)                                                    \
  T ApplyAnchoredNeutwoShoulder(T color, T peak, T anchor, float compression_strength, T clip) {         \
    T shoulder_range = peak - anchor;                                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                \
    T input_range = clip - anchor;                                                                       \
    T clipped_distance = min(distance_from_anchor, input_range);                                         \
    T clip_position = clipped_distance / input_range;                                                    \
    T position = clipped_distance / shoulder_range;                                                      \
    T position_three_halves = position * sqrt(position);                                                 \
    T residual_base = (T)1.f - clip_position * clip_position * clip_position;                            \
    T residual_weight = residual_base * residual_base * residual_base;                                   \
    T response_denominator_squared = mad(                                                                \
        residual_weight, mad(compression_strength, position_three_halves, (T)1.f), position * position); \
    T response = position * rsqrt(response_denominator_squared);                                         \
    return mad(shoulder_range, response, color - distance_from_anchor);                                  \
  }

APPLYANCHOREDNEUTWOSHOULDER_GENERATOR(float)
APPLYANCHOREDNEUTWOSHOULDER_GENERATOR(float3)
APPLYANCHOREDNEUTWOSHOULDER_CLIP_GENERATOR(float)
APPLYANCHOREDNEUTWOSHOULDER_CLIP_GENERATOR(float3)
#undef APPLYANCHOREDNEUTWOSHOULDER_GENERATOR
#undef APPLYANCHOREDNEUTWOSHOULDER_CLIP_GENERATOR

#define APPLYANCHOREDQUADRATICSHOULDER_GENERATOR(T)                                                     \
  T ApplyAnchoredQuadraticShoulder(T color, T peak, T anchor) {                                         \
    T shoulder_range = peak - anchor;                                                                   \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                               \
    T position = distance_from_anchor / shoulder_range;                                                 \
    T response = position * rsqrt(mad(position, position, (T)1.f));                                     \
    return mad(shoulder_range, response, color - distance_from_anchor);                                 \
  }                                                                                                     \
                                                                                                        \
  /* Adds detail-preserving compression while retaining the quadratic asymptote. */                     \
  /* Monotonic, concave down, and C2 at the anchor for compression_strength >= 0. */                    \
  T ApplyAnchoredQuadraticShoulder(T color, T peak, T anchor, float compression_strength) {             \
    T shoulder_range = peak - anchor;                                                                   \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                               \
    T position = distance_from_anchor / shoulder_range;                                                 \
    T position_squared = position * position;                                                           \
    T compression_term = compression_strength * position_squared / ((T)1.f + position);                 \
    T response_denominator_squared = mad(position, position, (T)1.f) + compression_term;                \
    T response = position * rsqrt(response_denominator_squared);                                        \
    return mad(shoulder_range, response, color - distance_from_anchor);                                 \
  }                                                                                                     \
                                                                                                        \
  /* Identity through anchor; reaches peak at clip, then remains flat. */                               \
  /* The joins at the anchor and clip are C2 continuous for valid ranges. */                            \
  T ApplyAnchoredQuadraticShoulder(T color, T peak, T anchor, float compression_strength, T clip) {     \
    T shoulder_range = peak - anchor;                                                                   \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                               \
    T input_range = clip - anchor;                                                                      \
    T clipped_distance = min(distance_from_anchor, input_range);                                        \
    T clip_position = clipped_distance / input_range;                                                   \
    T position = clipped_distance / shoulder_range;                                                     \
    T position_squared = position * position;                                                           \
    T compression_term = compression_strength * position_squared / ((T)1.f + position);                 \
    T residual_base = (T)1.f - clip_position * clip_position * clip_position;                           \
    T residual_weight = residual_base * residual_base * residual_base;                                  \
    T response_denominator_squared = mad(residual_weight, (T)1.f + compression_term, position_squared); \
    T response = position * rsqrt(response_denominator_squared);                                        \
    return mad(shoulder_range, response, color - distance_from_anchor);                                 \
  }

APPLYANCHOREDQUADRATICSHOULDER_GENERATOR(float)
APPLYANCHOREDQUADRATICSHOULDER_GENERATOR(float3)
#undef APPLYANCHOREDQUADRATICSHOULDER_GENERATOR

/// Rational approximation of the integrated quadratic Hill response:
/// 2 / PI * atan(PI / 2 * position). Maximum approximation error is 0.00027.
/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Requires anchor < peak.
#define APPLYANCHOREDHILLSHOULDER_GENERATOR(T)                                                            \
  T ApplyAnchoredHillShoulder(T color, T peak, T anchor) {                                                \
    T shoulder_range = peak - anchor;                                                                     \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                 \
    T position = distance_from_anchor / shoulder_range;                                                   \
    T position_squared = position * position;                                                             \
    T response_numerator = position * mad((T)2.678f, position_squared, mad((T)2.246f, position, (T)1.f)); \
    T response_residual = mad((T)1.102f, position_squared, mad((T)1.246f, position, (T)1.f));             \
    T response = response_numerator / (response_numerator + response_residual);                           \
    return mad(shoulder_range, response, color - distance_from_anchor);                                   \
  }                                                                                                       \
                                                                                                          \
  /* Reaches peak at clip and remains flat. Both joins are C2 continuous. */                              \
  /* Monotonic and concave down when clip >= anchor + 1.5 * (peak - anchor). */                           \
  T ApplyAnchoredHillShoulder(T color, T peak, T anchor, T clip) {                                        \
    T shoulder_range = peak - anchor;                                                                     \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                 \
    T input_range = clip - anchor;                                                                        \
    T clipped_distance = min(distance_from_anchor, input_range);                                          \
    T clip_position = clipped_distance / input_range;                                                     \
    T position = clipped_distance / shoulder_range;                                                       \
    T position_squared = position * position;                                                             \
    T response_numerator = position * mad((T)2.678f, position_squared, mad((T)2.246f, position, (T)1.f)); \
    T response_residual = mad((T)1.102f, position_squared, mad((T)1.246f, position, (T)1.f));             \
    T residual_base = (T)1.f - clip_position * clip_position * clip_position;                             \
    T residual_weight = residual_base * residual_base * residual_base;                                    \
    T response = response_numerator / mad(residual_weight, response_residual, response_numerator);        \
    return mad(shoulder_range, response, color - distance_from_anchor);                                   \
  }

APPLYANCHOREDHILLSHOULDER_GENERATOR(float)
APPLYANCHOREDHILLSHOULDER_GENERATOR(float3)
#undef APPLYANCHOREDHILLSHOULDER_GENERATOR

/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHOREDCUBICSHOULDER_GENERATOR(T)                                                          \
  T ApplyAnchoredCubicShoulder(T color, T peak, T anchor, float compression_strength) {                  \
    T shoulder_range = peak - anchor;                                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                \
    T weighted_distance = compression_strength * distance_from_anchor;                                   \
    T response_numerator = distance_from_anchor * (shoulder_range + weighted_distance);                  \
    T response_denominator = mad(                                                                        \
        shoulder_range, shoulder_range, weighted_distance * (shoulder_range + distance_from_anchor));    \
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor); \
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
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor);                    \
  }

APPLYANCHOREDCUBICSHOULDER_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_GENERATOR(float3)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float3)
#undef APPLYANCHOREDCUBICSHOULDER_GENERATOR
#undef APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR
