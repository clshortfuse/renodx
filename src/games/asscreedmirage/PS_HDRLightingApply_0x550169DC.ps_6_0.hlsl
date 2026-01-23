#include "./shared.h"

Texture2D<float4> t0_space2 : register(t0, space2);

Texture2D<float4> t3_space2 : register(t3, space2);

Texture3D<float4> t4_space2 : register(t4, space2);

Texture3D<float4> t5_space2 : register(t5, space2);

Texture3D<float4> t6_space2 : register(t6, space2);

cbuffer cb0_space2 : register(b0, space2) {
  float cb0_space2_000x : packoffset(c000.x);
  float cb0_space2_000y : packoffset(c000.y);
  int cb0_space2_000z : packoffset(c000.z);
  float cb0_space2_006x : packoffset(c006.x);
};

SamplerState s0_space99 : register(s0, space99);

SamplerState s2_space98 : register(s2, space98);

SamplerState s0_space3 : register(s0, space3);

SamplerState s1_space3 : register(s1, space3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    nointerpolation float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _14 = t0_space2.SampleLevel(s0_space99, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);  // main render
  float _18 = TEXCOORD_1 * 1.25f;
  _14.rgb *= _18;

  float4 _22 = t3_space2.Sample(s0_space3, float2(TEXCOORD.x, TEXCOORD.y));  // bloom

  _22.rgb *= CUSTOM_BLOOM;
  float3 bloom_color = _22.rgb;

#if 1
  float3 scene_color = _14.rgb;
  float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;
  float scene_luminance = renodx::color::y::from::BT709(scene_color) * mid_gray_bloomed;
  float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
  float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
  bloom_color = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * 0.5f);
#endif

  float _34 = 1.0f / ((cb0_space2_000y * _22.w) + 1.0f);
  float _35 = (bloom_color.x + (_14.x)) * _34;
  float _36 = (bloom_color.y + (_14.y)) * _34;
  float _37 = (bloom_color.z + (_14.z)) * _34;
  float _53;
  float _54;
  float _55;
  float _150;
  float _151;
  float _152;
  if (!(cb0_space2_000x == 0.0f)) {
    float _41 = TEXCOORD.x + -0.5f;
    float _42 = TEXCOORD.y + -0.5f;
    float _48 = exp2(log2(saturate(1.0f - dot(float2(_41, _42), float2(_41, _42)))) * cb0_space2_000x);
    _53 = (_48 * _35);
    _54 = (_48 * _36);
    _55 = (_48 * _37);
  } else {
    _53 = _35;
    _54 = _36;
    _55 = _37;
  }
  if (!(cb0_space2_000z == 0)) {  // HDR
    float _75 = (saturate((log2(_53) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f;
    float _76 = (saturate((log2(_54) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f;
    float _77 = (saturate((log2(_55) * 0.05000000074505806f) + 0.6236965656280518f) * 0.96875f) + 0.015625f;
    float4 _78 = t4_space2.SampleLevel(s1_space3, float3(_75, _76, _77), 0.0f);
    if (!(cb0_space2_006x == 0.0f)) {
      if (select((cb0_space2_006x > 0.0f), (TEXCOORD.x < cb0_space2_006x), (TEXCOORD.x > (-0.0f - cb0_space2_006x)))) {
        float4 _92 = t5_space2.SampleLevel(s1_space3, float3(_75, _76, _77), 0.0f);
        float4 _105 = t6_space2.SampleLevel(s2_space98, float3(((saturate(_92.x) * 0.96875f) + 0.015625f), ((saturate(_92.y) * 0.96875f) + 0.015625f), ((saturate(_92.z) * 0.96875f) + 0.015625f)), 0.0f);
        _150 = _105.x;
        _151 = _105.y;
        _152 = _105.z;
      } else {
        _150 = _78.x;
        _151 = _78.y;
        _152 = _78.z;
      }
    } else {
      _150 = _78.x;
      _151 = _78.y;
      _152 = _78.z;
    }
  } else {  // SDR
    float _122 = saturate(saturate(_53 / ((_53 * 0.9770992398262024f) + 1.465648889541626f)));
    float _123 = saturate(saturate(_54 / ((_54 * 0.9770992398262024f) + 1.465648889541626f)));
    float _124 = saturate(saturate(_55 / ((_55 * 0.9770992398262024f) + 1.465648889541626f)));
    _150 = select((_122 <= 0.0031308000907301903f), (_122 * 12.920000076293945f), (((pow(_122, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _151 = select((_123 <= 0.0031308000907301903f), (_123 * 12.920000076293945f), (((pow(_123, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _152 = select((_124 <= 0.0031308000907301903f), (_124 * 12.920000076293945f), (((pow(_124, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  }
  SV_Target.x = _150;
  SV_Target.y = _151;
  SV_Target.z = _152;
  SV_Target.w = 1.0f;
  return SV_Target;
}
