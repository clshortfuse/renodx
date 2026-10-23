#include "./shared.h"

namespace tlou2 {
namespace tonemap {

// Native curve:
//              A * x + B
//   T(x) = ------------------ + E
//           x * (x + C) + D
#define TLOU2_TONEMAP_APPLY_GENERATOR(T)                      \
  T Apply(T x, float A, float B, float C, float D, float E) { \
    return ((A * x) + B) / ((x * (x + C)) + D) + E;           \
  }

TLOU2_TONEMAP_APPLY_GENERATOR(float)
TLOU2_TONEMAP_APPLY_GENERATOR(float3)
#undef TLOU2_TONEMAP_APPLY_GENERATOR

float Derivative(float x, float A, float B, float C, float D) {
  float Denominator = (x * (x + C)) + D;
  float Numerator = (-A * x * x) - (2.f * B * x) + (A * D) - (B * C);
  return Numerator / (Denominator * Denominator);
}

// T''(x) = 2 * (A * (-C*D - 3*D*x + x^3)
//                   + B * (C^2 + 3*C*x - D + 3*x^2))
//          / (D + x * (C + x))^3
// Find the largest non-negative root of its cubic numerator. The additive
// offset E does not affect either derivative.
float FindInflectionPoint(float A, float B, float C, float D) {
  float A3 = A;
  float A2 = 3.f * B;
  float A1 = 3.f * ((B * C) - (A * D));
  float A0 = (B * C * C) - (A * C * D) - (B * D);
  float A3Rcp = 1.f / A3;

  float P = (3.f * A1 * A3 - A2 * A2) / (3.f * A3 * A3);
  float Q = (27.f * A0 * A3 * A3 - 9.f * A2 * A1 * A3 + 2.f * A2 * A2 * A2)
            / (27.f * A3 * A3 * A3);
  float Delta = (Q * Q) / 4.f + (P * P * P) / 27.f;
  float Root;

  if (Delta >= 0.f) {
    float SqrtDelta = sqrt(Delta);
    Root = renodx::math::Cbrt(-Q * 0.5f + SqrtDelta) + renodx::math::Cbrt(-Q * 0.5f - SqrtDelta);
  } else {
    float PositivePOver3 = -P / 3.f;
    float Angle = acos(clamp((-Q * 0.5f) * rsqrt(PositivePOver3 * PositivePOver3 * PositivePOver3), -1.f, 1.f));
    Root = 2.f * sqrt(PositivePOver3) * cos(Angle / 3.f);
  }

  return max(Root - (A2 * A3Rcp / 3.f), 0.f);
}

#define TLOU2_TONEMAP_APPLY_EXTENDED_GENERATOR(T)                                              \
  T ApplyExtended(T x, float A, float B, float C, float D, float E, inout float InflectionY) { \
    float PivotX = FindInflectionPoint(A, B, C, D);                                            \
    InflectionY = Apply(PivotX, A, B, C, D, E);                                                \
    float Slope = Derivative(PivotX, A, B, C, D);                                              \
    T Extended = InflectionY + (Slope * (x - PivotX));                                         \
    return renodx::math::Select(x > PivotX, Extended, Apply(x, A, B, C, D, E));                \
  }                                                                                            \
                                                                                               \
  T ApplyExtended(T x, float A, float B, float C, float D, float E) {                          \
    float InflectionY;                                                                         \
    return ApplyExtended(x, A, B, C, D, E, InflectionY);                                       \
  }

TLOU2_TONEMAP_APPLY_EXTENDED_GENERATOR(float)
TLOU2_TONEMAP_APPLY_EXTENDED_GENERATOR(float3)
#undef TLOU2_TONEMAP_APPLY_EXTENDED_GENERATOR

}  // namespace tonemap
}  // namespace tlou2

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

float ApplyAnchoredCInfinityShoulderMaxChannelScale(float3 color, float peak = 1.f, float anchor = 0.18f, float compression_strength = 100.f) {
  float max_channel = renodx::math::Max(abs(color));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_max, max_channel, 1.f);
}

float ApplyAnchoredCInfinityShoulderLuminanceScale(float3 color, float peak = 1.f, float anchor = 0.18f, float compression_strength = 100.f) {
  float luminance = renodx::color::yf::from::BT709(color);
  float compressed_luminance = ApplyAnchoredCInfinityShoulder(luminance, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_luminance, luminance, 1.f);
}

namespace tlou2 {
namespace post_post_processing {

// Final post-post-processing adjustment hook. The input and output are
// extended-range gamma-encoded BT.709; decode and re-encode here before
// performing operations that require linear light.
float3 ApplyFinalOutput(float3 color, float2 texcoord) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    } else if (RENODX_GAMMA_CORRECTION == 2.f) {
      color = renodx::color::gamma::DecodeSafe(color, 2.41f);
    } else {
      color = renodx::color::srgb::DecodeSafe(color);
    }
    if (RENODX_TONE_MAP_TYPE == 1.f) {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color = ApplyAnchoredCInfinityShoulder(color, peak_ratio, 0.4f, 1.f);
    }
    if (CUSTOM_GRAIN_TYPE != 0.f) {
      color = renodx::effects::ApplyFilmGrain(color, texcoord, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.03f);
    }

    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

    if (RENODX_GAMMA_CORRECTION == 1.f) {
      color = renodx::color::gamma::EncodeSafe(color, 2.2f);
    } else if (RENODX_GAMMA_CORRECTION == 2.f) {
      color = renodx::color::gamma::EncodeSafe(color, 2.41f);
    } else {
      color = renodx::color::srgb::EncodeSafe(color);
    }
  }
  return color;
}

}  // namespace post_processing
}  // namespace tlou2
