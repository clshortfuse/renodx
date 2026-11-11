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
  float _78;
  float _79;
  float _80;
  float _235;
  float _236;
  float _237;
  float _114;
  float _115;
  float _116;
  float _117;
  float _125;
  float _126;
  float _130;
  float _131;
  float _132;
  float _148;
  float _155;
  float _162;
  float _171;
  float _175;
  float _184;
  float _188;
  float _197;
  float _206;
  float _207;
  float _208;
  float _209;
  _12 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _19 = (FireUiPrimitive_396 != 0);
  _23 = select(_19, 1.0f, _12.x) * TEXCOORD0_centroid.x;
  _24 = select(_19, 1.0f, _12.y) * TEXCOORD0_centroid.y;
  _25 = select(_19, 1.0f, _12.z) * TEXCOORD0_centroid.z;
  _27 = dot(float3(_23, _24, _25), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _78 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max(((lerp(_27, _23, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _79 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max(((lerp(_27, _24, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _80 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max(((lerp(_27, _25, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_78, _79, _80, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _235 = color.r;
    _236 = color.g;
    _237 = color.b;
#else  // original code
    _114 = saturate(select((_78 <= 0.040449999272823334f), (_78 * 0.07739938050508499f), exp2(log2(abs((_78 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _115 = saturate(select((_79 <= 0.040449999272823334f), (_79 * 0.07739938050508499f), exp2(log2(abs((_79 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _116 = saturate(select((_80 <= 0.040449999272823334f), (_80 * 0.07739938050508499f), exp2(log2(abs((_80 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _117 = dot(float3(_114, _115, _116), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _125 = select((_117 > 0.5f), (((_117 * HDROutput_016.y) / (HDROutput_016.y - _117)) + HDROutput_016.x), (_117 / (1.000100016593933f - _117)));
    _126 = _117 + 9.999999747378752e-05f;
    _130 = _125 * (_114 / _126);
    _131 = (_115 / _126) * _125;
    _132 = (_116 / _126) * _125;
    _148 = saturate(max(max(_130, _131), _132) + -1.0f);
    _155 = HDROutput_064 * 9.999999747378752e-05f;
    _162 = exp2(log2(abs(_155 * (((1.0f - _148) * mad(0.04331360012292862f, _132, mad(0.3292819857597351f, _131, (_130 * 0.627403974533081f)))) + (_148 * mad(0.047561999410390854f, _132, mad(0.19859300553798676f, _131, (_130 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _171 = exp2(log2(abs(((_162 * 18.8515625f) + 0.8359375f) / ((_162 * 18.6875f) + 1.0f))) * 78.84375f);
    _175 = exp2(log2(abs(_155 * mad(0.012477199546992779f, _132, mad(0.9417769908905029f, _131, (_130 * 0.045745600014925f))))) * 0.1593017578125f);
    _184 = exp2(log2(abs(((_175 * 18.8515625f) + 0.8359375f) / ((_175 * 18.6875f) + 1.0f))) * 78.84375f);
    _188 = exp2(log2(abs(_155 * mad(0.9836069941520691f, _132, mad(0.017604099586606026f, _131, (_130 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _197 = exp2(log2(abs(((_188 * 18.8515625f) + 0.8359375f) / ((_188 * 18.6875f) + 1.0f))) * 78.84375f);
    _206 = saturate(_171 / HDROutput_084);
    _207 = saturate(_184 / HDROutput_084);
    _208 = saturate(_197 / HDROutput_084);
    _209 = HDROutput_084 - HDROutput_036;
    _235 = select((_171 > HDROutput_076), _171, select((_171 < HDROutput_084), max((((_206 * _206) * _209) + HDROutput_036), _171), _171));
    _236 = select((_184 > HDROutput_076), _184, select((_184 < HDROutput_084), max((((_207 * _207) * _209) + HDROutput_036), _184), _184));
    _237 = select((_197 > HDROutput_076), _197, select((_197 < HDROutput_084), max((((_208 * _208) * _209) + HDROutput_036), _197), _197));
#endif
  } else {
    _235 = _78;
    _236 = _79;
    _237 = _80;
  }
  SV_Target.x = _235;
  SV_Target.y = _236;
  SV_Target.z = _237;
  SV_Target.w = ((_12.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}