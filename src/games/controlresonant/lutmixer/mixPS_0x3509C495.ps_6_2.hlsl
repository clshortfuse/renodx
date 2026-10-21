#include "./lutmixer.hlsli"

Texture2D<float4> g_tColorLutMixSource2 : register(t0);

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
  float _72;
  float _73;
  float _74;
  float _95;
  float _96;
  float _97;
  uint _21;
  float _37;
  float _38;
  float _39;
  float _64;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _87;
  _8 = g_tColorLutMixSource2.Sample(g_sNearestClamp_internal, float2((SV_Position.x * 0.0004340277810115367f), (SV_Position.y * 0.02083333395421505f)));
  _14 = g_fColorLutMixMul2 * _8.x;
  _15 = g_fColorLutMixMul2 * _8.y;
  _16 = g_fColorLutMixMul2 * _8.z;
  if (g_fColorLutMixMul2 < 1.0f) {
    _21 = uint(SV_Position.x);
    _37 = exp2(log2(((float)((uint)(_21 % 48))) * 0.021276595070958138f) * 0.012683313339948654f);
    _38 = exp2(log2(((float)((uint)uint(SV_Position.y))) * 0.021276595070958138f) * 0.012683313339948654f);
    _39 = exp2(log2(((float)((uint)(_21 / 48u))) * 0.021276595070958138f) * 0.012683313339948654f);
    _64 = saturate(1.0f - g_fColorLutMixMul2) * 125.0f;
    _72 = ((exp2(log2(max((_37 + -0.8359375f), 0.0f) / (18.8515625f - (_37 * 18.6875f))) * 6.277394771575928f) * _64) + _14);
    _73 = ((exp2(log2(max((_38 + -0.8359375f), 0.0f) / (18.8515625f - (_38 * 18.6875f))) * 6.277394771575928f) * _64) + _15);
    _74 = ((exp2(log2(max((_39 + -0.8359375f), 0.0f) / (18.8515625f - (_39 * 18.6875f))) * 6.277394771575928f) * _64) + _16);
  } else {
    _72 = _14;
    _73 = _15;
    _74 = _16;
  }
  if (dot(float3(_72, _73, _74), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _78 = max(_72, 0.0f);
    _79 = max(_73, 0.0f);
    _80 = max(_74, 0.0f);
    _81 = min(_72, 0.0f);
    _82 = min(_73, 0.0f);
    _83 = min(_74, 0.0f);
    _87 = dot(float3(_78, _79, _80), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_81, _82, _83), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _95 = ((_87 * _81) + _78);
    _96 = ((_87 * _82) + _79);
    _97 = ((_87 * _83) + _80);
  } else {
    _95 = _72;
    _96 = _73;
    _97 = _74;
  }
  SV_Target.x = _95;
  SV_Target.y = _96;
  SV_Target.z = _97;
  SV_Target.w = 1.0f;
  return SV_Target;
}