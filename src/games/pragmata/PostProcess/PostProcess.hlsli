#include "../common.hlsli"

#ifndef TONEMAP_PARAM_REGISTER
#define TONEMAP_PARAM_REGISTER b1
#endif

cbuffer TonemapParam : register(TONEMAP_PARAM_REGISTER) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  //   float toe : packoffset(c000.w);
  float ORIGINAL_toe : packoffset(c000.w);
  //   float maxNit : packoffset(c001.x);
  float ORIGINAL_maxNit : packoffset(c001.x);
  //   float linearStart : packoffset(c001.y);
  float ORIGINAL_linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
  //   float tonemapParam_isHDRMode : packoffset(c002.w);
  float ORIGINAL_tonemapParam_isHDRMode : packoffset(c002.w);
  float useDynamicRangeConversion : packoffset(c003.x);
  float useHuePreserve : packoffset(c003.y);
  float exposureScale : packoffset(c003.z);
  float kneeStartNit : packoffset(c003.w);
  float knee : packoffset(c004.x);
  float curve_HDRip : packoffset(c004.y);
  float curve_k2 : packoffset(c004.z);
  float curve_k4 : packoffset(c004.w);
  row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
  row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
  float tonemapGraphScale : packoffset(c013.x);
  float offsetEVCurveStart : packoffset(c013.y);
  float offsetEVCurveRange : packoffset(c013.z);
};

static float maxNit = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_maxNit : renodx::math::FLT32_MAX;
static float linearStart = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_linearStart : renodx::math::FLT32_MAX;
static float toe = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_toe : 1.f;

static float tonemapParam_isHDRMode = (TONE_MAP_APPLY_PRE_TONE_MAP_CURVE == 0.f) ? ORIGINAL_tonemapParam_isHDRMode : 0.f;
