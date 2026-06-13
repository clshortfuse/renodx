#include "./shared.h"

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

cbuffer cb4 : register(b4) {
  float cb4_014z : packoffset(c014.z);
  int cb4_024z : packoffset(c024.z);
};

cbuffer cb10 : register(b10) {
  float4 g_rage_SoftParticleBuffer_000 : packoffset(c000.x);
  float4 g_rage_SoftParticleBuffer_016 : packoffset(c001.x);
};

cbuffer cb14_space1 : register(b14, space1) {
  float cb14_space1_011x : packoffset(c011.x);
  float cb14_space1_011y : packoffset(c011.y);
  float cb14_space1_011w : packoffset(c011.w);
};

SamplerState s2_space1 : register(s2, space1);

SamplerState s7_space1 : register(s7, space1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
  float SV_Target_2 : SV_Target2;
  float4 SV_Target_3 : SV_Target3;
};

OutputSignature main(
  linear float3 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1,
  linear float2 TEXCOORD_3 : TEXCOORD3,
  linear float3 TEXCOORD_2 : TEXCOORD2,
  nointerpolation float4 TEXCOORD_4 : TEXCOORD4,
  linear float4 TEXCOORD_5 : TEXCOORD5,
  nointerpolation float2 TEXCOORD_6 : TEXCOORD6,
  noperspective float4 SV_Position : SV_Position,
  linear float4 SV_ClipDistance : SV_ClipDistance
) {
  float4 SV_Target;
  float SV_Target_1;
  float SV_Target_2;
  float4 SV_Target_3;
  float _22 = TEXCOORD_4.x * TEXCOORD_5.x;
  float _23 = TEXCOORD_4.y * TEXCOORD_5.y;
  float _24 = TEXCOORD_4.z * TEXCOORD_5.z;
  float4 _25 = t15_space1.Sample(s7_space1, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float _27 = _25.w * TEXCOORD_4.w;
  float _28 = saturate(_27);
  float _31 = _22 * cb14_space1_011x;
  float _32 = _23 * cb14_space1_011x;
  float _33 = _24 * cb14_space1_011x;
  float _37 = g_rage_SoftParticleBuffer_016.x * SV_Position.x;
  float _38 = g_rage_SoftParticleBuffer_016.y * SV_Position.y;
  bool _40 = (cb14_space1_011w > 0.0f);
  float _60;
  float _61;
  [branch]
  if (_40) {
    float _42 = SV_Position.z * SV_Position.z;
    float _43 = 1.0f - _42;
    float4 _44 = t17_space1.Sample(s2_space1, float2(TEXCOORD_1.x, TEXCOORD_1.y));
    float _48 = _44.x * 2.0f;
    float _49 = _44.y * 2.0f;
    float _50 = _48 + -1.0f;
    float _51 = _49 + -1.0f;
    float _52 = cb14_space1_011w * _43;
    float _53 = g_rage_SoftParticleBuffer_016.x * _44.z;
    float _54 = _53 * _50;
    float _55 = _54 * _52;
    float _56 = g_rage_SoftParticleBuffer_016.y * _44.z;
    float _57 = _56 * _51;
    float _58 = _57 * _52;
    _60 = _55;
    _61 = _58;
  } else {
    _60 = 0.0f;
    _61 = 0.0f;
  }
  float _62 = _60 + _37;
  float _63 = _61 + _38;
  float4 _64 = t16_space1.Sample(s2_space1, float2(_62, _63));
  float _69 = cb14_space1_011y * _64.x;
  float _70 = cb14_space1_011y * _64.y;
  float _71 = cb14_space1_011y * _64.z;
  float _72 = _69 + _31;
  float _73 = _70 + _32;
  float _74 = _71 + _33;
  float _77 = _72 * cb4_014z;
  float _78 = _73 * cb4_014z;
  float _79 = _74 * cb4_014z;
  
  // Wrap the color outputs in saturate() to restrict emissive levels to standard SDR bounds.
  // This keeps the rain's transparency blending soft and natural in the upgraded r16g16b16a16_float backbuffer.
  SV_Target.x = saturate(_77);
  SV_Target.y = saturate(_78);
  SV_Target.z = saturate(_79);
  SV_Target.w = _28;
  
  bool _80 = !(_28 <= 0.0f);
  if (!_80) {
    if (true) discard;
  }
  bool _83 = (_28 > 0.0f);
  float _84 = float((bool)_83);
  float _85 = TEXCOORD_5.w + -66504.0f;
  float _86 = _84 * _85;
  float _87 = _86 + 66504.0f;
  SV_Target_1 = _87;
  SV_Target_2 = _28;
  bool _88 = (_28 > 0.003921568859368563f);
  int _91 = select(_88, 32, 0);
  uint _92 = cb4_024z << 6;
  int _93 = _92 & 64;
  int _94 = _93 | _91;
  int _95 = _92 & 128;
  int _96 = _94 | _95;
  float _97 = float((uint)_96);
  float _98 = _97 * 0.003921568859368563f;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = _98;
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2, SV_Target_3 };
  return output_signature;
}
