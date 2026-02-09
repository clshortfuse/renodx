#include "../common.hlsli"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct RadialBlurComputeResult {
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

Texture2D<float4> ImagePlameBase : register(t5);

Texture2D<float> ImagePlameAlpha : register(t6);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint renderOutputId : packoffset(c032.z);
  uint SceneInfo_Reserve : packoffset(c032.w);
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

cbuffer LensDistortionParam : register(b2) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b3) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b4) {
  float4 cbRadialColor : packoffset(c000.x);
  float2 cbRadialScreenPos : packoffset(c001.x);
  float2 cbRadialMaskSmoothstep : packoffset(c001.z);
  float2 cbRadialMaskRate : packoffset(c002.x);
  float cbRadialBlurPower : packoffset(c002.z);
  float cbRadialSharpRange : packoffset(c002.w);
  uint cbRadialBlurFlags : packoffset(c003.x);
  float cbRadialReserve0 : packoffset(c003.y);
  float cbRadialReserve1 : packoffset(c003.z);
  float cbRadialReserve2 : packoffset(c003.w);
};

cbuffer FilmGrainParam : register(b5) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b6) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  row_major float4x4 fColorMatrix : packoffset(c001.x);
};

cbuffer ColorDeficientTable : register(b7) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b8) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b9) {
  uint cPassEnabled : packoffset(c000.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  bool _37 = (((uint)(cPassEnabled) & 1) != 0);
  bool _41 = _37 && (bool)((uint)(distortionType) == 0);
  bool _43 = _37 && (bool)((uint)(distortionType) == 1);
  // Configure LUT sampling with proper color space handling and black level correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      COLOR_GRADE_LUT_STRENGTH,           // How strongly to apply LUT (1.0 = full effect)
      COLOR_GRADE_LUT_SCALING,            // Enable HDR scaling mode
      renodx::lut::config::type::SRGB,    // LUT expects sRGB input
      renodx::lut::config::type::LINEAR,  // Output in linear space
      fTextureSize);                      // LUT resolution for coordinate mapping
  lut_config.recolor = 0.f;               // Disable saturation restoration (handled elsewhere)

  // Track HDR colors through the pipeline for later restoration
  float3 sdrColor = 0;      // SDR version for LUT sampling
  float3 untonemapped = 0;  // Original HDR before any processing
  float3 hdrColor = 0;      // HDR color to preserve and restore

  float tonemap_toe = toe;
  float tonemap_highlight_contrast = contrast;
  float max_nit = maxNit;
  float linear_start = linearStart;
  if (TONE_MAP_TYPE != 0)
  {
    if (RENODX_TONE_MAP_TOE_ADJUSTMENT_TYPE != 0)
    {
      tonemap_toe *= RENODX_TONE_MAP_SHADOW_TOE;
    } else {
      tonemap_toe = RENODX_TONE_MAP_SHADOW_TOE;
    }
    tonemap_highlight_contrast = RENODX_TONE_MAP_HIGHLIGHT_CONTRAST;
    max_nit = 100.f;
    linear_start = 100.f;
  }
  float _478;
  float _479;
  float _480;
  float _481;
  float _482;
  float _483;
  float _484;
  float _485;
  float _486;
  float _991;
  float _992;
  float _993;
  float _1019;
  float _1020;
  float _1021;
  float _1032;
  float _1033;
  float _1034;
  float _1076;
  float _1092;
  float _1108;
  float _1133;
  float _1134;
  float _1135;
  float _1167;
  float _1168;
  float _1169;
  float _1181;
  float _1192;
  float _1203;
  float _1245;
  float _1256;
  float _1267;
  float _1293;
  float _1304;
  float _1315;
  float _1331;
  float _1332;
  float _1333;
  float _1351;
  float _1352;
  float _1353;
  float _1388;
  float _1389;
  float _1390;
  float _1462;
  float _1463;
  float _1464;
  if (_41) {
    float _70 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _71 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _72 = dot(float2(_70, _71), float2(_70, _71));
    float _75 = ((_72 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _82 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_75 * _70) + 0.5f), ((_75 * _71) + 0.5f)));
    float _84 = _82.x * Exposure;
    float _85 = invLinearBegin * _84;
    float _92 = select((_84 >= linearBegin), 0.0f, (1.0f - ((_85 * _85) * (3.0f - (_85 * 2.0f)))));
    float _94 = select((_84 < linear_start), 0.0f, 1.0f);
    float _99 = (pow(_85, tonemap_toe));
    float _102 = ((tonemap_highlight_contrast * _84) + madLinearStartContrastFactor) * ((1.0f - _94) - _92);
    float _108 = (max_nit - (exp2((contrastFactor * _84) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _94;
    if ((uint)(aberrationEnable) == 0) {
      float _112 = _82.y * Exposure;
      float _113 = _82.z * Exposure;
      float _114 = invLinearBegin * _112;
      float _120 = invLinearBegin * _113;
      float _127 = select((_112 >= linearBegin), 0.0f, (1.0f - ((_114 * _114) * (3.0f - (_114 * 2.0f)))));
      float _129 = select((_113 >= linearBegin), 0.0f, (1.0f - ((_120 * _120) * (3.0f - (_120 * 2.0f)))));
      float _132 = select((_112 < linear_start), 0.0f, 1.0f);
      float _133 = select((_113 < linear_start), 0.0f, 1.0f);
      _478 = ((_102 + ((_99 * _92) * linearBegin)) + _108);
      _479 = (((((tonemap_highlight_contrast * _112) + madLinearStartContrastFactor) * ((1.0f - _132) - _127)) + (((pow(_114, tonemap_toe)) * _127) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _112) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _132));
      _480 = (((((tonemap_highlight_contrast * _113) + madLinearStartContrastFactor) * ((1.0f - _133) - _129)) + (((pow(_120, tonemap_toe)) * _129) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _113) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _133));
      _481 = fDistortionCoef;
      _482 = 0.0f;
      _483 = 0.0f;
      _484 = 0.0f;
      _485 = 0.0f;
      _486 = fCorrectCoef;
    } else {
      float _175 = _72 + fRefraction;
      float _177 = (_175 * fDistortionCoef) + 1.0f;
      float _178 = _70 * fCorrectCoef;
      float _180 = _71 * fCorrectCoef;
      float _186 = ((_175 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _195 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_178 * _177) + 0.5f), ((_180 * _177) + 0.5f)));
      float _197 = _195.y * Exposure;
      float _198 = invLinearBegin * _197;
      float _205 = select((_197 >= linearBegin), 0.0f, (1.0f - ((_198 * _198) * (3.0f - (_198 * 2.0f)))));
      float _207 = select((_197 < linear_start), 0.0f, 1.0f);
      float4 _226 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_178 * _186) + 0.5f), ((_180 * _186) + 0.5f)));
      float _228 = _226.z * Exposure;
      float _229 = invLinearBegin * _228;
      float _236 = select((_228 >= linearBegin), 0.0f, (1.0f - ((_229 * _229) * (3.0f - (_229 * 2.0f)))));
      float _238 = select((_228 < linear_start), 0.0f, 1.0f);
      _478 = ((_102 + ((linearBegin * _99) * _92)) + _108);
      _479 = (((((tonemap_highlight_contrast * _197) + madLinearStartContrastFactor) * ((1.0f - _207) - _205)) + ((linearBegin * (pow(_198, tonemap_toe))) * _205)) + ((max_nit - (exp2((contrastFactor * _197) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _207));
      _480 = (((((tonemap_highlight_contrast * _228) + madLinearStartContrastFactor) * ((1.0f - _238) - _236)) + ((linearBegin * (pow(_229, tonemap_toe))) * _236)) + ((max_nit - (exp2((contrastFactor * _228) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _238));
      _481 = fDistortionCoef;
      _482 = 0.0f;
      _483 = 0.0f;
      _484 = 0.0f;
      _485 = 0.0f;
      _486 = fCorrectCoef;
    }
  } else {
    if (_43) {
      float _271 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _275 = sqrt((_271 * _271) + 1.0f);
      float _276 = 1.0f / _275;
      float _279 = (_275 * fOptimizedParam.z) * (_276 + fOptimizedParam.x);
      float _283 = fOptimizedParam.w * 0.5f;
      float4 _292 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_283 * _271) * _279) + 0.5f), ((((_283 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_276 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _279) + 0.5f)));
      float _296 = _292.x * Exposure;
      float _297 = _292.y * Exposure;
      float _298 = _292.z * Exposure;
      float _299 = invLinearBegin * _296;
      float _305 = invLinearBegin * _297;
      float _311 = invLinearBegin * _298;
      float _318 = select((_296 >= linearBegin), 0.0f, (1.0f - ((_299 * _299) * (3.0f - (_299 * 2.0f)))));
      float _320 = select((_297 >= linearBegin), 0.0f, (1.0f - ((_305 * _305) * (3.0f - (_305 * 2.0f)))));
      float _322 = select((_298 >= linearBegin), 0.0f, (1.0f - ((_311 * _311) * (3.0f - (_311 * 2.0f)))));
      float _326 = select((_296 < linear_start), 0.0f, 1.0f);
      float _327 = select((_297 < linear_start), 0.0f, 1.0f);
      float _328 = select((_298 < linear_start), 0.0f, 1.0f);
      _478 = (((((tonemap_highlight_contrast * _296) + madLinearStartContrastFactor) * ((1.0f - _326) - _318)) + (((pow(_299, tonemap_toe)) * _318) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _296) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _326));
      _479 = (((((tonemap_highlight_contrast * _297) + madLinearStartContrastFactor) * ((1.0f - _327) - _320)) + (((pow(_305, tonemap_toe)) * _320) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _297) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _327));
      _480 = (((((tonemap_highlight_contrast * _298) + madLinearStartContrastFactor) * ((1.0f - _328) - _322)) + (((pow(_311, tonemap_toe)) * _322) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _298) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _328));
      _481 = 0.0f;
      _482 = fOptimizedParam.x;
      _483 = fOptimizedParam.y;
      _484 = fOptimizedParam.z;
      _485 = fOptimizedParam.w;
      _486 = 1.0f;
    } else {
      float4 _386 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _390 = _386.x * Exposure;
      float _391 = _386.y * Exposure;
      float _392 = _386.z * Exposure;
      float _393 = invLinearBegin * _390;
      float _399 = invLinearBegin * _391;
      float _405 = invLinearBegin * _392;
      float _412 = select((_390 >= linearBegin), 0.0f, (1.0f - ((_393 * _393) * (3.0f - (_393 * 2.0f)))));
      float _414 = select((_391 >= linearBegin), 0.0f, (1.0f - ((_399 * _399) * (3.0f - (_399 * 2.0f)))));
      float _416 = select((_392 >= linearBegin), 0.0f, (1.0f - ((_405 * _405) * (3.0f - (_405 * 2.0f)))));
      float _420 = select((_390 < linear_start), 0.0f, 1.0f);
      float _421 = select((_391 < linear_start), 0.0f, 1.0f);
      float _422 = select((_392 < linear_start), 0.0f, 1.0f);
      _478 = (((((tonemap_highlight_contrast * _390) + madLinearStartContrastFactor) * ((1.0f - _420) - _412)) + (((pow(_393, tonemap_toe)) * _412) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _390) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _420));
      _479 = (((((tonemap_highlight_contrast * _391) + madLinearStartContrastFactor) * ((1.0f - _421) - _414)) + (((pow(_399, tonemap_toe)) * _414) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _391) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _421));
      _480 = (((((tonemap_highlight_contrast * _392) + madLinearStartContrastFactor) * ((1.0f - _422) - _416)) + (((pow(_405, tonemap_toe)) * _416) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _392) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _422));
      _481 = 0.0f;
      _482 = 0.0f;
      _483 = 0.0f;
      _484 = 0.0f;
      _485 = 0.0f;
      _486 = 1.0f;
    }
  }
  if (!(((uint)(cPassEnabled) & 32) == 0)) {
    float _508 = float((bool)(bool)(((uint)(cbRadialBlurFlags) & 2) != 0));
    float _512 = ComputeResultSRV[0].computeAlpha;
    float _515 = ((1.0f - _508) + (_512 * _508)) * cbRadialColor.w;
    if (!(_515 == 0.0f)) {
      float _522 = screenInverseSize.x * SV_Position.x;
      float _523 = screenInverseSize.y * SV_Position.y;
      float _525 = (-0.5f - cbRadialScreenPos.x) + _522;
      float _527 = (-0.5f - cbRadialScreenPos.y) + _523;
      float _530 = select((_525 < 0.0f), (1.0f - _522), _522);
      float _533 = select((_527 < 0.0f), (1.0f - _523), _523);
      float _538 = rsqrt(dot(float2(_525, _527), float2(_525, _527))) * cbRadialSharpRange;
      uint _545 = uint(abs(_538 * _527)) + uint(abs(_538 * _525));
      uint _549 = ((_545 ^ 61) ^ ((uint)(_545) >> 16)) * 9;
      uint _552 = (((uint)(_549) >> 4) ^ _549) * 668265261;
      float _557 = select((((uint)(cbRadialBlurFlags) & 1) != 0), (float((uint)((int)(((uint)(_552) >> 15) ^ _552))) * 2.3283064365386963e-10f), 1.0f);
      float _563 = 1.0f / max(1.0f, sqrt((_525 * _525) + (_527 * _527)));
      float _564 = cbRadialBlurPower * -0.004999999888241291f;
      float _573 = ((((_564 * _530) * _557) * _563) + 1.0f) * _525;
      float _574 = ((((_564 * _533) * _557) * _563) + 1.0f) * _527;
      float _576 = cbRadialBlurPower * -0.009999999776482582f;
      float _585 = ((((_576 * _530) * _557) * _563) + 1.0f) * _525;
      float _586 = ((((_576 * _533) * _557) * _563) + 1.0f) * _527;
      float _587 = Exposure * 0.3333333432674408f;
      float _588 = _587 * cbRadialColor.x;
      float _589 = _587 * cbRadialColor.y;
      float _590 = _587 * cbRadialColor.z;
      float _605 = (_478 * 0.3333333432674408f) * cbRadialColor.x;
      float _607 = (_479 * 0.3333333432674408f) * cbRadialColor.y;
      float _609 = (_480 * 0.3333333432674408f) * cbRadialColor.z;
      if (_41) {
        float _611 = _573 + cbRadialScreenPos.x;
        float _612 = _574 + cbRadialScreenPos.y;
        float _616 = ((dot(float2(_611, _612), float2(_611, _612)) * _481) + 1.0f) * _486;
        float4 _622 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_616 * _611) + 0.5f), ((_616 * _612) + 0.5f)), 0.0f);
        float _626 = _585 + cbRadialScreenPos.x;
        float _627 = _586 + cbRadialScreenPos.y;
        float _630 = (dot(float2(_626, _627), float2(_626, _627)) * _481) + 1.0f;
        float4 _637 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_626 * _486) * _630) + 0.5f), (((_627 * _486) * _630) + 0.5f)), 0.0f);
        float _644 = _588 * (_637.x + _622.x);
        float _645 = _589 * (_637.y + _622.y);
        float _646 = _590 * (_637.z + _622.z);
        float _647 = _644 * invLinearBegin;
        float _653 = _645 * invLinearBegin;
        float _659 = _646 * invLinearBegin;
        float _666 = select((_644 >= linearBegin), 0.0f, (1.0f - ((_647 * _647) * (3.0f - (_647 * 2.0f)))));
        float _668 = select((_645 >= linearBegin), 0.0f, (1.0f - ((_653 * _653) * (3.0f - (_653 * 2.0f)))));
        float _670 = select((_646 >= linearBegin), 0.0f, (1.0f - ((_659 * _659) * (3.0f - (_659 * 2.0f)))));
        float _674 = select((_644 < linear_start), 0.0f, 1.0f);
        float _675 = select((_645 < linear_start), 0.0f, 1.0f);
        float _676 = select((_646 < linear_start), 0.0f, 1.0f);
        _991 = (((((_666 * (pow(_647, tonemap_toe))) * linearBegin) + _605) + (((tonemap_highlight_contrast * _644) + madLinearStartContrastFactor) * ((1.0f - _674) - _666))) + ((max_nit - (exp2((contrastFactor * _644) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _674));
        _992 = ((((((pow(_653, tonemap_toe)) * _668) * linearBegin) + _607) + (((tonemap_highlight_contrast * _645) + madLinearStartContrastFactor) * ((1.0f - _675) - _668))) + ((max_nit - (exp2((contrastFactor * _645) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _675));
        _993 = ((((((pow(_659, tonemap_toe)) * _670) * linearBegin) + _609) + (((tonemap_highlight_contrast * _646) + madLinearStartContrastFactor) * ((1.0f - _676) - _670))) + ((max_nit - (exp2((contrastFactor * _646) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _676));
      } else {
        float _735 = cbRadialScreenPos.x + 0.5f;
        float _736 = _735 + _573;
        float _737 = cbRadialScreenPos.y + 0.5f;
        float _738 = _737 + _574;
        float _739 = _735 + _585;
        float _740 = _737 + _586;
        if (_43) {
          float _744 = (_736 * 2.0f) + -1.0f;
          float _748 = sqrt((_744 * _744) + 1.0f);
          float _749 = 1.0f / _748;
          float _752 = (_748 * _484) * (_749 + _482);
          float _756 = _485 * 0.5f;
          float4 _765 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_756 * _752) * _744) + 0.5f), ((((_756 * (((_749 + -1.0f) * _483) + 1.0f)) * _752) * ((_738 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
          float _771 = (_739 * 2.0f) + -1.0f;
          float _775 = sqrt((_771 * _771) + 1.0f);
          float _776 = 1.0f / _775;
          float _779 = (_775 * _484) * (_776 + _482);
          float4 _790 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_756 * _771) * _779) + 0.5f), ((((_756 * ((_740 * 2.0f) + -1.0f)) * (((_776 + -1.0f) * _483) + 1.0f)) * _779) + 0.5f)), 0.0f);
          float _797 = _588 * (_790.x + _765.x);
          float _798 = _589 * (_790.y + _765.y);
          float _799 = _590 * (_790.z + _765.z);
          float _800 = _797 * invLinearBegin;
          float _806 = _798 * invLinearBegin;
          float _812 = _799 * invLinearBegin;
          float _819 = select((_797 >= linearBegin), 0.0f, (1.0f - ((_800 * _800) * (3.0f - (_800 * 2.0f)))));
          float _821 = select((_798 >= linearBegin), 0.0f, (1.0f - ((_806 * _806) * (3.0f - (_806 * 2.0f)))));
          float _823 = select((_799 >= linearBegin), 0.0f, (1.0f - ((_812 * _812) * (3.0f - (_812 * 2.0f)))));
          float _827 = select((_797 < linear_start), 0.0f, 1.0f);
          float _828 = select((_798 < linear_start), 0.0f, 1.0f);
          float _829 = select((_799 < linear_start), 0.0f, 1.0f);
          _991 = (((((_819 * (pow(_800, tonemap_toe))) * linearBegin) + _605) + (((tonemap_highlight_contrast * _797) + madLinearStartContrastFactor) * ((1.0f - _827) - _819))) + ((max_nit - (exp2((contrastFactor * _797) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _827));
          _992 = ((((((pow(_806, tonemap_toe)) * _821) * linearBegin) + _607) + (((tonemap_highlight_contrast * _798) + madLinearStartContrastFactor) * ((1.0f - _828) - _821))) + ((max_nit - (exp2((contrastFactor * _798) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _828));
          _993 = ((((((pow(_812, tonemap_toe)) * _823) * linearBegin) + _609) + (((tonemap_highlight_contrast * _799) + madLinearStartContrastFactor) * ((1.0f - _829) - _823))) + ((max_nit - (exp2((contrastFactor * _799) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _829));
        } else {
          float4 _889 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_736, _738), 0.0f);
          float4 _893 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_739, _740), 0.0f);
          float _900 = _588 * (_893.x + _889.x);
          float _901 = _589 * (_893.y + _889.y);
          float _902 = _590 * (_893.z + _889.z);
          float _903 = _900 * invLinearBegin;
          float _909 = _901 * invLinearBegin;
          float _915 = _902 * invLinearBegin;
          float _922 = select((_900 >= linearBegin), 0.0f, (1.0f - ((_903 * _903) * (3.0f - (_903 * 2.0f)))));
          float _924 = select((_901 >= linearBegin), 0.0f, (1.0f - ((_909 * _909) * (3.0f - (_909 * 2.0f)))));
          float _926 = select((_902 >= linearBegin), 0.0f, (1.0f - ((_915 * _915) * (3.0f - (_915 * 2.0f)))));
          float _930 = select((_900 < linear_start), 0.0f, 1.0f);
          float _931 = select((_901 < linear_start), 0.0f, 1.0f);
          float _932 = select((_902 < linear_start), 0.0f, 1.0f);
          _991 = (((((_922 * (pow(_903, tonemap_toe))) * linearBegin) + _605) + (((tonemap_highlight_contrast * _900) + madLinearStartContrastFactor) * ((1.0f - _930) - _922))) + ((max_nit - (exp2((contrastFactor * _900) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _930));
          _992 = ((((((pow(_909, tonemap_toe)) * _924) * linearBegin) + _607) + (((tonemap_highlight_contrast * _901) + madLinearStartContrastFactor) * ((1.0f - _931) - _924))) + ((max_nit - (exp2((contrastFactor * _901) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _931));
          _993 = ((((((pow(_915, tonemap_toe)) * _926) * linearBegin) + _609) + (((tonemap_highlight_contrast * _902) + madLinearStartContrastFactor) * ((1.0f - _932) - _926))) + ((max_nit - (exp2((contrastFactor * _902) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _932));
        }
      }
      if (cbRadialMaskRate.x > 0.0f) {
        float _1002 = saturate((sqrt((_525 * _525) + (_527 * _527)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _1008 = (((_1002 * _1002) * cbRadialMaskRate.x) * (3.0f - (_1002 * 2.0f))) + cbRadialMaskRate.y;
        _1019 = ((_1008 * (_991 - _478)) + _478);
        _1020 = ((_1008 * (_992 - _479)) + _479);
        _1021 = ((_1008 * (_993 - _480)) + _480);
      } else {
        _1019 = _991;
        _1020 = _992;
        _1021 = _993;
      }
      _1032 = (lerp(_478, _1019, _515));
      _1033 = (lerp(_479, _1020, _515));
      _1034 = (lerp(_480, _1021, _515));
    } else {
      _1032 = _478;
      _1033 = _479;
      _1034 = _480;
    }
  } else {
    _1032 = _478;
    _1033 = _479;
    _1034 = _480;
  }
  // if (!(((uint)(cPassEnabled) & 2) == 0)) {
  //   float _1056 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
  //   float _1058 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
  //   float _1062 = frac(frac(dot(float2(_1056, _1058), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
  //   if (_1062 < fNoiseDensity) {
  //     int _1067 = (uint)(uint(_1058 * _1056)) ^ 12345391;
  //     uint _1068 = _1067 * 3635641;
  //     _1076 = (float((uint)((int)((((uint)(_1068) >> 26) | ((uint)(_1067 * 232681024))) ^ _1068))) * 2.3283064365386963e-10f);
  //   } else {
  //     _1076 = 0.0f;
  //   }
  //   float _1078 = frac(_1062 * 757.4846801757812f);
  //   if (_1078 < fNoiseDensity) {
  //     int _1082 = asint(_1078) ^ 12345391;
  //     uint _1083 = _1082 * 3635641;
  //     _1092 = ((float((uint)((int)((((uint)(_1083) >> 26) | ((uint)(_1082 * 232681024))) ^ _1083))) * 2.3283064365386963e-10f) + -0.5f);
  //   } else {
  //     _1092 = 0.0f;
  //   }
  //   float _1094 = frac(_1078 * 757.4846801757812f);
  //   if (_1094 < fNoiseDensity) {
  //     int _1098 = asint(_1094) ^ 12345391;
  //     uint _1099 = _1098 * 3635641;
  //     _1108 = ((float((uint)((int)((((uint)(_1099) >> 26) | ((uint)(_1098 * 232681024))) ^ _1099))) * 2.3283064365386963e-10f) + -0.5f);
  //   } else {
  //     _1108 = 0.0f;
  //   }
  //   float _1109 = _1076 * fNoisePower.x;
  //   float _1110 = _1108 * fNoisePower.y;
  //   float _1111 = _1092 * fNoisePower.y;
  //   float _1122 = exp2(log2(1.0f - saturate(dot(float3(_1032, _1033, _1034), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
  //   _1133 = ((_1122 * (mad(_1111, 1.4019999504089355f, _1109) - _1032)) + _1032);
  //   _1134 = ((_1122 * (mad(_1111, -0.7139999866485596f, mad(_1110, -0.3440000116825104f, _1109)) - _1033)) + _1033);
  //   _1135 = ((_1122 * (mad(_1110, 1.7719999551773071f, _1109) - _1034)) + _1034);
  // } else {
    _1133 = _1032;
    _1134 = _1033;
    _1135 = _1034;
  // }
  if (!(((uint)(cPassEnabled) & 4) == 0)) {
    if (TONE_MAP_TYPE != 0)
    {
      untonemapped = float3(_1133, _1134, _1135);
      hdrColor = untonemapped;

      float4 tonemap_scale = LUTToneMapScale(untonemapped);
      sdrColor = tonemap_scale.rgb;
      float lut_scale = tonemap_scale.a;

      float3 lut0_color = LUTBlackCorrection(sdrColor, tTextureMap0, lut_config);

      float3 blendedLutColor;
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float3 lut1_color = LUTBlackCorrection(sdrColor, tTextureMap1, lut_config);
        blendedLutColor = lerp(lut0_color, lut1_color, fTextureBlendRate);

        if (fTextureBlendRate2 > 0.0f) {
          float3 lut2_color = LUTBlackCorrection(blendedLutColor, tTextureMap2, lut_config);
          blendedLutColor = lerp(blendedLutColor, lut2_color, fTextureBlendRate2);
        }
      } else {
        if (fTextureBlendRate2 > 0.0f) {
          float3 lut2_color = LUTBlackCorrection(lut0_color, tTextureMap2, lut_config);
          blendedLutColor = lerp(lut0_color, lut2_color, fTextureBlendRate2);
        } else {
          blendedLutColor = lut0_color;
        }
      }

      float _1337 = mad(blendedLutColor.z, (fColorMatrix[2].x), mad(blendedLutColor.y, (fColorMatrix[1].x), (blendedLutColor.x * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
      float _1341 = mad(blendedLutColor.z, (fColorMatrix[2].y), mad(blendedLutColor.y, (fColorMatrix[1].y), (blendedLutColor.x * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
      float _1345 = mad(blendedLutColor.z, (fColorMatrix[2].z), mad(blendedLutColor.y, (fColorMatrix[1].z), (blendedLutColor.x * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);

      float3 postprocessColor = float3(_1337, _1341, _1345);
      // float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
      float3 upgradedColor = postprocessColor / lut_scale;
      _1351 = upgradedColor.r;
      _1352 = upgradedColor.g;
      _1353 = upgradedColor.b;
    } else {
      float _1160 = max(max(_1133, _1134), _1135);
      bool _1161 = (_1160 > 1.0f);
      if (_1161) {
        _1167 = (_1133 / _1160);
        _1168 = (_1134 / _1160);
        _1169 = (_1135 / _1160);
      } else {
        _1167 = _1133;
        _1168 = _1134;
        _1169 = _1135;
      }
      float _1170 = fTextureInverseSize * 0.5f;
      [branch]
      if (!(!(_1167 <= 0.0031308000907301903f))) {
        _1181 = (_1167 * 12.920000076293945f);
      } else {
        _1181 = (((pow(_1167, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      [branch]
      if (!(!(_1168 <= 0.0031308000907301903f))) {
        _1192 = (_1168 * 12.920000076293945f);
      } else {
        _1192 = (((pow(_1168, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      [branch]
      if (!(!(_1169 <= 0.0031308000907301903f))) {
        _1203 = (_1169 * 12.920000076293945f);
      } else {
        _1203 = (((pow(_1169, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      float _1204 = 1.0f - fTextureInverseSize;
      float _1208 = (_1181 * _1204) + _1170;
      float _1209 = (_1192 * _1204) + _1170;
      float _1210 = (_1203 * _1204) + _1170;
      float4 _1213 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1208, _1209, _1210), 0.0f);
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1220 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1208, _1209, _1210), 0.0f);
        float _1230 = ((_1220.x - _1213.x) * fTextureBlendRate) + _1213.x;
        float _1231 = ((_1220.y - _1213.y) * fTextureBlendRate) + _1213.y;
        float _1232 = ((_1220.z - _1213.z) * fTextureBlendRate) + _1213.z;
        if (fTextureBlendRate2 > 0.0f) {
          [branch]
          if (!(!(_1230 <= 0.0031308000907301903f))) {
            _1245 = (_1230 * 12.920000076293945f);
          } else {
            _1245 = (((pow(_1230, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          [branch]
          if (!(!(_1231 <= 0.0031308000907301903f))) {
            _1256 = (_1231 * 12.920000076293945f);
          } else {
            _1256 = (((pow(_1231, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          [branch]
          if (!(!(_1232 <= 0.0031308000907301903f))) {
            _1267 = (_1232 * 12.920000076293945f);
          } else {
            _1267 = (((pow(_1232, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          float4 _1269 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1245, _1256, _1267), 0.0f);
          _1331 = (lerp(_1230, _1269.x, fTextureBlendRate2));
          _1332 = (lerp(_1231, _1269.y, fTextureBlendRate2));
          _1333 = (lerp(_1232, _1269.z, fTextureBlendRate2));
        } else {
          _1331 = _1230;
          _1332 = _1231;
          _1333 = _1232;
        }
      } else {
        [branch]
        if (!(!(_1213.x <= 0.0031308000907301903f))) {
          _1293 = (_1213.x * 12.920000076293945f);
        } else {
          _1293 = (((pow(_1213.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_1213.y <= 0.0031308000907301903f))) {
          _1304 = (_1213.y * 12.920000076293945f);
        } else {
          _1304 = (((pow(_1213.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_1213.z <= 0.0031308000907301903f))) {
          _1315 = (_1213.z * 12.920000076293945f);
        } else {
          _1315 = (((pow(_1213.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _1317 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1293, _1304, _1315), 0.0f);
        _1331 = (lerp(_1213.x, _1317.x, fTextureBlendRate2));
        _1332 = (lerp(_1213.y, _1317.y, fTextureBlendRate2));
        _1333 = (lerp(_1213.z, _1317.z, fTextureBlendRate2));
      }
      float _1337 = mad(_1333, (fColorMatrix[2].x), mad(_1332, (fColorMatrix[1].x), (_1331 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
      float _1341 = mad(_1333, (fColorMatrix[2].y), mad(_1332, (fColorMatrix[1].y), (_1331 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
      float _1345 = mad(_1333, (fColorMatrix[2].z), mad(_1332, (fColorMatrix[1].z), (_1331 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
      if (_1161) {
        _1351 = (_1337 * _1160);
        _1352 = (_1341 * _1160);
        _1353 = (_1345 * _1160);
      } else {
        _1351 = _1337;
        _1352 = _1341;
        _1353 = _1345;
      }
    }
  } else {
    _1351 = _1133;
    _1352 = _1134;
    _1353 = _1135;
  }
  if (!(((uint)(cPassEnabled) & 8) == 0)) {
    _1388 = saturate(((cvdR.x * _1351) + (cvdR.y * _1352)) + (cvdR.z * _1353));
    _1389 = saturate(((cvdG.x * _1351) + (cvdG.y * _1352)) + (cvdG.z * _1353));
    _1390 = saturate(((cvdB.x * _1351) + (cvdB.y * _1352)) + (cvdB.z * _1353));
  } else {
    _1388 = _1351;
    _1389 = _1352;
    _1390 = _1353;
  }
  if (!(((uint)(cPassEnabled) & 16) == 0)) {
    float _1405 = screenInverseSize.x * SV_Position.x;
    float _1406 = screenInverseSize.y * SV_Position.y;
    float4 _1409 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1405, _1406), 0.0f);
    float _1414 = _1409.x * ColorParam.x;
    float _1415 = _1409.y * ColorParam.y;
    float _1416 = _1409.z * ColorParam.z;
    float _1419 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1405, _1406), 0.0f);
    float _1424 = (_1409.w * ColorParam.w) * saturate((_1419.x * Levels_Rate) + Levels_Range);
    _1462 = (((select((_1414 < 0.5f), ((_1388 * 2.0f) * _1414), (1.0f - (((1.0f - _1388) * 2.0f) * (1.0f - _1414)))) - _1388) * _1424) + _1388);
    _1463 = (((select((_1415 < 0.5f), ((_1389 * 2.0f) * _1415), (1.0f - (((1.0f - _1389) * 2.0f) * (1.0f - _1415)))) - _1389) * _1424) + _1389);
    _1464 = (((select((_1416 < 0.5f), ((_1390 * 2.0f) * _1416), (1.0f - (((1.0f - _1390) * 2.0f) * (1.0f - _1416)))) - _1390) * _1424) + _1390);
  } else {
    _1462 = _1388;
    _1463 = _1389;
    _1464 = _1390;
  }
  SV_Target.x = _1462;
  SV_Target.y = _1463;
  SV_Target.z = _1464;
  SV_Target.w = 0.0f;
  if (TONE_MAP_TYPE != 0.f) {
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb);
  }
  return SV_Target;
}
