#ifndef RENODX_SHADERS_TONEMAP_SMOOTH_SHOULDER_HLSL_
#define RENODX_SHADERS_TONEMAP_SMOOTH_SHOULDER_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace tonemap {

/// Scalar/per-channel smooth asymptotic shoulder.
/// Identity through anchor to every derivative, then asymptotically approaches peak.
/// Monotonic and concave down.
/// compression_strength controls how quickly the curve departs from identity.
/// Requires anchor < peak and compression_strength >= 1.
#define SMOOTH_SHOULDER_GENERATOR(T)                                                        \
  T SmoothShoulder(T color, T peak, T anchor = 0.18f, float compression_strength = 1.5f) {  \
    T shoulder_range = peak - anchor;                                                       \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                   \
    T inverse_position = shoulder_range * rcp(compression_strength * distance_from_anchor); \
    T flat_weight = exp2(-inverse_position);                                                \
    T response_denominator = mad(compression_strength, inverse_position, flat_weight);      \
    return mad(shoulder_range, rcp(response_denominator), color - distance_from_anchor);    \
  }

SMOOTH_SHOULDER_GENERATOR(float)
SMOOTH_SHOULDER_GENERATOR(float3)

#undef SMOOTH_SHOULDER_GENERATOR

namespace smoothshoulder {

/// Computes a uniform RGB scale from the largest absolute channel magnitude after applying SmoothShoulder.
/// Preserves RGB ratios when the returned scale is applied to the original color.
/// Useful for compressing HDR colors into the input range of an SDR LUT without per-channel hue shifts.
float ComputeMaxChannelScale(float3 color, float peak, float anchor = 0.18f, float compression_strength = 1.5f) {
  float max_channel = renodx::math::Max(abs(color));
  float new_max = renodx::tonemap::SmoothShoulder(max_channel, peak, anchor, compression_strength);
  return max_channel != 0.f ? new_max / max_channel : 1.f;
}

/// Applies SmoothShoulder using a uniform scale derived from the largest absolute channel magnitude.
/// Preserves RGB ratios while compressing the largest channel magnitude toward peak.
float3 MaxChannel(float3 color, float peak, float anchor = 0.18f, float compression_strength = 1.5f) {
  return color * ComputeMaxChannelScale(color, peak, anchor, compression_strength);
}

}  // namespace smoothshoulder
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_SMOOTH_SHOULDER_HLSL_