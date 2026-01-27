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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer TonemapParam : register(b2) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displaymax_nitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mullinear_startContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madlinear_startContrastFactor : packoffset(c002.z);
};

cbuffer LensDistortionParam : register(b3) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b4) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b5) {
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

cbuffer FilmGrainParam : register(b6) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b7) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  row_major float4x4 fColorMatrix : packoffset(c001.x);
};

cbuffer ColorDeficientTable : register(b8) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b9) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b10) {
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
  bool _43 = (((uint)(cPassEnabled) & 1) != 0);
  bool _47 = _43 && (bool)((uint)(distortionType) == 0);
  bool _49 = _43 && (bool)((uint)(distortionType) == 1);
  float _52 = Kerare.x / Kerare.w;
  float _53 = Kerare.y / Kerare.w;
  float _54 = Kerare.z / Kerare.w;
  float _58 = abs(rsqrt(dot(float3(_52, _53, _54), float3(_52, _53, _54))) * _54);
  float _65 = _58 * _58;
  float _69 = saturate(((_65 * _65) * (1.0f - saturate((kerare_scale * _58) + kerare_offset))) + kerare_brightness);
  float _70 = _69 * Exposure;

  // Configure LUT sampling with proper color space handling and black level correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      COLOR_GRADE_LUT_STRENGTH,  // How strongly to apply LUT (1.0 = full effect)
      COLOR_GRADE_LUT_SCALING,   // Enable HDR scaling mode
      renodx::lut::config::type::SRGB,   // LUT expects sRGB input
      renodx::lut::config::type::LINEAR, // Output in linear space
      fTextureSize);                      // LUT resolution for coordinate mapping
  lut_config.recolor = 0.f;  // Disable saturation restoration (handled elsewhere)

  // Track HDR colors through the pipeline for later restoration
  float3 sdrColor = 0;       // SDR version for LUT sampling
  float3 untonemapped = 0;   // Original HDR before any processing
  float3 hdrColor = 0;       // HDR color to preserve and restore

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

  float _505;
  float _506;
  float _507;
  float _508;
  float _509;
  float _510;
  float _511;
  float _512;
  float _513;
  float _1019;
  float _1020;
  float _1021;
  float _1047;
  float _1048;
  float _1049;
  float _1060;
  float _1061;
  float _1062;
  float _1104;
  float _1120;
  float _1136;
  float _1161;
  float _1162;
  float _1163;
  float _1195;
  float _1196;
  float _1197;
  float _1209;
  float _1220;
  float _1231;
  float _1273;
  float _1284;
  float _1295;
  float _1321;
  float _1332;
  float _1343;
  float _1359;
  float _1360;
  float _1361;
  float _1379;
  float _1380;
  float _1381;
  float _1416;
  float _1417;
  float _1418;
  float _1490;
  float _1491;
  float _1492;
  if (_47) {
    float _97 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _98 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _99 = dot(float2(_97, _98), float2(_97, _98));
    float _102 = ((_99 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _109 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_102 * _97) + 0.5f), ((_102 * _98) + 0.5f)));
    float _111 = _109.x * _70;
    float _112 = invLinearBegin * _111;
    float _119 = select((_111 >= linearBegin), 0.0f, (1.0f - ((_112 * _112) * (3.0f - (_112 * 2.0f)))));
    float _121 = select((_111 < linear_start), 0.0f, 1.0f);
    float _126 = (pow(_112, tonemap_toe));
    float _129 = ((tonemap_highlight_contrast * _111) + madlinear_startContrastFactor) * ((1.0f - _121) - _119);
    float _135 = (max_nit - (exp2((contrastFactor * _111) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _121;
    if ((uint)(aberrationEnable) == 0) {
      float _139 = _109.y * _70;
      float _140 = _109.z * _70;
      float _141 = invLinearBegin * _139;
      float _147 = invLinearBegin * _140;
      float _154 = select((_139 >= linearBegin), 0.0f, (1.0f - ((_141 * _141) * (3.0f - (_141 * 2.0f)))));
      float _156 = select((_140 >= linearBegin), 0.0f, (1.0f - ((_147 * _147) * (3.0f - (_147 * 2.0f)))));
      float _159 = select((_139 < linear_start), 0.0f, 1.0f);
      float _160 = select((_140 < linear_start), 0.0f, 1.0f);
      _505 = ((_129 + ((_126 * _119) * linearBegin)) + _135);
      _506 = (((((tonemap_highlight_contrast * _139) + madlinear_startContrastFactor) * ((1.0f - _159) - _154)) + (((pow(_141, tonemap_toe)) * _154) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _139) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _159));
      _507 = (((((tonemap_highlight_contrast * _140) + madlinear_startContrastFactor) * ((1.0f - _160) - _156)) + (((pow(_147, tonemap_toe)) * _156) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _140) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _160));
      _508 = fDistortionCoef;
      _509 = 0.0f;
      _510 = 0.0f;
      _511 = 0.0f;
      _512 = 0.0f;
      _513 = fCorrectCoef;
    } else {
      float _202 = _99 + fRefraction;
      float _204 = (_202 * fDistortionCoef) + 1.0f;
      float _205 = _97 * fCorrectCoef;
      float _207 = _98 * fCorrectCoef;
      float _213 = ((_202 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _222 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_205 * _204) + 0.5f), ((_207 * _204) + 0.5f)));
      float _224 = _222.y * _70;
      float _225 = invLinearBegin * _224;
      float _232 = select((_224 >= linearBegin), 0.0f, (1.0f - ((_225 * _225) * (3.0f - (_225 * 2.0f)))));
      float _234 = select((_224 < linear_start), 0.0f, 1.0f);
      float4 _253 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_205 * _213) + 0.5f), ((_207 * _213) + 0.5f)));
      float _255 = _253.z * _70;
      float _256 = invLinearBegin * _255;
      float _263 = select((_255 >= linearBegin), 0.0f, (1.0f - ((_256 * _256) * (3.0f - (_256 * 2.0f)))));
      float _265 = select((_255 < linear_start), 0.0f, 1.0f);
      _505 = ((_129 + ((linearBegin * _126) * _119)) + _135);
      _506 = (((((tonemap_highlight_contrast * _224) + madlinear_startContrastFactor) * ((1.0f - _234) - _232)) + ((linearBegin * (pow(_225, tonemap_toe))) * _232)) + ((max_nit - (exp2((contrastFactor * _224) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _234));
      _507 = (((((tonemap_highlight_contrast * _255) + madlinear_startContrastFactor) * ((1.0f - _265) - _263)) + ((linearBegin * (pow(_256, tonemap_toe))) * _263)) + ((max_nit - (exp2((contrastFactor * _255) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _265));
      _508 = fDistortionCoef;
      _509 = 0.0f;
      _510 = 0.0f;
      _511 = 0.0f;
      _512 = 0.0f;
      _513 = fCorrectCoef;
    }
  } else {
    if (_49) {
      float _298 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _302 = sqrt((_298 * _298) + 1.0f);
      float _303 = 1.0f / _302;
      float _306 = (_302 * fOptimizedParam.z) * (_303 + fOptimizedParam.x);
      float _310 = fOptimizedParam.w * 0.5f;
      float4 _319 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_310 * _298) * _306) + 0.5f), ((((_310 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_303 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _306) + 0.5f)));
      float _323 = _319.x * _70;
      float _324 = _319.y * _70;
      float _325 = _319.z * _70;
      float _326 = invLinearBegin * _323;
      float _332 = invLinearBegin * _324;
      float _338 = invLinearBegin * _325;
      float _345 = select((_323 >= linearBegin), 0.0f, (1.0f - ((_326 * _326) * (3.0f - (_326 * 2.0f)))));
      float _347 = select((_324 >= linearBegin), 0.0f, (1.0f - ((_332 * _332) * (3.0f - (_332 * 2.0f)))));
      float _349 = select((_325 >= linearBegin), 0.0f, (1.0f - ((_338 * _338) * (3.0f - (_338 * 2.0f)))));
      float _353 = select((_323 < linear_start), 0.0f, 1.0f);
      float _354 = select((_324 < linear_start), 0.0f, 1.0f);
      float _355 = select((_325 < linear_start), 0.0f, 1.0f);
      _505 = (((((tonemap_highlight_contrast * _323) + madlinear_startContrastFactor) * ((1.0f - _353) - _345)) + (((pow(_326, tonemap_toe)) * _345) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _323) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _353));
      _506 = (((((tonemap_highlight_contrast * _324) + madlinear_startContrastFactor) * ((1.0f - _354) - _347)) + (((pow(_332, tonemap_toe)) * _347) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _324) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _354));
      _507 = (((((tonemap_highlight_contrast * _325) + madlinear_startContrastFactor) * ((1.0f - _355) - _349)) + (((pow(_338, tonemap_toe)) * _349) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _325) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _355));
      _508 = 0.0f;
      _509 = fOptimizedParam.x;
      _510 = fOptimizedParam.y;
      _511 = fOptimizedParam.z;
      _512 = fOptimizedParam.w;
      _513 = 1.0f;
    } else {
      float4 _413 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _417 = _413.x * _70;
      float _418 = _413.y * _70;
      float _419 = _413.z * _70;
      float _420 = invLinearBegin * _417;
      float _426 = invLinearBegin * _418;
      float _432 = invLinearBegin * _419;
      float _439 = select((_417 >= linearBegin), 0.0f, (1.0f - ((_420 * _420) * (3.0f - (_420 * 2.0f)))));
      float _441 = select((_418 >= linearBegin), 0.0f, (1.0f - ((_426 * _426) * (3.0f - (_426 * 2.0f)))));
      float _443 = select((_419 >= linearBegin), 0.0f, (1.0f - ((_432 * _432) * (3.0f - (_432 * 2.0f)))));
      float _447 = select((_417 < linear_start), 0.0f, 1.0f);
      float _448 = select((_418 < linear_start), 0.0f, 1.0f);
      float _449 = select((_419 < linear_start), 0.0f, 1.0f);
      _505 = (((((tonemap_highlight_contrast * _417) + madlinear_startContrastFactor) * ((1.0f - _447) - _439)) + (((pow(_420, tonemap_toe)) * _439) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _417) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _447));
      _506 = (((((tonemap_highlight_contrast * _418) + madlinear_startContrastFactor) * ((1.0f - _448) - _441)) + (((pow(_426, tonemap_toe)) * _441) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _418) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _448));
      _507 = (((((tonemap_highlight_contrast * _419) + madlinear_startContrastFactor) * ((1.0f - _449) - _443)) + (((pow(_432, tonemap_toe)) * _443) * linearBegin)) + ((max_nit - (exp2((contrastFactor * _419) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _449));
      _508 = 0.0f;
      _509 = 0.0f;
      _510 = 0.0f;
      _511 = 0.0f;
      _512 = 0.0f;
      _513 = 1.0f;
    }
  }
  if (!(((uint)(cPassEnabled) & 32) == 0)) {
    float _535 = float((bool)(bool)(((uint)(cbRadialBlurFlags) & 2) != 0));
    float _539 = ComputeResultSRV[0].computeAlpha;
    float _542 = ((1.0f - _535) + (_539 * _535)) * cbRadialColor.w;
    if (!(_542 == 0.0f)) {
      float _550 = screenInverseSize.x * SV_Position.x;
      float _551 = screenInverseSize.y * SV_Position.y;
      float _553 = (-0.5f - cbRadialScreenPos.x) + _550;
      float _555 = (-0.5f - cbRadialScreenPos.y) + _551;
      float _558 = select((_553 < 0.0f), (1.0f - _550), _550);
      float _561 = select((_555 < 0.0f), (1.0f - _551), _551);
      float _566 = rsqrt(dot(float2(_553, _555), float2(_553, _555))) * cbRadialSharpRange;
      uint _573 = uint(abs(_566 * _555)) + uint(abs(_566 * _553));
      uint _577 = ((_573 ^ 61) ^ ((uint)(_573) >> 16)) * 9;
      uint _580 = (((uint)(_577) >> 4) ^ _577) * 668265261;
      float _585 = select((((uint)(cbRadialBlurFlags) & 1) != 0), (float((uint)((int)(((uint)(_580) >> 15) ^ _580))) * 2.3283064365386963e-10f), 1.0f);
      float _591 = 1.0f / max(1.0f, sqrt((_553 * _553) + (_555 * _555)));
      float _592 = cbRadialBlurPower * -0.004999999888241291f;
      float _601 = ((((_592 * _558) * _585) * _591) + 1.0f) * _553;
      float _602 = ((((_592 * _561) * _585) * _591) + 1.0f) * _555;
      float _604 = cbRadialBlurPower * -0.009999999776482582f;
      float _613 = ((((_604 * _558) * _585) * _591) + 1.0f) * _553;
      float _614 = ((((_604 * _561) * _585) * _591) + 1.0f) * _555;
      float _615 = (_69 * Exposure) * 0.3333333432674408f;
      float _616 = _615 * cbRadialColor.x;
      float _617 = _615 * cbRadialColor.y;
      float _618 = _615 * cbRadialColor.z;
      float _633 = (_505 * 0.3333333432674408f) * cbRadialColor.x;
      float _635 = (_506 * 0.3333333432674408f) * cbRadialColor.y;
      float _637 = (_507 * 0.3333333432674408f) * cbRadialColor.z;
      if (_47) {
        float _639 = _601 + cbRadialScreenPos.x;
        float _640 = _602 + cbRadialScreenPos.y;
        float _644 = ((dot(float2(_639, _640), float2(_639, _640)) * _508) + 1.0f) * _513;
        float4 _650 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_644 * _639) + 0.5f), ((_644 * _640) + 0.5f)), 0.0f);
        float _654 = _613 + cbRadialScreenPos.x;
        float _655 = _614 + cbRadialScreenPos.y;
        float _658 = (dot(float2(_654, _655), float2(_654, _655)) * _508) + 1.0f;
        float4 _665 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_654 * _513) * _658) + 0.5f), (((_655 * _513) * _658) + 0.5f)), 0.0f);
        float _672 = _616 * (_665.x + _650.x);
        float _673 = _617 * (_665.y + _650.y);
        float _674 = _618 * (_665.z + _650.z);
        float _675 = _672 * invLinearBegin;
        float _681 = _673 * invLinearBegin;
        float _687 = _674 * invLinearBegin;
        float _694 = select((_672 >= linearBegin), 0.0f, (1.0f - ((_675 * _675) * (3.0f - (_675 * 2.0f)))));
        float _696 = select((_673 >= linearBegin), 0.0f, (1.0f - ((_681 * _681) * (3.0f - (_681 * 2.0f)))));
        float _698 = select((_674 >= linearBegin), 0.0f, (1.0f - ((_687 * _687) * (3.0f - (_687 * 2.0f)))));
        float _702 = select((_672 < linear_start), 0.0f, 1.0f);
        float _703 = select((_673 < linear_start), 0.0f, 1.0f);
        float _704 = select((_674 < linear_start), 0.0f, 1.0f);
        _1019 = (((((_694 * (pow(_675, tonemap_toe))) * linearBegin) + _633) + (((tonemap_highlight_contrast * _672) + madlinear_startContrastFactor) * ((1.0f - _702) - _694))) + ((max_nit - (exp2((contrastFactor * _672) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _702));
        _1020 = ((((((pow(_681, tonemap_toe)) * _696) * linearBegin) + _635) + (((tonemap_highlight_contrast * _673) + madlinear_startContrastFactor) * ((1.0f - _703) - _696))) + ((max_nit - (exp2((contrastFactor * _673) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _703));
        _1021 = ((((((pow(_687, tonemap_toe)) * _698) * linearBegin) + _637) + (((tonemap_highlight_contrast * _674) + madlinear_startContrastFactor) * ((1.0f - _704) - _698))) + ((max_nit - (exp2((contrastFactor * _674) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _704));
      } else {
        float _763 = cbRadialScreenPos.x + 0.5f;
        float _764 = _763 + _601;
        float _765 = cbRadialScreenPos.y + 0.5f;
        float _766 = _765 + _602;
        float _767 = _763 + _613;
        float _768 = _765 + _614;
        if (_49) {
          float _772 = (_764 * 2.0f) + -1.0f;
          float _776 = sqrt((_772 * _772) + 1.0f);
          float _777 = 1.0f / _776;
          float _780 = (_776 * _511) * (_777 + _509);
          float _784 = _512 * 0.5f;
          float4 _793 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_784 * _780) * _772) + 0.5f), ((((_784 * (((_777 + -1.0f) * _510) + 1.0f)) * _780) * ((_766 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
          float _799 = (_767 * 2.0f) + -1.0f;
          float _803 = sqrt((_799 * _799) + 1.0f);
          float _804 = 1.0f / _803;
          float _807 = (_803 * _511) * (_804 + _509);
          float4 _818 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_784 * _799) * _807) + 0.5f), ((((_784 * ((_768 * 2.0f) + -1.0f)) * (((_804 + -1.0f) * _510) + 1.0f)) * _807) + 0.5f)), 0.0f);
          float _825 = _616 * (_818.x + _793.x);
          float _826 = _617 * (_818.y + _793.y);
          float _827 = _618 * (_818.z + _793.z);
          float _828 = _825 * invLinearBegin;
          float _834 = _826 * invLinearBegin;
          float _840 = _827 * invLinearBegin;
          float _847 = select((_825 >= linearBegin), 0.0f, (1.0f - ((_828 * _828) * (3.0f - (_828 * 2.0f)))));
          float _849 = select((_826 >= linearBegin), 0.0f, (1.0f - ((_834 * _834) * (3.0f - (_834 * 2.0f)))));
          float _851 = select((_827 >= linearBegin), 0.0f, (1.0f - ((_840 * _840) * (3.0f - (_840 * 2.0f)))));
          float _855 = select((_825 < linear_start), 0.0f, 1.0f);
          float _856 = select((_826 < linear_start), 0.0f, 1.0f);
          float _857 = select((_827 < linear_start), 0.0f, 1.0f);
          _1019 = (((((_847 * (pow(_828, tonemap_toe))) * linearBegin) + _633) + (((tonemap_highlight_contrast * _825) + madlinear_startContrastFactor) * ((1.0f - _855) - _847))) + ((max_nit - (exp2((contrastFactor * _825) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _855));
          _1020 = ((((((pow(_834, tonemap_toe)) * _849) * linearBegin) + _635) + (((tonemap_highlight_contrast * _826) + madlinear_startContrastFactor) * ((1.0f - _856) - _849))) + ((max_nit - (exp2((contrastFactor * _826) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _856));
          _1021 = ((((((pow(_840, tonemap_toe)) * _851) * linearBegin) + _637) + (((tonemap_highlight_contrast * _827) + madlinear_startContrastFactor) * ((1.0f - _857) - _851))) + ((max_nit - (exp2((contrastFactor * _827) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _857));
        } else {
          float4 _917 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_764, _766), 0.0f);
          float4 _921 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_767, _768), 0.0f);
          float _928 = _616 * (_921.x + _917.x);
          float _929 = _617 * (_921.y + _917.y);
          float _930 = _618 * (_921.z + _917.z);
          float _931 = _928 * invLinearBegin;
          float _937 = _929 * invLinearBegin;
          float _943 = _930 * invLinearBegin;
          float _950 = select((_928 >= linearBegin), 0.0f, (1.0f - ((_931 * _931) * (3.0f - (_931 * 2.0f)))));
          float _952 = select((_929 >= linearBegin), 0.0f, (1.0f - ((_937 * _937) * (3.0f - (_937 * 2.0f)))));
          float _954 = select((_930 >= linearBegin), 0.0f, (1.0f - ((_943 * _943) * (3.0f - (_943 * 2.0f)))));
          float _958 = select((_928 < linear_start), 0.0f, 1.0f);
          float _959 = select((_929 < linear_start), 0.0f, 1.0f);
          float _960 = select((_930 < linear_start), 0.0f, 1.0f);
          _1019 = (((((_950 * (pow(_931, tonemap_toe))) * linearBegin) + _633) + (((tonemap_highlight_contrast * _928) + madlinear_startContrastFactor) * ((1.0f - _958) - _950))) + ((max_nit - (exp2((contrastFactor * _928) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _958));
          _1020 = ((((((pow(_937, tonemap_toe)) * _952) * linearBegin) + _635) + (((tonemap_highlight_contrast * _929) + madlinear_startContrastFactor) * ((1.0f - _959) - _952))) + ((max_nit - (exp2((contrastFactor * _929) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _959));
          _1021 = ((((((pow(_943, tonemap_toe)) * _954) * linearBegin) + _637) + (((tonemap_highlight_contrast * _930) + madlinear_startContrastFactor) * ((1.0f - _960) - _954))) + ((max_nit - (exp2((contrastFactor * _930) + mullinear_startContrastFactor) * displaymax_nitSubContrastFactor)) * _960));
        }
      }
      if (cbRadialMaskRate.x > 0.0f) {
        float _1030 = saturate((sqrt((_553 * _553) + (_555 * _555)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _1036 = (((_1030 * _1030) * cbRadialMaskRate.x) * (3.0f - (_1030 * 2.0f))) + cbRadialMaskRate.y;
        _1047 = ((_1036 * (_1019 - _505)) + _505);
        _1048 = ((_1036 * (_1020 - _506)) + _506);
        _1049 = ((_1036 * (_1021 - _507)) + _507);
      } else {
        _1047 = _1019;
        _1048 = _1020;
        _1049 = _1021;
      }
      _1060 = (lerp(_505, _1047, _542));
      _1061 = (lerp(_506, _1048, _542));
      _1062 = (lerp(_507, _1049, _542));
    } else {
      _1060 = _505;
      _1061 = _506;
      _1062 = _507;
    }
  } else {
    _1060 = _505;
    _1061 = _506;
    _1062 = _507;
  }
  // if (!(((uint)(cPassEnabled) & 2) == 0)) {
  //   float _1084 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
  //   float _1086 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
  //   float _1090 = frac(frac(dot(float2(_1084, _1086), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
  //   if (_1090 < fNoiseDensity) {
  //     int _1095 = (uint)(uint(_1086 * _1084)) ^ 12345391;
  //     uint _1096 = _1095 * 3635641;
  //     _1104 = (float((uint)((int)((((uint)(_1096) >> 26) | ((uint)(_1095 * 232681024))) ^ _1096))) * 2.3283064365386963e-10f);
  //   } else {
  //     _1104 = 0.0f;
  //   }
  //   float _1106 = frac(_1090 * 757.4846801757812f);
  //   if (_1106 < fNoiseDensity) {
  //     int _1110 = asint(_1106) ^ 12345391;
  //     uint _1111 = _1110 * 3635641;
  //     _1120 = ((float((uint)((int)((((uint)(_1111) >> 26) | ((uint)(_1110 * 232681024))) ^ _1111))) * 2.3283064365386963e-10f) + -0.5f);
  //   } else {
  //     _1120 = 0.0f;
  //   }
  //   float _1122 = frac(_1106 * 757.4846801757812f);
  //   if (_1122 < fNoiseDensity) {
  //     int _1126 = asint(_1122) ^ 12345391;
  //     uint _1127 = _1126 * 3635641;
  //     _1136 = ((float((uint)((int)((((uint)(_1127) >> 26) | ((uint)(_1126 * 232681024))) ^ _1127))) * 2.3283064365386963e-10f) + -0.5f);
  //   } else {
  //     _1136 = 0.0f;
  //   }
  //   float _1137 = _1104 * fNoisePower.x;
  //   float _1138 = _1136 * fNoisePower.y;
  //   float _1139 = _1120 * fNoisePower.y;
  //   float _1150 = exp2(log2(1.0f - saturate(dot(float3(_1060, _1061, _1062), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
  //   _1161 = ((_1150 * (mad(_1139, 1.4019999504089355f, _1137) - _1060)) + _1060);
  //   _1162 = ((_1150 * (mad(_1139, -0.7139999866485596f, mad(_1138, -0.3440000116825104f, _1137)) - _1061)) + _1061);
  //   _1163 = ((_1150 * (mad(_1138, 1.7719999551773071f, _1137) - _1062)) + _1062);
  // } else {
    _1161 = _1060;
    _1162 = _1061;
    _1163 = _1062;
  // }
  if (!(((uint)(cPassEnabled) & 4) == 0)) {
    if (TONE_MAP_TYPE != 0) {

      untonemapped = float3(_1161, _1162, _1163);
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

      float _1365_v = mad(blendedLutColor.z, (fColorMatrix[2].x), mad(blendedLutColor.y, (fColorMatrix[1].x), (blendedLutColor.x * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
      float _1369_v = mad(blendedLutColor.z, (fColorMatrix[2].y), mad(blendedLutColor.y, (fColorMatrix[1].y), (blendedLutColor.x * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
      float _1373_v = mad(blendedLutColor.z, (fColorMatrix[2].z), mad(blendedLutColor.y, (fColorMatrix[1].z), (blendedLutColor.x * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);


      float3 postprocessColor = float3(_1365_v, _1369_v, _1373_v);
      // float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
      float3 upgradedColor = postprocessColor / lut_scale;

      _1379 = upgradedColor.r;
      _1380 = upgradedColor.g;
      _1381 = upgradedColor.b;
    } else {
      float _1188 = max(max(_1161, _1162), _1163);
      bool _1189 = (_1188 > 1.0f);
      if (_1189) {
        _1195 = (_1161 / _1188);
        _1196 = (_1162 / _1188);
        _1197 = (_1163 / _1188);
      } else {
        _1195 = _1161;
        _1196 = _1162;
        _1197 = _1163;
      }
      float _1198 = fTextureInverseSize * 0.5f;
      [branch]
      if (!(!(_1195 <= 0.0031308000907301903f))) {
        _1209 = (_1195 * 12.920000076293945f);
      } else {
        _1209 = (((pow(_1195, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      [branch]
      if (!(!(_1196 <= 0.0031308000907301903f))) {
        _1220 = (_1196 * 12.920000076293945f);
      } else {
        _1220 = (((pow(_1196, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      [branch]
      if (!(!(_1197 <= 0.0031308000907301903f))) {
        _1231 = (_1197 * 12.920000076293945f);
      } else {
        _1231 = (((pow(_1197, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      float _1232 = 1.0f - fTextureInverseSize;
      float _1236 = (_1209 * _1232) + _1198;
      float _1237 = (_1220 * _1232) + _1198;
      float _1238 = (_1231 * _1232) + _1198;
      float4 _1241 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1236, _1237, _1238), 0.0f);
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1248 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1236, _1237, _1238), 0.0f);
        float _1258 = ((_1248.x - _1241.x) * fTextureBlendRate) + _1241.x;
        float _1259 = ((_1248.y - _1241.y) * fTextureBlendRate) + _1241.y;
        float _1260 = ((_1248.z - _1241.z) * fTextureBlendRate) + _1241.z;
        if (fTextureBlendRate2 > 0.0f) {
          [branch]
          if (!(!(_1258 <= 0.0031308000907301903f))) {
            _1273 = (_1258 * 12.920000076293945f);
          } else {
            _1273 = (((pow(_1258, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          [branch]
          if (!(!(_1259 <= 0.0031308000907301903f))) {
            _1284 = (_1259 * 12.920000076293945f);
          } else {
            _1284 = (((pow(_1259, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          [branch]
          if (!(!(_1260 <= 0.0031308000907301903f))) {
            _1295 = (_1260 * 12.920000076293945f);
          } else {
            _1295 = (((pow(_1260, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          float4 _1297 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1273, _1284, _1295), 0.0f);
          _1359 = (lerp(_1258, _1297.x, fTextureBlendRate2));
          _1360 = (lerp(_1259, _1297.y, fTextureBlendRate2));
          _1361 = (lerp(_1260, _1297.z, fTextureBlendRate2));
        } else {
          _1359 = _1258;
          _1360 = _1259;
          _1361 = _1260;
        }
      } else {
        [branch]
        if (!(!(_1241.x <= 0.0031308000907301903f))) {
          _1321 = (_1241.x * 12.920000076293945f);
        } else {
          _1321 = (((pow(_1241.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_1241.y <= 0.0031308000907301903f))) {
          _1332 = (_1241.y * 12.920000076293945f);
        } else {
          _1332 = (((pow(_1241.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_1241.z <= 0.0031308000907301903f))) {
          _1343 = (_1241.z * 12.920000076293945f);
        } else {
          _1343 = (((pow(_1241.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _1345 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1321, _1332, _1343), 0.0f);
        _1359 = (lerp(_1241.x, _1345.x, fTextureBlendRate2));
        _1360 = (lerp(_1241.y, _1345.y, fTextureBlendRate2));
        _1361 = (lerp(_1241.z, _1345.z, fTextureBlendRate2));
      }
      float _1365_v = mad(_1361, (fColorMatrix[2].x), mad(_1360, (fColorMatrix[1].x), (_1359 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
      float _1369_v = mad(_1361, (fColorMatrix[2].y), mad(_1360, (fColorMatrix[1].y), (_1359 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
      float _1373_v = mad(_1361, (fColorMatrix[2].z), mad(_1360, (fColorMatrix[1].z), (_1359 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
      if (_1189) {
        _1379 = (_1365_v * _1188);
        _1380 = (_1369_v * _1188);
        _1381 = (_1373_v * _1188);
      } else {
        _1379 = _1365_v;
        _1380 = _1369_v;
        _1381 = _1373_v;
      }
    }
  } else {
    _1379 = _1161;
    _1380 = _1162;
    _1381 = _1163;
  }
  if (!(((uint)(cPassEnabled) & 8) == 0)) {
    _1416 = saturate(((cvdR.x * _1379) + (cvdR.y * _1380)) + (cvdR.z * _1381));
    _1417 = saturate(((cvdG.x * _1379) + (cvdG.y * _1380)) + (cvdG.z * _1381));
    _1418 = saturate(((cvdB.x * _1379) + (cvdB.y * _1380)) + (cvdB.z * _1381));
  } else {
    _1416 = _1379;
    _1417 = _1380;
    _1418 = _1381;
  }
  if (!(((uint)(cPassEnabled) & 16) == 0)) {
    float _1433 = screenInverseSize.x * SV_Position.x;
    float _1434 = screenInverseSize.y * SV_Position.y;
    float4 _1437 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1433, _1434), 0.0f);
    float _1442 = _1437.x * ColorParam.x;
    float _1443 = _1437.y * ColorParam.y;
    float _1444 = _1437.z * ColorParam.z;
    float _1447 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1433, _1434), 0.0f);
    float _1452 = (_1437.w * ColorParam.w) * saturate((_1447.x * Levels_Rate) + Levels_Range);
    _1490 = (((select((_1442 < 0.5f), ((_1416 * 2.0f) * _1442), (1.0f - (((1.0f - _1416) * 2.0f) * (1.0f - _1442)))) - _1416) * _1452) + _1416);
    _1491 = (((select((_1443 < 0.5f), ((_1417 * 2.0f) * _1443), (1.0f - (((1.0f - _1417) * 2.0f) * (1.0f - _1443)))) - _1417) * _1452) + _1417);
    _1492 = (((select((_1444 < 0.5f), ((_1418 * 2.0f) * _1444), (1.0f - (((1.0f - _1418) * 2.0f) * (1.0f - _1444)))) - _1418) * _1452) + _1418);
  } else {
    _1490 = _1416;
    _1491 = _1417;
    _1492 = _1418;
  }
  SV_Target.x = _1490;
  SV_Target.y = _1491;
  SV_Target.z = _1492;
  SV_Target.w = 0.0f;
  if (TONE_MAP_TYPE != 0.f) {
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb);
  } 
  return SV_Target;
}
