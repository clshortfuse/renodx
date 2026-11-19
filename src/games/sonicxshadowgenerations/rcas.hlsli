#ifndef SONIC_X_SHADOW_GENERATIONS_RCAS_HLSLI_
#define SONIC_X_SHADOW_GENERATIONS_RCAS_HLSLI_

#include "./shared.h"

float ReadLuminance(Texture2D<float4> scene, int2 pixel, int2 scene_max, float encoding) {
  float3 encoded = scene.Load(int3(clamp(pixel, int2(0, 0), scene_max), 0)).rgb;
  return max(0.f, renodx::color::y::from::BT709(renodx::draw::DecodeColor(encoded, encoding)));
}

// Lilium's luminance RCAS, adapted from RenoDX's Monster Hunter Rise implementation.
// Returns the sharpened color in the same encoding as the input.
float3 ApplyLiliumRCAS(Texture2D<float4> scene, int2 pixel, int2 scene_max, float strength, float peak, float encoding) {
  float3 color = scene.Load(int3(pixel, 0)).rgb;
  [branch]
  if (strength > 0.f) {
    float3 linear_color = renodx::draw::DecodeColor(color, encoding);
    float center = renodx::color::y::from::BT709(linear_color) / peak;
    if (center > 1e-6f) {
      float north = ReadLuminance(scene, pixel + int2(0, -1), scene_max, encoding) / peak;
      float west = ReadLuminance(scene, pixel + int2(-1, 0), scene_max, encoding) / peak;
      float east = ReadLuminance(scene, pixel + int2(1, 0), scene_max, encoding) / peak;
      float south = ReadLuminance(scene, pixel + int2(0, 1), scene_max, encoding) / peak;

      float ring_min = min(min(north, west), min(east, south));
      float ring_max = max(max(north, west), max(east, south));
      float limit = min(ring_max, 0.99f);
      float hit_min = ring_min / max(4.f * limit, 1e-6f);
      float hit_max = -(1.f - limit) / max(4.f * (1.f - ring_min), 1e-6f);
      float lobe = clamp(max(-hit_min, hit_max), -0.1875f, 0.f) * strength;

      float ring_sum = north + west + east + south;
      float contrast = max(ring_max, center) - min(ring_min, center);
      float noise = saturate(abs(0.25f * ring_sum - center) / max(contrast, 1e-6f));
      lobe *= 1.f - 0.5f * noise;

      float sharpened = (center + lobe * ring_sum) / (1.f + 4.f * lobe);
      float3 display_color = renodx::color::bt2020::from::BT709(linear_color);
      float max_channel = max(display_color.r, max(display_color.g, display_color.b));
      // Cap added gain at the output peak while retaining existing highlight headroom.
      float max_gain = max(1.f, peak / max(max_channel, 1e-6f));
      float gain = clamp(sharpened / center, 0.f, min(4.f, max_gain));
      color = renodx::draw::EncodeColor(linear_color * gain, encoding);
    }
  }
  return color;
}

#endif
