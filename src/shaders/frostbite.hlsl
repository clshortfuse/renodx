#ifndef SRC_SHADERS_FROSTBITE_HLSL_
#define SRC_SHADERS_FROSTBITE_HLSL_

#include "./math.hlsl"

namespace renodx {
namespace tonemap {
namespace frostbite {

// Frostbite Engine tone mapping
// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite

// Aplies exponential ("Photographic") luma compression
float rangeCompress(float x) {
  return 1.0 - exp(-x);
}

float rangeCompress(float val, float threshold, float max_value = 1.f) {
  if (val < threshold) return val;
  if (max_value <= threshold) return threshold;
  float range = max_value - threshold;
  return threshold + range * rangeCompress((val - threshold) / range);
}

float3 rangeCompress(float3 val, float threshold, float max_value = 1.f) {
  return float3(
      rangeCompress(val.x, threshold, max_value),
      rangeCompress(val.y, threshold, max_value),
      rangeCompress(val.z, threshold, max_value));
}

float3 BT709(float3 col, float max_value) {
  float3 ictcp = renodx::color::ictcp::from::BT709(col);

  // Hue-preserving range compression requires desaturation in order to achieve a natural look. We adaptively desaturate the input based on its luminance.

  float saturationAmount = pow(smoothstep(1.0, 0.3, ictcp.x), 1.3);
  col = renodx::color::bt709::from::ICtCp(ictcp * float3(1, saturationAmount.xx));

  // Only compress luminance starting at a certain point. Dimmer inputs are passed through without modification.
  float linearSegmentEnd = 0.25;

  // Hue-preserving mapping
  float maxCol = max(col.x, max(col.y, col.z));
  float mappedMax = rangeCompress(maxCol, linearSegmentEnd, max_value);
  float3 compressedHuePreserving = col * mappedMax / maxCol;

  // Non-hue preserving mapping
  float3 perChannelCompressed = rangeCompress(col, linearSegmentEnd, max_value);

  // Combine hue-preserving and non-hue-preserving colors. Absolute hue preservation looks unnatural, as bright colors *appear* to have been hue shifted.
  // Actually doing some amount of hue shifting looks more pleasing
  col = lerp(perChannelCompressed, compressedHuePreserving, 0.6);

  float3 ictcpMapped = renodx::color::ictcp::from::BT709(col);

  // Smoothly ramp off saturation as brightness increases, but keep some even for very bright input
  float postCompressionSaturationBoost = 0.3 * smoothstep(1.0, 0.5, ictcp.x);

  // Re-introduce some hue from the pre-compression color. Something similar could be accomplished by delaying the luma-dependent desaturation before range compression.
  // Doing it here however does a better job of preserving perceptual luminance of highly saturated colors. Because in the hue-preserving path we only range-compress the max channel,
  // saturated colors lose luminance. By desaturating them more aggressively first, compressing, and then re-adding some saturation, we can preserve their brightness to a greater extent.
  ictcpMapped.yz = lerp(ictcpMapped.yz, ictcp.yz * ictcpMapped.x / max(1e-3, ictcp.x), postCompressionSaturationBoost);

  col = renodx::color::bt709::from::ICtCp(ictcpMapped);

  return col;
}

}  // namespace frostbite
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_FROSTBITE_HLSL_