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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _19;
  float _20;
  float _71;
  float _72;
  float _73;
  float _229;
  float _230;
  float _231;
  float _108;
  float _109;
  float _110;
  float _111;
  float _119;
  float _120;
  float _124;
  float _125;
  float _126;
  float _142;
  float _149;
  float _156;
  float _165;
  float _169;
  float _178;
  float _182;
  float _191;
  float _200;
  float _201;
  float _202;
  float _203;
  _19 = ((((float4)(t0.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_19) discard;
  _20 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _71 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _72 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _73 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_71, _72, _73, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _229 = color.r;
    _230 = color.g;
    _231 = color.b;
#else  // original code
    _108 = saturate(select((_71 <= 0.040449999272823334f), (_71 * 0.07739938050508499f), exp2(log2(abs((_71 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _109 = saturate(select((_72 <= 0.040449999272823334f), (_72 * 0.07739938050508499f), exp2(log2(abs((_72 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _110 = saturate(select((_73 <= 0.040449999272823334f), (_73 * 0.07739938050508499f), exp2(log2(abs((_73 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _111 = dot(float3(_108, _109, _110), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _119 = select((_111 > 0.5f), (((_111 * HDROutput_016.y) / (HDROutput_016.y - _111)) + HDROutput_016.x), (_111 / (1.000100016593933f - _111)));
    _120 = _111 + 9.999999747378752e-05f;
    _124 = _119 * (_108 / _120);
    _125 = (_109 / _120) * _119;
    _126 = (_110 / _120) * _119;
    _142 = saturate(max(max(_124, _125), _126) + -1.0f);
    _149 = HDROutput_064 * 9.999999747378752e-05f;
    _156 = exp2(log2(abs(_149 * (((1.0f - _142) * mad(0.04331360012292862f, _126, mad(0.3292819857597351f, _125, (_124 * 0.627403974533081f)))) + (_142 * mad(0.047561999410390854f, _126, mad(0.19859300553798676f, _125, (_124 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _165 = exp2(log2(abs(((_156 * 18.8515625f) + 0.8359375f) / ((_156 * 18.6875f) + 1.0f))) * 78.84375f);
    _169 = exp2(log2(abs(_149 * mad(0.012477199546992779f, _126, mad(0.9417769908905029f, _125, (_124 * 0.045745600014925f))))) * 0.1593017578125f);
    _178 = exp2(log2(abs(((_169 * 18.8515625f) + 0.8359375f) / ((_169 * 18.6875f) + 1.0f))) * 78.84375f);
    _182 = exp2(log2(abs(_149 * mad(0.9836069941520691f, _126, mad(0.017604099586606026f, _125, (_124 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _191 = exp2(log2(abs(((_182 * 18.8515625f) + 0.8359375f) / ((_182 * 18.6875f) + 1.0f))) * 78.84375f);
    _200 = saturate(_165 / HDROutput_084);
    _201 = saturate(_178 / HDROutput_084);
    _202 = saturate(_191 / HDROutput_084);
    _203 = HDROutput_084 - HDROutput_036;
    _229 = select((_165 > HDROutput_076), _165, select((_165 < HDROutput_084), max((((_200 * _200) * _203) + HDROutput_036), _165), _165));
    _230 = select((_178 > HDROutput_076), _178, select((_178 < HDROutput_084), max((((_201 * _201) * _203) + HDROutput_036), _178), _178));
    _231 = select((_191 > HDROutput_076), _191, select((_191 < HDROutput_084), max((((_202 * _202) * _203) + HDROutput_036), _191), _191));
#endif
  } else {
    _229 = _71;
    _230 = _72;
    _231 = _73;
  }
  SV_Target.x = _229;
  SV_Target.y = _230;
  SV_Target.z = _231;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}