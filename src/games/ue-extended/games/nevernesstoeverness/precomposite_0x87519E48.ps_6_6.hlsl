Texture2D<float4> t0 : register(t0);

#include "../../common.hlsli"

cbuffer cb0 : register(b0) {
  float4 $Globals_000 : packoffset(c000.x);
  float4 $Globals_016 : packoffset(c001.x);
};

cbuffer cb1 : register(b1) {
  float4 Material_000[2] : packoffset(c000.x);
  int Material_032 : packoffset(c002.x);
  int Material_036 : packoffset(c002.y);
  int Material_040 : packoffset(c002.z);
  int Material_044 : packoffset(c002.w);
  int Material_048 : packoffset(c003.x);
  int Material_052 : packoffset(c003.y);
  int Material_056 : packoffset(c003.z);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float4 COLOR_1 : COLOR1,
  linear float4 ORIGINAL_POSITION : ORIGINAL_POSITION,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _19;
  float _40;
  float _41;
  float _42;
  float _65;
  float _66;
  float _67;
  float _91;
  float _102;
  float _113;
  float _114;
  float _115;
  float _78;
  float _79;
  float _80;
  _19 = t0.Sample(s0, float2((TEXCOORD_1.z * TEXCOORD_1.x), (TEXCOORD_1.w * TEXCOORD_1.y)));
  _40 = max(((((Material_000[0].y) - _19.x) * (Material_000[0].x)) + _19.x), 0.0f) * COLOR.x;
  _41 = max(((((Material_000[0].z) - _19.y) * (Material_000[0].x)) + _19.y), 0.0f) * COLOR.y;
  _42 = max(((((Material_000[0].w) - _19.z) * (Material_000[0].x)) + _19.z), 0.0f) * COLOR.z;

  [branch]
  if (($Globals_000.w) != 1.0f) {
    _65 = saturate((($Globals_000.w) * (_40 + -0.25f)) + 0.25f);
    _66 = saturate((($Globals_000.w) * (_41 + -0.25f)) + 0.25f);
    _67 = saturate((($Globals_000.w) * (_42 + -0.25f)) + 0.25f);
  } else {
    _65 = _40;
    _66 = _41;
    _67 = _42;
  }

  // decode back to linear, bt709 from 2020, revert 2.2 -> srgb, n2 tonemap
  if (PROCESSING_PATH == 0.f) {
    float3 color = float3(_65, _66, _67);
    color = renodx::color::pq::DecodeSafe(color, RENODX_DIFFUSE_WHITE_NITS);
    color = renodx::color::bt709::from::BT2020(color);
    color = renodx::color::correct::GammaSafe(color, true);
    color = renodx::tonemap::neutwo::MaxChannel(color, 1.0f, 2.5f);
    _65 = color.x;
    _66 = color.y;
    _67 = color.z;
  }

  [branch]
  if (($Globals_000.y) != 1.0f) {

    _78 = exp2(log2(_65) * ($Globals_000.x));
    _79 = exp2(log2(_66) * ($Globals_000.x));
    _80 = exp2(log2(_67) * ($Globals_000.x));
    if (_78 < 0.0031306699384003878f) {
      _91 = (_78 * 12.920000076293945f);
    } else {
      _91 = (((pow(_78, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_79 < 0.0031306699384003878f) {
      _102 = (_79 * 12.920000076293945f);
    } else {
      _102 = (((pow(_79, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_80 < 0.0031306699384003878f) {
      _113 = _91;
      _114 = _102;
      _115 = (_80 * 12.920000076293945f);
    } else {
      _113 = _91;
      _114 = _102;
      _115 = (((pow(_80, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    _113 = _65;
    _114 = _66;
    _115 = _67;
    _78 = _65;
    _79 = _66;
    _80 = _67;
    _91 = _65;
    _102 = _66;
  }
  SV_Target.x = _113;
  SV_Target.y = _114;
  SV_Target.z = _115;
  SV_Target.w = select((($Globals_016.x) != 0.0f), (COLOR.w * 0.44999998807907104f), COLOR.w);
  return SV_Target;
}