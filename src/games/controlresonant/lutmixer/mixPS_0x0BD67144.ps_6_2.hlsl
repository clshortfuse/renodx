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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
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
  float _100;
  float _101;
  float _102;
  float _123;
  float _124;
  float _125;
  uint _49;
  float _65;
  float _66;
  float _67;
  float _92;
  float _106;
  float _107;
  float _108;
  float _109;
  float _110;
  float _111;
  float _115;
  float _128;
  float _131;
  float _134;
  float _165;
  float _166;
  float _167;
  _8 = SV_Position.x * 0.0004340277810115367f;
  _9 = SV_Position.y * 0.02083333395421505f;
  _10 = g_tColorLutMixSource1.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _19 = g_tColorLutMixSource2.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _32 = g_tColorLutMixSource3.Sample(g_sNearestClamp_internal, float2(_8, _9));
  _41 = ((g_fColorLutMixMul2 * _19.x) + (g_fColorLutMixMul1 * _10.x)) + (g_fColorLutMixMul3 * _32.x);
  _42 = ((g_fColorLutMixMul2 * _19.y) + (g_fColorLutMixMul1 * _10.y)) + (g_fColorLutMixMul3 * _32.y);
  _43 = ((g_fColorLutMixMul2 * _19.z) + (g_fColorLutMixMul1 * _10.z)) + (g_fColorLutMixMul3 * _32.z);
  _44 = (g_fColorLutMixMul2 + g_fColorLutMixMul1) + g_fColorLutMixMul3;
  if (_44 < 1.0f) {
    _49 = uint(SV_Position.x);
    _65 = exp2(log2(((float)((uint)(_49 % 48))) * 0.021276595070958138f) * 0.012683313339948654f);
    _66 = exp2(log2(((float)((uint)uint(SV_Position.y))) * 0.021276595070958138f) * 0.012683313339948654f);
    _67 = exp2(log2(((float)((uint)(_49 / 48u))) * 0.021276595070958138f) * 0.012683313339948654f);
    _92 = saturate(1.0f - _44) * 125.0f;
    _100 = ((exp2(log2(max((_65 + -0.8359375f), 0.0f) / (18.8515625f - (_65 * 18.6875f))) * 6.277394771575928f) * _92) + _41);
    _101 = ((exp2(log2(max((_66 + -0.8359375f), 0.0f) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * _92) + _42);
    _102 = ((exp2(log2(max((_67 + -0.8359375f), 0.0f) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * _92) + _43);
  } else {
    _100 = _41;
    _101 = _42;
    _102 = _43;
  }
  if (dot(float3(_100, _101, _102), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _106 = max(_100, 0.0f);
    _107 = max(_101, 0.0f);
    _108 = max(_102, 0.0f);
    _109 = min(_100, 0.0f);
    _110 = min(_101, 0.0f);
    _111 = min(_102, 0.0f);
    _115 = dot(float3(_106, _107, _108), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_109, _110, _111), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _123 = ((_115 * _109) + _106);
    _124 = ((_115 * _110) + _107);
    _125 = ((_115 * _111) + _108);
  } else {
    _123 = _100;
    _124 = _101;
    _125 = _102;
  }

  const float3 compressed_color = CompressLUTMixerOutput(float3(_123, _124, _125));
  _123 = compressed_color.x;
  _124 = compressed_color.y;
  _125 = compressed_color.z;

  _128 = mad(0.05144599452614784f, _125, mad(0.5363325476646423f, _124, (_123 * 0.4122214615345001f)));
  _131 = mad(0.10739696025848389f, _125, mad(0.6806995272636414f, _124, (_123 * 0.21190349757671356f)));
  _134 = mad(0.6299787163734436f, _125, mad(0.2817188501358032f, _124, (_123 * 0.08830246329307556f)));
  _165 = exp2(log2(abs(_128)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_128 > 0.0f))) - ((int)(uint)((int)(_128 < 0.0f)))));
  _166 = exp2(log2(abs(_131)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_131 > 0.0f))) - ((int)(uint)((int)(_131 < 0.0f)))));
  _167 = exp2(log2(abs(_134)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_134 > 0.0f))) - ((int)(uint)((int)(_134 < 0.0f)))));
  SV_Target.x = mad(-0.004072046838700771f, _167, mad(0.7936177849769592f, _166, (_165 * 0.21045425534248352f)));
  SV_Target.y = mad(0.4505937099456787f, _167, mad(-2.4285922050476074f, _166, (_165 * 1.9779984951019287f)));
  SV_Target.z = mad(-0.8086757659912109f, _167, mad(0.7827717661857605f, _166, (_165 * 0.025904037058353424f)));
  SV_Target.w = 1.0f;
  return SV_Target;
}
