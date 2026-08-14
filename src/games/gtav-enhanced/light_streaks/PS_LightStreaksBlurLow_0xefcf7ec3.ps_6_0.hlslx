#include "../shared.h"

Texture2D<float4> t15_space1 : register(t15, space1);

cbuffer cb3 : register(b3) {
  int g_rage_dynamicsamplerindices_000 : packoffset(c000.x);
  int g_rage_dynamicsamplerindices_004 : packoffset(c000.y);
  int g_rage_dynamicsamplerindices_008 : packoffset(c000.z);
  int g_rage_dynamicsamplerindices_012 : packoffset(c000.w);
  int g_rage_dynamicsamplerindices_016 : packoffset(c001.x);
  int g_rage_dynamicsamplerindices_020 : packoffset(c001.y);
  int g_rage_dynamicsamplerindices_024 : packoffset(c001.z);
  int g_rage_dynamicsamplerindices_028 : packoffset(c001.w);
  int g_rage_dynamicsamplerindices_032 : packoffset(c002.x);
  int g_rage_dynamicsamplerindices_036 : packoffset(c002.y);
  int g_rage_dynamicsamplerindices_040 : packoffset(c002.z);
  int g_rage_dynamicsamplerindices_044 : packoffset(c002.w);
  int g_rage_dynamicsamplerindices_048 : packoffset(c003.x);
  int g_rage_dynamicsamplerindices_052 : packoffset(c003.y);
  int g_rage_dynamicsamplerindices_056 : packoffset(c003.z);
  int g_rage_dynamicsamplerindices_060 : packoffset(c003.w);
  int g_rage_dynamicsamplerindices_064 : packoffset(c004.x);
  int g_rage_dynamicsamplerindices_068 : packoffset(c004.y);
  int g_rage_dynamicsamplerindices_072 : packoffset(c004.z);
  int g_rage_dynamicsamplerindices_076 : packoffset(c004.w);
  int g_rage_dynamicsamplerindices_080 : packoffset(c005.x);
  int g_rage_dynamicsamplerindices_084 : packoffset(c005.y);
};

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_035y : packoffset(c035.y);
  float cb12_space1_035z : packoffset(c035.z);
  float cb12_space1_035w : packoffset(c035.w);
  float cb12_space1_040x : packoffset(c040.x);
  float cb12_space1_040y : packoffset(c040.y);
  float cb12_space1_040z : packoffset(c040.z);
  float cb12_space1_042x : packoffset(c042.x);
  float cb12_space1_042y : packoffset(c042.y);
  float cb12_space1_072x : packoffset(c072.x);
  float cb12_space1_072y : packoffset(c072.y);
};

SamplerState s0_space2[] : register(s0, space2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _7;
  float _8;
  float _9;
  int _10;
  _7 = 0.0f;
  _8 = 0.0f;
  _9 = 0.0f;
  _10 = 0;
  while(true) {
    float _11 = float(_10);
    float _13 = 1.0f - (_11 * 0.25f);
    float _14 = _13 * _13;
    float4 _31 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2((((cb12_space1_042x * _11) * cb12_space1_072x) + TEXCOORD.x), (((cb12_space1_042y * _11) * cb12_space1_072y) + TEXCOORD.y)));
    _31 = saturate(_31);
    float _38 = (_31.x * _14) + _7;
    float _39 = (_31.y * _14) + _8;
    float _40 = (_31.z * _14) + _9;
    int _41 = _10 + 1;
    if (!(_41 == 4)) {
      _7 = _38;
      _8 = _39;
      _9 = _40;
      _10 = _41;
      continue;
    }
    float _64 = (((cb12_space1_035w - cb12_space1_035z) * 2.0f) * select((cb12_space1_035y > 0.0f), abs(TEXCOORD.y + -0.5f), abs(TEXCOORD.x + -0.5f))) + cb12_space1_035z;
    float _65 = _64 * _64;
    SV_Target.x = ((cb12_space1_040x * _38) * _65);
    SV_Target.y = ((cb12_space1_040y * _39) * _65);
    SV_Target.z = ((cb12_space1_040z * _40) * _65);
    SV_Target.w = 1.0f;
    SV_Target.rgb *= CUSTOM_LIGHT_STREAKS;
    break;
  }
  return SV_Target;
}
