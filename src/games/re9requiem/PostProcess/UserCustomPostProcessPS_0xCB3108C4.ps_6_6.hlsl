#include "./PostProcess.hlsli"

Texture2D<float4> RE_POSTPROCESS_Input0 : register(t0);

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
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
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
  float tonemapParam_isHDRMode : packoffset(c002.w);
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

cbuffer LDRPostProcessParam : register(b2) {
  float fHazeFilterStart : packoffset(c000.x);
  float fHazeFilterInverseRange : packoffset(c000.y);
  float fHazeFilterHeightStart : packoffset(c000.z);
  float fHazeFilterHeightInverseRange : packoffset(c000.w);
  float4 fHazeFilterUVWOffset : packoffset(c001.x);
  float fHazeFilterScale : packoffset(c002.x);
  float fHazeFilterBorder : packoffset(c002.y);
  float fHazeFilterBorderFade : packoffset(c002.z);
  float fHazeFilterDepthDiffBias : packoffset(c002.w);
  uint fHazeFilterAttribute : packoffset(c003.x);
  uint fHazeFilterReductionResolution : packoffset(c003.y);
  uint fHazeFilterReserved1 : packoffset(c003.z);
  uint fHazeFilterReserved2 : packoffset(c003.w);
  float fDistortionCoef : packoffset(c004.x);
  float fRefraction : packoffset(c004.y);
  float fRefractionCenterRate : packoffset(c004.z);
  float fGradationStartOffset : packoffset(c004.w);
  float fGradationEndOffset : packoffset(c005.x);
  uint aberrationEnable : packoffset(c005.y);
  uint distortionType : packoffset(c005.z);
  float fCorrectCoef : packoffset(c005.w);
  uint aberrationBlurEnable : packoffset(c006.x);
  float fBlurNoisePower : packoffset(c006.y);
  float2 LensDistortion_Reserve : packoffset(c006.z);
  float4 fOptimizedParam : packoffset(c007.x);
  float2 fNoisePower : packoffset(c008.x);
  float2 fNoiseUVOffset : packoffset(c008.z);
  float fNoiseDensity : packoffset(c009.x);
  float fNoiseContrast : packoffset(c009.y);
  float fBlendRate : packoffset(c009.z);
  float fReverseNoiseSize : packoffset(c009.w);
  float fTextureSize : packoffset(c010.x);
  float fTextureBlendRate : packoffset(c010.y);
  float fTextureBlendRate2 : packoffset(c010.z);
  float fTextureInverseSize : packoffset(c010.w);
  float fHalfTextureInverseSize : packoffset(c011.x);
  float fOneMinusTextureInverseSize : packoffset(c011.y);
  float fColorCorrectTextureReserve : packoffset(c011.z);
  float fColorCorrectTextureReserve2 : packoffset(c011.w);
  row_major float4x4 fColorMatrix : packoffset(c012.x);
  float4 cvdR : packoffset(c016.x);
  float4 cvdG : packoffset(c017.x);
  float4 cvdB : packoffset(c018.x);
  float4 ColorParam : packoffset(c019.x);
  float Levels_Rate : packoffset(c020.x);
  float Levels_Range : packoffset(c020.y);
  uint Blend_Type : packoffset(c020.z);
  float ImagePlane_Reserve : packoffset(c020.w);
  float4 cbRadialColor : packoffset(c021.x);
  float2 cbRadialScreenPos : packoffset(c022.x);
  float2 cbRadialMaskSmoothstep : packoffset(c022.z);
  float2 cbRadialMaskRate : packoffset(c023.x);
  float cbRadialBlurPower : packoffset(c023.z);
  float cbRadialSharpRange : packoffset(c023.w);
  uint cbRadialBlurFlags : packoffset(c024.x);
  float cbRadialReserve0 : packoffset(c024.y);
  float cbRadialReserve1 : packoffset(c024.z);
  float cbRadialReserve2 : packoffset(c024.w);
};

