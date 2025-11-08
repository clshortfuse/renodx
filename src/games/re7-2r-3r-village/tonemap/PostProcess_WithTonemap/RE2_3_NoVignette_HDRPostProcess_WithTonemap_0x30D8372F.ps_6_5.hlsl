#include "../../common.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

// cbuffer TonemapParamUBO : register(b1, space0)
// {
//     float4 TonemapParam_m0[3] : packoffset(c0);
// };
cbuffer TonemapParamUBO : register(b1, space0) {
  // First float4
  float contrast;      // TonemapParam_m0[0u].x
  float linearBegin;   // TonemapParam_m0[0u].y
  float linearLength;  // TonemapParam_m0[0u].z
  float toe;           // TonemapParam_m0[0u].w

  // Second float4
  float maxNit;                          // TonemapParam_m0[1u].x
  float linearStart;                     // TonemapParam_m0[1u].y
  float displayMaxNitSubContrastFactor;  // TonemapParam_m0[1u].z
  float contrastFactor;                  // TonemapParam_m0[1u].w

  // Third float4
  float mulLinearStartContrastFactor;  // TonemapParam_m0[2u].x
  float invLinearBegin;                // TonemapParam_m0[2u].y
  float madLinearStartContrastFactor;  // TonemapParam_m0[2u].z
};

cbuffer LensDistortionParamUBO : register(b2, space0) {
  float4 LensDistortionParam_m0[2] : packoffset(c0);
};

cbuffer PaniniProjectionParamUBO : register(b3, space0) {
  float4 PaniniProjectionParam_m0[1] : packoffset(c0);
};

cbuffer RadialBlurRenderParamUBO : register(b4, space0) {
  float4 RadialBlurRenderParam_m0[4] : packoffset(c0);
};

cbuffer FilmGrainParamUBO : register(b5, space0) {
  float4 FilmGrainParam_m0[2] : packoffset(c0);
};

cbuffer ColorCorrectTextureUBO : register(b6, space0) {
  float4 ColorCorrectTexture_m0[5] : packoffset(c0);
};

cbuffer ColorDeficientTableUBO : register(b7, space0) {
  float4 ColorDeficientTable_m0[3] : packoffset(c0);
};

cbuffer ImagePlaneParamUBO : register(b8, space0) {
  float4 ImagePlaneParam_m0[2] : packoffset(c0);
};

cbuffer CBControlUBO : register(b9, space0) {
  float4 CBControl_m0[1] : packoffset(c0);
};

Texture2D<float4> RE_POSTPROCESS_Color : register(t0, space0);
Buffer<uint4> ComputeResultSRV : register(t1, space0);
Texture3D<float4> tTextureMap0 : register(t2, space0);
Texture3D<float4> tTextureMap1 : register(t3, space0);
Texture3D<float4> tTextureMap2 : register(t4, space0);
Texture2D<float4> ImagePlameBase : register(t5, space0);
Texture2D<float4> ImagePlameAlpha : register(t6, space0);
SamplerState BilinearClamp : register(s5, space32);
SamplerState BilinearBorder : register(s6, space32);
SamplerState TrilinearClamp : register(s9, space32);

static float4 gl_FragCoord;
static float4 Kerare;
static float Exposure;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float4 Kerare : Kerare;
  float Exposure : Exposure;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  // Map cbuffer variables to TonemapParam_m0 indices
  float4 TonemapParam_m0[3u];
  TonemapParam_m0[0u] = float4(contrast, linearBegin, linearLength, toe);
  TonemapParam_m0[1u] = float4(maxNit, linearStart, displayMaxNitSubContrastFactor, contrastFactor);
  TonemapParam_m0[2u] = float4(mulLinearStartContrastFactor, invLinearBegin, madLinearStartContrastFactor, 0.0);
#if 1
  TonemapParam_m0[0u].w = GetToneMapToe(toe);  // toe
