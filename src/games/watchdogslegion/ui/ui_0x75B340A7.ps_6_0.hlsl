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
  float _18;
  float _58;
  float _59;
  float _60;
  float _215;
  float _216;
  float _217;
  float _94;
  float _95;
  float _96;
  float _97;
  float _105;
  float _106;
  float _110;
  float _111;
  float _112;
  float _128;
  float _135;
  float _142;
  float _151;
  float _155;
  float _164;
  float _168;
  float _177;
  float _186;
  float _187;
  float _188;
  float _189;
  _18 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _58 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _18)) + _18) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _59 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _18)) + _18) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _60 = (exp2(log2(abs(((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _18)) + _18) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_58, _59, _60, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _215 = color.r;
    _216 = color.g;
    _217 = color.b;
#else  // original code
    _94 = saturate(select((_58 <= 0.040449999272823334f), (_58 * 0.07739938050508499f), exp2(log2(abs((_58 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _95 = saturate(select((_59 <= 0.040449999272823334f), (_59 * 0.07739938050508499f), exp2(log2(abs((_59 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _96 = saturate(select((_60 <= 0.040449999272823334f), (_60 * 0.07739938050508499f), exp2(log2(abs((_60 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _97 = dot(float3(_94, _95, _96), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _105 = select((_97 > 0.5f), (((_97 * HDROutput_016.y) / (HDROutput_016.y - _97)) + HDROutput_016.x), (_97 / (1.000100016593933f - _97)));
    _106 = _97 + 9.999999747378752e-05f;
    _110 = _105 * (_94 / _106);
    _111 = (_95 / _106) * _105;
    _112 = (_96 / _106) * _105;
    _128 = saturate(max(max(_110, _111), _112) + -1.0f);
    _135 = HDROutput_064 * 9.999999747378752e-05f;
    _142 = exp2(log2(abs(_135 * (((1.0f - _128) * mad(0.04331360012292862f, _112, mad(0.3292819857597351f, _111, (_110 * 0.627403974533081f)))) + (_128 * mad(0.047561999410390854f, _112, mad(0.19859300553798676f, _111, (_110 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _151 = exp2(log2(abs(((_142 * 18.8515625f) + 0.8359375f) / ((_142 * 18.6875f) + 1.0f))) * 78.84375f);
    _155 = exp2(log2(abs(_135 * mad(0.012477199546992779f, _112, mad(0.9417769908905029f, _111, (_110 * 0.045745600014925f))))) * 0.1593017578125f);
    _164 = exp2(log2(abs(((_155 * 18.8515625f) + 0.8359375f) / ((_155 * 18.6875f) + 1.0f))) * 78.84375f);
    _168 = exp2(log2(abs(_135 * mad(0.9836069941520691f, _112, mad(0.017604099586606026f, _111, (_110 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _177 = exp2(log2(abs(((_168 * 18.8515625f) + 0.8359375f) / ((_168 * 18.6875f) + 1.0f))) * 78.84375f);
    _186 = saturate(_151 / HDROutput_084);
    _187 = saturate(_164 / HDROutput_084);
    _188 = saturate(_177 / HDROutput_084);
    _189 = HDROutput_084 - HDROutput_036;
    _215 = select((_151 > HDROutput_076), _151, select((_151 < HDROutput_084), max((((_186 * _186) * _189) + HDROutput_036), _151), _151));
    _216 = select((_164 > HDROutput_076), _164, select((_164 < HDROutput_084), max((((_187 * _187) * _189) + HDROutput_036), _164), _164));
    _217 = select((_177 > HDROutput_076), _177, select((_177 < HDROutput_084), max((((_188 * _188) * _189) + HDROutput_036), _177), _177));
#endif
  } else {
    _215 = _58;
    _216 = _59;
    _217 = _60;
  }
  SV_Target.x = _215;
  SV_Target.y = _216;
  SV_Target.z = _217;
  SV_Target.w = ((select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y)) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}