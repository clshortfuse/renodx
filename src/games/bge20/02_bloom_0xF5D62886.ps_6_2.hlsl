#include "./shared.h"

Texture2D<float4> Bloom_Parameters_srcTexture : register(t1, space0);
SamplerState Bloom_Samplers_samplerClampLinear : register(s0, space3);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

void frag_main() {
  uint _31_dummy_parameter;
  uint2 _31 = spvTextureSize(Bloom_Parameters_srcTexture, 0u, _31_dummy_parameter);
  float _36 = 1.0f / float(int(_31.x));
  float _38 = 1.0f / float(int(_31.y));
  float _39 = _36 * gl_FragCoord.x;
  float _40 = _38 * gl_FragCoord.y;
  float _43 = _36 * (gl_FragCoord.x + (-0.75f));
  float _45 = _38 * (gl_FragCoord.y + (-0.75f));
  float _54 = _43 + _36;
  float _60 = _45 + _38;
  float _76 = dot(float3(Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_43, _45)).xyz), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _83 = dot(float3(Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_54, _45)).xyz), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _86 = dot(float3(Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_43, _60)).xyz), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _89 = dot(float3(Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_54, _60)).xyz), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _94 = dot(float3(Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_39, _40)).xyz), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _106 = _76 + _83;
  float _109 = (-0.0f) - (_106 + (((-0.0f) - _89) - _86));
  float _112 = ((_76 - _83) + _86) - _89;
  float _123 = 1.0f / (min(abs(_109), abs(_112)) + max(((_106 + _86) + _89) * 0.03125f, 0.0078125f));
  float _132 = min(8.0f, max(-8.0f, _123 * _109)) * _36;
  float _133 = min(8.0f, max(-8.0f, _123 * _112)) * _38;
  float _134 = _132 * 0.16666667163372039794921875f;
  float _136 = _133 * 0.16666667163372039794921875f;
  float4 _139 = Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_39 - _134, _40 - _136));
  float4 _146 = Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_134 + _39, _136 + _40));
  float _151 = _146.x + _139.x;
  float _152 = _146.y + _139.y;
  float _153 = _146.z + _139.z;
  float _158 = _132 * 0.5f;
  float _159 = _133 * 0.5f;
  float4 _162 = Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_39 - _158, _40 - _159));
  float4 _169 = Bloom_Parameters_srcTexture.Sample(Bloom_Samplers_samplerClampLinear, float2(_158 + _39, _159 + _40));
  float _176 = ((_162.x + _151) + _169.x) * 0.25f;
  float _180 = ((_162.y + _152) + _169.y) * 0.25f;
  float _183 = ((_162.z + _153) + _169.z) * 0.25f;
  float _184 = dot(float3(_176, _180, _183), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  bool _190 = (_184 < min(_94, min(min(_76, _83), min(_86, _89)))) || (_184 > max(_94, max(max(_76, _83), max(_86, _89))));
  SV_Target.x = _190 ? (_151 * 0.5f) : _176;
  SV_Target.y = _190 ? (_152 * 0.5f) : _180;
  SV_Target.z = _190 ? (_153 * 0.5f) : _183;

  // SV_Target.rgb = max(0, SV_Target.rgb);
  // SV_Target.rgb = injectedData.toneMapGammaCorrection ? pow(SV_Target.rgb, 2.2f) : renodx::color::bt709::from::SRGB(SV_Target.rgb);
  // SV_Target.rgb *= injectedData.toneMapGameNits / 80.f;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
