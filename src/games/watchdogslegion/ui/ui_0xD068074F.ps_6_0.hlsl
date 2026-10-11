#include "UI.hlsli"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
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

cbuffer cb1 : register(b1) {
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
  float4 _11;
  bool _18;
  float _22;
  float _23;
  float _24;
  float _26;
  float _66;
  float _67;
  float _68;
  float _223;
  float _224;
  float _225;
  float _102;
  float _103;
  float _104;
  float _105;
  float _113;
  float _114;
  float _118;
  float _119;
  float _120;
  float _136;
  float _143;
  float _150;
  float _159;
  float _163;
  float _172;
  float _176;
  float _185;
  float _194;
  float _195;
  float _196;
  float _197;
  _11 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _18 = (FireUiPrimitive_396 != 0);
  _22 = select(_18, 1.0f, _11.x) * TEXCOORD0_centroid.x;
  _23 = select(_18, 1.0f, _11.y) * TEXCOORD0_centroid.y;
  _24 = select(_18, 1.0f, _11.z) * TEXCOORD0_centroid.z;
  _26 = dot(float3(_22, _23, _24), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _66 = (exp2(log2(abs((lerp(_26, _22, FireUiPrimitive_344)) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _67 = (exp2(log2(abs((lerp(_26, _23, FireUiPrimitive_344)) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _68 = (exp2(log2(abs((lerp(_26, _24, FireUiPrimitive_344)) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_66, _67, _68, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _223 = color.r;
    _224 = color.g;
    _225 = color.b;
#else  // original code
    _102 = saturate(select((_66 <= 0.040449999272823334f), (_66 * 0.07739938050508499f), exp2(log2(abs((_66 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _103 = saturate(select((_67 <= 0.040449999272823334f), (_67 * 0.07739938050508499f), exp2(log2(abs((_67 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _104 = saturate(select((_68 <= 0.040449999272823334f), (_68 * 0.07739938050508499f), exp2(log2(abs((_68 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _105 = dot(float3(_102, _103, _104), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _113 = select((_105 > 0.5f), (((_105 * HDROutput_016.y) / (HDROutput_016.y - _105)) + HDROutput_016.x), (_105 / (1.000100016593933f - _105)));
    _114 = _105 + 9.999999747378752e-05f;
    _118 = _113 * (_102 / _114);
    _119 = (_103 / _114) * _113;
    _120 = (_104 / _114) * _113;
    _136 = saturate(max(max(_118, _119), _120) + -1.0f);
    _143 = HDROutput_064 * 9.999999747378752e-05f;
    _150 = exp2(log2(abs(_143 * (((1.0f - _136) * mad(0.04331360012292862f, _120, mad(0.3292819857597351f, _119, (_118 * 0.627403974533081f)))) + (_136 * mad(0.047561999410390854f, _120, mad(0.19859300553798676f, _119, (_118 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _159 = exp2(log2(abs(((_150 * 18.8515625f) + 0.8359375f) / ((_150 * 18.6875f) + 1.0f))) * 78.84375f);
    _163 = exp2(log2(abs(_143 * mad(0.012477199546992779f, _120, mad(0.9417769908905029f, _119, (_118 * 0.045745600014925f))))) * 0.1593017578125f);
    _172 = exp2(log2(abs(((_163 * 18.8515625f) + 0.8359375f) / ((_163 * 18.6875f) + 1.0f))) * 78.84375f);
    _176 = exp2(log2(abs(_143 * mad(0.9836069941520691f, _120, mad(0.017604099586606026f, _119, (_118 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _185 = exp2(log2(abs(((_176 * 18.8515625f) + 0.8359375f) / ((_176 * 18.6875f) + 1.0f))) * 78.84375f);
    _194 = saturate(_159 / HDROutput_084);
    _195 = saturate(_172 / HDROutput_084);
    _196 = saturate(_185 / HDROutput_084);
    _197 = HDROutput_084 - HDROutput_036;
    _223 = select((_159 > HDROutput_076), _159, select((_159 < HDROutput_084), max((((_194 * _194) * _197) + HDROutput_036), _159), _159));
    _224 = select((_172 > HDROutput_076), _172, select((_172 < HDROutput_084), max((((_195 * _195) * _197) + HDROutput_036), _172), _172));
    _225 = select((_185 > HDROutput_076), _185, select((_185 < HDROutput_084), max((((_196 * _196) * _197) + HDROutput_036), _185), _185));
#endif
  } else {
    _223 = _66;
    _224 = _67;
    _225 = _68;
  }
  SV_Target.x = _223;
  SV_Target.y = _224;
  SV_Target.z = _225;
  SV_Target.w = ((_11.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}