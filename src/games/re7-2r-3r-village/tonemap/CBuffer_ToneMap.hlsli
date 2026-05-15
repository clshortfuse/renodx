#ifndef CBUFFER_TONEMAP_HLSLI
#define CBUFFER_TONEMAP_HLSLI

#include "../common.hlsli"

#ifndef SHADER_HASH
#define SHADER_HASH 0
#endif

#if SHADER_HASH == 0x2F362206 || SHADER_HASH == 0x16906EB5  // REVillage uses 0.95f for the toe parameter
#define RENODX_CUSTOM_TOE 0.95f
#else
#define RENODX_CUSTOM_TOE 1.f
#endif

#if SHADER_HASH == 0x314A98A7 || SHADER_HASH == 0x2F362206  // RE2/3 LDR + RE8 LDR
#define TONEMAP_PARAM_REGISTER b2
#elif SHADER_HASH == 0x30D8372F || SHADER_HASH == 0x16906EB5  // RE2/3 NoVignette LDR + RE8 NoVignette LDR
#define TONEMAP_PARAM_REGISTER b1
#elif SHADER_HASH == 0xAD20915B || SHADER_HASH == 0x9E94200C  // RE7_LDRPostProcess_WithTonemap
#define TONEMAP_REGISTER b1
#elif SHADER_HASH == 0xE4345E78 || SHADER_HASH == 0xB3FE7A3D  // RE7_PostToneMapC4L_PS_0xE4345E78 + RE7_PostTonemap_PS_0xB3FE7A3D
#define TONEMAP_REGISTER b0
#endif  // SHADER_HASH

#ifdef TONEMAP_PARAM_REGISTER
cbuffer TonemapParam : register(TONEMAP_PARAM_REGISTER) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float ORIGINAL_toe : packoffset(c000.w);
  float ORIGINAL_maxNit : packoffset(c001.x);
  float ORIGINAL_linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
};

float GetToe() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? ORIGINAL_toe : RENODX_CUSTOM_TOE;
}
float GetMaxNit() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? ORIGINAL_maxNit : renodx::math::FLT16_MAX;
}
float GetLinearStart() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? ORIGINAL_linearStart : renodx::math::FLT16_MAX;
}

#define toe         GetToe()
#define maxNit      GetMaxNit()
#define linearStart GetLinearStart()

#endif

#ifdef TONEMAP_REGISTER
cbuffer Tonemap : register(TONEMAP_REGISTER) {
  float exposureAdjustment : packoffset(c000.x);
  float ORIGINAL_tonemapRange : packoffset(c000.y);
  float sharpness : packoffset(c000.z);
  float preTonemapRange : packoffset(c000.w);
  int useAutoExposure : packoffset(c001.x);
  float echoBlend : packoffset(c001.y);
  float AABlend : packoffset(c001.z);
  float AASubPixel : packoffset(c001.w);
  float ResponsiveAARate : packoffset(c002.x);
};
float GetTonemapRange() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? ORIGINAL_tonemapRange : 0.f;
}

#define tonemapRange GetTonemapRange()

#endif

#endif  // CBUFFER_TONEMAP_HLSLI
