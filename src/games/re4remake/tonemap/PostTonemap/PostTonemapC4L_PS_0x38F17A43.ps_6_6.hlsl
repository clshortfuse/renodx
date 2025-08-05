#include "../../common.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer CameraKerare : register(b0) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer TonemapParam : register(b1) {
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
    new_max_nit = 125;                                   // maxNit
    new_linear_start = 125;                              // linearStart
  }

  float4 SV_Target;
  float4 _16 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _22 = Kerare.x / Kerare.w;
  float _23 = Kerare.y / Kerare.w;
  float _24 = Kerare.z / Kerare.w;
  float _28 = abs(rsqrt(dot(float3(_22, _23, _24), float3(_22, _23, _24))) * _24);
  float _35 = _28 * _28;
  float _39 = saturate(((_35 * _35) * (1.0f - saturate((kerare_scale * _28) + kerare_offset))) + kerare_brightness);
  float _41 = (_16.x * Exposure) * _39;
  float _43 = (_16.y * Exposure) * _39;
  float _45 = (_16.z * Exposure) * _39;
  float _148;
  float _149;
  float _150;
  if (isfinite(max(max(_41, _43), _45))) {
    float _54 = invLinearBegin * _41;
    float _60 = invLinearBegin * _43;
    float _66 = invLinearBegin * _45;
    float _73 = select((_41 >= linearBegin), 0.0f, (1.0f - ((_54 * _54) * (3.0f - (_54 * 2.0f)))));
    float _75 = select((_43 >= linearBegin), 0.0f, (1.0f - ((_60 * _60) * (3.0f - (_60 * 2.0f)))));
    float _77 = select((_45 >= linearBegin), 0.0f, (1.0f - ((_66 * _66) * (3.0f - (_66 * 2.0f)))));
    float _83 = select((_41 < new_linear_start), 0.0f, 1.0f);
    float _84 = select((_43 < new_linear_start), 0.0f, 1.0f);
    float _85 = select((_45 < new_linear_start), 0.0f, 1.0f);
    _148 = (((((new_contrast * _41) + madLinearStartContrastFactor) * ((1.0f - _83) - _73)) + (((pow(_54, new_toe))*_73) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _41) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _83));
    _149 = (((((new_contrast * _43) + madLinearStartContrastFactor) * ((1.0f - _84) - _75)) + (((pow(_60, new_toe))*_75) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _43) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _84));
    _150 = (((((new_contrast * _45) + madLinearStartContrastFactor) * ((1.0f - _85) - _77)) + (((pow(_66, new_toe))*_77) * linearBegin)) + ((new_max_nit - (exp2((contrastFactor * _45) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _85));
  } else {
    _148 = 1.0f;
    _149 = 1.0f;
    _150 = 1.0f;
  }
  SV_Target.x = _148;
  SV_Target.y = _149;
  SV_Target.z = _150;
  SV_Target.w = 1.0f;

  if (TONE_MAP_TYPE != 0) {
    SV_Target.rgb = ApplyCustomGrading(SV_Target.rgb);
    SV_Target.rgb = AdjustGammaByChannel(SV_Target.rgb, RENODX_GAMMA_ADJUST);
  }

  return SV_Target;
}
