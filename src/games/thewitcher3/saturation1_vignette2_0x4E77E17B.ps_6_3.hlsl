#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t2 : register(t2);

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

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_2 : TEXCOORD2
) : SV_Target {
  float4 SV_Target;
  float _18 = (TEXCOORD.x - CustomPixelConsts_272.x) / CustomPixelConsts_272.x;
  float _19 = (TEXCOORD.y - CustomPixelConsts_272.y) / CustomPixelConsts_272.y;
  float _23 = sqrt((_19 * _19) + (_18 * _18));
  float _26 = saturate((_23 - CustomPixelConsts_256.y) * CustomPixelConsts_256.z);
  float4 _27 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _57;
  float _58;
  [branch]
  if (_26 > 0.0f) {
    float _41 = ((_26 * _26) * CustomPixelConsts_256.x) * min(max((1.0f / _23), -3.4028234663852886e+38f), 3.4028234663852886e+38f);
    float _43 = (_18 * CustomPixelConsts_272.z) * _41;
    float _45 = (_19 * CustomPixelConsts_272.w) * _41;
    float4 _50 = t0.SampleLevel(s1, float2((TEXCOORD.x - (_43 * 2.0f)), (TEXCOORD.y - (_45 * 2.0f))), 0.0f);
    float4 _54 = t0.SampleLevel(s1, float2((TEXCOORD.x - _43), (TEXCOORD.y - _45)), 0.0f);
    _57 = _50.x;
    _58 = _54.y;
  } else {
    _57 = _27.x;
    _58 = _27.y;
  }
  float _92 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_57)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _93 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_58)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _94 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_27.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _95 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_92, _93, _94));
  float _101 = saturate((_95 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
  float _106 = saturate((_95 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);
  
  // float _116 = exp2(log2(max(0.0f, _92)) * 2.200000047683716f);
  // float _117 = exp2(log2(max(0.0f, _93)) * 2.200000047683716f);
  // float _118 = exp2(log2(max(0.0f, _94)) * 2.200000047683716f);
  float _116 = CustomGammaDecode(_92);
  float _117 = CustomGammaDecode(_93);
  float _118 = CustomGammaDecode(_94);
  float3 ungraded = float3(_116, _117, _118);
  
  float _119 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_116, _117, _118));
  float _138 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _101) + CustomPixelConsts_192.x;
  float _139 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _101) + CustomPixelConsts_192.y;
  float _140 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _101) + CustomPixelConsts_192.z;
  float _141 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _101) + CustomPixelConsts_192.w;
  float _158 = ((CustomPixelConsts_208.w - _141) * _106) + _141;
  float _187 = CustomPixelConsts_144.x * CustomGammaEncode(((_158 * (_116 - _119)) + _119) * (lerp(_138, CustomPixelConsts_208.x, _106)));
  float _188 = CustomPixelConsts_144.y * CustomGammaEncode(((_158 * (_117 - _119)) + _119) * (lerp(_139, CustomPixelConsts_208.y, _106)));
  float _189 = CustomPixelConsts_144.z * CustomGammaEncode(((_158 * (_118 - _119)) + _119) * (lerp(_140, CustomPixelConsts_208.z, _106)));

  float3 graded = renodx::color::gamma::DecodeSafe(float3(_187, _188, _189));
  graded = CustomColorGrading(ungraded, graded);
  _187 = renodx::color::gamma::EncodeSafe(graded.x);
  _188 = renodx::color::gamma::EncodeSafe(graded.y);
  _189 = renodx::color::gamma::EncodeSafe(graded.z);

  float4 _190 = t2.Sample(s2, float2(TEXCOORD_2.x, TEXCOORD_2.y));
  float _211 = saturate((CustomPixelConsts_096.w * _190.x) * saturate(1.0f - dot(float3((pow(_187, 2.200000047683716f)), (pow(_188, 2.200000047683716f)), (pow(_189, 2.200000047683716f))), float3(CustomPixelConsts_096.x, CustomPixelConsts_096.y, CustomPixelConsts_096.z))));
  float _228 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  SV_Target.x = (((lerp(_187, CustomPixelConsts_112.x * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_211 * CUSTOM_VIGNETTE))) * _228) + CustomPixelConsts_240.x);
  SV_Target.y = (((lerp(_188, CustomPixelConsts_112.y * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_211 * CUSTOM_VIGNETTE))) * _228) + CustomPixelConsts_240.x);
  SV_Target.z = (((lerp(_189, CustomPixelConsts_112.z * CUSTOM_VIGNETTE_BLACK_LEVEL, saturate(_211 * CUSTOM_VIGNETTE))) * _228) + CustomPixelConsts_240.x);
  SV_Target.w = 1.0f;

  SV_Target.xyz = renodx::color::gamma::DecodeSafe(SV_Target.xyz);
  SV_Target.xyz = renodx::color::gamma::EncodeSafe(CustomTonemap(SV_Target.xyz));

  return SV_Target;
}