#endif
  TonemapParam_m0[1u].x = GetToneMapMaxNitAndLinearStart();  // maxNit
  TonemapParam_m0[1u].y = GetToneMapMaxNitAndLinearStart();  // linearStart

  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      CUSTOM_LUT_STRENGTH,
      CUSTOM_LUT_SCALING,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      ColorCorrectTexture_m0[0u].x);
  lut_config.recolor = 0.f;
  float3 sdrColor;
  float3 untonemapped;
  float3 hdrColor;

  uint4 _99 = asuint(CBControl_m0[0u]);
  uint _100 = _99.x;
  bool _103 = (_100 & 1u) != 0u;
  uint4 _106 = asuint(LensDistortionParam_m0[0u]);
  uint _107 = _106.w;
  bool _109 = _103 && (_107 == 0u);
  bool _111 = _103 && (_107 == 1u);
  float _566;
  float _567;
  float _568;
  float _569;
  float _570;
  float _571;
  float _572;
  float _573;
  float _574;
  if (_109) {
    float _143 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
    float _145 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
    float _146 = dot(float2(_143, _145), float2(_143, _145));
    float _153 = ((_146 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
    float4 _163 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_153 * _143) + 0.5f, (_153 * _145) + 0.5f));
    float _166 = _163.x * Exposure;
    float _167 = TonemapParam_m0[2u].y * _166;
    float _176 = (_166 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_167 * _167) * (3.0f - (_167 * 2.0f))));
    float _178 = (_166 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
    float _184 = exp2(log2(_167) * TonemapParam_m0[0u].w);
    float _187 = ((TonemapParam_m0[0u].x * _166) + TonemapParam_m0[2u].z) * ((1.0f - _178) - _176);
    float _193 = (TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _166) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _178;
    float frontier_phi_7_1_ladder;
    float frontier_phi_7_1_ladder_1;
    float frontier_phi_7_1_ladder_2;
    float frontier_phi_7_1_ladder_3;
    float frontier_phi_7_1_ladder_4;
    float frontier_phi_7_1_ladder_5;
    float frontier_phi_7_1_ladder_6;
    float frontier_phi_7_1_ladder_7;
    float frontier_phi_7_1_ladder_8;
    if (_106.z == 0u) {
      float _196 = _163.y * Exposure;
      float _197 = _163.z * Exposure;
      float _198 = TonemapParam_m0[2u].y * _196;
      float _204 = TonemapParam_m0[2u].y * _197;
      float _211 = (_196 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_198 * _198) * (3.0f - (_198 * 2.0f))));
      float _213 = (_197 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_204 * _204) * (3.0f - (_204 * 2.0f))));
      float _216 = (_196 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _217 = (_197 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_1_ladder = LensDistortionParam_m0[1u].x;
      frontier_phi_7_1_ladder_1 = 0.0f;
      frontier_phi_7_1_ladder_2 = 0.0f;
      frontier_phi_7_1_ladder_3 = 0.0f;
      frontier_phi_7_1_ladder_4 = 0.0f;
      frontier_phi_7_1_ladder_5 = LensDistortionParam_m0[0u].x;
      frontier_phi_7_1_ladder_6 = ((((TonemapParam_m0[0u].x * _197) + TonemapParam_m0[2u].z) * ((1.0f - _217) - _213)) + ((exp2(log2(_204) * TonemapParam_m0[0u].w) * _213) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _197) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _217);
      frontier_phi_7_1_ladder_7 = ((((TonemapParam_m0[0u].x * _196) + TonemapParam_m0[2u].z) * ((1.0f - _216) - _211)) + ((exp2(log2(_198) * TonemapParam_m0[0u].w) * _211) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _196) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _216);
      frontier_phi_7_1_ladder_8 = (_187 + ((_184 * _176) * TonemapParam_m0[0u].y)) + _193;
    } else {
      float _258 = _146 + LensDistortionParam_m0[0u].y;
      float _260 = (_258 * LensDistortionParam_m0[0u].x) + 1.0f;
      float _261 = _143 * LensDistortionParam_m0[1u].x;
      float _263 = _145 * LensDistortionParam_m0[1u].x;
      float _269 = ((_258 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
      float _282 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_261 * _260) + 0.5f, (_263 * _260) + 0.5f)).y * Exposure;
      float _283 = TonemapParam_m0[2u].y * _282;
      float _290 = (_282 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_283 * _283) * (3.0f - (_283 * 2.0f))));
      float _292 = (_282 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _314 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_261 * _269) + 0.5f, (_263 * _269) + 0.5f)).z * Exposure;
      float _315 = TonemapParam_m0[2u].y * _314;
      float _322 = (_314 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_315 * _315) * (3.0f - (_315 * 2.0f))));
      float _324 = (_314 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_1_ladder = LensDistortionParam_m0[1u].x;
      frontier_phi_7_1_ladder_1 = 0.0f;
      frontier_phi_7_1_ladder_2 = 0.0f;
      frontier_phi_7_1_ladder_3 = 0.0f;
      frontier_phi_7_1_ladder_4 = 0.0f;
      frontier_phi_7_1_ladder_5 = LensDistortionParam_m0[0u].x;
      frontier_phi_7_1_ladder_6 = ((((TonemapParam_m0[0u].x * _314) + TonemapParam_m0[2u].z) * ((1.0f - _324) - _322)) + ((TonemapParam_m0[0u].y * exp2(log2(_315) * TonemapParam_m0[0u].w)) * _322)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _314) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _324);
      frontier_phi_7_1_ladder_7 = ((((TonemapParam_m0[0u].x * _282) + TonemapParam_m0[2u].z) * ((1.0f - _292) - _290)) + ((TonemapParam_m0[0u].y * exp2(log2(_283) * TonemapParam_m0[0u].w)) * _290)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _282) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _292);
      frontier_phi_7_1_ladder_8 = (_187 + ((TonemapParam_m0[0u].y * _184) * _176)) + _193;
    }
    _566 = frontier_phi_7_1_ladder_8;
    _567 = frontier_phi_7_1_ladder_7;
    _568 = frontier_phi_7_1_ladder_6;
    _569 = frontier_phi_7_1_ladder_5;
    _570 = frontier_phi_7_1_ladder_4;
    _571 = frontier_phi_7_1_ladder_3;
    _572 = frontier_phi_7_1_ladder_2;
    _573 = frontier_phi_7_1_ladder_1;
    _574 = frontier_phi_7_1_ladder;
  } else {
    float frontier_phi_7_2_ladder;
    float frontier_phi_7_2_ladder_1;
    float frontier_phi_7_2_ladder_2;
    float frontier_phi_7_2_ladder_3;
    float frontier_phi_7_2_ladder_4;
    float frontier_phi_7_2_ladder_5;
    float frontier_phi_7_2_ladder_6;
    float frontier_phi_7_2_ladder_7;
    float frontier_phi_7_2_ladder_8;
    if (_111) {
      float _357 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
      float _362 = sqrt((_357 * _357) + 1.0f);
      float _363 = 1.0f / _362;
      float _366 = (_362 * PaniniProjectionParam_m0[0u].z) * (_363 + PaniniProjectionParam_m0[0u].x);
      float _370 = PaniniProjectionParam_m0[0u].w * 0.5f;
      float4 _379 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_370 * _357) * _366) + 0.5f, (((_370 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_363 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _366) + 0.5f));
      float _384 = _379.x * Exposure;
      float _385 = _379.y * Exposure;
      float _386 = _379.z * Exposure;
      float _387 = TonemapParam_m0[2u].y * _384;
      float _393 = TonemapParam_m0[2u].y * _385;
      float _399 = TonemapParam_m0[2u].y * _386;
      float _406 = (_384 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_387 * _387) * (3.0f - (_387 * 2.0f))));
      float _408 = (_385 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_393 * _393) * (3.0f - (_393 * 2.0f))));
      float _410 = (_386 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_399 * _399) * (3.0f - (_399 * 2.0f))));
      float _414 = (_384 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _415 = (_385 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _416 = (_386 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_2_ladder = 1.0f;
      frontier_phi_7_2_ladder_1 = PaniniProjectionParam_m0[0u].w;
      frontier_phi_7_2_ladder_2 = PaniniProjectionParam_m0[0u].z;
      frontier_phi_7_2_ladder_3 = PaniniProjectionParam_m0[0u].y;
      frontier_phi_7_2_ladder_4 = PaniniProjectionParam_m0[0u].x;
      frontier_phi_7_2_ladder_5 = 0.0f;
      frontier_phi_7_2_ladder_6 = ((((TonemapParam_m0[0u].x * _386) + TonemapParam_m0[2u].z) * ((1.0f - _416) - _410)) + ((exp2(log2(_399) * TonemapParam_m0[0u].w) * _410) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _386) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _416);
      frontier_phi_7_2_ladder_7 = ((((TonemapParam_m0[0u].x * _385) + TonemapParam_m0[2u].z) * ((1.0f - _415) - _408)) + ((exp2(log2(_393) * TonemapParam_m0[0u].w) * _408) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _385) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _415);
      frontier_phi_7_2_ladder_8 = ((((TonemapParam_m0[0u].x * _384) + TonemapParam_m0[2u].z) * ((1.0f - _414) - _406)) + ((exp2(log2(_387) * TonemapParam_m0[0u].w) * _406) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _384) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _414);
    } else {
      float4 _473 = RE_POSTPROCESS_Color.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
      float _479 = _473.x * Exposure;
      float _480 = _473.y * Exposure;
      float _481 = _473.z * Exposure;
      float _482 = TonemapParam_m0[2u].y * _479;
      float _488 = TonemapParam_m0[2u].y * _480;
      float _494 = TonemapParam_m0[2u].y * _481;
      float _501 = (_479 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_482 * _482) * (3.0f - (_482 * 2.0f))));
      float _503 = (_480 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_488 * _488) * (3.0f - (_488 * 2.0f))));
      float _505 = (_481 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_494 * _494) * (3.0f - (_494 * 2.0f))));
      float _509 = (_479 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _510 = (_480 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _511 = (_481 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_2_ladder = 1.0f;
      frontier_phi_7_2_ladder_1 = 0.0f;
      frontier_phi_7_2_ladder_2 = 0.0f;
      frontier_phi_7_2_ladder_3 = 0.0f;
      frontier_phi_7_2_ladder_4 = 0.0f;
      frontier_phi_7_2_ladder_5 = 0.0f;
      frontier_phi_7_2_ladder_6 = ((((TonemapParam_m0[0u].x * _481) + TonemapParam_m0[2u].z) * ((1.0f - _511) - _505)) + ((exp2(log2(_494) * TonemapParam_m0[0u].w) * _505) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _481) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _511);
      frontier_phi_7_2_ladder_7 = ((((TonemapParam_m0[0u].x * _480) + TonemapParam_m0[2u].z) * ((1.0f - _510) - _503)) + ((exp2(log2(_488) * TonemapParam_m0[0u].w) * _503) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _480) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _510);
      frontier_phi_7_2_ladder_8 = ((((TonemapParam_m0[0u].x * _479) + TonemapParam_m0[2u].z) * ((1.0f - _509) - _501)) + ((exp2(log2(_482) * TonemapParam_m0[0u].w) * _501) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _479) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _509);
    }
    _566 = frontier_phi_7_2_ladder_8;
    _567 = frontier_phi_7_2_ladder_7;
    _568 = frontier_phi_7_2_ladder_6;
    _569 = frontier_phi_7_2_ladder_5;
    _570 = frontier_phi_7_2_ladder_4;
    _571 = frontier_phi_7_2_ladder_3;
    _572 = frontier_phi_7_2_ladder_2;
    _573 = frontier_phi_7_2_ladder_1;
    _574 = frontier_phi_7_2_ladder;
  }
  float _578;
  float _580;
  float _582;
  if ((_100 & 32u) == 0u) {
    _578 = _566;
    _580 = _567;
    _582 = _568;
  } else {
    uint4 _605 = asuint(RadialBlurRenderParam_m0[3u]);
    uint _606 = _605.x;
    float _609 = float((_606 & 2u) != 0u);
    float _616 = ((1.0f - _609) + (asfloat(ComputeResultSRV.Load(0u).x) * _609)) * RadialBlurRenderParam_m0[0u].w;
    float frontier_phi_8_9_ladder;
    float frontier_phi_8_9_ladder_1;
    float frontier_phi_8_9_ladder_2;
    if (_616 == 0.0f) {
      frontier_phi_8_9_ladder = _568;
      frontier_phi_8_9_ladder_1 = _567;
      frontier_phi_8_9_ladder_2 = _566;
    } else {
      float _665 = SceneInfo_m0[23u].z * gl_FragCoord.x;
      float _666 = SceneInfo_m0[23u].w * gl_FragCoord.y;
      float _668 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _665;
      float _670 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _666;
      float _673 = (_668 < 0.0f) ? (1.0f - _665) : _665;
      float _676 = (_670 < 0.0f) ? (1.0f - _666) : _666;
      float _683 = rsqrt(dot(float2(_668, _670), float2(_668, _670))) * RadialBlurRenderParam_m0[2u].w;
      uint _690 = uint(abs(_683 * _670)) + uint(abs(_683 * _668));
      uint _696 = ((_690 ^ 61u) ^ (_690 >> 16u)) * 9u;
      uint _700 = ((_696 >> 4u) ^ _696) * 668265261u;
      float _708 = ((_606 & 1u) != 0u) ? (float((_700 >> 15u) ^ _700) * 2.3283064365386962890625e-10f) : 1.0f;
      float _714 = 1.0f / max(1.0f, sqrt((_668 * _668) + (_670 * _670)));
      float _715 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
      float _725 = ((((_715 * _673) * _708) * _714) + 1.0f) * _668;
      float _726 = ((((_715 * _676) * _708) * _714) + 1.0f) * _670;
      float _727 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
      float _737 = ((((_727 * _673) * _708) * _714) + 1.0f) * _668;
      float _738 = ((((_727 * _676) * _708) * _714) + 1.0f) * _670;
      float _739 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
      float _749 = ((((_739 * _673) * _708) * _714) + 1.0f) * _668;
      float _750 = ((((_739 * _676) * _708) * _714) + 1.0f) * _670;
      float _751 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
      float _761 = ((((_751 * _673) * _708) * _714) + 1.0f) * _668;
      float _762 = ((((_751 * _676) * _708) * _714) + 1.0f) * _670;
      float _763 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
      float _773 = ((((_763 * _673) * _708) * _714) + 1.0f) * _668;
      float _774 = ((((_763 * _676) * _708) * _714) + 1.0f) * _670;
      float _775 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
      float _785 = ((((_775 * _673) * _708) * _714) + 1.0f) * _668;
      float _786 = ((((_775 * _676) * _708) * _714) + 1.0f) * _670;
      float _787 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
      float _797 = ((((_787 * _673) * _708) * _714) + 1.0f) * _668;
      float _798 = ((((_787 * _676) * _708) * _714) + 1.0f) * _670;
      float _799 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
      float _809 = ((((_799 * _673) * _708) * _714) + 1.0f) * _668;
      float _810 = ((((_799 * _676) * _708) * _714) + 1.0f) * _670;
      float _811 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
      float _821 = ((((_811 * _673) * _708) * _714) + 1.0f) * _668;
      float _822 = ((((_811 * _676) * _708) * _714) + 1.0f) * _670;
      float _823 = Exposure * 0.100000001490116119384765625f;
      float _825 = _823 * RadialBlurRenderParam_m0[0u].x;
      float _826 = _823 * RadialBlurRenderParam_m0[0u].y;
      float _827 = _823 * RadialBlurRenderParam_m0[0u].z;
      float _845 = (_566 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x;
      float _847 = (_567 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y;
      float _849 = (_568 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z;
      float _1266;
      float _1269;
      float _1272;
      if (_109) {
        float _909 = _725 + RadialBlurRenderParam_m0[1u].x;
        float _910 = _726 + RadialBlurRenderParam_m0[1u].y;
        float _916 = ((dot(float2(_909, _910), float2(_909, _910)) * _569) + 1.0f) * _574;
        float4 _922 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_916 * _909) + 0.5f, (_916 * _910) + 0.5f), 0.0f);
        float _927 = _737 + RadialBlurRenderParam_m0[1u].x;
        float _928 = _738 + RadialBlurRenderParam_m0[1u].y;
        float _933 = (dot(float2(_927, _928), float2(_927, _928)) * _569) + 1.0f;
        float4 _940 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_927 * _574) * _933) + 0.5f, ((_928 * _574) * _933) + 0.5f), 0.0f);
        float _948 = _749 + RadialBlurRenderParam_m0[1u].x;
        float _949 = _750 + RadialBlurRenderParam_m0[1u].y;
        float _954 = (dot(float2(_948, _949), float2(_948, _949)) * _569) + 1.0f;
        float4 _961 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_948 * _574) * _954) + 0.5f, ((_949 * _574) * _954) + 0.5f), 0.0f);
        float _969 = _761 + RadialBlurRenderParam_m0[1u].x;
        float _970 = _762 + RadialBlurRenderParam_m0[1u].y;
        float _975 = (dot(float2(_969, _970), float2(_969, _970)) * _569) + 1.0f;
        float4 _982 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_969 * _574) * _975) + 0.5f, ((_970 * _574) * _975) + 0.5f), 0.0f);
        float _990 = _773 + RadialBlurRenderParam_m0[1u].x;
        float _991 = _774 + RadialBlurRenderParam_m0[1u].y;
        float _996 = (dot(float2(_990, _991), float2(_990, _991)) * _569) + 1.0f;
        float4 _1003 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_990 * _574) * _996) + 0.5f, ((_991 * _574) * _996) + 0.5f), 0.0f);
        float _1011 = _785 + RadialBlurRenderParam_m0[1u].x;
        float _1012 = _786 + RadialBlurRenderParam_m0[1u].y;
        float _1017 = (dot(float2(_1011, _1012), float2(_1011, _1012)) * _569) + 1.0f;
        float4 _1024 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1011 * _574) * _1017) + 0.5f, ((_1012 * _574) * _1017) + 0.5f), 0.0f);
        float _1032 = _797 + RadialBlurRenderParam_m0[1u].x;
        float _1033 = _798 + RadialBlurRenderParam_m0[1u].y;
        float _1038 = (dot(float2(_1032, _1033), float2(_1032, _1033)) * _569) + 1.0f;
        float4 _1045 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1032 * _574) * _1038) + 0.5f, ((_1033 * _574) * _1038) + 0.5f), 0.0f);
        float _1053 = _809 + RadialBlurRenderParam_m0[1u].x;
        float _1054 = _810 + RadialBlurRenderParam_m0[1u].y;
        float _1059 = (dot(float2(_1053, _1054), float2(_1053, _1054)) * _569) + 1.0f;
        float4 _1066 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1053 * _574) * _1059) + 0.5f, ((_1054 * _574) * _1059) + 0.5f), 0.0f);
        float _1074 = _821 + RadialBlurRenderParam_m0[1u].x;
        float _1075 = _822 + RadialBlurRenderParam_m0[1u].y;
        float _1080 = (dot(float2(_1074, _1075), float2(_1074, _1075)) * _569) + 1.0f;
        float4 _1087 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1074 * _574) * _1080) + 0.5f, ((_1075 * _574) * _1080) + 0.5f), 0.0f);
        float _1095 = _825 * ((((((((_940.x + _922.x) + _961.x) + _982.x) + _1003.x) + _1024.x) + _1045.x) + _1066.x) + _1087.x);
        float _1096 = _826 * ((((((((_940.y + _922.y) + _961.y) + _982.y) + _1003.y) + _1024.y) + _1045.y) + _1066.y) + _1087.y);
        float _1097 = _827 * ((((((((_940.z + _922.z) + _961.z) + _982.z) + _1003.z) + _1024.z) + _1045.z) + _1066.z) + _1087.z);
        float _1098 = _1095 * TonemapParam_m0[2u].y;
        float _1104 = _1096 * TonemapParam_m0[2u].y;
        float _1110 = _1097 * TonemapParam_m0[2u].y;
        float _1117 = (_1095 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1098 * _1098) * (3.0f - (_1098 * 2.0f))));
        float _1119 = (_1096 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1104 * _1104) * (3.0f - (_1104 * 2.0f))));
        float _1121 = (_1097 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1110 * _1110) * (3.0f - (_1110 * 2.0f))));
        float _1125 = (_1095 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1126 = (_1096 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1127 = (_1097 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        _1266 = ((((_1117 * exp2(log2(_1098) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _845) + (((TonemapParam_m0[0u].x * _1095) + TonemapParam_m0[2u].z) * ((1.0f - _1125) - _1117))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1095) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1125);
        _1269 = ((((exp2(log2(_1104) * TonemapParam_m0[0u].w) * _1119) * TonemapParam_m0[0u].y) + _847) + (((TonemapParam_m0[0u].x * _1096) + TonemapParam_m0[2u].z) * ((1.0f - _1126) - _1119))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1096) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1126);
        _1272 = ((((exp2(log2(_1110) * TonemapParam_m0[0u].w) * _1121) * TonemapParam_m0[0u].y) + _849) + (((TonemapParam_m0[0u].x * _1097) + TonemapParam_m0[2u].z) * ((1.0f - _1127) - _1121))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1097) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1127);
      } else {
        float _1185 = RadialBlurRenderParam_m0[1u].x + 0.5f;
        float _1186 = _1185 + _725;
        float _1187 = RadialBlurRenderParam_m0[1u].y + 0.5f;
        float _1188 = _1187 + _726;
        float _1189 = _1185 + _737;
        float _1190 = _1187 + _738;
        float _1191 = _1185 + _749;
        float _1192 = _1187 + _750;
        float _1193 = _1185 + _761;
        float _1194 = _1187 + _762;
        float _1195 = _1185 + _773;
        float _1196 = _1187 + _774;
        float _1197 = _1185 + _785;
        float _1198 = _1187 + _786;
        float _1199 = _1185 + _797;
        float _1200 = _1187 + _798;
        float _1201 = _1185 + _809;
        float _1202 = _1187 + _810;
        float _1203 = _1185 + _821;
        float _1204 = _1187 + _822;
        float frontier_phi_25_18_ladder;
        float frontier_phi_25_18_ladder_1;
        float frontier_phi_25_18_ladder_2;
        if (_111) {
          float _1278 = (_1186 * 2.0f) + (-1.0f);
          float _1282 = sqrt((_1278 * _1278) + 1.0f);
          float _1283 = 1.0f / _1282;
          float _1286 = (_1282 * _572) * (_1283 + _570);
          float _1290 = _573 * 0.5f;
          float4 _1299 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1286) * _1278) + 0.5f, (((_1290 * (((_1283 + (-1.0f)) * _571) + 1.0f)) * _1286) * ((_1188 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _1306 = (_1189 * 2.0f) + (-1.0f);
          float _1310 = sqrt((_1306 * _1306) + 1.0f);
          float _1311 = 1.0f / _1310;
          float _1314 = (_1310 * _572) * (_1311 + _570);
          float4 _1325 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1306) * _1314) + 0.5f, (((_1290 * ((_1190 * 2.0f) + (-1.0f))) * (((_1311 + (-1.0f)) * _571) + 1.0f)) * _1314) + 0.5f), 0.0f);
          float _1335 = (_1191 * 2.0f) + (-1.0f);
          float _1339 = sqrt((_1335 * _1335) + 1.0f);
          float _1340 = 1.0f / _1339;
          float _1343 = (_1339 * _572) * (_1340 + _570);
          float4 _1354 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1335) * _1343) + 0.5f, (((_1290 * ((_1192 * 2.0f) + (-1.0f))) * (((_1340 + (-1.0f)) * _571) + 1.0f)) * _1343) + 0.5f), 0.0f);
          float _1364 = (_1193 * 2.0f) + (-1.0f);
          float _1368 = sqrt((_1364 * _1364) + 1.0f);
          float _1369 = 1.0f / _1368;
          float _1372 = (_1368 * _572) * (_1369 + _570);
          float4 _1383 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1364) * _1372) + 0.5f, (((_1290 * ((_1194 * 2.0f) + (-1.0f))) * (((_1369 + (-1.0f)) * _571) + 1.0f)) * _1372) + 0.5f), 0.0f);
          float _1393 = (_1195 * 2.0f) + (-1.0f);
          float _1397 = sqrt((_1393 * _1393) + 1.0f);
          float _1398 = 1.0f / _1397;
          float _1401 = (_1397 * _572) * (_1398 + _570);
          float4 _1412 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1393) * _1401) + 0.5f, (((_1290 * ((_1196 * 2.0f) + (-1.0f))) * (((_1398 + (-1.0f)) * _571) + 1.0f)) * _1401) + 0.5f), 0.0f);
          float _1422 = (_1197 * 2.0f) + (-1.0f);
          float _1426 = sqrt((_1422 * _1422) + 1.0f);
          float _1427 = 1.0f / _1426;
          float _1430 = (_1426 * _572) * (_1427 + _570);
          float4 _1441 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1422) * _1430) + 0.5f, (((_1290 * ((_1198 * 2.0f) + (-1.0f))) * (((_1427 + (-1.0f)) * _571) + 1.0f)) * _1430) + 0.5f), 0.0f);
          float _1451 = (_1199 * 2.0f) + (-1.0f);
          float _1455 = sqrt((_1451 * _1451) + 1.0f);
          float _1456 = 1.0f / _1455;
          float _1459 = (_1455 * _572) * (_1456 + _570);
          float4 _1470 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1451) * _1459) + 0.5f, (((_1290 * ((_1200 * 2.0f) + (-1.0f))) * (((_1456 + (-1.0f)) * _571) + 1.0f)) * _1459) + 0.5f), 0.0f);
          float _1480 = (_1201 * 2.0f) + (-1.0f);
          float _1484 = sqrt((_1480 * _1480) + 1.0f);
          float _1485 = 1.0f / _1484;
          float _1488 = (_1484 * _572) * (_1485 + _570);
          float4 _1499 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1480) * _1488) + 0.5f, (((_1290 * ((_1202 * 2.0f) + (-1.0f))) * (((_1485 + (-1.0f)) * _571) + 1.0f)) * _1488) + 0.5f), 0.0f);
          float _1509 = (_1203 * 2.0f) + (-1.0f);
          float _1513 = sqrt((_1509 * _1509) + 1.0f);
          float _1514 = 1.0f / _1513;
          float _1517 = (_1513 * _572) * (_1514 + _570);
          float4 _1528 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1290 * _1509) * _1517) + 0.5f, (((_1290 * ((_1204 * 2.0f) + (-1.0f))) * (((_1514 + (-1.0f)) * _571) + 1.0f)) * _1517) + 0.5f), 0.0f);
          float _1536 = _825 * ((((((((_1325.x + _1299.x) + _1354.x) + _1383.x) + _1412.x) + _1441.x) + _1470.x) + _1499.x) + _1528.x);
          float _1537 = _826 * ((((((((_1325.y + _1299.y) + _1354.y) + _1383.y) + _1412.y) + _1441.y) + _1470.y) + _1499.y) + _1528.y);
          float _1538 = _827 * ((((((((_1325.z + _1299.z) + _1354.z) + _1383.z) + _1412.z) + _1441.z) + _1470.z) + _1499.z) + _1528.z);
          float _1539 = _1536 * TonemapParam_m0[2u].y;
          float _1545 = _1537 * TonemapParam_m0[2u].y;
          float _1551 = _1538 * TonemapParam_m0[2u].y;
          float _1558 = (_1536 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1539 * _1539) * (3.0f - (_1539 * 2.0f))));
          float _1560 = (_1537 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1545 * _1545) * (3.0f - (_1545 * 2.0f))));
          float _1562 = (_1538 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1551 * _1551) * (3.0f - (_1551 * 2.0f))));
          float _1566 = (_1536 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1567 = (_1537 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1568 = (_1538 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_25_18_ladder = ((((_1558 * exp2(log2(_1539) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _845) + (((TonemapParam_m0[0u].x * _1536) + TonemapParam_m0[2u].z) * ((1.0f - _1566) - _1558))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1536) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1566);
          frontier_phi_25_18_ladder_1 = ((((exp2(log2(_1545) * TonemapParam_m0[0u].w) * _1560) * TonemapParam_m0[0u].y) + _847) + (((TonemapParam_m0[0u].x * _1537) + TonemapParam_m0[2u].z) * ((1.0f - _1567) - _1560))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1537) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1567);
          frontier_phi_25_18_ladder_2 = ((((exp2(log2(_1551) * TonemapParam_m0[0u].w) * _1562) * TonemapParam_m0[0u].y) + _849) + (((TonemapParam_m0[0u].x * _1538) + TonemapParam_m0[2u].z) * ((1.0f - _1568) - _1562))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1538) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1568);
        } else {
          float4 _1624 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1186, _1188), 0.0f);
          float4 _1629 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1189, _1190), 0.0f);
          float4 _1637 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1191, _1192), 0.0f);
          float4 _1645 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1193, _1194), 0.0f);
          float4 _1653 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1195, _1196), 0.0f);
          float4 _1661 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1197, _1198), 0.0f);
          float4 _1669 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1199, _1200), 0.0f);
          float4 _1677 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1201, _1202), 0.0f);
          float4 _1685 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1203, _1204), 0.0f);
          float _1693 = _825 * ((((((((_1629.x + _1624.x) + _1637.x) + _1645.x) + _1653.x) + _1661.x) + _1669.x) + _1677.x) + _1685.x);
          float _1694 = _826 * ((((((((_1629.y + _1624.y) + _1637.y) + _1645.y) + _1653.y) + _1661.y) + _1669.y) + _1677.y) + _1685.y);
          float _1695 = _827 * ((((((((_1629.z + _1624.z) + _1637.z) + _1645.z) + _1653.z) + _1661.z) + _1669.z) + _1677.z) + _1685.z);
          float _1696 = _1693 * TonemapParam_m0[2u].y;
          float _1702 = _1694 * TonemapParam_m0[2u].y;
          float _1708 = _1695 * TonemapParam_m0[2u].y;
          float _1715 = (_1693 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1696 * _1696) * (3.0f - (_1696 * 2.0f))));
          float _1717 = (_1694 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1702 * _1702) * (3.0f - (_1702 * 2.0f))));
          float _1719 = (_1695 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1708 * _1708) * (3.0f - (_1708 * 2.0f))));
          float _1723 = (_1693 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1724 = (_1694 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1725 = (_1695 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_25_18_ladder = ((((_1715 * exp2(log2(_1696) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _845) + (((TonemapParam_m0[0u].x * _1693) + TonemapParam_m0[2u].z) * ((1.0f - _1723) - _1715))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1693) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1723);
          frontier_phi_25_18_ladder_1 = ((((exp2(log2(_1702) * TonemapParam_m0[0u].w) * _1717) * TonemapParam_m0[0u].y) + _847) + (((TonemapParam_m0[0u].x * _1694) + TonemapParam_m0[2u].z) * ((1.0f - _1724) - _1717))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1694) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1724);
          frontier_phi_25_18_ladder_2 = ((((exp2(log2(_1708) * TonemapParam_m0[0u].w) * _1719) * TonemapParam_m0[0u].y) + _849) + (((TonemapParam_m0[0u].x * _1695) + TonemapParam_m0[2u].z) * ((1.0f - _1725) - _1719))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1695) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1725);
        }
        _1266 = frontier_phi_25_18_ladder;
        _1269 = frontier_phi_25_18_ladder_1;
        _1272 = frontier_phi_25_18_ladder_2;
      }
      float _1931;
      float _1932;
      float _1933;
      if (RadialBlurRenderParam_m0[2u].x > 0.0f) {
        float _1915 = clamp((sqrt((_668 * _668) + (_670 * _670)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
        float _1921 = (((_1915 * _1915) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_1915 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
        _1931 = (_1921 * (_1266 - _566)) + _566;
        _1932 = (_1921 * (_1269 - _567)) + _567;
        _1933 = (_1921 * (_1272 - _568)) + _568;
      } else {
        _1931 = _1266;
        _1932 = _1269;
        _1933 = _1272;
      }
      frontier_phi_8_9_ladder = ((_1933 - _568) * _616) + _568;
      frontier_phi_8_9_ladder_1 = ((_1932 - _567) * _616) + _567;
      frontier_phi_8_9_ladder_2 = ((_1931 - _566) * _616) + _566;
    }
    _578 = frontier_phi_8_9_ladder_2;
    _580 = frontier_phi_8_9_ladder_1;
    _582 = frontier_phi_8_9_ladder;
  }
  float _618;
  float _620;
  float _622;
  if ((_100 & 2u) == 0u) {
    _618 = _578;
    _620 = _580;
    _622 = _582;
  } else {
    float _647 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
    float _649 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
    float _658 = frac(frac(dot(float2(_647, _649), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
    float _904;
    if (_658 < FilmGrainParam_m0[1u].x) {
      uint _892 = uint(_649 * _647) ^ 12345391u;
      uint _894 = _892 * 3635641u;
      _904 = float(((_894 >> 26u) | (_892 * 232681024u)) ^ _894) * 2.3283064365386962890625e-10f;
    } else {
      _904 = 0.0f;
    }
    float _907 = frac(_658 * 757.48468017578125f);
    float _1262;
    if (_907 < FilmGrainParam_m0[1u].x) {
      uint _1253 = asuint(_907) ^ 12345391u;
      uint _1254 = _1253 * 3635641u;
      _1262 = (float(((_1254 >> 26u) | (_1253 * 232681024u)) ^ _1254) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _1262 = 0.0f;
    }
    float _1264 = frac(_907 * 757.48468017578125f);
    float _1879;
    if (_1264 < FilmGrainParam_m0[1u].x) {
      uint _1870 = asuint(_1264) ^ 12345391u;
      uint _1871 = _1870 * 3635641u;
      _1879 = (float(((_1871 >> 26u) | (_1870 * 232681024u)) ^ _1871) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _1879 = 0.0f;
    }
    float _1880 = _904 * FilmGrainParam_m0[0u].x;
    float _1881 = _1879 * FilmGrainParam_m0[0u].y;
    float _1882 = _1262 * FilmGrainParam_m0[0u].y;
    float _1902 = exp2(log2(1.0f - clamp(dot(float3(_578, _580, _582), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
    _618 = (_1902 * (mad(_1882, 1.401999950408935546875f, _1880) - _578)) + _578;
    _620 = (_1902 * (mad(_1882, -0.7139999866485595703125f, mad(_1881, -0.3440000116825103759765625f, _1880)) - _580)) + _580;
    _622 = (_1902 * (mad(_1881, 1.77199995517730712890625f, _1880) - _582)) + _582;
  }
  float _850;
  float _853;
  float _856;
  if ((_100 & 4u) == 0u) {
    _850 = _618;
    _853 = _620;
    _856 = _622;
  } else {
    float _888 = max(max(_618, _620), _622);
    bool _889 = _888 > 1.0f;
    float _1246;
    float _1247;
    float _1248;
#if 1  // use UpgradeToneMap() for LUT sampling
    untonemapped = float3(_618, _620, _622);
    hdrColor = untonemapped;

    sdrColor = LUTToneMap(untonemapped);
#endif

#if 0  // max channel LUT sampling
        if (_889)
        {
            _1246 = _618 / _888;
            _1247 = _620 / _888;
            _1248 = _622 / _888;
        }
        else
        {
            _1246 = _618;
            _1247 = _620;
            _1248 = _622;
        }
#else
    _1246 = sdrColor.r;
    _1247 = sdrColor.g;
    _1248 = sdrColor.b;
#endif

#if 0
        float _1249 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _1940;
        if (_1246 > 0.003130800090730190277099609375f)
        {
            _1940 = (exp2(log2(_1246) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1940 = _1246 * 12.9200000762939453125f;
        }
        float _1948;
        if (_1247 > 0.003130800090730190277099609375f)
        {
            _1948 = (exp2(log2(_1247) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1948 = _1247 * 12.9200000762939453125f;
        }
        float _1956;
        if (_1248 > 0.003130800090730190277099609375f)
        {
            _1956 = (exp2(log2(_1248) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1956 = _1248 * 12.9200000762939453125f;
        }
        float _1957 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _1961 = (_1940 * _1957) + _1249;
        float _1962 = (_1948 * _1957) + _1249;
        float _1963 = (_1956 * _1957) + _1249;
        float4 _1966 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1961, _1962, _1963), 0.0f);
#else
    float3 _1966 = LUTBlackCorrection(float3(_1246, _1247, _1248), tTextureMap0, lut_config);
#endif
    float _1968 = _1966.x;
    float _1969 = _1966.y;
    float _1970 = _1966.z;
    float _1990;
    float _1993;
    float _1996;
    if (ColorCorrectTexture_m0[0u].y > 0.0f) {
#if 0
            float4 _1973 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1961, _1962, _1963), 0.0f);
#else
      float3 _1973 = LUTBlackCorrection(float3(_1246, _1247, _1248), tTextureMap1, lut_config);
#endif
      float _1984 = ((_1973.x - _1968) * ColorCorrectTexture_m0[0u].y) + _1968;
      float _1985 = ((_1973.y - _1969) * ColorCorrectTexture_m0[0u].y) + _1969;
      float _1986 = ((_1973.z - _1970) * ColorCorrectTexture_m0[0u].y) + _1970;
      float frontier_phi_46_43_ladder;
      float frontier_phi_46_43_ladder_1;
      float frontier_phi_46_43_ladder_2;
      if (ColorCorrectTexture_m0[0u].z > 0.0f) {
#if 0
                float _2022;
                if (_1984 > 0.003130800090730190277099609375f)
                {
                    _2022 = (exp2(log2(_1984) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2022 = _1984 * 12.9200000762939453125f;
                }
                float _2038;
                if (_1985 > 0.003130800090730190277099609375f)
                {
                    _2038 = (exp2(log2(_1985) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2038 = _1985 * 12.9200000762939453125f;
                }
                float _2065;
                if (_1986 > 0.003130800090730190277099609375f)
                {
                    _2065 = (exp2(log2(_1986) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2065 = _1986 * 12.9200000762939453125f;
                }
                float4 _2067 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2022, _2038, _2065), 0.0f);
#else
        float3 _2067 = LUTBlackCorrection(float3(_1984, _1985, _1986), tTextureMap2, lut_config);
#endif
        frontier_phi_46_43_ladder = ((_2067.z - _1986) * ColorCorrectTexture_m0[0u].z) + _1986;
        frontier_phi_46_43_ladder_1 = ((_2067.y - _1985) * ColorCorrectTexture_m0[0u].z) + _1985;
        frontier_phi_46_43_ladder_2 = ((_2067.x - _1984) * ColorCorrectTexture_m0[0u].z) + _1984;
      } else {
        frontier_phi_46_43_ladder = _1986;
        frontier_phi_46_43_ladder_1 = _1985;
        frontier_phi_46_43_ladder_2 = _1984;
      }
      _1990 = frontier_phi_46_43_ladder_2;
      _1993 = frontier_phi_46_43_ladder_1;
      _1996 = frontier_phi_46_43_ladder;
    } else {
#if 0
            float _2020;
            if (_1968 > 0.003130800090730190277099609375f)
            {
                _2020 = (exp2(log2(_1968) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2020 = _1968 * 12.9200000762939453125f;
            }
            float _2036;
            if (_1969 > 0.003130800090730190277099609375f)
            {
                _2036 = (exp2(log2(_1969) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2036 = _1969 * 12.9200000762939453125f;
            }
            float _2052;
            if (_1970 > 0.003130800090730190277099609375f)
            {
                _2052 = (exp2(log2(_1970) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2052 = _1970 * 12.9200000762939453125f;
            }
            float4 _2054 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2020, _2036, _2052), 0.0f);
#else
      float3 _2054 = LUTBlackCorrection(float3(_1968, _1969, _1970), tTextureMap2, lut_config);
#endif
      _1990 = ((_2054.x - _1968) * ColorCorrectTexture_m0[0u].z) + _1968;
      _1993 = ((_2054.y - _1969) * ColorCorrectTexture_m0[0u].z) + _1969;
      _1996 = ((_2054.z - _1970) * ColorCorrectTexture_m0[0u].z) + _1970;
    }
    float _852 = mad(_1996, ColorCorrectTexture_m0[3u].x, mad(_1993, ColorCorrectTexture_m0[2u].x, _1990 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
    float _855 = mad(_1996, ColorCorrectTexture_m0[3u].y, mad(_1993, ColorCorrectTexture_m0[2u].y, _1990 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
    float _858 = mad(_1996, ColorCorrectTexture_m0[3u].z, mad(_1993, ColorCorrectTexture_m0[2u].z, _1990 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
    float frontier_phi_13_46_ladder;
    float frontier_phi_13_46_ladder_1;
    float frontier_phi_13_46_ladder_2;
#if 0
        if (_889)
        {
            frontier_phi_13_46_ladder = _858 * _888;
            frontier_phi_13_46_ladder_1 = _855 * _888;
            frontier_phi_13_46_ladder_2 = _852 * _888;
        }
        else
        {
            frontier_phi_13_46_ladder = _858;
            frontier_phi_13_46_ladder_1 = _855;
            frontier_phi_13_46_ladder_2 = _852;
        }
        _850 = frontier_phi_13_46_ladder_2;
        _853 = frontier_phi_13_46_ladder_1;
        _856 = frontier_phi_13_46_ladder;
#else
    float3 postprocessColor = float3(_852, _855, _858);
    float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
    _850 = upgradedColor.r;
    _853 = upgradedColor.g;
    _856 = upgradedColor.b;
#endif
  }
  float _1205;
  float _1207;
  float _1209;
  if ((_100 & 8u) == 0u) {
    _1205 = _850;
    _1207 = _853;
    _1209 = _856;
  } else {
    _1205 = clamp(((ColorDeficientTable_m0[0u].x * _850) + (ColorDeficientTable_m0[0u].y * _853)) + (ColorDeficientTable_m0[0u].z * _856), 0.0f, 1.0f);
    _1207 = clamp(((ColorDeficientTable_m0[1u].x * _850) + (ColorDeficientTable_m0[1u].y * _853)) + (ColorDeficientTable_m0[1u].z * _856), 0.0f, 1.0f);
    _1209 = clamp(((ColorDeficientTable_m0[2u].x * _850) + (ColorDeficientTable_m0[2u].y * _853)) + (ColorDeficientTable_m0[2u].z * _856), 0.0f, 1.0f);
  }
  float _1780;
  float _1782;
  float _1784;
  if ((_100 & 16u) == 0u) {
    _1780 = _1205;
    _1782 = _1207;
    _1784 = _1209;
  } else {
    float _1805 = SceneInfo_m0[23u].z * gl_FragCoord.x;
    float _1806 = SceneInfo_m0[23u].w * gl_FragCoord.y;
    float4 _1808 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1805, _1806), 0.0f);
    float _1814 = _1808.x * ImagePlaneParam_m0[0u].x;
    float _1815 = _1808.y * ImagePlaneParam_m0[0u].y;
    float _1816 = _1808.z * ImagePlaneParam_m0[0u].z;
    float _1825 = (_1808.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1805, _1806), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
    _1780 = ((((_1814 < 0.5f) ? ((_1205 * 2.0f) * _1814) : (1.0f - (((1.0f - _1205) * 2.0f) * (1.0f - _1814)))) - _1205) * _1825) + _1205;
    _1782 = ((((_1815 < 0.5f) ? ((_1207 * 2.0f) * _1815) : (1.0f - (((1.0f - _1207) * 2.0f) * (1.0f - _1815)))) - _1207) * _1825) + _1207;
    _1784 = ((((_1816 < 0.5f) ? ((_1209 * 2.0f) * _1816) : (1.0f - (((1.0f - _1209) * 2.0f) * (1.0f - _1816)))) - _1209) * _1825) + _1209;
  }
  SV_Target.x = _1780;
  SV_Target.y = _1782;
  SV_Target.z = _1784;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyPreDisplayMap(SV_Target.rgb);
#endif
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  Kerare = stage_input.Kerare;
  Exposure = stage_input.Exposure;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
