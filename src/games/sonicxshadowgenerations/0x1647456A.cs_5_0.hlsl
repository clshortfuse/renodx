#include "./shared.h"
#include "./fsr_dispatch.hlsli"
#include "./rcas.hlsli"

cbuffer cbFsr : register(b0) {
  int sample_mode : packoffset(c4);
}

Texture2D<float4> scene_texture : register(t0);
RWTexture2D<float4> output_texture : register(u0);

void WriteSharpenedPixel(uint2 pixel, uint2 output_size, int2 scene_max, float strength, float peak, float encoding) {
  if (any(pixel >= output_size)) return;

  float3 color = ApplyLiliumRCAS(scene_texture, int2(pixel), scene_max, strength, peak, encoding);
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
