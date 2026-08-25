#include "video_commons.hlsli"

Texture2D<float4> source_texture : register(t0);
RWTexture2D<float4> destination_texture : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 id : SV_DispatchThreadID) {
  if (id.x >= hans_output_size.x || id.y >= hans_output_size.y) return;
  uint2 base = id.xy * 2u;
  float3 color = 0.0f.xxx;
  color += source_texture.Load(int3(HAnSClamp(base), 0)).rgb;
  color += source_texture.Load(int3(HAnSClamp(base + uint2(1, 0)), 0)).rgb;
  color += source_texture.Load(int3(HAnSClamp(base + uint2(0, 1)), 0)).rgb;
  color += source_texture.Load(int3(HAnSClamp(base + uint2(1, 1)), 0)).rgb;
  color = HAnSAnalysisColor(color * 0.25f);
  destination_texture[id.xy] = float4(min(color.r, min(color.g, color.b)), HAnSLuma(color), max(color.r, max(color.g, color.b)), 1.0f);
}
