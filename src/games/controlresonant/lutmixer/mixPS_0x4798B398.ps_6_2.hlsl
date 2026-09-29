#include "./lutmixer.hlsli"

Texture2D<float4> g_tColorLutMixSource3 : register(t0);

cbuffer colorlutmixer : register(b0) {
  float g_fColorLutMixMul1 : packoffset(c000.x);
  float g_fColorLutMixMul2 : packoffset(c000.y);
  float g_fColorLutMixMul3 : packoffset(c000.z);
};

SamplerState g_sNearestClamp_internal : register(s1, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _8;
  float _14;
  float _15;
  float _16;
  float _36;
  float _37;
  float _38;
  float _59;
  float _60;
  float _61;
  uint _21;
  float _28;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _51;
  _8 = g_tColorLutMixSource3.Sample(g_sNearestClamp_internal, float2((SV_Position.x * 0.0009765625f), (SV_Position.y * 0.03125f)));
  _14 = g_fColorLutMixMul3 * _8.x;
  _15 = g_fColorLutMixMul3 * _8.y;
  _16 = g_fColorLutMixMul3 * _8.z;
  if (g_fColorLutMixMul3 < 1.0f) {
    _21 = uint(SV_Position.x);
    _28 = saturate(1.0f - g_fColorLutMixMul3) * 0.032258063554763794f;
    _36 = ((_28 * ((float)((uint)((uint)(_21 & 31))))) + _14);
    _37 = ((_28 * ((float)((uint)uint(SV_Position.y)))) + _15);
    _38 = ((_28 * ((float)((uint)((uint)((uint)(_21) >> 5))))) + _16);
  } else {
    _36 = _14;
    _37 = _15;
    _38 = _16;
  }
  if (dot(float3(_36, _37, _38), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _42 = max(_36, 0.0f);
    _43 = max(_37, 0.0f);
    _44 = max(_38, 0.0f);
    _45 = min(_36, 0.0f);
    _46 = min(_37, 0.0f);
    _47 = min(_38, 0.0f);
    _51 = dot(float3(_42, _43, _44), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_45, _46, _47), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _59 = ((_51 * _45) + _42);
    _60 = ((_51 * _46) + _43);
    _61 = ((_51 * _47) + _44);
  } else {
    _59 = _36;
    _60 = _37;
    _61 = _38;
  }
  SV_Target.x = _59;
  SV_Target.y = _60;
  SV_Target.z = _61;
  SV_Target.w = 1.0f;
  return SV_Target;
}