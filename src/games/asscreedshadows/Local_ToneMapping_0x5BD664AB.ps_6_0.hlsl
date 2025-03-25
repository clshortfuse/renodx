#include "./shared.h"

struct _t0 {
  float data[1];
};
StructuredBuffer<_t0> t0 : register(t0, space1);

Texture2D<float4> t1 : register(t0, space3);

Texture3D<float2> t2 : register(t1, space3);

Texture2D<float> t3 : register(t2, space3);

cbuffer cb0 : register(b1) {
  float cb0_000x : packoffset(c000.x);
  float cb0_000y : packoffset(c000.y);
  float cb0_000z : packoffset(c000.z);
  float cb0_000w : packoffset(c000.w);
  float cb0_001x : packoffset(c001.x);
  float cb0_001y : packoffset(c001.y);
  float cb0_001z : packoffset(c001.z);
  float cb0_001w : packoffset(c001.w);
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_002z : packoffset(c002.z);
  float cb0_002w : packoffset(c002.w);
  float cb0_003x : packoffset(c003.x);
  float cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_003w : packoffset(c003.w);
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004z : packoffset(c004.z);
  float cb0_004w : packoffset(c004.w);
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
};

cbuffer cb1 : register(b0, space1) {
  float cb1_071x : packoffset(c071.x);
};

cbuffer cb2 : register(b0, space3) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_000w : packoffset(c000.w);
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_001w : packoffset(c001.w);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
};

SamplerState s0 : register(s0, space99);

SamplerState s1 : register(s8, space98);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _12 = t1.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _16 = dot(float3(_12.x, _12.y, _12.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  bool _17 = (_16 == 0.0f);
  float _169;
  if (!_17) {
    _t0 _21 = t0.Load(3);
    _t0 _23 = t0.Load(0);
    float _27 = _21.data[0] * 983.52001953125f;
    float _28 = _27 * _23.data[0];
    float _29 = _28 * cb1_071x;
    float _30 = log2(_29);
    float _33 = cb2_000x * 0.5f;
    float _34 = _30 - _33;
    float _35 = 1.0f / cb2_000x;
    float _36 = _34 * _35;
    bool _37 = (_16 > 9.99999993922529e-09f);
    float _38 = _16 * 5464.0f;
    float _39 = log2(_38);
    float _40 = (_37 ? _39 : -14.159683227539062f);
    float _41 = _40 - _34;
    float _42 = _41 * _35;
    float _43 = saturate(_42);
    float2 _44 = t2.SampleLevel(s1, float3(TEXCOORD.x, TEXCOORD.y, _43), 0.0f);
    float _47 = max(_44.y, 1.0000000116860974e-07f);
    float _48 = _44.x / _47;
    float _49 = _48 + _36;
    float _50 = _49 / _35;
    float _51 = t3.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _53 = _51.x * 5464.0f;
    float _54 = log2(_53);
    float _71 = dot(float4(cb0_000x, cb0_000y, cb0_000z, cb0_000w), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _77 = dot(float4(cb0_001x, cb0_001y, cb0_001z, cb0_001w), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _83 = dot(float4(cb0_002x, cb0_002y, cb0_002z, cb0_002w), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _89 = dot(float4(cb0_003x, cb0_003y, cb0_003z, cb0_003w), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _95 = dot(float4(cb0_004x, cb0_004y, cb0_004z, cb0_004w), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _101 = dot(float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _102 = _89 + _71;
    float _103 = _95 + _77;
    float _104 = _101 + _83;
    float _105 = max(0.0f, _102);
    float _106 = max(0.0f, _103);
    float _107 = max(0.0f, _104);
    float _108 = max(0.0f, _105);
    float _109 = max(0.0f, _106);
    float _110 = max(0.0f, _107);
    float _111 = dot(float3(_108, _109, _110), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _112 = _21.data[0] * 5464.0f;
    float _113 = log2(_112);
    float _114 = _111 * 5464.0f;
    float _115 = log2(_114);
    float _116 = _111 * 10928.0f;
    float _117 = log2(_116);
    float _118 = _115 - _113;
    float _119 = _117 - _113;
    float _120 = _119 * 6.0f;
    float _121 = max(0.0f, _118);
    float _122 = max(0.0f, _120);
    float _123 = cb2_002x / cb2_000y;
    float _124 = cb2_002y / cb2_000z;
    float _125 = max(1.0f, _123);
    float _126 = max(1.0f, _124);
    float _127 = _121 * cb2_001y;
    float _128 = _122 * cb2_001z;
    float _129 = min(_127, _125);
    float _130 = min(_128, _126);
    float _131 = max(1.0f, _129);
    float _132 = max(1.0f, _130);
    float _133 = _121 * cb2_001w;
    float _134 = cb2_001x + _30;
    float _135 = _134 - _133;
    float _136 = _54 - _50;
    float _137 = _136 * cb2_002z;
    float _138 = _137 + _50;
    float _139 = _138 - _135;
    float _140 = _40 - _138;
    bool _141 = (_139 > 0.0f);
    bool _142 = (_139 < 0.0f);
    int _143 = (uint)(_141);
    int _144 = (uint)(_142);
    int _145 = _143 - _144;
    int _146 = max(0, _145);
    float _147 = float(_146);
    float _148 = 1.0f - _147;
    float _149 = _131 * cb2_000y;
    float _150 = _149 * _147;
    float _151 = _132 * cb2_000z;
    float _152 = _151 * _148;
    float _153 = 1.0f - _150;
    float _154 = _153 - _152;
    float _155 = _154 * _139;
    float _156 = cb2_000w * _140;
    float _157 = _135 + _156;
    float _158 = _157 + _155;
    float _159 = exp2(_158);
    float _160 = _159 * 0.0001830161054385826f;
    float _161 = _160 / _16;
    int _162 = asint(_161);
    int _163 = _162 & 2139095040;
    bool _164 = ((uint)_163 > (uint)2139095039);
    bool _165 = isinf(_161);
    bool _166 = _165 || _164;
    float _167 = (_166 ? 1.0f : _161);
    _169 = _167;
  } else {
    _169 = 1.0f;
  }
#if 1
  _169 *= lerp(1.f, _169, CUSTOM_LOCAL_TONEMAP_STRENGTH);
#endif
  float _170 = _169 * _12.x;
  float _171 = _169 * _12.y;
  float _172 = _169 * _12.z;
  SV_Target.x = _170;
  SV_Target.y = _171;
  SV_Target.z = _172;
  SV_Target.w = 1.0f;
  return SV_Target;
}
