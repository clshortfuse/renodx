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
  float _16;
  float _18;
  float _35;
  float _36;
  float _37;
  float _38;
  float _51;
  float _52;
  float _53;
  float _54;
  float _231;
  float _232;
  float _233;
  float _74;
  float _75;
  float _76;
  float _110;
  float _111;
  float _112;
  float _113;
  float _121;
  float _122;
  float _126;
  float _127;
  float _128;
  float _144;
  float _151;
  float _158;
  float _167;
  float _171;
  float _180;
  float _184;
  float _193;
  float _202;
  float _203;
  float _204;
  float _205;
  _16 = select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y));
  _18 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _35 = ((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _18)) + _18) * FireUiPrimitive_016.x;
  _36 = ((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _18)) + _18) * FireUiPrimitive_016.y;
  _37 = ((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _18)) + _18) * FireUiPrimitive_016.z;
  _38 = (_16 * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_16 > 0.0f) {
    _51 = (FireUiPrimitive_000.x + _35);
    _52 = (FireUiPrimitive_000.y + _36);
    _53 = (FireUiPrimitive_000.z + _37);
    _54 = (FireUiPrimitive_000.w + _38);
  } else {
    _51 = _35;
    _52 = _36;
    _53 = _37;
    _54 = _38;
  }
  _74 = (exp2(log2(abs(_51)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _75 = (exp2(log2(abs(_52)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _76 = (exp2(log2(abs(_53)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_74, _75, _76, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _231 = color.r;
    _232 = color.g;
    _233 = color.b;
#else  // original code
    _110 = saturate(select((_74 <= 0.040449999272823334f), (_74 * 0.07739938050508499f), exp2(log2(abs((_74 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _111 = saturate(select((_75 <= 0.040449999272823334f), (_75 * 0.07739938050508499f), exp2(log2(abs((_75 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _112 = saturate(select((_76 <= 0.040449999272823334f), (_76 * 0.07739938050508499f), exp2(log2(abs((_76 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _113 = dot(float3(_110, _111, _112), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _121 = select((_113 > 0.5f), (((_113 * HDROutput_016.y) / (HDROutput_016.y - _113)) + HDROutput_016.x), (_113 / (1.000100016593933f - _113)));
    _122 = _113 + 9.999999747378752e-05f;
    _126 = _121 * (_110 / _122);
    _127 = (_111 / _122) * _121;
    _128 = (_112 / _122) * _121;
    _144 = saturate(max(max(_126, _127), _128) + -1.0f);
    _151 = HDROutput_064 * 9.999999747378752e-05f;
    _158 = exp2(log2(abs(_151 * (((1.0f - _144) * mad(0.04331360012292862f, _128, mad(0.3292819857597351f, _127, (_126 * 0.627403974533081f)))) + (_144 * mad(0.047561999410390854f, _128, mad(0.19859300553798676f, _127, (_126 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _167 = exp2(log2(abs(((_158 * 18.8515625f) + 0.8359375f) / ((_158 * 18.6875f) + 1.0f))) * 78.84375f);
    _171 = exp2(log2(abs(_151 * mad(0.012477199546992779f, _128, mad(0.9417769908905029f, _127, (_126 * 0.045745600014925f))))) * 0.1593017578125f);
    _180 = exp2(log2(abs(((_171 * 18.8515625f) + 0.8359375f) / ((_171 * 18.6875f) + 1.0f))) * 78.84375f);
    _184 = exp2(log2(abs(_151 * mad(0.9836069941520691f, _128, mad(0.017604099586606026f, _127, (_126 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _193 = exp2(log2(abs(((_184 * 18.8515625f) + 0.8359375f) / ((_184 * 18.6875f) + 1.0f))) * 78.84375f);
    _202 = saturate(_167 / HDROutput_084);
    _203 = saturate(_180 / HDROutput_084);
    _204 = saturate(_193 / HDROutput_084);
    _205 = HDROutput_084 - HDROutput_036;
    _231 = select((_167 > HDROutput_076), _167, select((_167 < HDROutput_084), max((((_202 * _202) * _205) + HDROutput_036), _167), _167));
    _232 = select((_180 > HDROutput_076), _180, select((_180 < HDROutput_084), max((((_203 * _203) * _205) + HDROutput_036), _180), _180));
    _233 = select((_193 > HDROutput_076), _193, select((_193 < HDROutput_084), max((((_204 * _204) * _205) + HDROutput_036), _193), _193));
#endif
  } else {
    _231 = _74;
    _232 = _75;
    _233 = _76;
  }
  SV_Target.x = _231;
  SV_Target.y = _232;
  SV_Target.z = _233;
  SV_Target.w = _54;
  return SV_Target;
}