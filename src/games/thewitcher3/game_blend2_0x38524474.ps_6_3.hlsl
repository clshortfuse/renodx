#include "./common.hlsl"
#include "./lilium_rcas.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _6 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _43 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.x)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _44 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.y)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _45 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  // float _43 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.x)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  // float _44 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.y)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  // float _45 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  float _46 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_43, _44, _45));
  float _52 = saturate((_46 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
  float _57 = saturate((_46 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);
  // float _67 = exp2(log2(max(0.0f, _43)) * 2.200000047683716f);
  // float _68 = exp2(log2(max(0.0f, _44)) * 2.200000047683716f);
  // float _69 = exp2(log2(max(0.0f, _45)) * 2.200000047683716f);
  float _67 = CustomGammaDecode(_43);
  float _68 = CustomGammaDecode(_44);
  float _69 = CustomGammaDecode(_45);
  float3 ungraded = float3(_67, _68, _69);

  float _70 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_67, _68, _69));
  float _89 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _52) + CustomPixelConsts_192.x;
  float _90 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _52) + CustomPixelConsts_192.y;
  float _91 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _52) + CustomPixelConsts_192.z;
  float _92 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _52) + CustomPixelConsts_192.w;
  float _109 = ((CustomPixelConsts_208.w - _92) * _57) + _92;
  float _144 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  // SV_Target.x = (((CustomPixelConsts_144.x * exp2(log2(max(0.0f, (((_109 * (_67 - _70)) + _70) * (lerp(_89, CustomPixelConsts_208.x, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  // SV_Target.y = (((CustomPixelConsts_144.y * exp2(log2(max(0.0f, (((_109 * (_68 - _70)) + _70) * (lerp(_90, CustomPixelConsts_208.y, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  // SV_Target.z = (((CustomPixelConsts_144.z * exp2(log2(max(0.0f, (((_109 * (_69 - _70)) + _70) * (lerp(_91, CustomPixelConsts_208.z, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  SV_Target.x = (((CustomPixelConsts_144.x * CustomGammaEncode((((_109 * (_67 - _70)) + _70) * (lerp(_89, CustomPixelConsts_208.x, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.y = (((CustomPixelConsts_144.y * CustomGammaEncode((((_109 * (_68 - _70)) + _70) * (lerp(_90, CustomPixelConsts_208.y, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.z = (((CustomPixelConsts_144.z * CustomGammaEncode((((_109 * (_69 - _70)) + _70) * (lerp(_91, CustomPixelConsts_208.z, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.w = 1.0f;

  SV_Target.xyz = renodx::color::gamma::DecodeSafe(SV_Target.xyz);
  SV_Target.xyz = CustomColorGrading(ungraded, SV_Target.xyz);
  SV_Target.xyz = renodx::color::gamma::EncodeSafe(CustomTonemap(SV_Target.xyz));

  return SV_Target;
}
