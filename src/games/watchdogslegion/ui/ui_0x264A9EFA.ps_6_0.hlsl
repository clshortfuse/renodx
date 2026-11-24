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
  bool _23;
  float4 _24;
  bool _31;
  float _35;
  float _36;
  float _37;
  float _39;
  float _67;
  float _68;
  float _69;
  float _70;
  float _83;
  float _84;
  float _85;
  float _86;
  float _263;
  float _264;
  float _265;
  float _106;
  float _107;
  float _108;
  float _142;
  float _143;
  float _144;
  float _145;
  float _153;
  float _154;
  float _158;
  float _159;
  float _160;
  float _176;
  float _183;
  float _190;
  float _199;
  float _203;
  float _212;
  float _216;
  float _225;
  float _234;
  float _235;
  float _236;
  float _237;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _24 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _31 = (FireUiPrimitive_396 != 0);
  _35 = select(_31, 1.0f, _24.x) * TEXCOORD0_centroid.x;
  _36 = select(_31, 1.0f, _24.y) * TEXCOORD0_centroid.y;
  _37 = select(_31, 1.0f, _24.z) * TEXCOORD0_centroid.z;
  _39 = dot(float3(_35, _36, _37), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _67 = FireUiPrimitive_016.x * min(max(((lerp(_39, _35, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _68 = FireUiPrimitive_016.y * min(max(((lerp(_39, _36, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _69 = FireUiPrimitive_016.z * min(max(((lerp(_39, _37, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _70 = (_24.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_24.w > 0.0f) {
    _83 = (FireUiPrimitive_000.x + _67);
    _84 = (FireUiPrimitive_000.y + _68);
    _85 = (FireUiPrimitive_000.z + _69);
    _86 = (FireUiPrimitive_000.w + _70);
  } else {
    _83 = _67;
    _84 = _68;
    _85 = _69;
    _86 = _70;
  }
  _106 = (exp2(log2(abs(_83)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _107 = (exp2(log2(abs(_84)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _108 = (exp2(log2(abs(_85)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_106, _107, _108, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _263 = color.r;
    _264 = color.g;
    _265 = color.b;
#else  // original code
    _142 = saturate(select((_106 <= 0.040449999272823334f), (_106 * 0.07739938050508499f), exp2(log2(abs((_106 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _143 = saturate(select((_107 <= 0.040449999272823334f), (_107 * 0.07739938050508499f), exp2(log2(abs((_107 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _144 = saturate(select((_108 <= 0.040449999272823334f), (_108 * 0.07739938050508499f), exp2(log2(abs((_108 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _145 = dot(float3(_142, _143, _144), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _153 = select((_145 > 0.5f), (((_145 * HDROutput_016.y) / (HDROutput_016.y - _145)) + HDROutput_016.x), (_145 / (1.000100016593933f - _145)));
    _154 = _145 + 9.999999747378752e-05f;
    _158 = _153 * (_142 / _154);
    _159 = (_143 / _154) * _153;
    _160 = (_144 / _154) * _153;
    _176 = saturate(max(max(_158, _159), _160) + -1.0f);
    _183 = HDROutput_064 * 9.999999747378752e-05f;
    _190 = exp2(log2(abs(_183 * (((1.0f - _176) * mad(0.04331360012292862f, _160, mad(0.3292819857597351f, _159, (_158 * 0.627403974533081f)))) + (_176 * mad(0.047561999410390854f, _160, mad(0.19859300553798676f, _159, (_158 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _199 = exp2(log2(abs(((_190 * 18.8515625f) + 0.8359375f) / ((_190 * 18.6875f) + 1.0f))) * 78.84375f);
    _203 = exp2(log2(abs(_183 * mad(0.012477199546992779f, _160, mad(0.9417769908905029f, _159, (_158 * 0.045745600014925f))))) * 0.1593017578125f);
    _212 = exp2(log2(abs(((_203 * 18.8515625f) + 0.8359375f) / ((_203 * 18.6875f) + 1.0f))) * 78.84375f);
    _216 = exp2(log2(abs(_183 * mad(0.9836069941520691f, _160, mad(0.017604099586606026f, _159, (_158 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _225 = exp2(log2(abs(((_216 * 18.8515625f) + 0.8359375f) / ((_216 * 18.6875f) + 1.0f))) * 78.84375f);
    _234 = saturate(_199 / HDROutput_084);
    _235 = saturate(_212 / HDROutput_084);
    _236 = saturate(_225 / HDROutput_084);
    _237 = HDROutput_084 - HDROutput_036;
    _263 = select((_199 > HDROutput_076), _199, select((_199 < HDROutput_084), max((((_234 * _234) * _237) + HDROutput_036), _199), _199));
    _264 = select((_212 > HDROutput_076), _212, select((_212 < HDROutput_084), max((((_235 * _235) * _237) + HDROutput_036), _212), _212));
    _265 = select((_225 > HDROutput_076), _225, select((_225 < HDROutput_084), max((((_236 * _236) * _237) + HDROutput_036), _225), _225));
#endif
  } else {
    _263 = _106;
    _264 = _107;
    _265 = _108;
  }
  SV_Target.x = _263;
  SV_Target.y = _264;
  SV_Target.z = _265;
  SV_Target.w = _86;
  return SV_Target;
}
