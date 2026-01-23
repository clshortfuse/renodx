#include "./shared.h"

Texture2D<float4> t0_space2 : register(t0, space2);

Texture2D<float4> t3_space2 : register(t3, space2);

Texture3D<float4> t4_space2 : register(t4, space2);

cbuffer cb0_space2 : register(b0, space2) {
  float cb0_space2_000x : packoffset(c000.x);
  float cb0_space2_000y : packoffset(c000.y);
};

SamplerState s0_space99 : register(s0, space99);

SamplerState s0_space3 : register(s0, space3);

SamplerState s1_space3 : register(s1, space3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    nointerpolation float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _11 = t0_space2.SampleLevel(s0_space99, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);  // main render
  float _15 = TEXCOORD_1 * 1.25f;
  _11.rgb *= _15;

  float4 _19 = t3_space2.Sample(s0_space3, float2(TEXCOORD.x, TEXCOORD.y));  // bloom

  _19.rgb *= CUSTOM_BLOOM;
  float3 bloom_color = _19.rgb;

#if 1
  float3 scene_color = _11.rgb;
  float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;
  float scene_luminance = renodx::color::y::from::BT709(scene_color) * mid_gray_bloomed;
  float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
  float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
  bloom_color = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * 0.5f);
#endif

  float _31 = 1.0f / ((cb0_space2_000y * _19.w) + 1.0f);
  float _35 = TEXCOORD.x + -0.5f;
  float _36 = TEXCOORD.y + -0.5f;
  float _43 = exp2(log2(saturate(1.0f - dot(float2(_35, _36), float2(_35, _36)))) * cb0_space2_000x);
  float4 _65 = t4_space2.SampleLevel(
      s1_space3,
      float3(
          ((saturate((log2(((bloom_color.x + (_11.x)) * _31) * _43) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f),
          ((saturate((log2(((bloom_color.y + (_11.y)) * _31) * _43) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f),
          ((saturate((log2(((bloom_color.z + (_11.z)) * _31) * _43) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f)),
      0.0f);
  SV_Target.x = _65.x;
  SV_Target.y = _65.y;
  SV_Target.z = _65.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
