#ifndef SRC_SHADERS_FROSTBITE_HLSL_
#define SRC_SHADERS_FROSTBITE_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace tonemap {
namespace frostbite {

// Frostbite Engine tone mapping
// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite

// Aplies exponential ("Photographic") luma compression
float RangeCompress(float x) {
  return 1.0 - exp(-x);
}

float RangeCompress(float val, float threshold, float max_value = 1.f) {
  if (val < threshold) {
    return val;
  } else if (max_value <= threshold) {
    return threshold;
  } else {
    float range = max_value - threshold;
    return threshold + range * RangeCompress((val - threshold) / range);
  }
}

float3 RangeCompress(float3 val, float threshold, float max_value = 1.f) {
  return float3(
      RangeCompress(val.x, threshold, max_value),
      RangeCompress(val.y, threshold, max_value),
      RangeCompress(val.z, threshold, max_value));
}

float3 BT709(float3 col, float max_value = 1.f, float rolloff_start = 0.25f, float saturation_boost_amount = 0.3f, float hue_correct_amount = 0.6f, uint hue_processor = 1u) {
  float3 perceptual;
  if (hue_processor == 3u) {
    perceptual = renodx::color::dtucs::uvY::from::BT709(col).zxy;
  } else if (hue_processor == 2u) {
    perceptual = renodx::color::oklab::from::BT709(col);
  } else {
    perceptual = renodx::color::ictcp::from::BT709(col);
  }

  // Hue-preserving range compression requires desaturation in order to achieve a natural look. We adaptively desaturate the input based on its luminance.

  float saturationAmount = pow(smoothstep(1.0, 0.3, perceptual.x), 1.3);
  if (hue_processor == 3u) {
    col = renodx::color::bt709::from::dtucs::uvY((perceptual * float3(1, saturationAmount.xx)).yzx);
  } else if (hue_processor == 2u) {
    col = renodx::color::bt709::from::OkLab(perceptual * float3(1, saturationAmount.xx));
  } else {
    col = renodx::color::bt709::from::ICtCp(perceptual * float3(1, saturationAmount.xx));
  }

  // Only compress luminance starting at a certain point. Dimmer inputs are passed through without modification.
  float linearSegmentEnd = rolloff_start;

  // Hue-preserving mapping
  float maxCol = max(col.x, max(col.y, col.z));
  float mappedMax = RangeCompress(maxCol, linearSegmentEnd, max_value);
  float3 compressedHuePreserving = col * mappedMax / maxCol;

  // Non-hue preserving mapping
  float3 perChannelCompressed = RangeCompress(col, linearSegmentEnd, max_value);

  // Combine hue-preserving and non-hue-preserving colors. Absolute hue preservation looks unnatural, as bright colors *appear* to have been hue shifted.
  // Actually doing some amount of hue shifting looks more pleasing
  col = lerp(perChannelCompressed, compressedHuePreserving, hue_correct_amount);

  float3 perceptualMapped;
  if (hue_processor == 3u) {
    perceptualMapped = renodx::color::dtucs::uvY::from::BT709(col).zxy;
  } else if (hue_processor == 2u) {
    perceptualMapped = renodx::color::oklab::from::BT709(col);
  } else {
    perceptualMapped = renodx::color::ictcp::from::BT709(col);
  }

  // Smoothly ramp off saturation as brightness increases, but keep some even for very bright input
  float postCompressionSaturationBoost = saturation_boost_amount * smoothstep(1.0, 0.5, perceptual.x);

  // Re-introduce some hue from the pre-compression color. Something similar could be accomplished by delaying the luma-dependent desaturation before range compression.
  // Doing it here however does a better job of preserving perceptual luminance of highly saturated colors. Because in the hue-preserving path we only range-compress the max channel,
  // saturated colors lose luminance. By desaturating them more aggressively first, compressing, and then re-adding some saturation, we can preserve their brightness to a greater extent.
  perceptualMapped.yz = lerp(perceptualMapped.yz, perceptual.yz * perceptualMapped.x / max(1e-3, perceptual.x), postCompressionSaturationBoost);

  if (hue_processor == 3u) {
    col = renodx::color::bt709::from::dtucs::uvY(perceptualMapped.yzx);
  } else if (hue_processor == 2u) {
    col = renodx::color::bt709::from::OkLab(perceptualMapped);
  } else {
    col = renodx::color::bt709::from::ICtCp(perceptualMapped);
  }

  return col;
}

}  // namespace frostbite
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_FROSTBITE_HLSL_
