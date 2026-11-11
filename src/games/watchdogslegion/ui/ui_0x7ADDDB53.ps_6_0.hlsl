#include "UI.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
};

cbuffer cb1 : register(b1) {
  float4 HDROutput_000 : packoffset(c000.x);
  float4 HDROutput_016 : packoffset(c001.x);
  float HDROutput_032 : packoffset(c002.x);
  float HDROutput_036 : packoffset(c002.y);
  float HDROutput_040 : packoffset(c002.z);
  float HDROutput_044 : packoffset(c002.w);
  float HDROutput_048 : packoffset(c003.x);
  float HDROutput_052 : packoffset(c003.y);
  float HDROutput_056 : packoffset(c003.z);
  float HDROutput_060 : packoffset(c003.w);
  float HDROutput_064 : packoffset(c004.x);
  float HDROutput_068 : packoffset(c004.y);
  float HDROutput_072 : packoffset(c004.z);
  float HDROutput_076 : packoffset(c004.w);
  float HDROutput_080 : packoffset(c005.x);
  float HDROutput_084 : packoffset(c005.y);
};

cbuffer cb2 : register(b2) {
  float4 FireUiPrimitive_000 : packoffset(c000.x);
  float4 FireUiPrimitive_016 : packoffset(c001.x);
  float4 FireUiPrimitive_032 : packoffset(c002.x);
  float4 FireUiPrimitive_048[4] : packoffset(c003.x);
  float4 FireUiPrimitive_112 : packoffset(c007.x);
  float4 FireUiPrimitive_128[4] : packoffset(c008.x);
  float4 FireUiPrimitive_192[8] : packoffset(c012.x);
  float3 FireUiPrimitive_320 : packoffset(c020.x);
  float FireUiPrimitive_332 : packoffset(c020.w);
  float2 FireUiPrimitive_336 : packoffset(c021.x);
  float FireUiPrimitive_344 : packoffset(c021.z);
  float FireUiPrimitive_348 : packoffset(c021.w);
  float2 FireUiPrimitive_352 : packoffset(c022.x);
  float FireUiPrimitive_360 : packoffset(c022.z);
  float FireUiPrimitive_364 : packoffset(c022.w);
  float FireUiPrimitive_368 : packoffset(c023.x);
  float FireUiPrimitive_372 : packoffset(c023.y);
  float FireUiPrimitive_376 : packoffset(c023.z);
  float FireUiPrimitive_380 : packoffset(c023.w);
  float FireUiPrimitive_384 : packoffset(c024.x);
  int FireUiPrimitive_388 : packoffset(c024.y);
  int FireUiPrimitive_392 : packoffset(c024.z);
  int FireUiPrimitive_396 : packoffset(c024.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float4 TEXCOORD0_centroid: TEXCOORD0_centroid,
    linear float4 TEXCOORD1_centroid: TEXCOORD1_centroid,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  bool _20;
  uint2 _21;
  float _24;
  float _26;
  float _28;
  float4 _29;
  float _32;
  float _39;
  float _45;
  float _46;
  float _51;
  float _55;
  float _56;
  float _66;
  float4 _71;
  float _80;
  float _124;
  float _125;
  float _126;
  float _282;
  float _283;
  float _284;
  float _161;
  float _162;
  float _163;
  float _164;
  float _172;
  float _173;
  float _177;
  float _178;
  float _179;
  float _195;
  float _202;
  float _209;
  float _218;
  float _222;
  float _231;
  float _235;
  float _244;
  float _253;
  float _254;
  float _255;
  float _256;
  _20 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_20) discard;
  // uint2 _21;
  t0.GetDimensions(_21.x, _21.y);
  _24 = ddx_coarse(TEXCOORD1_centroid.x);
  _26 = ddx_coarse(TEXCOORD1_centroid.z);
  _28 = (_24 * float((int)((int)(_21.x)))) / _26;
  _29 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _32 = min(_29.x, _29.w);
  _39 = ((FireUiPrimitive_364 - FireUiPrimitive_368) * _28) + FireUiPrimitive_368;
  _45 = ((FireUiPrimitive_348 - FireUiPrimitive_360) * _28) + FireUiPrimitive_360;
  _46 = _45 * 2.0f;
  _51 = saturate((((1.0f - _32) - _39) + _45) / _46);
  _55 = (_51 * _51) * (3.0f - (_51 * 2.0f));
  _56 = 1.0f - _55;
  _66 = FireUiPrimitive_380 * (4.0f / _26);
  _71 = t0.Sample(s1, float2((TEXCOORD1_centroid.x - ((FireUiPrimitive_336.x * _24) * _66)), (TEXCOORD1_centroid.y - ((FireUiPrimitive_336.y * ddy_coarse(TEXCOORD1_centroid.y)) * _66))));
  _80 = saturate((((1.0f - _39) + _45) - max(((FireUiPrimitive_372 * _28) + _32), min(_71.x, _71.w))) / _46);
  _124 = (exp2(log2(abs(FireUiPrimitive_016.x * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _125 = (exp2(log2(abs(FireUiPrimitive_016.y * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _126 = (exp2(log2(abs(FireUiPrimitive_016.z * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_124, _125, _126, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _282 = color.r;
    _283 = color.g;
    _284 = color.b;
#else  // original code
    _161 = saturate(select((_124 <= 0.040449999272823334f), (_124 * 0.07739938050508499f), exp2(log2(abs((_124 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _162 = saturate(select((_125 <= 0.040449999272823334f), (_125 * 0.07739938050508499f), exp2(log2(abs((_125 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _163 = saturate(select((_126 <= 0.040449999272823334f), (_126 * 0.07739938050508499f), exp2(log2(abs((_126 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _164 = dot(float3(_161, _162, _163), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _172 = select((_164 > 0.5f), (((_164 * HDROutput_016.y) / (HDROutput_016.y - _164)) + HDROutput_016.x), (_164 / (1.000100016593933f - _164)));
    _173 = _164 + 9.999999747378752e-05f;
    _177 = _172 * (_161 / _173);
    _178 = (_162 / _173) * _172;
    _179 = (_163 / _173) * _172;
    _195 = saturate(max(max(_177, _178), _179) + -1.0f);
    _202 = HDROutput_064 * 9.999999747378752e-05f;
    _209 = exp2(log2(abs(_202 * (((1.0f - _195) * mad(0.04331360012292862f, _179, mad(0.3292819857597351f, _178, (_177 * 0.627403974533081f)))) + (_195 * mad(0.047561999410390854f, _179, mad(0.19859300553798676f, _178, (_177 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _218 = exp2(log2(abs(((_209 * 18.8515625f) + 0.8359375f) / ((_209 * 18.6875f) + 1.0f))) * 78.84375f);
    _222 = exp2(log2(abs(_202 * mad(0.012477199546992779f, _179, mad(0.9417769908905029f, _178, (_177 * 0.045745600014925f))))) * 0.1593017578125f);
    _231 = exp2(log2(abs(((_222 * 18.8515625f) + 0.8359375f) / ((_222 * 18.6875f) + 1.0f))) * 78.84375f);
    _235 = exp2(log2(abs(_202 * mad(0.9836069941520691f, _179, mad(0.017604099586606026f, _178, (_177 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _244 = exp2(log2(abs(((_235 * 18.8515625f) + 0.8359375f) / ((_235 * 18.6875f) + 1.0f))) * 78.84375f);
    _253 = saturate(_218 / HDROutput_084);
    _254 = saturate(_231 / HDROutput_084);
    _255 = saturate(_244 / HDROutput_084);
    _256 = HDROutput_084 - HDROutput_036;
    _282 = select((_218 > HDROutput_076), _218, select((_218 < HDROutput_084), max((((_253 * _253) * _256) + HDROutput_036), _218), _218));
    _283 = select((_231 > HDROutput_076), _231, select((_231 < HDROutput_084), max((((_254 * _254) * _256) + HDROutput_036), _231), _231));
    _284 = select((_244 > HDROutput_076), _244, select((_244 < HDROutput_084), max((((_255 * _255) * _256) + HDROutput_036), _244), _244));
#endif
  } else {
    _282 = _124;
    _283 = _125;
    _284 = _126;
  }
  SV_Target.x = _282;
  SV_Target.y = _283;
  SV_Target.z = _284;
  SV_Target.w = ((max(_56, (((_55 - ((_80 * _80) * (3.0f - (_80 * 2.0f)))) * dot(float3(FireUiPrimitive_016.x, FireUiPrimitive_016.y, FireUiPrimitive_016.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f))) + _56)) * FireUiPrimitive_016.w) * (lerp(FireUiPrimitive_376, 1.0f, _56)));
  return SV_Target;
}
