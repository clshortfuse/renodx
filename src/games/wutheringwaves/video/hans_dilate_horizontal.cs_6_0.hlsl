#include "video_commons.hlsli"

Texture2D<float4> source_texture : register(t0);
RWTexture2D<float4> destination_texture : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 id : SV_DispatchThreadID) {
  if (id.x >= hans_output_size.x || id.y >= hans_output_size.y) return;
  uint radius = HAnSRadius();
  float3 result = 0.0f.xxx;
  for (int offset = -12; offset <= 12; ++offset) {
    if (abs(offset) <= radius) result = max(result, source_texture.Load(int3(HAnSClamp(id.xy + uint2(offset, 0)), 0)).rgb);
  }
  destination_texture[id.xy] = float4(result, 1.0f);
}
