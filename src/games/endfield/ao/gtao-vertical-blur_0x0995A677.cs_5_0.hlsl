#include "../shared.h"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

RWTexture2D<unorm float4> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID) {
  if (shader_injection.disable_game_ao >= 0.5f) {
    u0[vThreadID.xy] = 1.0;
    return;
  }

  float2 pixel = float2(vThreadID.xy) + 0.5;
  float2 uv = pixel * cb0[4].zw;

  float radius_scale = 1.0 - t1.SampleLevel(s0_s, uv, 0).z;
  radius_scale = saturate(radius_scale + radius_scale);
  radius_scale *= AO_DENOISER_BLUR_BETA;

  float center_depth = t0.SampleLevel(s0_s, uv, 0).x;
  float2 texel_size = cb0[4].zw;

  float2 offset = 0.0;
  float3 accum = float3(0.0, 0.0, -1.0);

  [loop]
  while (true) {
    if (1.0 < accum.z) break;

    float2 step_offset = float2(0.0, accum.z * texel_size.y * radius_scale);

    float2 depth_uv = step_offset * cb0[4].zw + uv;
    float sample_depth = t0.SampleLevel(s0_s, depth_uv, 0).x;
    float weight = 1.0 - min(1.0, abs(sample_depth - center_depth));

    float2 ao_uv = pixel * cb0[4].zw + step_offset;
    float ao = t2.SampleLevel(s1_s, ao_uv, 0).x;

    accum = float3(accum.x + weight, accum.y + ao * weight, accum.z + 1.0);
  }

  float result = accum.y / max(9.99999975e-05, accum.x);
  u0[vThreadID.xy] = result.xxxx;
}
