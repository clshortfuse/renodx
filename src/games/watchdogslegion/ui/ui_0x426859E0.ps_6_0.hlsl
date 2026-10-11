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
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _13;
  float4 _21;
  float _25;
  float _26;
  float _27;
  float _28;
  float _56;
  float _57;
  float _58;
  float _59;
  float _72;
  float _73;
  float _74;
  float _75;
  float _253;
  float _254;
  float _255;
  float _95;
  float _96;
  float _97;
  float _132;
  float _133;
  float _134;
  float _135;
  float _143;
  float _144;
  float _148;
  float _149;
  float _150;
  float _166;
  float _173;
  float _180;
  float _189;
  float _193;
  float _202;
  float _206;
  float _215;
  float _224;
  float _225;
  float _226;
  float _227;
  _13 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _21 = t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y)));
  _25 = _21.x * 0.7400000095367432f;
  _26 = _21.y * 0.7400000095367432f;
  _27 = _21.z * 0.7400000095367432f;
  _28 = dot(float3(_25, _26, _27), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _56 = FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (_25 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f);
  _57 = FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (_26 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f);
  _58 = FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (_27 - _28)) + _28) * cb0_836w), 0.0f), 64512.0f);
  _59 = (_13.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_13.w > 0.0f) {
    _72 = (FireUiPrimitive_000.x + _56);
    _73 = (FireUiPrimitive_000.y + _57);
    _74 = (FireUiPrimitive_000.z + _58);
    _75 = (FireUiPrimitive_000.w + _59);
  } else {
    _72 = _56;
    _73 = _57;
    _74 = _58;
    _75 = _59;
  }
  _95 = (exp2(log2(abs(_72)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _96 = (exp2(log2(abs(_73)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _97 = (exp2(log2(abs(_74)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_95, _96, _97, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _253 = color.r;
    _254 = color.g;
    _255 = color.b;
#else  // original code
    _132 = saturate(select((_95 <= 0.040449999272823334f), (_95 * 0.07739938050508499f), exp2(log2(abs((_95 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _133 = saturate(select((_96 <= 0.040449999272823334f), (_96 * 0.07739938050508499f), exp2(log2(abs((_96 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _134 = saturate(select((_97 <= 0.040449999272823334f), (_97 * 0.07739938050508499f), exp2(log2(abs((_97 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _135 = dot(float3(_132, _133, _134), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _143 = select((_135 > 0.5f), (((_135 * HDROutput_016.y) / (HDROutput_016.y - _135)) + HDROutput_016.x), (_135 / (1.000100016593933f - _135)));
    _144 = _135 + 9.999999747378752e-05f;
    _148 = _143 * (_132 / _144);
    _149 = (_133 / _144) * _143;
    _150 = (_134 / _144) * _143;
    _166 = saturate(max(max(_148, _149), _150) + -1.0f);
    _173 = HDROutput_064 * 9.999999747378752e-05f;
    _180 = exp2(log2(abs(_173 * (((1.0f - _166) * mad(0.04331360012292862f, _150, mad(0.3292819857597351f, _149, (_148 * 0.627403974533081f)))) + (_166 * mad(0.047561999410390854f, _150, mad(0.19859300553798676f, _149, (_148 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _189 = exp2(log2(abs(((_180 * 18.8515625f) + 0.8359375f) / ((_180 * 18.6875f) + 1.0f))) * 78.84375f);
    _193 = exp2(log2(abs(_173 * mad(0.012477199546992779f, _150, mad(0.9417769908905029f, _149, (_148 * 0.045745600014925f))))) * 0.1593017578125f);
    _202 = exp2(log2(abs(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f))) * 78.84375f);
    _206 = exp2(log2(abs(_173 * mad(0.9836069941520691f, _150, mad(0.017604099586606026f, _149, (_148 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _215 = exp2(log2(abs(((_206 * 18.8515625f) + 0.8359375f) / ((_206 * 18.6875f) + 1.0f))) * 78.84375f);
    _224 = saturate(_189 / HDROutput_084);
    _225 = saturate(_202 / HDROutput_084);
    _226 = saturate(_215 / HDROutput_084);
    _227 = HDROutput_084 - HDROutput_036;
    _253 = select((_189 > HDROutput_076), _189, select((_189 < HDROutput_084), max((((_224 * _224) * _227) + HDROutput_036), _189), _189));
    _254 = select((_202 > HDROutput_076), _202, select((_202 < HDROutput_084), max((((_225 * _225) * _227) + HDROutput_036), _202), _202));
    _255 = select((_215 > HDROutput_076), _215, select((_215 < HDROutput_084), max((((_226 * _226) * _227) + HDROutput_036), _215), _215));
#endif
  } else {
    _253 = _95;
    _254 = _96;
    _255 = _97;
  }
  SV_Target.x = _253;
  SV_Target.y = _254;
  SV_Target.z = _255;
  SV_Target.w = _75;
  return SV_Target;
}