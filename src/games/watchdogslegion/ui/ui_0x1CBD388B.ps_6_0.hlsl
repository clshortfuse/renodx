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
  float _42;
  float _43;
  float4 _68;
  float4 _70;
  float4 _72;
  float _85;
  float _86;
  float _87;
  float _88;
  float _128;
  float _129;
  float _130;
  float _286;
  float _287;
  float _288;
  float _165;
  float _166;
  float _167;
  float _168;
  float _176;
  float _177;
  float _181;
  float _182;
  float _183;
  float _199;
  float _206;
  float _213;
  float _222;
  float _226;
  float _235;
  float _239;
  float _248;
  float _257;
  float _258;
  float _259;
  float _260;
  _42 = frac(TEXCOORD1_centroid.x);
  _43 = frac(TEXCOORD1_centroid.y);
  _68 = t0.Sample(s0, float2(min(max(((_42 * (FireUiPrimitive_192[0].x)) + (FireUiPrimitive_192[0].z)), (FireUiPrimitive_192[4].x)), (FireUiPrimitive_192[5].x)), min(max(((_43 * (FireUiPrimitive_192[0].y)) + (FireUiPrimitive_192[0].w)), (FireUiPrimitive_192[4].y)), (FireUiPrimitive_192[5].y))));
  _70 = t0.Sample(s0, float2(min(max(((_42 * (FireUiPrimitive_192[2].x)) + (FireUiPrimitive_192[2].z)), (FireUiPrimitive_192[6].x)), (FireUiPrimitive_192[7].x)), min(max(((_43 * (FireUiPrimitive_192[2].y)) + (FireUiPrimitive_192[2].w)), (FireUiPrimitive_192[6].y)), (FireUiPrimitive_192[7].y))));
  _72 = t0.Sample(s0, float2(min(max(((_42 * (FireUiPrimitive_192[3].x)) + (FireUiPrimitive_192[3].z)), (FireUiPrimitive_192[6].z)), (FireUiPrimitive_192[7].z)), min(max(((_43 * (FireUiPrimitive_192[3].y)) + (FireUiPrimitive_192[3].w)), (FireUiPrimitive_192[6].w)), (FireUiPrimitive_192[7].w))));
  _85 = ((_68.x + -0.7037500143051147f) + (_70.x * 1.4019999504089355f)) * TEXCOORD0_centroid.x;
  _86 = (((_68.x + 0.531220018863678f) - (_70.x * 0.714139997959137f)) - (_72.x * 0.3441399931907654f)) * TEXCOORD0_centroid.y;
  _87 = ((_68.x + -0.8894699811935425f) + (_72.x * 1.7719999551773071f)) * TEXCOORD0_centroid.z;
  _88 = dot(float3(_85, _86, _87), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _128 = (exp2(log2(abs(((FireUiPrimitive_344 * (_85 - _88)) + _88) * FireUiPrimitive_016.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _129 = (exp2(log2(abs((lerp(_88, _86, FireUiPrimitive_344)) * FireUiPrimitive_016.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _130 = (exp2(log2(abs((lerp(_88, _87, FireUiPrimitive_344)) * FireUiPrimitive_016.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_128, _129, _130, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _286 = color.r;
    _287 = color.g;
    _288 = color.b;
#else  // original code
    _165 = saturate(select((_128 <= 0.040449999272823334f), (_128 * 0.07739938050508499f), exp2(log2(abs((_128 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _166 = saturate(select((_129 <= 0.040449999272823334f), (_129 * 0.07739938050508499f), exp2(log2(abs((_129 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _167 = saturate(select((_130 <= 0.040449999272823334f), (_130 * 0.07739938050508499f), exp2(log2(abs((_130 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _168 = dot(float3(_165, _166, _167), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _176 = select((_168 > 0.5f), (((_168 * HDROutput_016.y) / (HDROutput_016.y - _168)) + HDROutput_016.x), (_168 / (1.000100016593933f - _168)));
    _177 = _168 + 9.999999747378752e-05f;
    _181 = _176 * (_165 / _177);
    _182 = (_166 / _177) * _176;
    _183 = (_167 / _177) * _176;
    _199 = saturate(max(max(_181, _182), _183) + -1.0f);
    _206 = HDROutput_064 * 9.999999747378752e-05f;
    _213 = exp2(log2(abs(_206 * (((1.0f - _199) * mad(0.04331360012292862f, _183, mad(0.3292819857597351f, _182, (_181 * 0.627403974533081f)))) + (_199 * mad(0.047561999410390854f, _183, mad(0.19859300553798676f, _182, (_181 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _222 = exp2(log2(abs(((_213 * 18.8515625f) + 0.8359375f) / ((_213 * 18.6875f) + 1.0f))) * 78.84375f);
    _226 = exp2(log2(abs(_206 * mad(0.012477199546992779f, _183, mad(0.9417769908905029f, _182, (_181 * 0.045745600014925f))))) * 0.1593017578125f);
    _235 = exp2(log2(abs(((_226 * 18.8515625f) + 0.8359375f) / ((_226 * 18.6875f) + 1.0f))) * 78.84375f);
    _239 = exp2(log2(abs(_206 * mad(0.9836069941520691f, _183, mad(0.017604099586606026f, _182, (_181 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _248 = exp2(log2(abs(((_239 * 18.8515625f) + 0.8359375f) / ((_239 * 18.6875f) + 1.0f))) * 78.84375f);
    _257 = saturate(_222 / HDROutput_084);
    _258 = saturate(_235 / HDROutput_084);
    _259 = saturate(_248 / HDROutput_084);
    _260 = HDROutput_084 - HDROutput_036;
    _286 = select((_222 > HDROutput_076), _222, select((_222 < HDROutput_084), max((((_257 * _257) * _260) + HDROutput_036), _222), _222));
    _287 = select((_235 > HDROutput_076), _235, select((_235 < HDROutput_084), max((((_258 * _258) * _260) + HDROutput_036), _235), _235));
    _288 = select((_248 > HDROutput_076), _248, select((_248 < HDROutput_084), max((((_259 * _259) * _260) + HDROutput_036), _248), _248));
#endif
  } else {
    _286 = _128;
    _287 = _129;
    _288 = _130;
  }
  SV_Target.x = _286;
  SV_Target.y = _287;
  SV_Target.z = _288;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}