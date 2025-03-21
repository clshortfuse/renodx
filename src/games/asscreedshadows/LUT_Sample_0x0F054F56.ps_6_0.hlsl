#include "./shared.h"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t0, space2);

Texture3D<float4> t2 : register(t3, space2);

Texture2D<float4> t3 : register(t11, space2);

Texture2D<float4> t4 : register(t12, space2);

cbuffer cb0 : register(b0, space1) {
  uint cb0_076x : packoffset(c076.x);
};

cbuffer cb1 : register(b0, space2) {
  float cb1_000x : packoffset(c000.x);
  float cb1_007x : packoffset(c007.x);
  uint cb1_007y : packoffset(c007.y);
  float cb1_008x : packoffset(c008.x);
  float cb1_008y : packoffset(c008.y);
  float cb1_008z : packoffset(c008.z);
};

SamplerState s0 : register(s0, space99);

SamplerState s1 : register(s0, space3);

SamplerState s2 : register(s1, space3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    nointerpolation float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _16 = t1.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _20 = (_16.x) * TEXCOORD_1;
  float _21 = (_16.y) * TEXCOORD_1;
  float _22 = (_16.z) * TEXCOORD_1;
  float4 _23 = t3.SampleLevel(s2, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _28 = _23.x + _20;
  float _29 = _23.y + _21;
  float _30 = _23.z + _22;
  bool _33 = ((uint)(cb1_007y) == 0);
  float _53;
  float _54;
  float _55;
  float _126;
  float _127;
  float _128;
  if (!_33) {
    float4 _35 = t4.SampleLevel(s2, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _39 = _35.x * _23.x;
    float _40 = _35.y * _23.y;
    float _41 = _35.z * _23.z;
    float _46 = _39 * cb1_008x;
    float _47 = _40 * cb1_008y;
    float _48 = _41 * cb1_008z;
    float _49 = _46 + _28;
    float _50 = _47 + _29;
    float _51 = _48 + _30;
    _53 = _49;
    _54 = _50;
    _55 = _51;
  } else {
    _53 = _28;
    _54 = _29;
    _55 = _30;
  }
  float _58 = cb1_007x * _23.w;
  float _59 = _58 + 1.0f;
  float _60 = 1.0f / _59;
  float _61 = _60 * _53;
  float _62 = _60 * _54;
  float _63 = _60 * _55;
  bool _66 = !(cb1_000x == 0.0f);
  if (_66) {
    float _68 = TEXCOORD.x + -0.5f;
    float _69 = TEXCOORD.y + -0.5f;
    float _70 = dot(float2(_68, _69), float2(_68, _69));
    float _71 = 1.0f - _70;
    float _72 = saturate(_71);
    float _73 = log2(_72);
    float _74 = _73 * cb1_000x;
    float _75 = exp2(_74);
    uint _78 = (cb0_076x) + 41451437u;
    uint _79 = uint(SV_Position.x);
    uint _80 = uint(SV_Position.y);
    uint _81 = _78 * 1215282323;
    uint _82 = _81 + -200870954u;
    uint _83 = _82 << 16;
    int _84 = (uint)(_82) >> 16;
    int _85 = _83 | _84;
    uint _86 = _85 * _82;
    uint _87 = _82 + _79;
    uint _88 = _87 + _86;
    uint _89 = _84 + _80;
    int _90 = _88 & 63;
    int _91 = _89 & 63;
    float4 _92 = t0.Load(int3(_90, _91, 0));
    uint _95 = _78 * -1935564855;
    uint _96 = _95 + 706565374u;
    uint _97 = _96 << 16;
    int _98 = (uint)(_96) >> 16;
    int _99 = _97 | _98;
    uint _100 = _99 * _96;
    uint _101 = _96 + _79;
    uint _102 = _101 + _100;
    uint _103 = _98 + _80;
    int _104 = _102 & 63;
    int _105 = _103 & 63;
    float4 _106 = t0.Load(int3(_104, _105, 0));
    float _108 = _75 * 0.0625f;
    float _109 = _75 * 0.125f;
    float _110 = _92.x + -0.5f;
    float _111 = _92.y + -0.5f;
    float _112 = (_106.x) + -0.5f;
    float _113 = _108 * _110;
    float _114 = _108 * _111;
    float _115 = _109 * _112;
    float _116 = _113 + _75;
    float _117 = _114 + _75;
    float _118 = _115 + _75;
    float _119 = max(0.0f, _116);
    float _120 = max(0.0f, _117);
    float _121 = max(0.0f, _118);
    float _122 = _119 * _61;
    float _123 = _120 * _62;
    float _124 = _121 * _63;
    _126 = _122;
    _127 = _123;
    _128 = _124;
  } else {
    _126 = _61;
    _127 = _62;
    _128 = _63;
  }
  float _129 = log2(_126);
  float _130 = _129 * 0.05000000074505806f;
  float _131 = _130 + 0.6236965656280518f;
  float _132 = log2(_127);
  float _133 = _132 * 0.05000000074505806f;
  float _134 = _133 + 0.6236965656280518f;
  float _135 = log2(_128);
  float _136 = _135 * 0.05000000074505806f;
  float _137 = _136 + 0.6236965656280518f;
  float4 _147 = t2.SampleLevel(s1, saturate(float3(_131, _134, _137)) * 0.96875f + 0.015625f, 0.0f);
  SV_Target.x = _147.x;
  SV_Target.y = _147.y;
  SV_Target.z = _147.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
