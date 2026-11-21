#include "./fsr_dispatch.hlsli"

cbuffer cbFsr : register(b0) {
  float4 scale_and_offset : packoffset(c0);
  float2 input_reciprocal_size : packoffset(c1);
  int sample_mode : packoffset(c4);
}

Texture2D<float4> source_texture : register(t0);
SamplerState source_sampler : register(s0);
RWTexture2D<float4> output_texture : register(u0);

void WriteScenePixel(uint2 pixel, uint2 output_size, bool native_resolution) {
  if (any(pixel >= output_size)) return;

  float3 color;
  [branch]
  if (native_resolution) {
    color = source_texture.Load(int3(pixel, 0)).rgb;
  } else {
    float2 source_pixel = float2(pixel) * scale_and_offset.xy + scale_and_offset.zw;
    color = source_texture.SampleLevel(source_sampler, (source_pixel + 0.5f) * input_reciprocal_size, 0).rgb;
  }
  output_texture[pixel] = float4(sample_mode == 1 ? color * color : color, 1.f);
}

[numthreads(64, 1, 1)]
void main(uint3 group : SV_GroupID, uint lane : SV_GroupIndex) {
  uint2 output_size;
  output_texture.GetDimensions(output_size.x, output_size.y);
  bool native_resolution = all(scale_and_offset == float4(1.f, 1.f, 0.f, 0.f));
  uint2 pixel = FsrTilePixel(group.xy, lane);
  WriteScenePixel(pixel, output_size, native_resolution);
  WriteScenePixel(pixel + uint2(8, 0), output_size, native_resolution);
  WriteScenePixel(pixel + uint2(0, 8), output_size, native_resolution);
  WriteScenePixel(pixel + uint2(8, 8), output_size, native_resolution);
}
