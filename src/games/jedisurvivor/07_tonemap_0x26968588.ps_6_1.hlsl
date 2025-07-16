#include "./shared.h"

cbuffer _19_21 : register(b0, space0) {
  float4 _21_m0[80] : packoffset(c0);
};

cbuffer _24_26 : register(b1, space0) {
  float4 _26_m0[235] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);   // Render
Texture2D<float4> _9 : register(t1, space0);   // Bloom?
Texture2D<float4> _10 : register(t2, space0);  // Luminance?
Texture2D<float4> _11 : register(t3, space0);  // Noise / Grain
Texture3D<float4> _14 : register(t4, space0);  // LUT
SamplerState _29 : register(s0, space0);
SamplerState _30 : register(s1, space0);
SamplerState _31 : register(s2, space0);
SamplerState _32 : register(s3, space0);

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

float4 main(
    // clang-format off
  noperspective float2 TEXCOORD : TEXCOORD0,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float3 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  float4 gl_FragCoord : SV_Position) : SV_Target0 {
  // clang-format on
  float _127;
  float _128;
  float _129;
  float _130;
  if (_21_m0[71u].y > 0.0f) {
    float _100 = ((_21_m0[71u].y * 0.25f) * dot(float2(TEXCOORD_3.x, TEXCOORD_3.y), float2(TEXCOORD_3.x, TEXCOORD_3.y))) + 1.0f;
    float _106 = (_21_m0[71u].y * 0.5f) + 1.0f;
    float _107 = (_100 * TEXCOORD_3.x) / _106;
    float _108 = (_100 * TEXCOORD_3.y) / _106;
    _127 = _107;
    _128 = _108;
    _129 = ((_21_m0[38u].z * _107) + _21_m0[39u].x) * _21_m0[38u].x;
    _130 = ((_21_m0[38u].w * _108) + _21_m0[39u].y) * _21_m0[38u].y;
  } else {
    _127 = TEXCOORD_3.x;
    _128 = TEXCOORD_3.y;
    _129 = TEXCOORD.x;
    _130 = TEXCOORD.y;
  }
  float _146 = (_21_m0[68u].z * _127) + _21_m0[68u].x;
  float _147 = (_21_m0[68u].w * _128) + _21_m0[68u].y;
  float _158 = float(int(uint(_146 > 0.0f) - uint(_146 < 0.0f)));
  float _159 = float(int(uint(_147 > 0.0f) - uint(_147 < 0.0f)));
  float _165 = clamp(abs(_146) - _21_m0[74u].z, 0.0f, 1.0f);
  float _166 = clamp(abs(_147) - _21_m0[74u].z, 0.0f, 1.0f);
  float _230 = _8.Sample(_29, float2((((((_146 - (((_165 * _21_m0[74u].x) * _21_m0[71u].x) * _158)) * _21_m0[69u].z) + _21_m0[69u].x) * _21_m0[38u].z) + _21_m0[39u].x) * _21_m0[38u].x, ((_21_m0[38u].w * (((_147 - ((_166 * _21_m0[74u].x) * _159)) * _21_m0[69u].w) + _21_m0[69u].y)) + _21_m0[39u].y) * _21_m0[38u].y)).x * _26_m0[135u].z;
  float _231 = _8.Sample(_29, float2(((_21_m0[38u].z * (((_146 - (((_165 * _21_m0[74u].y) * _158) * _21_m0[71u].x)) * _21_m0[69u].z) + _21_m0[69u].x)) + _21_m0[39u].x) * _21_m0[38u].x, ((_21_m0[38u].w * ((_21_m0[69u].w * (_147 - ((_166 * _21_m0[74u].y) * _159))) + _21_m0[69u].y)) + _21_m0[39u].y) * _21_m0[38u].y)).y * _26_m0[135u].z;
  float _232 = _8.Sample(_29, float2(_129, _130)).z * _26_m0[135u].z;
  float _237 = dot(float3(_230, _231, _232), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));

  // float3 input_color = float3(_230, _231, _232);
  // return float4(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(input_color), 100.f * 0.1f / 0.18f), saturate(_237));

  float _258 = (float(uint(floor(_21_m0[37u].y * _129)) & 1u) * 2.0f) + (-1.0f);
  float _263 = (float(uint(floor(_21_m0[37u].z * _130)) & 1u) * 2.0f) + (-1.0f);
  float4 _269 = _8.Sample(_29, float2((_258 * _21_m0[38u].x) + _129, _130));
  float _274 = _269.x * _26_m0[135u].z;
  float _275 = _269.y * _26_m0[135u].z;
  float _276 = _269.z * _26_m0[135u].z;
  float4 _282 = _8.Sample(_29, float2(_129, (_21_m0[38u].y * _263) + _130));
  float _287 = _282.x * _26_m0[135u].z;
  float _288 = _282.y * _26_m0[135u].z;
  float _289 = _282.z * _26_m0[135u].z;
  float _325 = (-0.0f) - (_21_m0[61u].y * clamp(1.0f - (max(max(abs(_237 - dot(float3(_274, _275, _276), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_237 - dot(float3(_287, _288, _289), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(ddx_fine(_237) * _258), abs(ddy_fine(_237) * _263))) * TEXCOORD_1.x), 0.0f, 1.0f));
  float4 _384 = _9.Sample(_30, float2(min(max((_21_m0[58u].z * _129) + _21_m0[59u].x, _21_m0[50u].z), _21_m0[51u].x), min(max((_21_m0[58u].w * _130) + _21_m0[59u].y, _21_m0[50u].w), _21_m0[51u].y)));
  float4 _407 = _10.Sample(_31, float2((((_21_m0[68u].z * _127) + _21_m0[68u].x) * 0.5f) + 0.5f, 0.5f - (((_21_m0[68u].w * _128) + _21_m0[68u].y) * 0.5f)));
  float _442 = _21_m0[61u].x * TEXCOORD_1.y;
  float _443 = _21_m0[61u].x * TEXCOORD_1.z;
  float _448 = 1.0f / (dot(float2(_442, _443), float2(_442, _443)) + 1.0f);
  float _449 = _448 * _448;
  float _450 = ((((((((((_274 - (_230 * 4.0f)) + _287) + _230) - (ddx_fine(_230) * _258)) + _230) - (ddy_fine(_230) * _263)) * _325) + _230) + ((_384.x * _26_m0[135u].z) * (_21_m0[60u].x + (_21_m0[67u].x * _407.x)))) * TEXCOORD_1.x) * _449;
  float _451 = ((((((((((_275 - (_231 * 4.0f)) + _288) + _231) - (ddx_fine(_231) * _258)) + _231) - (ddy_fine(_231) * _263)) * _325) + _231) + ((_384.y * _26_m0[135u].z) * (_21_m0[60u].y + (_21_m0[67u].y * _407.y)))) * TEXCOORD_1.x) * _449;
  float _452 = ((((((((((_276 - (_232 * 4.0f)) + _289) + _232) - (ddx_fine(_232) * _258)) + _232) - (ddy_fine(_232) * _263)) * _325) + _232) + ((_384.z * _26_m0[135u].z) * (_21_m0[60u].z + (_21_m0[67u].z * _407.z)))) * TEXCOORD_1.x) * _449;
  float _453 = dot(float3(_450, _451, _452), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _461 = clamp(_453 / _21_m0[65u].x, 0.0f, 1.0f);
  float _466 = (_461 * _461) * (3.0f - (_461 * 2.0f));
  float _472 = clamp((_453 - _21_m0[65u].y) / (1.0f - _21_m0[65u].y), 0.0f, 1.0f);
  float _476 = (_472 * _472) * (3.0f - (_472 * 2.0f));
  uint _492_dummy_parameter;
  uint2 _492 = spvTextureSize(_11, 0u, _492_dummy_parameter);
  float _494 = float(int(_492.x));
  float _496 = float(int(_492.y));
  float _516 = ((_21_m0[71u].z * dot(float3(_21_m0[64u].xyz), float3(_476, _466 - _476, 1.0f - _466))) * (_11.Load(int3(uint2(uint(int(fmod((_494 * TEXCOORD_2.z) + gl_FragCoord.x, _494))), uint(int(fmod((_496 * TEXCOORD_2.w) + gl_FragCoord.y, _496)))), 0u)).x + (-0.5f))) * (4.0f - (clamp(_453 * 11.0f, 0.0f, 1.0f) * 3.0f));
  float _517 = _516 + 0.5f;
  float _533 = 0.5f - _516;
  float _572 = exp2(log2((((1.0f - (_533 * (1.0f - ((_450 + (-0.5f)) * 2.0f)))) * float(_450 > 0.5f)) + (((_450 * 2.0f) * float(_450 <= 0.5f)) * _517)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _573 = exp2(log2((((1.0f - (_533 * (1.0f - ((_451 + (-0.5f)) * 2.0f)))) * float(_451 > 0.5f)) + (((_451 * 2.0f) * float(_451 <= 0.5f)) * _517)) * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _574 = exp2(log2((((1.0f - (_533 * (1.0f - ((_452 + (-0.5f)) * 2.0f)))) * float(_452 > 0.5f)) + (((_452 * 2.0f) * float(_452 <= 0.5f)) * _517)) * 0.00999999977648258209228515625f) * 0.1593017578125f);

  float3 lut_input_color = float3(
      (exp2(log2((1.0f / ((_572 * 18.6875f) + 1.0f)) * ((_572 * 18.8515625f) + 0.8359375f)) * 78.84375f) * 0.96875f) + 0.015625f,
      (exp2(log2((1.0f / ((_573 * 18.6875f) + 1.0f)) * ((_573 * 18.8515625f) + 0.8359375f)) * 78.84375f) * 0.96875f) + 0.015625f,
      (exp2(log2((1.0f / ((_574 * 18.6875f) + 1.0f)) * ((_574 * 18.8515625f) + 0.8359375f)) * 78.84375f) * 0.96875f) + 0.015625f);

  float4 _616 = _14.Sample(_32, lut_input_color);
  float _621 = _616.x * 1.0499999523162841796875f;
  float _623 = _616.y * 1.0499999523162841796875f;
  float _624 = _616.z * 1.0499999523162841796875f;
  float _646;
  float _648;
  float _650;
  if (_21_m0[70u].x > 0.0f) {
    float frontier_phi_4_3_ladder;
    float frontier_phi_4_3_ladder_1;
    float frontier_phi_4_3_ladder_2;
    if ((uint(_26_m0[132u].y * TEXCOORD.y) & 16u) == 0u) {
      frontier_phi_4_3_ladder = _621;
      frontier_phi_4_3_ladder_1 = _623;
      frontier_phi_4_3_ladder_2 = _624;
    } else {
      frontier_phi_4_3_ladder = clamp(_621, 0.0f, 1.0f);
      frontier_phi_4_3_ladder_1 = clamp(_623, 0.0f, 1.0f);
      frontier_phi_4_3_ladder_2 = clamp(_624, 0.0f, 1.0f);
    }
    _646 = frontier_phi_4_3_ladder;
    _648 = frontier_phi_4_3_ladder_1;
    _650 = frontier_phi_4_3_ladder_2;
  } else {
    _646 = _621;
    _648 = _623;
    _650 = _624;
  }
  float4 SV_Target;
  SV_Target.x = _646;
  SV_Target.y = _648;
  SV_Target.z = _650;
  SV_Target.w = clamp(dot(float3(_621, _623, _624), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f);

  // if (gl_FragCoord.x > 1920.f) {
  //   SV_Target.rgb = float3(_450, _451, _452) * 3.f;
  //   SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  //   // SV_Target.rgb = renodx::color::bt2020::from::BT2020(SV_Target.rgb);
  //   SV_Target.rgb = renodx::color::pq::Encode(SV_Target.rgb, 203.f);
  // }
  // SV_Target.rgb = renodx::color::ap1::from::BT709(SV_Target.rgb);

  return SV_Target;
}
