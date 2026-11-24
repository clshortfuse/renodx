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
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
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
  float _93;
  float _94;
  float _95;
  float _133;
  float _134;
  float _135;
  float _291;
  float _292;
  float _293;
  float _170;
  float _171;
  float _172;
  float _173;
  float _181;
  float _182;
  float _186;
  float _187;
  float _188;
  float _204;
  float _211;
  float _218;
  float _227;
  float _231;
  float _240;
  float _244;
  float _253;
  float _262;
  float _263;
  float _264;
  float _265;
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
  _93 = FireUiPrimitive_000.x + FireUiPrimitive_016.x;
  _94 = FireUiPrimitive_000.y + FireUiPrimitive_016.y;
  _95 = FireUiPrimitive_000.z + FireUiPrimitive_016.z;
  _133 = (exp2(log2(abs(_93 * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _134 = (exp2(log2(abs(_94 * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _135 = (exp2(log2(abs(_95 * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_133, _134, _135, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _291 = color.r;
    _292 = color.g;
    _293 = color.b;
#else  // original code
    _170 = saturate(select((_133 <= 0.040449999272823334f), (_133 * 0.07739938050508499f), exp2(log2(abs((_133 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _171 = saturate(select((_134 <= 0.040449999272823334f), (_134 * 0.07739938050508499f), exp2(log2(abs((_134 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _172 = saturate(select((_135 <= 0.040449999272823334f), (_135 * 0.07739938050508499f), exp2(log2(abs((_135 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _173 = dot(float3(_170, _171, _172), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _181 = select((_173 > 0.5f), (((_173 * HDROutput_016.y) / (HDROutput_016.y - _173)) + HDROutput_016.x), (_173 / (1.000100016593933f - _173)));
    _182 = _173 + 9.999999747378752e-05f;
    _186 = _181 * (_170 / _182);
    _187 = (_171 / _182) * _181;
    _188 = (_172 / _182) * _181;
    _204 = saturate(max(max(_186, _187), _188) + -1.0f);
    _211 = HDROutput_064 * 9.999999747378752e-05f;
    _218 = exp2(log2(abs(_211 * (((1.0f - _204) * mad(0.04331360012292862f, _188, mad(0.3292819857597351f, _187, (_186 * 0.627403974533081f)))) + (_204 * mad(0.047561999410390854f, _188, mad(0.19859300553798676f, _187, (_186 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _227 = exp2(log2(abs(((_218 * 18.8515625f) + 0.8359375f) / ((_218 * 18.6875f) + 1.0f))) * 78.84375f);
    _231 = exp2(log2(abs(_211 * mad(0.012477199546992779f, _188, mad(0.9417769908905029f, _187, (_186 * 0.045745600014925f))))) * 0.1593017578125f);
    _240 = exp2(log2(abs(((_231 * 18.8515625f) + 0.8359375f) / ((_231 * 18.6875f) + 1.0f))) * 78.84375f);
    _244 = exp2(log2(abs(_211 * mad(0.9836069941520691f, _188, mad(0.017604099586606026f, _187, (_186 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _253 = exp2(log2(abs(((_244 * 18.8515625f) + 0.8359375f) / ((_244 * 18.6875f) + 1.0f))) * 78.84375f);
    _262 = saturate(_227 / HDROutput_084);
    _263 = saturate(_240 / HDROutput_084);
    _264 = saturate(_253 / HDROutput_084);
    _265 = HDROutput_084 - HDROutput_036;
    _291 = select((_227 > HDROutput_076), _227, select((_227 < HDROutput_084), max((((_262 * _262) * _265) + HDROutput_036), _227), _227));
    _292 = select((_240 > HDROutput_076), _240, select((_240 < HDROutput_084), max((((_263 * _263) * _265) + HDROutput_036), _240), _240));
    _293 = select((_253 > HDROutput_076), _253, select((_253 < HDROutput_084), max((((_264 * _264) * _265) + HDROutput_036), _253), _253));
#endif
  } else {
    _291 = _133;
    _292 = _134;
    _293 = _135;
  }
  SV_Target.x = _291;
  SV_Target.y = _292;
  SV_Target.z = _293;
  SV_Target.w = ((max(_56, (((_55 - ((_80 * _80) * (3.0f - (_80 * 2.0f)))) * dot(float3(_93, _94, _95), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f))) + _56)) * (FireUiPrimitive_000.w + FireUiPrimitive_016.w)) * (lerp(FireUiPrimitive_376, 1.0f, _56)));
  return SV_Target;
}