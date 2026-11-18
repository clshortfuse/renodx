#include "./shared.h"
#include "./fsr_dispatch.hlsli"

cbuffer cbFsr : register(b0) {
  int sample_mode : packoffset(c4);
}

Texture2D<float4> scene_texture : register(t0);
RWTexture2D<float4> output_texture : register(u0);

float ReadLuminance(int2 pixel, int2 scene_max, float encoding) {
  float3 encoded = scene_texture.Load(int3(clamp(pixel, int2(0, 0), scene_max), 0)).rgb;
  return max(0.f, renodx::color::y::from::BT709(renodx::draw::DecodeColor(encoded, encoding)));
}

// Lilium's luminance RCAS, adapted from RenoDX's Monster Hunter Rise implementation.
void WriteSharpenedPixel(uint2 pixel, uint2 output_size, int2 scene_max, float strength, float peak, float encoding) {
  if (any(pixel >= output_size)) return;

  float3 color = scene_texture.Load(int3(pixel, 0)).rgb;
  [branch]
  if (strength > 0.f) {
    float3 linear_color = renodx::draw::DecodeColor(color, encoding);
    float center = renodx::color::y::from::BT709(linear_color) / peak;
    if (center > 1e-6f) {
      int2 coord = int2(pixel);
      float north = ReadLuminance(coord + int2(0, -1), scene_max, encoding) / peak;
      float west = ReadLuminance(coord + int2(-1, 0), scene_max, encoding) / peak;
      float east = ReadLuminance(coord + int2(1, 0), scene_max, encoding) / peak;
      float south = ReadLuminance(coord + int2(0, 1), scene_max, encoding) / peak;

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
  output_texture[pixel] = float4(sample_mode == 1 ? color * color : color, 1.f);
}

[numthreads(64, 1, 1)]
void main(uint3 group : SV_GroupID, uint lane : SV_GroupIndex) {
  uint2 output_size, scene_size;
  output_texture.GetDimensions(output_size.x, output_size.y);
  scene_texture.GetDimensions(scene_size.x, scene_size.y);
  int2 scene_max = int2(scene_size) - 1;
  float strength = shader_injection.custom_rcas;
  float peak = max(RENODX_PEAK_WHITE_NITS / max(RENODX_GRAPHICS_WHITE_NITS, 1.f), 1e-6f);
  float encoding = RENODX_INTERMEDIATE_ENCODING;
  uint2 pixel = FsrTilePixel(group.xy, lane);
  WriteSharpenedPixel(pixel, output_size, scene_max, strength, peak, encoding);
  WriteSharpenedPixel(pixel + uint2(8, 0), output_size, scene_max, strength, peak, encoding);
  WriteSharpenedPixel(pixel + uint2(0, 8), output_size, scene_max, strength, peak, encoding);
  WriteSharpenedPixel(pixel + uint2(8, 8), output_size, scene_max, strength, peak, encoding);
}
