#include "./shared.h"

cbuffer _Globals : register(b1) {
  float4 u_param[3] : packoffset(c0);
}

SamplerState scene_sampler : register(s0);
Texture2D<float4> scene_texture : register(t0);

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float strength = shader_injection.chromatic_aberration;
  if (strength <= 0.f) return scene_texture.Sample(scene_sampler, uv);

  float2 base_uv = uv * u_param[2].zw;
  float2 radial = 2.f * (base_uv - u_param[1].zw);
  float radius_squared = dot(radial, radial);
  if (radius_squared > 0.f) {
    radial *= exp2(u_param[0].w * log2(radius_squared));
  }
  float3 offsets = u_param[0].xyz * strength;
  float2 red_uv = u_param[2].xy * saturate((radial * offsets.x) * u_param[1].xy + base_uv);
  float2 green_uv = u_param[2].xy * saturate((radial * offsets.y) * u_param[1].xy + base_uv);
  float2 blue_uv = u_param[2].xy * saturate((radial * offsets.z) * u_param[1].xy + base_uv);

  return float4(scene_texture.Sample(scene_sampler, red_uv).r,
                scene_texture.Sample(scene_sampler, green_uv).g,
                scene_texture.Sample(scene_sampler, blue_uv).b,
                scene_texture.Sample(scene_sampler, uv).a);
}
