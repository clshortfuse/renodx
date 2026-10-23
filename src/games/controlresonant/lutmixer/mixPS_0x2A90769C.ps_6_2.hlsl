#include "./lutmixer.hlsli"

Texture2D<float4> g_tColorLutMixSource2 : register(t0);

Texture2D<float4> g_tColorLutMixSource3 : register(t1);

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
  float _7;
  float _8;
  float4 _9;
  float4 _18;
  float _27;
  float _28;
  float _29;
  float _30;
  float _50;
  float _51;
  float _52;
  float _73;
  float _74;
  float _75;
  uint _35;
  float _42;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _65;
  _7 = SV_Position.x * 0.0009765625f;
  _8 = SV_Position.y * 0.03125f;
  _9 = g_tColorLutMixSource2.Sample(g_sNearestClamp_internal, float2(_7, _8));
  _18 = g_tColorLutMixSource3.Sample(g_sNearestClamp_internal, float2(_7, _8));
  _27 = (g_fColorLutMixMul3 * _18.x) + (g_fColorLutMixMul2 * _9.x);
  _28 = (g_fColorLutMixMul3 * _18.y) + (g_fColorLutMixMul2 * _9.y);
  _29 = (g_fColorLutMixMul3 * _18.z) + (g_fColorLutMixMul2 * _9.z);
  _30 = g_fColorLutMixMul3 + g_fColorLutMixMul2;
  if (_30 < 1.0f) {
    _35 = uint(SV_Position.x);
    _42 = saturate(1.0f - _30) * 0.032258063554763794f;
    _50 = ((_42 * ((float)((uint)((uint)(_35 & 31))))) + _27);
    _51 = ((_42 * ((float)((uint)uint(SV_Position.y)))) + _28);
    _52 = ((_42 * ((float)((uint)((uint)((uint)(_35) >> 5))))) + _29);
  } else {
    _50 = _27;
    _51 = _28;
    _52 = _29;
  }
  if (dot(float3(_50, _51, _52), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _56 = max(_50, 0.0f);
    _57 = max(_51, 0.0f);
    _58 = max(_52, 0.0f);
    _59 = min(_50, 0.0f);
    _60 = min(_51, 0.0f);
    _61 = min(_52, 0.0f);
    _65 = dot(float3(_56, _57, _58), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_59, _60, _61), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _73 = ((_65 * _59) + _56);
    _74 = ((_65 * _60) + _57);
    _75 = ((_65 * _61) + _58);
  } else {
    _73 = _50;
    _74 = _51;
    _75 = _52;
  }
  SV_Target.x = _73;
  SV_Target.y = _74;
  SV_Target.z = _75;
  SV_Target.w = 1.0f;
  return SV_Target;
}