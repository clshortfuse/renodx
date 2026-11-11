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

cbuffer cb0 : register(b0) {
  float cb0_836w : packoffset(c836.w);
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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _12;
  bool _19;
  float _23;
  float _24;
  float _25;
  float _27;
  float _55;
  float _56;
  float _57;
  float _58;
  float _71;
  float _72;
  float _73;
  float _74;
  float _251;
  float _252;
  float _253;
  float _94;
  float _95;
  float _96;
  float _130;
  float _131;
  float _132;
  float _133;
  float _141;
  float _142;
  float _146;
  float _147;
  float _148;
  float _164;
  float _171;
  float _178;
  float _187;
  float _191;
  float _200;
  float _204;
  float _213;
  float _222;
  float _223;
  float _224;
  float _225;
  _12 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _19 = (FireUiPrimitive_396 != 0);
  _23 = select(_19, 1.0f, _12.x) * TEXCOORD0_centroid.x;
  _24 = select(_19, 1.0f, _12.y) * TEXCOORD0_centroid.y;
  _25 = select(_19, 1.0f, _12.z) * TEXCOORD0_centroid.z;
  _27 = dot(float3(_23, _24, _25), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _55 = FireUiPrimitive_016.x * min(max(((lerp(_27, _23, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _56 = FireUiPrimitive_016.y * min(max(((lerp(_27, _24, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _57 = FireUiPrimitive_016.z * min(max(((lerp(_27, _25, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _58 = (_12.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_12.w > 0.0f) {
    _71 = (FireUiPrimitive_000.x + _55);
    _72 = (FireUiPrimitive_000.y + _56);
    _73 = (FireUiPrimitive_000.z + _57);
    _74 = (FireUiPrimitive_000.w + _58);
  } else {
    _71 = _55;
    _72 = _56;
    _73 = _57;
    _74 = _58;
  }
  _94 = (exp2(log2(abs(_71)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _95 = (exp2(log2(abs(_72)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _96 = (exp2(log2(abs(_73)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_94, _95, _96, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _251 = color.r;
    _252 = color.g;
    _253 = color.b;
#else  // original code
    _130 = saturate(select((_94 <= 0.040449999272823334f), (_94 * 0.07739938050508499f), exp2(log2(abs((_94 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _131 = saturate(select((_95 <= 0.040449999272823334f), (_95 * 0.07739938050508499f), exp2(log2(abs((_95 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _132 = saturate(select((_96 <= 0.040449999272823334f), (_96 * 0.07739938050508499f), exp2(log2(abs((_96 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _133 = dot(float3(_130, _131, _132), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _141 = select((_133 > 0.5f), (((_133 * HDROutput_016.y) / (HDROutput_016.y - _133)) + HDROutput_016.x), (_133 / (1.000100016593933f - _133)));
    _142 = _133 + 9.999999747378752e-05f;
    _146 = _141 * (_130 / _142);
    _147 = (_131 / _142) * _141;
    _148 = (_132 / _142) * _141;
    _164 = saturate(max(max(_146, _147), _148) + -1.0f);
    _171 = HDROutput_064 * 9.999999747378752e-05f;
    _178 = exp2(log2(abs(_171 * (((1.0f - _164) * mad(0.04331360012292862f, _148, mad(0.3292819857597351f, _147, (_146 * 0.627403974533081f)))) + (_164 * mad(0.047561999410390854f, _148, mad(0.19859300553798676f, _147, (_146 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _187 = exp2(log2(abs(((_178 * 18.8515625f) + 0.8359375f) / ((_178 * 18.6875f) + 1.0f))) * 78.84375f);
    _191 = exp2(log2(abs(_171 * mad(0.012477199546992779f, _148, mad(0.9417769908905029f, _147, (_146 * 0.045745600014925f))))) * 0.1593017578125f);
    _200 = exp2(log2(abs(((_191 * 18.8515625f) + 0.8359375f) / ((_191 * 18.6875f) + 1.0f))) * 78.84375f);
    _204 = exp2(log2(abs(_171 * mad(0.9836069941520691f, _148, mad(0.017604099586606026f, _147, (_146 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _213 = exp2(log2(abs(((_204 * 18.8515625f) + 0.8359375f) / ((_204 * 18.6875f) + 1.0f))) * 78.84375f);
    _222 = saturate(_187 / HDROutput_084);
    _223 = saturate(_200 / HDROutput_084);
    _224 = saturate(_213 / HDROutput_084);
    _225 = HDROutput_084 - HDROutput_036;
    _251 = select((_187 > HDROutput_076), _187, select((_187 < HDROutput_084), max((((_222 * _222) * _225) + HDROutput_036), _187), _187));
    _252 = select((_200 > HDROutput_076), _200, select((_200 < HDROutput_084), max((((_223 * _223) * _225) + HDROutput_036), _200), _200));
    _253 = select((_213 > HDROutput_076), _213, select((_213 < HDROutput_084), max((((_224 * _224) * _225) + HDROutput_036), _213), _213));
#endif
  } else {
    _251 = _94;
    _252 = _95;
    _253 = _96;
  }
  SV_Target.x = _251;
  SV_Target.y = _252;
  SV_Target.z = _253;
  SV_Target.w = _74;
  return SV_Target;
}