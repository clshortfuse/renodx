#include "video_commons.hlsli"

Texture2D<float4> source_texture : register(t0);
SamplerState source_sampler : register(s0);
Texture2D<float4> hans_map : register(t1);

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  const float4 video = source_texture.SampleLevel(source_sampler, uv, 0.0f);
  const float hans_local_map = hans_map.SampleLevel(source_sampler, uv, 0.0f).r;
  const float3 result = AutoHDRVideo(video.rgb, position.xy, hans_local_map);
  return float4(result, video.a);
}


