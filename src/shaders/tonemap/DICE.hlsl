#ifndef SRC_SHADERS_DICE_HLSL_
#define SRC_SHADERS_DICE_HLSL_

#include "../color.hlsl"
#include "../math.hlsl"

namespace renodx {
namespace tonemap {
namespace dice {
namespace internal {

// Aplies exponential ("Photographic") luminance/luma compression.
// The pow can modulate the curve without changing the values around the edges.
float RangeCompress(float x, float max_value = asfloat(0x7F7FFFFF), float modulation = 1.f) {
  // Branches are for static parameters optimizations
  if (modulation == 1.f && max_value == renodx::math::FLT_MAX) {
    // This does e^X. We expect X to be between 0 and 1.
    return 1.f - exp(-x);
  }
  if (modulation == 1.f && max_value != renodx::math::FLT_MAX) {
    const float lost_range = exp(-max_value);
    const float restore_range_scale = 1.f / (1.f - lost_range);
    return (1.f - exp(-x)) * restore_range_scale;
  }
  if (modulation != 1.f && max_value == renodx::math::FLT_MAX) {
    return (1.f - pow(exp(-x), modulation));
  }
  const float lost_range = pow(exp(-max_value), modulation);
  const float restore_range_scale = 1.f / (1.f - lost_range);
  return (1.f - pow(exp(-x), modulation)) * restore_range_scale;
}

// Refurbished DICE HDR tonemapper (per channel or luminance)
float LuminanceCompress(float value_in, float value_out_max, float shoulder_start = 0.f, bool use_value_max = false,
                        float value_in_max = asfloat(0x7F7FFFFF), float modulation_pow = 1.f) {
  const float compressable_value = value_in - shoulder_start;
  const float compressable_range = value_in_max - shoulder_start;
  const float compressed_range = max(value_out_max - shoulder_start, renodx::math::FLT_MIN);
  const float possible_out_value =
      shoulder_start
      + (compressed_range
         * internal::RangeCompress(compressable_value / compressed_range,
                                   use_value_max ? (compressable_range / compressed_range) : renodx::math::FLT_MAX,
                                   modulation_pow));
  return (value_in <= shoulder_start) ? value_in : possible_out_value;
}

}  // namespace internal

// Tonemapper inspired from DICE. Can work by luminance to maintain hue.
// "highlights_shoulder_start" should be between 0 and 1. Determines where the highlights curve (shoulder) starts.
// Leaving at zero for now as it's a simple and good looking default.
float3 BT709(float3 color, float output_luminance_max, float highlights_shoulder_start = 0.f,
             float highlights_modulation_pow = 1.f) {
  const float source_luminance = renodx::color::y::from::BT709(color);
  if (source_luminance > 0.0f) {
    const float compressed_luminance =
        internal::LuminanceCompress(source_luminance, output_luminance_max, highlights_shoulder_start, false,
                                    renodx::math::FLT_MAX, highlights_modulation_pow);
    color *= compressed_luminance / source_luminance;
  }
  return color;

#if 0  // NOLINT By channel implementation
  color.r = internal::LuminanceCompress(color.r, output_luminance_max, highlights_shoulder_start, false,
                                        renodx::math::FLT_MAX, highlights_modulation_pow);
  color.g = internal::LuminanceCompress(color.g, output_luminance_max, highlights_shoulder_start, false,
                                        renodx::math::FLT_MAX, highlights_modulation_pow);
  color.b = internal::LuminanceCompress(color.b, output_luminance_max, highlights_shoulder_start, false,
                                        renodx::math::FLT_MAX, highlights_modulation_pow);
  return color;
#endif
}

}  // namespace dice
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_DICE_HLSL_
