#include "../../common.hlsli"
// text shader, contains UID, not doing anything with it for now
Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float4 $Globals_000 : packoffset(c000.x);
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
  float _15;
  float _33;
  float _34;
  float _35;
  float _59;
  float _70;
  float _81;
  float _82;
  float _83;
  float _46;
  float _47;
  float _48;
  _15 = (((float4)(t0.Sample(s0, float2(TEXCOORD_1.x, TEXCOORD_1.y)))).w) * COLOR.w;
  [branch]
  if (($Globals_000.w) != 1.0f) {
    _33 = saturate((($Globals_000.w) * (COLOR.x + -0.25f)) + 0.25f);
    _34 = saturate((($Globals_000.w) * (COLOR.y + -0.25f)) + 0.25f);
    _35 = saturate((($Globals_000.w) * (COLOR.z + -0.25f)) + 0.25f);
  } else {
    _33 = COLOR.x;
    _34 = COLOR.y;
    _35 = COLOR.z;
  }
  [branch]
  if (($Globals_000.y) != 1.0f) {
    _46 = exp2(log2(_33) * ($Globals_000.x));
    _47 = exp2(log2(_34) * ($Globals_000.x));
    _48 = exp2(log2(_35) * ($Globals_000.x));
    if (_46 < 0.0031306699384003878f) {
      _59 = (_46 * 12.920000076293945f);
    } else {
      _59 = (((pow(_46, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_47 < 0.0031306699384003878f) {
      _70 = (_47 * 12.920000076293945f);
    } else {
      _70 = (((pow(_47, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_48 < 0.0031306699384003878f) {
      _81 = _59;
      _82 = _70;
      _83 = (_48 * 12.920000076293945f);
    } else {
      _81 = _59;
      _82 = _70;
      _83 = (((pow(_48, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    _81 = _33;
    _82 = _34;
    _83 = _35;
  }
  SV_Target.x = _81;
  SV_Target.y = _82;
  SV_Target.z = _83;
  SV_Target.w = ((($Globals_000.z) * ((_15 * -2.0f) + 1.0f)) + _15);
  // Hardcoded UID hide for 4K users for now
  float2 viewport_size = float2(3840.0f, 2160.0f);
  float2 mask_size = float2(viewport_size.x * 0.20f, viewport_size.y * 0.05f);
  if ((SV_Position.x < mask_size.x) && (SV_Position.y > (viewport_size.y - mask_size.y))) {
    return float4(0.0f, 0.0f, 0.0f, 0.0f);
  }
  return SV_Target;
}