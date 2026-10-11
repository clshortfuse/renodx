#include "other.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

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
  float4 GPUParticlesRender_000 : packoffset(c000.x);
  float4 GPUParticlesRender_016 : packoffset(c001.x);
  float4 GPUParticlesRender_032 : packoffset(c002.x);
  float4 GPUParticlesRender_048 : packoffset(c003.x);
  float3 GPUParticlesRender_064 : packoffset(c004.x);
  float GPUParticlesRender_076 : packoffset(c004.w);
  float3 GPUParticlesRender_080 : packoffset(c005.x);
  float GPUParticlesRender_092 : packoffset(c005.w);
  float3 GPUParticlesRender_096 : packoffset(c006.x);
  float GPUParticlesRender_108 : packoffset(c006.w);
  float3 GPUParticlesRender_112 : packoffset(c007.x);
  float GPUParticlesRender_124 : packoffset(c007.w);
  float3 GPUParticlesRender_128 : packoffset(c008.x);
  float GPUParticlesRender_140 : packoffset(c008.w);
  float GPUParticlesRender_144 : packoffset(c009.x);
};

SamplerState s0 : register(s0);

SamplerComparisonState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float3 TEXCOORD1_centroid : TEXCOORD1_centroid,
  linear float2 TEXCOORD2_centroid : TEXCOORD2_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _19;
  bool _23;
  float4 _24;
  float _31;
  float _36;
  float _37;
  float _39;
  float _41;
  float _44;
  float _47;
  float _50;
  float _53;
  float _54;
  float _55;
  float _61;
  float _62;
  float _63;
  float _121;
  float _134;
  float _147;
  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  _19 = ((TEXCOORD0_centroid.w - GPUParticlesRender_144) < 0.0f);
  if (_19) discard;
  _23 = (((((float4)(t0.SampleCmpLevelZero(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y), TEXCOORD1_centroid.z))).x) + -0.5f) < 0.0f);
  if (_23) discard;
  _24 = t1.Sample(s0, float2(TEXCOORD2_centroid.x, TEXCOORD2_centroid.y));
  _31 = saturate(_24.y * 40.0f);
  _36 = (GPUParticlesRender_016.y * (saturate((_24.x * 3.0f) + 0.03999999910593033f) - _31)) + _31;
  _37 = _36 * TEXCOORD0_centroid.x;
  _39 = (TEXCOORD0_centroid.y * 0.5f) * _36;
  _41 = (TEXCOORD0_centroid.z * 0.5f) * _36;
#if 1  // custom code
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_bt709 = float3(_37 * 0.5f, _39, _41);
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
    float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
    SV_Target.rgb = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);
    SV_Target.w = 1.0f;
    return SV_Target;
  }
#endif
  _44 = mad(0.043299999088048935f, _41, mad(0.3292999863624573f, _39, (_37 * 0.31369999051094055f)));
  _47 = mad(0.01140000019222498f, _41, mad(0.9194999933242798f, _39, (_37 * 0.03454999998211861f)));
  _50 = mad(0.8956000208854675f, _41, mad(0.08799999952316284f, _39, (_37 * 0.008200000040233135f)));
  _53 = HDROutput_064 * _44;
  _54 = HDROutput_064 * _47;
  _55 = HDROutput_064 * _50;
  _61 = _53 / HDROutput_048;
  _62 = _54 / HDROutput_048;
  _63 = _55 / HDROutput_048;
  _121 = exp2(log2(abs((select((_53 < HDROutput_048), ((HDROutput_048 * exp2(log2(abs(select((_61 <= 0.0031308000907301903f), (_61 * 12.920000076293945f), ((exp2(log2(abs(_61)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)))) * 2.4000000953674316f)) / HDROutput_064), _44) * 9.999999747378752e-05f) * HDROutput_064)) * 0.1593017578125f);
  _134 = exp2(log2(abs((select((_54 < HDROutput_048), ((HDROutput_048 * exp2(log2(abs(select((_62 <= 0.0031308000907301903f), (_62 * 12.920000076293945f), ((exp2(log2(abs(_62)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)))) * 2.4000000953674316f)) / HDROutput_064), _47) * 9.999999747378752e-05f) * HDROutput_064)) * 0.1593017578125f);
  _147 = exp2(log2(abs((select((_55 < HDROutput_048), ((HDROutput_048 * exp2(log2(abs(select((_63 <= 0.0031308000907301903f), (_63 * 12.920000076293945f), ((exp2(log2(abs(_63)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)))) * 2.4000000953674316f)) / HDROutput_064), _50) * 9.999999747378752e-05f) * HDROutput_064)) * 0.1593017578125f);
  SV_Target.x = exp2(log2(abs(((_121 * 18.8515625f) + 0.8359375f) / ((_121 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.y = exp2(log2(abs(((_134 * 18.8515625f) + 0.8359375f) / ((_134 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.z = exp2(log2(abs(((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f))) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}