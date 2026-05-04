#include "./common.hlsl"

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
  linear float2 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_2 : TEXCOORD2
) : SV_Target {
  float4 SV_Target;
  float4 _8 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _45 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_8.x)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _46 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_8.y)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _47 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_8.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _48 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_45, _46, _47));
  float _54 = saturate((_48 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
  float _59 = saturate((_48 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);

  // float _69 = exp2(log2(max(0.0f, _45)) * 2.200000047683716f);
  // float _70 = exp2(log2(max(0.0f, _46)) * 2.200000047683716f);
  // float _71 = exp2(log2(max(0.0f, _47)) * 2.200000047683716f);
  float _69 = CustomGammaDecode(_45);
  float _70 = CustomGammaDecode(_46);
  float _71 = CustomGammaDecode(_47);
  float3 ungraded = float3(_69, _70, _71);

  float _72 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_69, _70, _71));
  float _91 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _54) + CustomPixelConsts_192.x;
  float _92 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _54) + CustomPixelConsts_192.y;
  float _93 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _54) + CustomPixelConsts_192.z;
  float _94 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _54) + CustomPixelConsts_192.w;
  float _111 = ((CustomPixelConsts_208.w - _94) * _59) + _94;

  // float _140 = CustomPixelConsts_144.x * exp2(log2(max(0.0f, (((_111 * (_69 - _72)) + _72) * (lerp(_91, CustomPixelConsts_208.x, _59))))) * 0.4545454680919647f);
  // float _141 = CustomPixelConsts_144.y * exp2(log2(max(0.0f, (((_111 * (_70 - _72)) + _72) * (lerp(_92, CustomPixelConsts_208.y, _59))))) * 0.4545454680919647f);
  // float _142 = CustomPixelConsts_144.z * exp2(log2(max(0.0f, (((_111 * (_71 - _72)) + _72) * (lerp(_93, CustomPixelConsts_208.z, _59))))) * 0.4545454680919647f);
  float _140 = CustomPixelConsts_144.x * CustomGammaEncode(((_111 * (ungraded.x - _72)) + _72) * (lerp(_91, CustomPixelConsts_208.x, _59)));
  float _141 = CustomPixelConsts_144.y * CustomGammaEncode(((_111 * (ungraded.y - _72)) + _72) * (lerp(_92, CustomPixelConsts_208.y, _59)));
  float _142 = CustomPixelConsts_144.z * CustomGammaEncode(((_111 * (ungraded.z - _72)) + _72) * (lerp(_93, CustomPixelConsts_208.z, _59)));
  float3 graded = renodx::color::gamma::DecodeSafe(float3(_140, _141, _142));
  graded = CustomColorGrading(ungraded, graded);
  _140 = renodx::color::gamma::EncodeSafe(graded.x);
  _141 = renodx::color::gamma::EncodeSafe(graded.y);
  _142 = renodx::color::gamma::EncodeSafe(graded.z);

  float _143 = TEXCOORD_2.x + -0.5f;
  float _144 = TEXCOORD_2.y + -0.5f;
  float _151 = saturate((sqrt((_144 * _144) + (_143 * _143)) * 2.4390244483947754f) + -0.6707317233085632f);
  float _152 = _151 * _151;
  float _176 = saturate((CustomPixelConsts_096.w * min(dot(float4(-0.10000000149011612f, -0.10499999672174454f, 1.1200000047683716f, 0.09000000357627869f), float4((_152 * _152), (_152 * _151), _152, _151)), 0.9399999976158142f)) * saturate(1.0f - dot(float3((renodx::math::SafePow(_140, 2.200000047683716f)), (renodx::math::SafePow(_141, 2.200000047683716f)), (renodx::math::SafePow(_142, 2.200000047683716f))), float3(CustomPixelConsts_096.x, CustomPixelConsts_096.y, CustomPixelConsts_096.z))));
  float _193 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  SV_Target.x = (((lerp(_140, CustomPixelConsts_112.x * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_176 * CUSTOM_VIGNETTE))) * _193) + CustomPixelConsts_240.x);
  SV_Target.y = (((lerp(_141, CustomPixelConsts_112.y * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_176 * CUSTOM_VIGNETTE))) * _193) + CustomPixelConsts_240.x);
  SV_Target.z = (((lerp(_142, CustomPixelConsts_112.z * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_176 * CUSTOM_VIGNETTE))) * _193) + CustomPixelConsts_240.x);
  SV_Target.w = 1.0f;

  SV_Target.xyz = renodx::color::gamma::DecodeSafe(SV_Target.xyz);
  SV_Target.xyz = renodx::color::gamma::EncodeSafe(CustomTonemap(SV_Target.xyz));
  
  return SV_Target;
}
