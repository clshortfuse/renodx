#define SHADER_HASH 0x38F17A43

#include "../../tonemap.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer CameraKerare : register(b0) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

// cbuffer TonemapParam : register(b1) {
//   float contrast : packoffset(c000.x);
//   float linearBegin : packoffset(c000.y);
//   float linearLength : packoffset(c000.z);
//   float toe : packoffset(c000.w);
//   float maxNit : packoffset(c001.x);
//   float linearStart : packoffset(c001.y);
//   float displayMaxNitSubContrastFactor : packoffset(c001.z);
//   float contrastFactor : packoffset(c001.w);
//   float mulLinearStartContrastFactor : packoffset(c002.x);
//   float invLinearBegin : packoffset(c002.y);
//   float madLinearStartContrastFactor : packoffset(c002.z);
// };

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float4 _13 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _19 = Kerare.x / Kerare.w;
  float _20 = Kerare.y / Kerare.w;
  float _21 = Kerare.z / Kerare.w;
  float _25 = abs(rsqrt(dot(float3(_19, _20, _21), float3(_19, _20, _21))) * _21);
  float _32 = _25 * _25;
  float _36 = saturate(((_32 * _32) * (1.0f - saturate((kerare_scale * _25) + kerare_offset))) + kerare_brightness);
  float _38 = (_13.x * Exposure) * _36;
  float _40 = (_13.y * Exposure) * _36;
  float _42 = (_13.z * Exposure) * _36;
  float _145;
  float _146;
  float _147;
  if (isfinite(max(max(_38, _40), _42))) {
    float _51 = invLinearBegin * _38;
    float _57 = invLinearBegin * _40;
    float _63 = invLinearBegin * _42;
    float _70 = select((_38 >= linearBegin), 0.0f, (1.0f - ((_51 * _51) * (3.0f - (_51 * 2.0f)))));
    float _72 = select((_40 >= linearBegin), 0.0f, (1.0f - ((_57 * _57) * (3.0f - (_57 * 2.0f)))));
    float _74 = select((_42 >= linearBegin), 0.0f, (1.0f - ((_63 * _63) * (3.0f - (_63 * 2.0f)))));
    float _80 = select((_38 < linearStart), 0.0f, 1.0f);
    float _81 = select((_40 < linearStart), 0.0f, 1.0f);
    float _82 = select((_42 < linearStart), 0.0f, 1.0f);
    _145 = (((((contrast * _38) + madLinearStartContrastFactor) * ((1.0f - _80) - _70)) + (((pow(_51, toe))*_70) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _38) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _80));
    _146 = (((((contrast * _40) + madLinearStartContrastFactor) * ((1.0f - _81) - _72)) + (((pow(_57, toe))*_72) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _40) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _81));
    _147 = (((((contrast * _42) + madLinearStartContrastFactor) * ((1.0f - _82) - _74)) + (((pow(_63, toe))*_74) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _42) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _82));
  } else {
    _145 = 1.0f;
    _146 = 1.0f;
    _147 = 1.0f;
  }
  SV_Target.x = _145;
  SV_Target.y = _146;
  SV_Target.z = _147;
  SV_Target.w = 1.0f;

  if (TONE_MAP_TYPE != 0) {
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb, SV_Position.xy);
  }

  return SV_Target;
}
