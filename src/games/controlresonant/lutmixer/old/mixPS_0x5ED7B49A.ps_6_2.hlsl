#include "../lutmixer.hlsli"

Texture2D<float4> g_tColorLutMixSource2 : register(t0);

Texture2D<float4> g_tColorLutMixSource3 : register(t1);

cbuffer colorlutmixer : register(b0) {
  float g_fColorLutMixMul1 : packoffset(c000.x);
  float g_fColorLutMixMul2 : packoffset(c000.y);
  float g_fColorLutMixMul3 : packoffset(c000.z);
};

SamplerState g_sNearestClamp_internal : register(s1, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _7;
  float _8;
  float4 _9;
  float4 _18;
  float _27;
  float _28;
  float _29;
  float _30;
  float _86;
  float _87;
  float _88;
  float _109;
  float _110;
  float _111;
  uint _35;
  float _51;
  float _52;
  float _53;
  float _78;
  float _92;
  float _93;
  float _94;
  float _95;
  float _96;
  float _97;
  float _101;
  _7 = SV_Position.x * 0.0004340277810115367f;
  _8 = SV_Position.y * 0.02083333395421505f;
  _9 = g_tColorLutMixSource2.Sample(g_sNearestClamp_internal, float2(_7, _8));
  _18 = g_tColorLutMixSource3.Sample(g_sNearestClamp_internal, float2(_7, _8));
  _27 = (g_fColorLutMixMul3 * _18.x) + (g_fColorLutMixMul2 * _9.x);
  _28 = (g_fColorLutMixMul3 * _18.y) + (g_fColorLutMixMul2 * _9.y);
  _29 = (g_fColorLutMixMul3 * _18.z) + (g_fColorLutMixMul2 * _9.z);
  _30 = g_fColorLutMixMul3 + g_fColorLutMixMul2;
  if (_30 < 1.0f) {
    _35 = uint(SV_Position.x);
    _51 = exp2(log2(((float)((uint)(_35 % 48))) * 0.021276595070958138f) * 0.012683313339948654f);
    _52 = exp2(log2(((float)((uint)uint(SV_Position.y))) * 0.021276595070958138f) * 0.012683313339948654f);
    _53 = exp2(log2(((float)((uint)(_35 / 48u))) * 0.021276595070958138f) * 0.012683313339948654f);
    _78 = saturate(1.0f - _30) * 125.0f;
    _86 = ((exp2(log2(max((_51 + -0.8359375f), 0.0f) / (18.8515625f - (_51 * 18.6875f))) * 6.277394771575928f) * _78) + _27);
    _87 = ((exp2(log2(max((_52 + -0.8359375f), 0.0f) / (18.8515625f - (_52 * 18.6875f))) * 6.277394771575928f) * _78) + _28);
    _88 = ((exp2(log2(max((_53 + -0.8359375f), 0.0f) / (18.8515625f - (_53 * 18.6875f))) * 6.277394771575928f) * _78) + _29);
  } else {
    _86 = _27;
    _87 = _28;
    _88 = _29;
  }
  if (dot(float3(_86, _87, _88), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _92 = max(_86, 0.0f);
    _93 = max(_87, 0.0f);
    _94 = max(_88, 0.0f);
    _95 = min(_86, 0.0f);
    _96 = min(_87, 0.0f);
    _97 = min(_88, 0.0f);
    _101 = dot(float3(_92, _93, _94), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_95, _96, _97), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _109 = ((_101 * _95) + _92);
    _110 = ((_101 * _96) + _93);
    _111 = ((_101 * _97) + _94);
  } else {
    _109 = _86;
    _110 = _87;
    _111 = _88;
  }
  SV_Target.x = _109;
  SV_Target.y = _110;
  SV_Target.z = _111;
  SV_Target.w = 1.0f;
  SV_Target.rgb = CompressLUTMixerOutput(SV_Target.rgb);
  return SV_Target;
}
