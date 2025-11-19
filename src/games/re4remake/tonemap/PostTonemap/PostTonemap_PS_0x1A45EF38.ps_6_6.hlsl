#include "../../common.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer TonemapParam : register(b0) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
};

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float new_toe = toe;
  float new_contrast = contrast;
  float new_max_nit = maxNit;
  float new_linear_start = linearStart;
  if (TONE_MAP_TYPE != 0) {
    if (RENODX_TONE_MAP_TOE_ADJUSTMENT_TYPE == 0) {
      new_toe *= RENODX_TONE_MAP_SHADOW_TOE;  // toe
    } else {
      new_toe = RENODX_TONE_MAP_SHADOW_TOE;  // toe
    }
    new_contrast *= RENODX_TONE_MAP_HIGHLIGHT_CONTRAST;  // contrast
    new_max_nit = 100.f;                                 // maxNit
    new_linear_start = 100.f;                            // linearStart
  }

  float4 SV_Target;
  float4 _10 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _14 = _10.x * Exposure;
  float _15 = _10.y * Exposure;
  float _16 = _10.z * Exposure;
  float _119;
  float _120;
  float _121;

#if 1
  BlowoutAndHueShift(_14, _15, _16);
#endif

  if (isfinite(max(max(_14, _15), _16))) {
    float _25 = invLinearBegin * _14;
    float _31 = invLinearBegin * _15;
    float _37 = invLinearBegin * _16;
    float _44 = select((_14 >= linearBegin), 0.0f, (1.0f - ((_25 * _25) * (3.0f - (_25 * 2.0f)))));
    float _46 = select((_15 >= linearBegin), 0.0f, (1.0f - ((_31 * _31) * (3.0f - (_31 * 2.0f)))));
    float _48 = select((_16 >= linearBegin), 0.0f, (1.0f - ((_37 * _37) * (3.0f - (_37 * 2.0f)))));
    float _54 = select((_14 < new_linear_start), 0.0f, 1.0f);
    float _55 = select((_15 < new_linear_start), 0.0f, 1.0f);
    float _56 = select((_16 < new_linear_start), 0.0f, 1.0f);
    _119 = (((((new_contrast * _14) + madLinearStartContrastFactor) * ((1.0f - _54) - _44)) + (((pow(_25, new_toe))*_44) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _14) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _54));
    _120 = (((((new_contrast * _15) + madLinearStartContrastFactor) * ((1.0f - _55) - _46)) + (((pow(_31, new_toe))*_46) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _15) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _55));
    _121 = (((((new_contrast * _16) + madLinearStartContrastFactor) * ((1.0f - _56) - _48)) + (((pow(_37, new_toe))*_48) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _16) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _56));
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
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb);
  }

  return SV_Target;
}
