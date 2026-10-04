#include "video_commons.hlsli"

Texture2D<float4> source_texture : register(t0);
Texture2D<float4> dilated_texture : register(t1);
RWTexture2D<float4> destination_texture : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 id : SV_DispatchThreadID) {
  if (id.x >= hans_output_size.x || id.y >= hans_output_size.y) return;
  float3 feature = source_texture.Load(int3(id.xy, 0)).rgb;
  float3 dilated = dilated_texture.Load(int3(id.xy, 0)).rgb;
  float3 local_contrast = max(feature - dilated, 0.0f.xxx);
  float3 soft = rcp(1.0f.xxx + exp(clamp(
      -20.0f.xxx * (local_contrast - HANS_THRESHOLD.xxx), -20.0f.xxx, 20.0f.xxx)));
  float3 feature_maps = feature * soft;
  float fused = max(feature_maps.r, max(feature_maps.g, feature_maps.b));
  destination_texture[id.xy] = float4(fused, feature_maps);
}
