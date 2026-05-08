#include "../shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

struct VSOutput {
  float4 position : SV_POSITION0;
  float3 texcoord : TEXCOORD0;
};

VSOutput main(float4 v0 : POSITION0, float3 v1 : TEXCOORD0, uint vertex_id : SV_VertexID) {
  VSOutput output;

  if (CUSTOM_VIDEO_PLAYBACK_SEEN > 0.5f) {
    float z = v1.z;
    if (vertex_id == 0u) {
      output.position = float4(-1.f, 1.f, 0.f, 1.f);
      output.texcoord = float3(0.f, 0.f, z);
    } else if (vertex_id == 1u) {
      output.position = float4(3.f, 1.f, 0.f, 1.f);
      output.texcoord = float3(cb0[0].x * 2.f, 0.f, z);
    } else {
      output.position = float4(-1.f, -3.f, 0.f, 1.f);
      output.texcoord = float3(0.f, cb0[0].y * 2.f, z);
    }
  } else {
    float2 inv_size = 1.f / max(cb0[0].xy, 1.f.xx);
    float2 clip_xy = v0.xy * inv_size * float2(2.f, -2.f) + float2(-1.f, 1.f);

    output.position = float4(clip_xy, 0.f, 1.f);
    output.texcoord = v1;
  }

  return output;
}
