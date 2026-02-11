#define SHADER_HASH 0x1A45EF38

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
  float4 _10 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _14 = _10.x * Exposure;
  float _15 = _10.y * Exposure;
  float _16 = _10.z * Exposure;
  float _119;
  float _120;
  float _121;
  if (isfinite(max(max(_14, _15), _16))) {
    float _25 = invLinearBegin * _14;
    float _31 = invLinearBegin * _15;
    float _37 = invLinearBegin * _16;
    float _44 = select((_14 >= linearBegin), 0.0f, (1.0f - ((_25 * _25) * (3.0f - (_25 * 2.0f)))));
    float _46 = select((_15 >= linearBegin), 0.0f, (1.0f - ((_31 * _31) * (3.0f - (_31 * 2.0f)))));
    float _48 = select((_16 >= linearBegin), 0.0f, (1.0f - ((_37 * _37) * (3.0f - (_37 * 2.0f)))));
    float _54 = select((_14 < linearStart), 0.0f, 1.0f);
    float _55 = select((_15 < linearStart), 0.0f, 1.0f);
    float _56 = select((_16 < linearStart), 0.0f, 1.0f);
    _119 = (((((contrast * _14) + madLinearStartContrastFactor) * ((1.0f - _54) - _44)) + (((pow(_25, toe))*_44) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _14) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _54));
    _120 = (((((contrast * _15) + madLinearStartContrastFactor) * ((1.0f - _55) - _46)) + (((pow(_31, toe))*_46) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _15) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _55));
    _121 = (((((contrast * _16) + madLinearStartContrastFactor) * ((1.0f - _56) - _48)) + (((pow(_37, toe))*_48) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _16) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _56));
  } else {
    _119 = 1.0f;
    _120 = 1.0f;
    _121 = 1.0f;
  }
  SV_Target.x = _119;
  SV_Target.y = _120;
  SV_Target.z = _121;
  SV_Target.w = 1.0f;

  if (TONE_MAP_TYPE != 0) {
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb, SV_Position.xy);
  }

  return SV_Target;
}
