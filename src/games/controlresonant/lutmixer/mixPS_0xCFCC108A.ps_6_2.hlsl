#include "./lutmixer.hlsli"

Texture2D<float4> g_tColorLutMixSource1 : register(t0);

Texture2D<float4> g_tColorLutMixSource2 : register(t1);

Texture2D<float4> g_tColorLutMixSource3 : register(t2);

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
  float _8;
  float _9;
  float4 _10;
  float4 _19;
  float4 _32;
  float _41;
  float _42;
  float _43;
  float _44;
  float _64;
  float _65;
  float _66;
  float _87;
  float _88;
  float _89;
  uint _49;
  float _56;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _75;
  float _79;
  _8 = SV_Position.x * 0.0009765625f;
  _9 = SV_Position.y * 0.03125f;
  _10 = g_tColorLutMixSource1.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _19 = g_tColorLutMixSource2.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _32 = g_tColorLutMixSource3.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _41 = ((g_fColorLutMixMul2 * _19.x) + (g_fColorLutMixMul1 * _10.x)) + (g_fColorLutMixMul3 * _32.x);
  _42 = ((g_fColorLutMixMul2 * _19.y) + (g_fColorLutMixMul1 * _10.y)) + (g_fColorLutMixMul3 * _32.y);
  _43 = ((g_fColorLutMixMul2 * _19.z) + (g_fColorLutMixMul1 * _10.z)) + (g_fColorLutMixMul3 * _32.z);
  _44 = (g_fColorLutMixMul2 + g_fColorLutMixMul1) + g_fColorLutMixMul3;
  if (_44 < 1.0f) {
    _49 = uint(SV_Position.x);
    _56 = saturate(1.0f - _44) * 0.032258063554763794f;
    _64 = ((_56 * ((float)((uint)((uint)(_49 & 31))))) + _41);
    _65 = ((_56 * ((float)((uint)uint(SV_Position.y)))) + _42);
    _66 = ((_56 * ((float)((uint)((uint)((uint)(_49) >> 5))))) + _43);
  } else {
    _64 = _41;
    _65 = _42;
    _66 = _43;
  }
  if (dot(float3(_64, _65, _66), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _70 = max(_64, 0.0f);
    _71 = max(_65, 0.0f);
    _72 = max(_66, 0.0f);
    _73 = min(_64, 0.0f);
    _74 = min(_65, 0.0f);
    _75 = min(_66, 0.0f);
    _79 = dot(float3(_70, _71, _72), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_73, _74, _75), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _87 = ((_79 * _73) + _70);
    _88 = ((_79 * _74) + _71);
    _89 = ((_79 * _75) + _72);
  } else {
    _87 = _64;
    _88 = _65;
    _89 = _66;
  }
  SV_Target.x = _87;
  SV_Target.y = _88;
  SV_Target.z = _89;
  SV_Target.w = 1.0f;
  return SV_Target;
}