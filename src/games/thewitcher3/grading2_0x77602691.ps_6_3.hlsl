//#include "./common.hlsl"
#include "./lutsampling.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

// cbuffer cb3 : register(b3) {
//   float4 CustomPixelConsts_000 : packoffset(c000.x);
//   float4 CustomPixelConsts_016 : packoffset(c001.x);
//   float4 CustomPixelConsts_032 : packoffset(c002.x);
//   float4 CustomPixelConsts_048 : packoffset(c003.x);
//   float4 CustomPixelConsts_064 : packoffset(c004.x);
//   float4 CustomPixelConsts_080 : packoffset(c005.x);
//   float4 CustomPixelConsts_096 : packoffset(c006.x);
//   float4 CustomPixelConsts_112 : packoffset(c007.x);
//   float4 CustomPixelConsts_128 : packoffset(c008.x);
//   float4 CustomPixelConsts_144 : packoffset(c009.x);
//   float4 CustomPixelConsts_160 : packoffset(c010.x);
//   float4 CustomPixelConsts_176 : packoffset(c011.x);
//   float4 CustomPixelConsts_192 : packoffset(c012.x);
//   float4 CustomPixelConsts_208 : packoffset(c013.x);
//   float4 CustomPixelConsts_224 : packoffset(c014.x);
//   float4 CustomPixelConsts_240 : packoffset(c015.x);
//   float4 CustomPixelConsts_256 : packoffset(c016.x);
//   float4 CustomPixelConsts_272 : packoffset(c017.x);
//   float4 CustomPixelConsts_288 : packoffset(c018.x);
//   float4 CustomPixelConsts_304 : packoffset(c019.x);
//   float4 CustomPixelConsts_320 : packoffset(c020.x);
//   float4 CustomPixelConsts_336[4] : packoffset(c021.x);
// };

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _19 = t0.Sample(s0, float2(min(max(TEXCOORD.x, CustomPixelConsts_000.x), CustomPixelConsts_000.z), min(max(TEXCOORD.y, CustomPixelConsts_000.y), CustomPixelConsts_000.w)));

  float3 ungraded = _19.rgb;
  float4 ungraded_sdr = ColorGradingSDR(ungraded);

  float3 lut_sampled_sdr1 = LUTSampling(ungraded_sdr.xyz, ungraded_sdr.xyz, t1, s1);
  float3 lut_sampled_sdr2 = LUTSampling(lut_sampled_sdr1, ungraded_sdr.xyz, t2, s2);

  float3 graded_sdr = VanillaOutput2(lut_sampled_sdr1, lut_sampled_sdr2, ungraded_sdr.xyz);
  float3 graded_hdr = ColorGradeHDR(float4(graded_sdr, ungraded_sdr.w));
  SV_Target.xyz = lerp(ungraded, graded_hdr, CUSTOM_LUT_STRENGTH);
  SV_Target.w = _19.w;
  return SV_Target;
  // _19.rgb = ungraded_sdr.rgb;

  // // linear to 2.2
  // float _35 = exp2(log2(abs(_19.z)) * 0.4545454680919647f);
  // float _37 = _35 * 63.75f;
  // float _38 = floor(_37);
  // float _41 = _37 - _38;
  // float _45 = min(0.9999899864196777f, saturate((_35 * 0.99609375f) + 0.015625f));
  // float _52 = min(max(((saturate(exp2(log2(abs(_19.x)) * 0.4545454680919647f)) + 0.0078125f) * 0.99609375f), 0.015625f), 0.984375f);
  // float _53 = min(max(((saturate(exp2(log2(abs(_19.y)) * 0.4545454680919647f)) + 0.0078125f) * 0.99609375f), 0.015625f), 0.984375f);

  // float _56 = floor(_45 * 8.0f);
  // float _61 = (floor((_45 * 64.0f) - (_56 * 8.0f)) + _52) * 0.125f;
  // float _63 = (_56 + _53) * 0.125f;
  // float4 _64 = t1.SampleLevel(s1, float2(_61, _63), 0.0f);
  // float _69 = min(0.9999899864196777f, saturate(_38 * 0.015625f));
  // float _72 = floor(_69 * 8.0f);
  // float _77 = (floor((_69 * 64.0f) - (_72 * 8.0f)) + _52) * 0.125f;
  // float _79 = (_72 + _53) * 0.125f;
  // float4 _80 = t1.SampleLevel(s1, float2(_77, _79), 0.0f);

  // //2.2 to linear
  // float _102 = exp2(log2(abs(lerp(_80.x, _64.x, _41))) * 2.200000047683716f);
  // float _103 = exp2(log2(abs(lerp(_80.y, _64.y, _41))) * 2.200000047683716f);
  // float _104 = exp2(log2(abs(lerp(_80.z, _64.z, _41))) * 2.200000047683716f);
  // float4 _107 = t2.SampleLevel(s2, float2(_61, _63), 0.0f);
  // float4 _111 = t2.SampleLevel(s2, float2(_77, _79), 0.0f);
  // float3 test = _64.rgb;
  // SV_Target.x = ((((CustomPixelConsts_016.z * (((exp2(log2(abs(lerp(_111.x, _107.x, _41))) * 2.200000047683716f) - _102) * CustomPixelConsts_016.x) + _102)) - _19.x) * CustomPixelConsts_016.y) + _19.x);
  // SV_Target.y = ((((CustomPixelConsts_016.z * (((exp2(log2(abs(lerp(_111.y, _107.y, _41))) * 2.200000047683716f) - _103) * CustomPixelConsts_016.x) + _103)) - _19.y) * CustomPixelConsts_016.y) + _19.y);
  // SV_Target.z = ((((CustomPixelConsts_016.z * (((exp2(log2(abs(lerp(_111.z, _107.z, _41))) * 2.200000047683716f) - _104) * CustomPixelConsts_016.x) + _104)) - _19.z) * CustomPixelConsts_016.y) + _19.z);
  // SV_Target.w = _19.w;

  // float3 graded_sdr = SV_Target.rgb;
  // // SV_Target.rgb = CustomUpgradeGrading(ungraded, ungraded_sdr, graded_sdr);
  // SV_Target.rgb = lerp(ungraded, ColorGradeHDR(float4(SV_Target.rgb, ungraded_sdr.w)), CUSTOM_LUT_STRENGTH);

  return SV_Target;
}
