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
  float4 _11 = t0_space2.SampleLevel(s0_space99, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _15 = _11.x * TEXCOORD_1;
  float _16 = _11.y * TEXCOORD_1;
  float _17 = _11.z * TEXCOORD_1;
  float4 _18 = t3_space2.Sample(s0_space3, float2(TEXCOORD.x, TEXCOORD.y));

  _18.rgb *= CUSTOM_BLOOM;
  float3 bloom_color = _18.rgb;

#if 1
  float3 scene_color = float3(_15, _16, _17);
  float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;
  float scene_luminance = renodx::color::y::from::BT709(scene_color) * mid_gray_bloomed;
  float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
  float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
  bloom_color = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * 0.5f);
#endif

  float _23 = bloom_color.x + _15;
  float _24 = bloom_color.y + _16;
  float _25 = bloom_color.z + _17;
  float _28 = cb0_space2_000y * _18.w;
  float _29 = _28 + 1.0f;
  float _30 = 1.0f / _29;
  float _31 = _23 * _30;
  float _32 = _24 * _30;
  float _33 = _25 * _30;
  float _34 = TEXCOORD.x + -0.5f;
  float _35 = TEXCOORD.y + -0.5f;
  float _37 = dot(float2(_34, _35), float2(_34, _35));
  float _38 = 1.0f - _37;
  float _39 = saturate(_38);
  float _40 = log2(_39);
  float _41 = _40 * cb0_space2_000x;
  float _42 = exp2(_41);
  float _43 = _31 * _42;
  float _44 = _32 * _42;
  float _45 = _33 * _42;
  float _46 = log2(_43);
  float _47 = _46 * 0.05000000074505806f;
  float _48 = _47 + 0.6236965656280518f;
  float _49 = log2(_44);
  float _50 = _49 * 0.05000000074505806f;
  float _51 = _50 + 0.6236965656280518f;
  float _52 = log2(_45);
  float _53 = _52 * 0.05000000074505806f;
  float _54 = _53 + 0.6236965656280518f;
  float _55 = saturate(_48);
  float _56 = saturate(_51);
  float _57 = saturate(_54);
  float _58 = _55 * 0.96875f;
  float _59 = _56 * 0.96875f;
  float _60 = _57 * 0.96875f;
  float _61 = _58 + 0.015625f;
  float _62 = _59 + 0.015625f;
  float _63 = _60 + 0.015625f;
  float4 _64 = t4_space2.SampleLevel(s1_space3, float3(_61, _62, _63), 0.0f);
  SV_Target.x = _64.x;
  SV_Target.y = _64.y;
  SV_Target.z = _64.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