cbuffer CBControl : register(b3) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  struct RGCParam {
    float CyanLimit;
    float MagentaLimit;
    float YellowLimit;
    float CyanThreshold;
    float MagentaThreshold;
    float YellowThreshold;
    float RollOff;
    uint EnableReferenceGamutCompress;
    float InvCyanSTerm;
    float InvMagentaSTerm;
    float InvYellowSTerm;
    float InvRollOff;
  } cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b4) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
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
  uint _55 = uint(float((uint)(int)(distortionType)));
  bool _60 = (LDRPPSettings_enabled != 0);
  bool _61 = ((cPassEnabled & 1) != 0);
  float _321;
  float _322;
  float _323;
  float _413;
  float _968;
  float _969;
  float _970;
  float _1004;
  float _1005;
  float _1006;
  float _1017;
  float _1018;
  float _1019;
  float _1049;
  float _1065;
  float _1081;
  float _1109;
  float _1110;
  float _1111;
  float _1169;
  float _1190;
  float _1210;
  float _1218;
  float _1219;
  float _1220;
  float _1431;
  float _1432;
  float _1433;
  float _1447;
  float _1448;
  float _1449;
  float _1482;
  float _1483;
  float _1484;
  float _1534;
  float _1546;
  float _1558;
  float _1569;
  float _1570;
  float _1571;
  float _1632;
  float _1665;
  float _1676;
  float _1687;
  float _1688;
  float _1689;
  if (!(_61 && _60)) {
    float4 _71 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _321 = (min(_71.x, 65000.0f) * Exposure);
    _322 = (min(_71.y, 65000.0f) * Exposure);
    _323 = (min(_71.z, 65000.0f) * Exposure);
  } else {
    if (_55 == 0) {
      float _89 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _90 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _91 = dot(float2(_89, _90), float2(_89, _90));
      float _93 = (_91 * fDistortionCoef) + 1.0f;
      float _94 = _89 * fCorrectCoef;
      float _96 = _90 * fCorrectCoef;
      float _98 = (_94 * _93) + 0.5f;
      float _99 = (_96 * _93) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _104 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_98, _99));
        _321 = (_104.x * Exposure);
        _322 = (_104.y * Exposure);
        _323 = (_104.z * Exposure);
      } else {
        float _123 = ((saturate((sqrt((_89 * _89) + (_90 * _90)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _133 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _134 = _123 * 2.0f;
          float _138 = (((_133 * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _143 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_138 * _94) + 0.5f), ((_138 * _96) + 0.5f)));
          float _149 = ((((_133 + 0.125f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _154 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_149 * _94) + 0.5f), ((_149 * _96) + 0.5f)));
          float _161 = ((((_133 + 0.25f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _166 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_161 * _94) + 0.5f), ((_161 * _96) + 0.5f)));
          float _175 = ((((_133 + 0.375f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _180 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_175 * _94) + 0.5f), ((_175 * _96) + 0.5f)));
          float _189 = ((((_133 + 0.5f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _194 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_189 * _94) + 0.5f), ((_189 * _96) + 0.5f)));
          float _200 = ((((_133 + 0.625f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _205 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_200 * _94) + 0.5f), ((_200 * _96) + 0.5f)));
          float _213 = ((((_133 + 0.75f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _218 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_213 * _94) + 0.5f), ((_213 * _96) + 0.5f)));
          float _233 = ((((_133 + 0.875f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _238 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_233 * _94) + 0.5f), ((_233 * _96) + 0.5f)));
          float _245 = ((((_133 + 1.0f) * _134) + _91) * fDistortionCoef) + 1.0f;
          float4 _250 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_245 * _94) + 0.5f), ((_245 * _96) + 0.5f)));
          float _253 = Exposure * 0.3199999928474426f;
          _321 = ((((_154.x + _143.x) + (_166.x * 0.75f)) + (_180.x * 0.375f)) * _253);
          _322 = ((Exposure * 0.3636363744735718f) * ((((_205.y + _180.y) * 0.625f) + _194.y) + ((_218.y + _166.y) * 0.25f)));
          _323 = (((((_218.z * 0.75f) + (_205.z * 0.375f)) + _238.z) + _250.z) * _253);
        } else {
          float _259 = _123 + _91;
          float _261 = (_259 * fDistortionCoef) + 1.0f;
          float _268 = ((_259 + _123) * fDistortionCoef) + 1.0f;
          float4 _273 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_98, _99));
          float4 _276 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_261 * _94) + 0.5f), ((_261 * _96) + 0.5f)));
          float4 _279 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_268 * _94) + 0.5f), ((_268 * _96) + 0.5f)));
          _321 = (_273.x * Exposure);
          _322 = (_276.y * Exposure);
          _323 = (_279.z * Exposure);
        }
      }
    } else {
      if (_55 == 1) {
        float _292 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _296 = sqrt((_292 * _292) + 1.0f);
        float _297 = 1.0f / _296;
        float _305 = ((_296 * fOptimizedParam.z) * (_297 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _313 = RE_POSTPROCESS_Input0.Sample(BilinearBorder, float2(((_305 * _292) + 0.5f), (((_305 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_297 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _321 = (_313.x * Exposure);
        _322 = (_313.y * Exposure);
        _323 = (_313.z * Exposure);
      } else {
        _321 = 0.0f;
        _322 = 0.0f;
        _323 = 0.0f;
      }
    }
  }
  if (_60 && (bool)((cPassEnabled & 32) != 0)) {
    float _363 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _367 = ComputeResultSRV[0].computeAlpha;
    float _370 = ((1.0f - _363) + (_367 * _363)) * cbRadialColor.w;
    if (!(_370 == 0.0f)) {
      float _376 = screenInverseSize.x * SV_Position.x;
      float _377 = screenInverseSize.y * SV_Position.y;
      float _379 = _376 + (-0.5f - cbRadialScreenPos.x);
      float _381 = _377 + (-0.5f - cbRadialScreenPos.y);
      float _384 = select((_379 < 0.0f), (1.0f - _376), _376);
      float _387 = select((_381 < 0.0f), (1.0f - _377), _377);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _393 = rsqrt(dot(float2(_379, _381), float2(_379, _381))) * cbRadialSharpRange;
          uint _400 = uint(abs(_393 * _381)) + uint(abs(_393 * _379));
          uint _404 = ((_400 ^ 61) ^ ((uint)(_400) >> 16)) * 9;
          uint _407 = (((uint)(_404) >> 4) ^ _404) * 668265261;
          _413 = (float((uint)((int)(((uint)(_407) >> 15) ^ _407))) * 2.3283064365386963e-10f);
        } else {
          _413 = 1.0f;
        }
        float _417 = sqrt((_379 * _379) + (_381 * _381));
        float _419 = 1.0f / max(1.0f, _417);
        float _420 = _413 * _384;
        float _421 = cbRadialBlurPower * _419;
        float _422 = _421 * -0.0011111111380159855f;
        float _424 = _413 * _387;
        float _428 = ((_422 * _420) + 1.0f) * _379;
        float _429 = ((_422 * _424) + 1.0f) * _381;
        float _431 = _421 * -0.002222222276031971f;
        float _436 = ((_431 * _420) + 1.0f) * _379;
        float _437 = ((_431 * _424) + 1.0f) * _381;
        float _438 = _421 * -0.0033333334140479565f;
        float _443 = ((_438 * _420) + 1.0f) * _379;
        float _444 = ((_438 * _424) + 1.0f) * _381;
        float _445 = _421 * -0.004444444552063942f;
        float _450 = ((_445 * _420) + 1.0f) * _379;
        float _451 = ((_445 * _424) + 1.0f) * _381;
        float _452 = _421 * -0.0055555556900799274f;
        float _457 = ((_452 * _420) + 1.0f) * _379;
        float _458 = ((_452 * _424) + 1.0f) * _381;
        float _459 = _421 * -0.006666666828095913f;
        float _464 = ((_459 * _420) + 1.0f) * _379;
        float _465 = ((_459 * _424) + 1.0f) * _381;
        float _466 = _421 * -0.007777777966111898f;
        float _471 = ((_466 * _420) + 1.0f) * _379;
        float _472 = ((_466 * _424) + 1.0f) * _381;
        float _473 = _421 * -0.008888889104127884f;
        float _478 = ((_473 * _420) + 1.0f) * _379;
        float _479 = ((_473 * _424) + 1.0f) * _381;
        float _482 = _419 * ((cbRadialBlurPower * -0.009999999776482582f) * _413);
        float _487 = ((_482 * _384) + 1.0f) * _379;
        float _488 = ((_482 * _387) + 1.0f) * _381;
        do {
          if (_61 && (bool)(_55 == 0)) {
            float _490 = _428 + cbRadialScreenPos.x;
            float _491 = _429 + cbRadialScreenPos.y;
            float _495 = ((dot(float2(_490, _491), float2(_490, _491)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _501 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_495 * _490) + 0.5f), ((_495 * _491) + 0.5f)), 0.0f);
            float _505 = _436 + cbRadialScreenPos.x;
            float _506 = _437 + cbRadialScreenPos.y;
            float _510 = ((dot(float2(_505, _506), float2(_505, _506)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _515 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_510 * _505) + 0.5f), ((_510 * _506) + 0.5f)), 0.0f);
            float _522 = _443 + cbRadialScreenPos.x;
            float _523 = _444 + cbRadialScreenPos.y;
            float _527 = ((dot(float2(_522, _523), float2(_522, _523)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _532 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_527 * _522) + 0.5f), ((_527 * _523) + 0.5f)), 0.0f);
            float _539 = _450 + cbRadialScreenPos.x;
            float _540 = _451 + cbRadialScreenPos.y;
            float _544 = ((dot(float2(_539, _540), float2(_539, _540)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _549 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_544 * _539) + 0.5f), ((_544 * _540) + 0.5f)), 0.0f);
            float _556 = _457 + cbRadialScreenPos.x;
            float _557 = _458 + cbRadialScreenPos.y;
            float _561 = ((dot(float2(_556, _557), float2(_556, _557)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _566 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_561 * _556) + 0.5f), ((_561 * _557) + 0.5f)), 0.0f);
            float _573 = _464 + cbRadialScreenPos.x;
            float _574 = _465 + cbRadialScreenPos.y;
            float _578 = ((dot(float2(_573, _574), float2(_573, _574)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _583 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_578 * _573) + 0.5f), ((_578 * _574) + 0.5f)), 0.0f);
            float _590 = _471 + cbRadialScreenPos.x;
            float _591 = _472 + cbRadialScreenPos.y;
            float _595 = ((dot(float2(_590, _591), float2(_590, _591)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _600 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_595 * _590) + 0.5f), ((_595 * _591) + 0.5f)), 0.0f);
            float _607 = _478 + cbRadialScreenPos.x;
            float _608 = _479 + cbRadialScreenPos.y;
            float _612 = ((dot(float2(_607, _608), float2(_607, _608)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _617 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_612 * _607) + 0.5f), ((_612 * _608) + 0.5f)), 0.0f);
            float _624 = _487 + cbRadialScreenPos.x;
            float _625 = _488 + cbRadialScreenPos.y;
            float _629 = ((dot(float2(_624, _625), float2(_624, _625)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _634 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_629 * _624) + 0.5f), ((_629 * _625) + 0.5f)), 0.0f);
            _968 = ((((((((_515.x + _501.x) + _532.x) + _549.x) + _566.x) + _583.x) + _600.x) + _617.x) + _634.x);
            _969 = ((((((((_515.y + _501.y) + _532.y) + _549.y) + _566.y) + _583.y) + _600.y) + _617.y) + _634.y);
            _970 = ((((((((_515.z + _501.z) + _532.z) + _549.z) + _566.z) + _583.z) + _600.z) + _617.z) + _634.z);
          } else {
            float _642 = cbRadialScreenPos.x + 0.5f;
            float _643 = _428 + _642;
            float _644 = cbRadialScreenPos.y + 0.5f;
            float _645 = _429 + _644;
            float _646 = _436 + _642;
            float _647 = _437 + _644;
            float _648 = _443 + _642;
            float _649 = _444 + _644;
            float _650 = _450 + _642;
            float _651 = _451 + _644;
            float _652 = _457 + _642;
            float _653 = _458 + _644;
            float _654 = _464 + _642;
            float _655 = _465 + _644;
            float _656 = _471 + _642;
            float _657 = _472 + _644;
            float _658 = _478 + _642;
            float _659 = _479 + _644;
            float _660 = _487 + _642;
            float _661 = _488 + _644;
            if (_61 && (bool)(_55 == 1)) {
              float _665 = (_643 * 2.0f) + -1.0f;
              float _669 = sqrt((_665 * _665) + 1.0f);
              float _670 = 1.0f / _669;
              float _677 = fOptimizedParam.w * 0.5f;
              float _678 = ((_669 * fOptimizedParam.z) * (_670 + fOptimizedParam.x)) * _677;
              float4 _685 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_678 * _665) + 0.5f), (((_678 * ((_645 * 2.0f) + -1.0f)) * (((_670 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _691 = (_646 * 2.0f) + -1.0f;
              float _695 = sqrt((_691 * _691) + 1.0f);
              float _696 = 1.0f / _695;
              float _703 = ((_695 * fOptimizedParam.z) * (_696 + fOptimizedParam.x)) * _677;
              float4 _709 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_703 * _691) + 0.5f), (((_703 * ((_647 * 2.0f) + -1.0f)) * (((_696 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _718 = (_648 * 2.0f) + -1.0f;
              float _722 = sqrt((_718 * _718) + 1.0f);
              float _723 = 1.0f / _722;
              float _730 = ((_722 * fOptimizedParam.z) * (_723 + fOptimizedParam.x)) * _677;
              float4 _736 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_730 * _718) + 0.5f), (((_730 * ((_649 * 2.0f) + -1.0f)) * (((_723 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _745 = (_650 * 2.0f) + -1.0f;
              float _749 = sqrt((_745 * _745) + 1.0f);
              float _750 = 1.0f / _749;
              float _757 = ((_749 * fOptimizedParam.z) * (_750 + fOptimizedParam.x)) * _677;
              float4 _763 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_757 * _745) + 0.5f), (((_757 * ((_651 * 2.0f) + -1.0f)) * (((_750 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _772 = (_652 * 2.0f) + -1.0f;
              float _776 = sqrt((_772 * _772) + 1.0f);
              float _777 = 1.0f / _776;
              float _784 = ((_776 * fOptimizedParam.z) * (_777 + fOptimizedParam.x)) * _677;
              float4 _790 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_784 * _772) + 0.5f), (((_784 * ((_653 * 2.0f) + -1.0f)) * (((_777 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _799 = (_654 * 2.0f) + -1.0f;
              float _803 = sqrt((_799 * _799) + 1.0f);
              float _804 = 1.0f / _803;
              float _811 = ((_803 * fOptimizedParam.z) * (_804 + fOptimizedParam.x)) * _677;
              float4 _817 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_811 * _799) + 0.5f), (((_811 * ((_655 * 2.0f) + -1.0f)) * (((_804 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _826 = (_656 * 2.0f) + -1.0f;
              float _830 = sqrt((_826 * _826) + 1.0f);
              float _831 = 1.0f / _830;
              float _838 = ((_830 * fOptimizedParam.z) * (_831 + fOptimizedParam.x)) * _677;
              float4 _844 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_838 * _826) + 0.5f), (((_838 * ((_657 * 2.0f) + -1.0f)) * (((_831 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _853 = (_658 * 2.0f) + -1.0f;
              float _857 = sqrt((_853 * _853) + 1.0f);
              float _858 = 1.0f / _857;
              float _865 = ((_857 * fOptimizedParam.z) * (_858 + fOptimizedParam.x)) * _677;
              float4 _871 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_865 * _853) + 0.5f), (((_865 * ((_659 * 2.0f) + -1.0f)) * (((_858 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _880 = (_660 * 2.0f) + -1.0f;
              float _884 = sqrt((_880 * _880) + 1.0f);
              float _885 = 1.0f / _884;
              float _892 = ((_884 * fOptimizedParam.z) * (_885 + fOptimizedParam.x)) * _677;
              float4 _898 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_892 * _880) + 0.5f), (((_892 * ((_661 * 2.0f) + -1.0f)) * (((_885 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _968 = ((((((((_709.x + _685.x) + _736.x) + _763.x) + _790.x) + _817.x) + _844.x) + _871.x) + _898.x);
              _969 = ((((((((_709.y + _685.y) + _736.y) + _763.y) + _790.y) + _817.y) + _844.y) + _871.y) + _898.y);
              _970 = ((((((((_709.z + _685.z) + _736.z) + _763.z) + _790.z) + _817.z) + _844.z) + _871.z) + _898.z);
            } else {
              float4 _907 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_643, _645), 0.0f);
              float4 _911 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_646, _647), 0.0f);
              float4 _918 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_648, _649), 0.0f);
              float4 _925 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_650, _651), 0.0f);
              float4 _932 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_652, _653), 0.0f);
              float4 _939 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_654, _655), 0.0f);
              float4 _946 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_656, _657), 0.0f);
              float4 _953 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_658, _659), 0.0f);
              float4 _960 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_660, _661), 0.0f);
              _968 = ((((((((_911.x + _907.x) + _918.x) + _925.x) + _932.x) + _939.x) + _946.x) + _953.x) + _960.x);
              _969 = ((((((((_911.y + _907.y) + _918.y) + _925.y) + _932.y) + _939.y) + _946.y) + _953.y) + _960.y);
              _970 = ((((((((_911.z + _907.z) + _918.z) + _925.z) + _932.z) + _939.z) + _946.z) + _953.z) + _960.z);
            }
          }
          float _980 = (cbRadialColor.z * (_323 + (Exposure * _970))) * 0.10000000149011612f;
          float _981 = (cbRadialColor.y * (_322 + (Exposure * _969))) * 0.10000000149011612f;
          float _982 = (cbRadialColor.x * (_321 + (Exposure * _968))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _987 = saturate((_417 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _993 = (((_987 * _987) * cbRadialMaskRate.x) * (3.0f - (_987 * 2.0f))) + cbRadialMaskRate.y;
              _1004 = ((_993 * (_982 - _321)) + _321);
              _1005 = ((_993 * (_981 - _322)) + _322);
              _1006 = ((_993 * (_980 - _323)) + _323);
            } else {
              _1004 = _982;
              _1005 = _981;
              _1006 = _980;
            }
            _1017 = (lerp(_321, _1004, _370));
            _1018 = (lerp(_322, _1005, _370));
            _1019 = (lerp(_323, _1006, _370));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1017 = _321;
      _1018 = _322;
      _1019 = _323;
    }
  } else {
    _1017 = _321;
    _1018 = _322;
    _1019 = _323;
  }
  if (_60 && (bool)((cPassEnabled & 2) != 0)) {
    float _1027 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1029 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1035 = frac(frac((_1029 * 0.005837149918079376f) + (_1027 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1035 < fNoiseDensity) {
        int _1040 = (uint)(uint(_1029 * _1027)) ^ 12345391;
        uint _1041 = _1040 * 3635641;
        _1049 = (float((uint)((int)((((uint)(_1041) >> 26) | ((uint)(_1040 * 232681024))) ^ _1041))) * 2.3283064365386963e-10f);
      } else {
        _1049 = 0.0f;
      }
      float _1051 = frac(_1035 * 757.4846801757812f);
      do {
        if (_1051 < fNoiseDensity) {
          int _1055 = asint(_1051) ^ 12345391;
          uint _1056 = _1055 * 3635641;
          _1065 = ((float((uint)((int)((((uint)(_1056) >> 26) | ((uint)(_1055 * 232681024))) ^ _1056))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1065 = 0.0f;
        }
        float _1067 = frac(_1051 * 757.4846801757812f);
        do {
          if (_1067 < fNoiseDensity) {
            int _1071 = asint(_1067) ^ 12345391;
            uint _1072 = _1071 * 3635641;
            _1081 = ((float((uint)((int)((((uint)(_1072) >> 26) | ((uint)(_1071 * 232681024))) ^ _1072))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1081 = 0.0f;
          }
          float _1082 = _1049 * fNoisePower.x * CUSTOM_NOISE;
          float _1083 = _1081 * fNoisePower.y * CUSTOM_NOISE;
          float _1084 = _1065 * fNoisePower.y * CUSTOM_NOISE;
          float _1098 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1017), saturate(_1018), saturate(_1019)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1109 = ((_1098 * (mad(_1084, 1.4019999504089355f, _1082) - _1017)) + _1017);
          _1110 = ((_1098 * (mad(_1084, -0.7139999866485596f, mad(_1083, -0.3440000116825104f, _1082)) - _1018)) + _1018);
          _1111 = ((_1098 * (mad(_1083, 1.7719999551773071f, _1082) - _1019)) + _1019);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1109 = _1017;
    _1110 = _1018;
    _1111 = _1019;
  }
  float _1126 = mad(_1111, (fOCIOTransformMatrix[2].x), mad(_1110, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1109)));
  float _1129 = mad(_1111, (fOCIOTransformMatrix[2].y), mad(_1110, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1109)));
  float _1132 = mad(_1111, (fOCIOTransformMatrix[2].z), mad(_1110, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1109)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1138 = max(max(_1126, _1129), _1132);
    if (!(_1138 == 0.0f)) {
      float _1144 = abs(_1138);
      float _1145 = (_1138 - _1126) / _1144;
      float _1146 = (_1138 - _1129) / _1144;
      float _1147 = (_1138 - _1132) / _1144;
      do {
        if (!(!(_1145 >= cbControlRGCParam.CyanThreshold))) {
          float _1157 = _1145 - cbControlRGCParam.CyanThreshold;
          _1169 = ((_1157 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1157) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1169 = _1145;
        }
        do {
          if (!(!(_1146 >= cbControlRGCParam.MagentaThreshold))) {
            float _1178 = _1146 - cbControlRGCParam.MagentaThreshold;
            _1190 = ((_1178 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1178) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1190 = _1146;
          }
          do {
            if (!(!(_1147 >= cbControlRGCParam.YellowThreshold))) {
              float _1198 = _1147 - cbControlRGCParam.YellowThreshold;
              _1210 = ((_1198 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1198) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1210 = _1147;
            }
            _1218 = (_1138 - (_1169 * _1144));
            _1219 = (_1138 - (_1190 * _1144));
            _1220 = (_1138 - (_1210 * _1144));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1218 = _1126;
      _1219 = _1129;
      _1220 = _1132;
    }
  } else {
    _1218 = _1126;
    _1219 = _1129;
    _1220 = _1132;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _60,
        cPassEnabled,
        _1218,
        _1219,
        _1220,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureSize,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1447,
        _1448,
        _1449);
  #else
  if (_60 && (bool)((cPassEnabled & 4) != 0)) {
    float _1271 = (((log2(select((_1218 < 3.0517578125e-05f), ((_1218 * 0.5f) + 1.52587890625e-05f), _1218)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1272 = (((log2(select((_1219 < 3.0517578125e-05f), ((_1219 * 0.5f) + 1.52587890625e-05f), _1219)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1273 = (((log2(select((_1220 < 3.0517578125e-05f), ((_1220 * 0.5f) + 1.52587890625e-05f), _1220)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1276 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1271, _1272, _1273), 0.0f);
    float _1289 = max(exp2((_1276.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1290 = max(exp2((_1276.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1291 = max(exp2((_1276.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1293 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1296 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1271, _1272, _1273), 0.0f);
        float _1318 = ((max(exp2((_1296.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1289) * fTextureBlendRate) + _1289;
        float _1319 = ((max(exp2((_1296.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1290) * fTextureBlendRate) + _1290;
        float _1320 = ((max(exp2((_1296.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1291) * fTextureBlendRate) + _1291;
        if (_1293) {
          float4 _1350 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1318 < 3.0517578125e-05f), ((_1318 * 0.5f) + 1.52587890625e-05f), _1318)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1319 < 3.0517578125e-05f), ((_1319 * 0.5f) + 1.52587890625e-05f), _1319)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1320 < 3.0517578125e-05f), ((_1320 * 0.5f) + 1.52587890625e-05f), _1320)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1431 = (((max(exp2((_1350.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1318) * fTextureBlendRate2) + _1318);
          _1432 = (((max(exp2((_1350.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1319) * fTextureBlendRate2) + _1319);
          _1433 = (((max(exp2((_1350.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1320) * fTextureBlendRate2) + _1320);
        } else {
          _1431 = _1318;
          _1432 = _1319;
          _1433 = _1320;
        }
      } else {
        if (_1293) {
          float4 _1405 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1289 < 3.0517578125e-05f), ((_1289 * 0.5f) + 1.52587890625e-05f), _1289)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1290 < 3.0517578125e-05f), ((_1290 * 0.5f) + 1.52587890625e-05f), _1290)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1291 < 3.0517578125e-05f), ((_1291 * 0.5f) + 1.52587890625e-05f), _1291)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1431 = (((max(exp2((_1405.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1289) * fTextureBlendRate2) + _1289);
          _1432 = (((max(exp2((_1405.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1290) * fTextureBlendRate2) + _1290);
          _1433 = (((max(exp2((_1405.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1291) * fTextureBlendRate2) + _1291);
        } else {
          _1431 = _1289;
          _1432 = _1290;
          _1433 = _1291;
        }
      }
      _1447 = (mad(_1433, (fColorMatrix[2].x), mad(_1432, (fColorMatrix[1].x), (_1431 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1448 = (mad(_1433, (fColorMatrix[2].y), mad(_1432, (fColorMatrix[1].y), (_1431 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1449 = (mad(_1433, (fColorMatrix[2].z), mad(_1432, (fColorMatrix[1].z), (_1431 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1447 = _1218;
    _1448 = _1219;
    _1449 = _1220;
  }
  #endif
  if (_60 && (bool)((cPassEnabled & 8) != 0)) {
    _1482 = (((cvdR.x * _1447) + (cvdR.y * _1448)) + (cvdR.z * _1449));
    _1483 = (((cvdG.x * _1447) + (cvdG.y * _1448)) + (cvdG.z * _1449));
    _1484 = (((cvdB.x * _1447) + (cvdB.y * _1448)) + (cvdB.z * _1449));
  } else {
    _1482 = _1447;
    _1483 = _1448;
    _1484 = _1449;
  }
  float _1488 = screenInverseSize.x * SV_Position.x;
  float _1489 = screenInverseSize.y * SV_Position.y;
  float4 _1495 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1488, _1489), 0.0f);
  if (_60 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1509 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1488, _1489), 0.0f);
    float _1515 = ColorParam.x * _1495.x;
    float _1516 = ColorParam.y * _1495.y;
    float _1517 = ColorParam.z * _1495.z;
    float _1522 = (ColorParam.w * _1495.w) * saturate((_1509.x * Levels_Rate) + Levels_Range);
    do {
      if (_1515 < 0.5f) {
        _1534 = ((_1482 * 2.0f) * _1515);
      } else {
        _1534 = (1.0f - (((1.0f - _1482) * 2.0f) * (1.0f - _1515)));
      }
      do {
        if (_1516 < 0.5f) {
          _1546 = ((_1483 * 2.0f) * _1516);
        } else {
          _1546 = (1.0f - (((1.0f - _1483) * 2.0f) * (1.0f - _1516)));
        }
        do {
          if (_1517 < 0.5f) {
            _1558 = ((_1484 * 2.0f) * _1517);
          } else {
            _1558 = (1.0f - (((1.0f - _1484) * 2.0f) * (1.0f - _1517)));
          }
          _1569 = (lerp(_1482, _1534, _1522));
          _1570 = (lerp(_1483, _1546, _1522));
          _1571 = (lerp(_1484, _1558, _1522));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1569 = _1482;
    _1570 = _1483;
    _1571 = _1484;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _1611 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _1571, mad((RGBToXYZViaCrosstalkMatrix[0].y), _1570, ((RGBToXYZViaCrosstalkMatrix[0].x) * _1569)));
      float _1614 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _1571, mad((RGBToXYZViaCrosstalkMatrix[1].y), _1570, ((RGBToXYZViaCrosstalkMatrix[1].x) * _1569)));
      float _1619 = (_1614 + _1611) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _1571, mad((RGBToXYZViaCrosstalkMatrix[2].y), _1570, ((RGBToXYZViaCrosstalkMatrix[2].x) * _1569)));
      float _1620 = _1611 / _1619;
      float _1621 = _1614 / _1619;
      do {
        if (_1614 < curve_HDRip) {
          _1632 = (_1614 * exposureScale);
        } else {
          _1632 = ((log2((_1614 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _1634 = (_1620 / _1621) * _1632;
        float _1638 = (((1.0f - _1620) - _1621) / _1621) * _1632;
        _1687 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _1638, mad((XYZToRGBViaCrosstalkMatrix[0].y), _1632, (_1634 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _1688 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _1638, mad((XYZToRGBViaCrosstalkMatrix[1].y), _1632, (_1634 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _1689 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _1638, mad((XYZToRGBViaCrosstalkMatrix[2].y), _1632, (_1634 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_1569 < curve_HDRip) {
          _1665 = (exposureScale * _1569);
        } else {
          _1665 = ((log2((_1569 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_1570 < curve_HDRip) {
            _1676 = (exposureScale * _1570);
          } else {
            _1676 = ((log2((_1570 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_1571 < curve_HDRip) {
            _1687 = _1665;
            _1688 = _1676;
            _1689 = (exposureScale * _1571);
          } else {
            _1687 = _1665;
            _1688 = _1676;
            _1689 = ((log2((_1571 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _1687 = _1569;
    _1688 = _1570;
    _1689 = _1571;
  }
  SV_Target.x = _1687;
  SV_Target.y = _1688;
  SV_Target.z = _1689;
  SV_Target.w = 1.0f;
  return SV_Target;
}
