#define SHADER_HASH 0xF37A126A

#include "../../tonemap.hlsli"

Texture2D<float4> HDRImage : register(t0);

// cbuffer TonemapParam : register(b0) {
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
  float4 _8 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _12 = _8.x * Exposure;
  float _13 = _8.y * Exposure;
  float _14 = _8.z * Exposure;
  float _117;
  float _118;
  float _119;
  if (isfinite(max(max(_12, _13), _14))) {
    float _23 = invLinearBegin * _12;
    float _29 = invLinearBegin * _13;
    float _35 = invLinearBegin * _14;
    float _42 = select((_12 >= linearBegin), 0.0f, (1.0f - ((_23 * _23) * (3.0f - (_23 * 2.0f)))));
    float _44 = select((_13 >= linearBegin), 0.0f, (1.0f - ((_29 * _29) * (3.0f - (_29 * 2.0f)))));
    float _46 = select((_14 >= linearBegin), 0.0f, (1.0f - ((_35 * _35) * (3.0f - (_35 * 2.0f)))));
    float _52 = select((_12 < linearStart), 0.0f, 1.0f);
    float _53 = select((_13 < linearStart), 0.0f, 1.0f);
    float _54 = select((_14 < linearStart), 0.0f, 1.0f);
    _117 = (((((contrast * _12) + madLinearStartContrastFactor) * ((1.0f - _52) - _42)) + (((pow(_23, toe))*_42) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _12) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _52));
    _118 = (((((contrast * _13) + madLinearStartContrastFactor) * ((1.0f - _53) - _44)) + (((pow(_29, toe))*_44) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _13) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _53));
    _119 = (((((contrast * _14) + madLinearStartContrastFactor) * ((1.0f - _54) - _46)) + (((pow(_35, toe))*_46) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _14) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _54));
  } else {
    _117 = 1.0f;
    _118 = 1.0f;
    _119 = 1.0f;
  }
  SV_Target.x = _117;
  SV_Target.y = _118;
  SV_Target.z = _119;
  SV_Target.w = 1.0f;

  if (TONE_MAP_TYPE != 0) {
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb, SV_Position.xy);
  }

  return SV_Target;
}
