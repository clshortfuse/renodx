#include "./PostProcess.hlsli"

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

cbuffer EnvironmentInfo : register(b1) {
  uint timeMillisecond : packoffset(c000.x);
  uint frameCount : packoffset(c000.y);
  uint isOddFrame : packoffset(c000.z);
  uint reserveEnvironmentInfo : packoffset(c000.w);
  float breakingPBRSpecularIntensity : packoffset(c001.x);
  float breakingPBRIBLReflectanceBias : packoffset(c001.y);
  float breakingPBRIBLIntensity : packoffset(c001.z);
  float breakingPBRCubemapReflectionScale : packoffset(c001.w);
  uint vrsTier2Enable : packoffset(c002.x);
  uint dynamicTextureTableNullBlackHandle : packoffset(c002.y);
  uint prevTimeMillisecond : packoffset(c002.z);
  uint bindlessMaterialMaxNum : packoffset(c002.w);
  float rtLightRadius : packoffset(c003.x);
  float accurateVelocityDistanceSq : packoffset(c003.y);
  float EnvironmentInfoReserved1 : packoffset(c003.z);
  float EnvironmentInfoReserved2 : packoffset(c003.w);
  float4 userGlobalParams[32] : packoffset(c004.x);
  uint4 dynamicTextureTableHandles[256] : packoffset(c036.x);
  uint4 bakedResourceSharedTablesHandles[32] : packoffset(c292.x);
};

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b3) {
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

cbuffer LDRPostProcessParam : register(b4) {
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

cbuffer CBControl : register(b5) {
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

cbuffer UserShaderLDRPostProcessSettings : register(b6) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b7) {
  float4 VAR_Flicker_Color : packoffset(c000.x);
  float VAR_Flicker_Opacity : packoffset(c001.x);
  float VAR_Flicker_Scale : packoffset(c001.y);
  float VAR_Flicker_Speed : packoffset(c001.z);
  float VAR_Flicker_Gradation : packoffset(c001.w);
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
  float _50 = (1.0f / max(VAR_Flicker_Scale, 0.009999999776482582f)) * ((screenInverseSize.y * SV_Position.y) - (frac((float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Flicker_Speed) * 100.0f));
  float _59 = ((sin(_50 * 8.391579627990723f) + sin(_50 * 5.069784164428711f)) + sin(_50 * 3.7269840240478516f)) * 0.16664999723434448f;
  float _60 = _59 + 0.5f;
  float _138;
  float _408;
  float _409;
  float _410;
  float _486;
  float _550;
  float _1105;
  float _1106;
  float _1107;
  float _1141;
  float _1142;
  float _1143;
  float _1154;
  float _1155;
  float _1156;
  float _1186;
  float _1202;
  float _1218;
  float _1246;
  float _1247;
  float _1248;
  float _1306;
  float _1327;
  float _1347;
  float _1355;
  float _1356;
  float _1357;
  float _1568;
  float _1569;
  float _1570;
  float _1584;
  float _1585;
  float _1586;
  float _1619;
  float _1620;
  float _1621;
  float _1671;
  float _1683;
  float _1695;
  float _1706;
  float _1707;
  float _1708;
  float _1769;
  float _1802;
  float _1813;
  float _1824;
  float _1825;
  float _1826;
  [branch]
  if (film_aspect == 0.0f) {
    float _99 = Kerare.x / Kerare.w;
    float _100 = Kerare.y / Kerare.w;
    float _101 = Kerare.z / Kerare.w;
    float _105 = abs(rsqrt(dot(float3(_99, _100, _101), float3(_99, _100, _101))) * _101);
    float _110 = _105 * _105;
    _138 = ((_110 * _110) * (1.0f - saturate((_105 * kerare_scale) + kerare_offset)));
  } else {
    float _121 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _123 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _125 = sqrt(dot(float2(_123, _121), float2(_123, _121)));
    float _133 = (_125 * _125) + 1.0f;
    _138 = ((1.0f / (_133 * _133)) * (1.0f - saturate(((1.0f / (_125 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _141 = saturate(_138 + kerare_brightness) * Exposure;
  uint _142 = uint(float((uint)(int)(distortionType)));
  bool _147 = (LDRPPSettings_enabled != 0);
  bool _148 = ((cPassEnabled & 1) != 0);
  if (!(_148 && _147)) {
    float4 _158 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _408 = (min(_158.x, 65000.0f) * _141);
    _409 = (min(_158.y, 65000.0f) * _141);
    _410 = (min(_158.z, 65000.0f) * _141);
  } else {
    if (_142 == 0) {
      float _176 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _177 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _178 = dot(float2(_176, _177), float2(_176, _177));
      float _180 = (_178 * fDistortionCoef) + 1.0f;
      float _181 = _176 * fCorrectCoef;
      float _183 = _177 * fCorrectCoef;
      float _185 = (_181 * _180) + 0.5f;
      float _186 = (_183 * _180) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _191 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_185, _186));
        _408 = (_191.x * _141);
        _409 = (_191.y * _141);
        _410 = (_191.z * _141);
      } else {
        float _210 = ((saturate((sqrt((_176 * _176) + (_177 * _177)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _220 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _221 = _210 * 2.0f;
          float _225 = (((_220 * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _230 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_225 * _181) + 0.5f), ((_225 * _183) + 0.5f)));
          float _236 = ((((_220 + 0.125f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _241 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_236 * _181) + 0.5f), ((_236 * _183) + 0.5f)));
          float _248 = ((((_220 + 0.25f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _253 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_248 * _181) + 0.5f), ((_248 * _183) + 0.5f)));
          float _262 = ((((_220 + 0.375f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _267 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_262 * _181) + 0.5f), ((_262 * _183) + 0.5f)));
          float _276 = ((((_220 + 0.5f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _281 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_276 * _181) + 0.5f), ((_276 * _183) + 0.5f)));
          float _287 = ((((_220 + 0.625f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _292 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_287 * _181) + 0.5f), ((_287 * _183) + 0.5f)));
          float _300 = ((((_220 + 0.75f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _305 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_300 * _181) + 0.5f), ((_300 * _183) + 0.5f)));
          float _320 = ((((_220 + 0.875f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _325 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_320 * _181) + 0.5f), ((_320 * _183) + 0.5f)));
          float _332 = ((((_220 + 1.0f) * _221) + _178) * fDistortionCoef) + 1.0f;
          float4 _337 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_332 * _181) + 0.5f), ((_332 * _183) + 0.5f)));
          float _340 = _141 * 0.3199999928474426f;
          _408 = ((((_241.x + _230.x) + (_253.x * 0.75f)) + (_267.x * 0.375f)) * _340);
          _409 = ((_141 * 0.3636363744735718f) * ((((_292.y + _267.y) * 0.625f) + _281.y) + ((_305.y + _253.y) * 0.25f)));
          _410 = (((((_305.z * 0.75f) + (_292.z * 0.375f)) + _325.z) + _337.z) * _340);
        } else {
          float _346 = _210 + _178;
          float _348 = (_346 * fDistortionCoef) + 1.0f;
          float _355 = ((_346 + _210) * fDistortionCoef) + 1.0f;
          float4 _360 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_185, _186));
          float4 _363 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_348 * _181) + 0.5f), ((_348 * _183) + 0.5f)));
          float4 _366 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_355 * _181) + 0.5f), ((_355 * _183) + 0.5f)));
          _408 = (_360.x * _141);
          _409 = (_363.y * _141);
          _410 = (_366.z * _141);
        }
      }
    } else {
      if (_142 == 1) {
        float _379 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _383 = sqrt((_379 * _379) + 1.0f);
        float _384 = 1.0f / _383;
        float _392 = ((_383 * fOptimizedParam.z) * (_384 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _400 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_392 * _379) + 0.5f), (((_392 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_384 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _408 = (_400.x * _141);
        _409 = (_400.y * _141);
        _410 = (_400.z * _141);
      } else {
        _408 = 0.0f;
        _409 = 0.0f;
        _410 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _447 = Kerare.x / Kerare.w;
    float _448 = Kerare.y / Kerare.w;
    float _449 = Kerare.z / Kerare.w;
    float _453 = abs(rsqrt(dot(float3(_447, _448, _449), float3(_447, _448, _449))) * _449);
    float _458 = _453 * _453;
    _486 = ((_458 * _458) * (1.0f - saturate((_453 * kerare_scale) + kerare_offset)));
  } else {
    float _469 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _471 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _473 = sqrt(dot(float2(_471, _469), float2(_471, _469)));
    float _481 = (_473 * _473) + 1.0f;
    _486 = ((1.0f / (_481 * _481)) * (1.0f - saturate(((1.0f / (_473 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _489 = saturate(_486 + kerare_brightness) * Exposure;
  if (_147 && (bool)((cPassEnabled & 32) != 0)) {
    float _500 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _504 = ComputeResultSRV[0].computeAlpha;
    float _507 = ((1.0f - _500) + (_504 * _500)) * cbRadialColor.w;
    if (!(_507 == 0.0f)) {
      float _513 = screenInverseSize.x * SV_Position.x;
      float _514 = screenInverseSize.y * SV_Position.y;
      float _516 = _513 + (-0.5f - cbRadialScreenPos.x);
      float _518 = _514 + (-0.5f - cbRadialScreenPos.y);
      float _521 = select((_516 < 0.0f), (1.0f - _513), _513);
      float _524 = select((_518 < 0.0f), (1.0f - _514), _514);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _530 = rsqrt(dot(float2(_516, _518), float2(_516, _518))) * cbRadialSharpRange;
          uint _537 = uint(abs(_530 * _518)) + uint(abs(_530 * _516));
          uint _541 = ((_537 ^ 61) ^ ((uint)(_537) >> 16)) * 9;
          uint _544 = (((uint)(_541) >> 4) ^ _541) * 668265261;
          _550 = (float((uint)((int)(((uint)(_544) >> 15) ^ _544))) * 2.3283064365386963e-10f);
        } else {
          _550 = 1.0f;
        }
        float _554 = sqrt((_516 * _516) + (_518 * _518));
        float _556 = 1.0f / max(1.0f, _554);
        float _557 = _550 * _521;
        float _558 = cbRadialBlurPower * _556;
        float _559 = _558 * -0.0011111111380159855f;
        float _561 = _550 * _524;
        float _565 = ((_559 * _557) + 1.0f) * _516;
        float _566 = ((_559 * _561) + 1.0f) * _518;
        float _568 = _558 * -0.002222222276031971f;
        float _573 = ((_568 * _557) + 1.0f) * _516;
        float _574 = ((_568 * _561) + 1.0f) * _518;
        float _575 = _558 * -0.0033333334140479565f;
        float _580 = ((_575 * _557) + 1.0f) * _516;
        float _581 = ((_575 * _561) + 1.0f) * _518;
        float _582 = _558 * -0.004444444552063942f;
        float _587 = ((_582 * _557) + 1.0f) * _516;
        float _588 = ((_582 * _561) + 1.0f) * _518;
        float _589 = _558 * -0.0055555556900799274f;
        float _594 = ((_589 * _557) + 1.0f) * _516;
        float _595 = ((_589 * _561) + 1.0f) * _518;
        float _596 = _558 * -0.006666666828095913f;
        float _601 = ((_596 * _557) + 1.0f) * _516;
        float _602 = ((_596 * _561) + 1.0f) * _518;
        float _603 = _558 * -0.007777777966111898f;
        float _608 = ((_603 * _557) + 1.0f) * _516;
        float _609 = ((_603 * _561) + 1.0f) * _518;
        float _610 = _558 * -0.008888889104127884f;
        float _615 = ((_610 * _557) + 1.0f) * _516;
        float _616 = ((_610 * _561) + 1.0f) * _518;
        float _619 = _556 * ((cbRadialBlurPower * -0.009999999776482582f) * _550);
        float _624 = ((_619 * _521) + 1.0f) * _516;
        float _625 = ((_619 * _524) + 1.0f) * _518;
        do {
          if (_148 && (bool)(_142 == 0)) {
            float _627 = _565 + cbRadialScreenPos.x;
            float _628 = _566 + cbRadialScreenPos.y;
            float _632 = ((dot(float2(_627, _628), float2(_627, _628)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _638 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_632 * _627) + 0.5f), ((_632 * _628) + 0.5f)), 0.0f);
            float _642 = _573 + cbRadialScreenPos.x;
            float _643 = _574 + cbRadialScreenPos.y;
            float _647 = ((dot(float2(_642, _643), float2(_642, _643)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _652 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_647 * _642) + 0.5f), ((_647 * _643) + 0.5f)), 0.0f);
            float _659 = _580 + cbRadialScreenPos.x;
            float _660 = _581 + cbRadialScreenPos.y;
            float _664 = ((dot(float2(_659, _660), float2(_659, _660)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _669 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_664 * _659) + 0.5f), ((_664 * _660) + 0.5f)), 0.0f);
            float _676 = _587 + cbRadialScreenPos.x;
            float _677 = _588 + cbRadialScreenPos.y;
            float _681 = ((dot(float2(_676, _677), float2(_676, _677)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _686 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_681 * _676) + 0.5f), ((_681 * _677) + 0.5f)), 0.0f);
            float _693 = _594 + cbRadialScreenPos.x;
            float _694 = _595 + cbRadialScreenPos.y;
            float _698 = ((dot(float2(_693, _694), float2(_693, _694)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _703 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_698 * _693) + 0.5f), ((_698 * _694) + 0.5f)), 0.0f);
            float _710 = _601 + cbRadialScreenPos.x;
            float _711 = _602 + cbRadialScreenPos.y;
            float _715 = ((dot(float2(_710, _711), float2(_710, _711)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _720 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_715 * _710) + 0.5f), ((_715 * _711) + 0.5f)), 0.0f);
            float _727 = _608 + cbRadialScreenPos.x;
            float _728 = _609 + cbRadialScreenPos.y;
            float _732 = ((dot(float2(_727, _728), float2(_727, _728)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _737 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_732 * _727) + 0.5f), ((_732 * _728) + 0.5f)), 0.0f);
            float _744 = _615 + cbRadialScreenPos.x;
            float _745 = _616 + cbRadialScreenPos.y;
            float _749 = ((dot(float2(_744, _745), float2(_744, _745)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _754 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_749 * _744) + 0.5f), ((_749 * _745) + 0.5f)), 0.0f);
            float _761 = _624 + cbRadialScreenPos.x;
            float _762 = _625 + cbRadialScreenPos.y;
            float _766 = ((dot(float2(_761, _762), float2(_761, _762)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _771 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_766 * _761) + 0.5f), ((_766 * _762) + 0.5f)), 0.0f);
            _1105 = ((((((((_652.x + _638.x) + _669.x) + _686.x) + _703.x) + _720.x) + _737.x) + _754.x) + _771.x);
            _1106 = ((((((((_652.y + _638.y) + _669.y) + _686.y) + _703.y) + _720.y) + _737.y) + _754.y) + _771.y);
            _1107 = ((((((((_652.z + _638.z) + _669.z) + _686.z) + _703.z) + _720.z) + _737.z) + _754.z) + _771.z);
          } else {
            float _779 = cbRadialScreenPos.x + 0.5f;
            float _780 = _565 + _779;
            float _781 = cbRadialScreenPos.y + 0.5f;
            float _782 = _566 + _781;
            float _783 = _573 + _779;
            float _784 = _574 + _781;
            float _785 = _580 + _779;
            float _786 = _581 + _781;
            float _787 = _587 + _779;
            float _788 = _588 + _781;
            float _789 = _594 + _779;
            float _790 = _595 + _781;
            float _791 = _601 + _779;
            float _792 = _602 + _781;
            float _793 = _608 + _779;
            float _794 = _609 + _781;
            float _795 = _615 + _779;
            float _796 = _616 + _781;
            float _797 = _624 + _779;
            float _798 = _625 + _781;
            if (_148 && (bool)(_142 == 1)) {
              float _802 = (_780 * 2.0f) + -1.0f;
              float _806 = sqrt((_802 * _802) + 1.0f);
              float _807 = 1.0f / _806;
              float _814 = fOptimizedParam.w * 0.5f;
              float _815 = ((_806 * fOptimizedParam.z) * (_807 + fOptimizedParam.x)) * _814;
              float4 _822 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_815 * _802) + 0.5f), (((_815 * ((_782 * 2.0f) + -1.0f)) * (((_807 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _828 = (_783 * 2.0f) + -1.0f;
              float _832 = sqrt((_828 * _828) + 1.0f);
              float _833 = 1.0f / _832;
              float _840 = ((_832 * fOptimizedParam.z) * (_833 + fOptimizedParam.x)) * _814;
              float4 _846 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_840 * _828) + 0.5f), (((_840 * ((_784 * 2.0f) + -1.0f)) * (((_833 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _855 = (_785 * 2.0f) + -1.0f;
              float _859 = sqrt((_855 * _855) + 1.0f);
              float _860 = 1.0f / _859;
              float _867 = ((_859 * fOptimizedParam.z) * (_860 + fOptimizedParam.x)) * _814;
              float4 _873 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_867 * _855) + 0.5f), (((_867 * ((_786 * 2.0f) + -1.0f)) * (((_860 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _882 = (_787 * 2.0f) + -1.0f;
              float _886 = sqrt((_882 * _882) + 1.0f);
              float _887 = 1.0f / _886;
              float _894 = ((_886 * fOptimizedParam.z) * (_887 + fOptimizedParam.x)) * _814;
              float4 _900 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_894 * _882) + 0.5f), (((_894 * ((_788 * 2.0f) + -1.0f)) * (((_887 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _909 = (_789 * 2.0f) + -1.0f;
              float _913 = sqrt((_909 * _909) + 1.0f);
              float _914 = 1.0f / _913;
              float _921 = ((_913 * fOptimizedParam.z) * (_914 + fOptimizedParam.x)) * _814;
              float4 _927 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_921 * _909) + 0.5f), (((_921 * ((_790 * 2.0f) + -1.0f)) * (((_914 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _936 = (_791 * 2.0f) + -1.0f;
              float _940 = sqrt((_936 * _936) + 1.0f);
              float _941 = 1.0f / _940;
              float _948 = ((_940 * fOptimizedParam.z) * (_941 + fOptimizedParam.x)) * _814;
              float4 _954 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_948 * _936) + 0.5f), (((_948 * ((_792 * 2.0f) + -1.0f)) * (((_941 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _963 = (_793 * 2.0f) + -1.0f;
              float _967 = sqrt((_963 * _963) + 1.0f);
              float _968 = 1.0f / _967;
              float _975 = ((_967 * fOptimizedParam.z) * (_968 + fOptimizedParam.x)) * _814;
              float4 _981 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_975 * _963) + 0.5f), (((_975 * ((_794 * 2.0f) + -1.0f)) * (((_968 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _990 = (_795 * 2.0f) + -1.0f;
              float _994 = sqrt((_990 * _990) + 1.0f);
              float _995 = 1.0f / _994;
              float _1002 = ((_994 * fOptimizedParam.z) * (_995 + fOptimizedParam.x)) * _814;
              float4 _1008 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1002 * _990) + 0.5f), (((_1002 * ((_796 * 2.0f) + -1.0f)) * (((_995 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1017 = (_797 * 2.0f) + -1.0f;
              float _1021 = sqrt((_1017 * _1017) + 1.0f);
              float _1022 = 1.0f / _1021;
              float _1029 = ((_1021 * fOptimizedParam.z) * (_1022 + fOptimizedParam.x)) * _814;
              float4 _1035 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1029 * _1017) + 0.5f), (((_1029 * ((_798 * 2.0f) + -1.0f)) * (((_1022 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1105 = ((((((((_846.x + _822.x) + _873.x) + _900.x) + _927.x) + _954.x) + _981.x) + _1008.x) + _1035.x);
              _1106 = ((((((((_846.y + _822.y) + _873.y) + _900.y) + _927.y) + _954.y) + _981.y) + _1008.y) + _1035.y);
              _1107 = ((((((((_846.z + _822.z) + _873.z) + _900.z) + _927.z) + _954.z) + _981.z) + _1008.z) + _1035.z);
            } else {
              float4 _1044 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_780, _782), 0.0f);
              float4 _1048 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_783, _784), 0.0f);
              float4 _1055 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_785, _786), 0.0f);
              float4 _1062 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_787, _788), 0.0f);
              float4 _1069 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_789, _790), 0.0f);
              float4 _1076 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_791, _792), 0.0f);
              float4 _1083 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_793, _794), 0.0f);
              float4 _1090 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_795, _796), 0.0f);
              float4 _1097 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_797, _798), 0.0f);
              _1105 = ((((((((_1048.x + _1044.x) + _1055.x) + _1062.x) + _1069.x) + _1076.x) + _1083.x) + _1090.x) + _1097.x);
              _1106 = ((((((((_1048.y + _1044.y) + _1055.y) + _1062.y) + _1069.y) + _1076.y) + _1083.y) + _1090.y) + _1097.y);
              _1107 = ((((((((_1048.z + _1044.z) + _1055.z) + _1062.z) + _1069.z) + _1076.z) + _1083.z) + _1090.z) + _1097.z);
            }
          }
          float _1117 = (cbRadialColor.z * (_410 + (_489 * _1107))) * 0.10000000149011612f;
          float _1118 = (cbRadialColor.y * (_409 + (_489 * _1106))) * 0.10000000149011612f;
          float _1119 = (cbRadialColor.x * (_408 + (_489 * _1105))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1124 = saturate((_554 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1130 = (((_1124 * _1124) * cbRadialMaskRate.x) * (3.0f - (_1124 * 2.0f))) + cbRadialMaskRate.y;
              _1141 = ((_1130 * (_1119 - _408)) + _408);
              _1142 = ((_1130 * (_1118 - _409)) + _409);
              _1143 = ((_1130 * (_1117 - _410)) + _410);
            } else {
              _1141 = _1119;
              _1142 = _1118;
              _1143 = _1117;
            }
            _1154 = (lerp(_408, _1141, _507));
            _1155 = (lerp(_409, _1142, _507));
            _1156 = (lerp(_410, _1143, _507));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1154 = _408;
      _1155 = _409;
      _1156 = _410;
    }
  } else {
    _1154 = _408;
    _1155 = _409;
    _1156 = _410;
  }
  if (_147 && (bool)((cPassEnabled & 2) != 0)) {
    float _1164 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1166 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1172 = frac(frac((_1166 * 0.005837149918079376f) + (_1164 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1172 < fNoiseDensity) {
        int _1177 = (uint)(uint(_1166 * _1164)) ^ 12345391;
        uint _1178 = _1177 * 3635641;
        _1186 = (float((uint)((int)((((uint)(_1178) >> 26) | ((uint)(_1177 * 232681024))) ^ _1178))) * 2.3283064365386963e-10f);
      } else {
        _1186 = 0.0f;
      }
      float _1188 = frac(_1172 * 757.4846801757812f);
      do {
        if (_1188 < fNoiseDensity) {
          int _1192 = asint(_1188) ^ 12345391;
          uint _1193 = _1192 * 3635641;
          _1202 = ((float((uint)((int)((((uint)(_1193) >> 26) | ((uint)(_1192 * 232681024))) ^ _1193))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1202 = 0.0f;
        }
        float _1204 = frac(_1188 * 757.4846801757812f);
        do {
          if (_1204 < fNoiseDensity) {
            int _1208 = asint(_1204) ^ 12345391;
            uint _1209 = _1208 * 3635641;
            _1218 = ((float((uint)((int)((((uint)(_1209) >> 26) | ((uint)(_1208 * 232681024))) ^ _1209))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1218 = 0.0f;
          }
          float _1219 = _1186 * fNoisePower.x * CUSTOM_NOISE;
          float _1220 = _1218 * fNoisePower.y * CUSTOM_NOISE;
          float _1221 = _1202 * fNoisePower.y * CUSTOM_NOISE;
          float _1235 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1154), saturate(_1155), saturate(_1156)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1246 = ((_1235 * (mad(_1221, 1.4019999504089355f, _1219) - _1154)) + _1154);
          _1247 = ((_1235 * (mad(_1221, -0.7139999866485596f, mad(_1220, -0.3440000116825104f, _1219)) - _1155)) + _1155);
          _1248 = ((_1235 * (mad(_1220, 1.7719999551773071f, _1219) - _1156)) + _1156);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1246 = _1154;
    _1247 = _1155;
    _1248 = _1156;
  }
  float _1263 = mad(_1248, (fOCIOTransformMatrix[2].x), mad(_1247, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1246)));
  float _1266 = mad(_1248, (fOCIOTransformMatrix[2].y), mad(_1247, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1246)));
  float _1269 = mad(_1248, (fOCIOTransformMatrix[2].z), mad(_1247, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1246)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1275 = max(max(_1263, _1266), _1269);
    if (!(_1275 == 0.0f)) {
      float _1281 = abs(_1275);
      float _1282 = (_1275 - _1263) / _1281;
      float _1283 = (_1275 - _1266) / _1281;
      float _1284 = (_1275 - _1269) / _1281;
      do {
        if (!(!(_1282 >= cbControlRGCParam.CyanThreshold))) {
          float _1294 = _1282 - cbControlRGCParam.CyanThreshold;
          _1306 = ((_1294 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1294) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1306 = _1282;
        }
        do {
          if (!(!(_1283 >= cbControlRGCParam.MagentaThreshold))) {
            float _1315 = _1283 - cbControlRGCParam.MagentaThreshold;
            _1327 = ((_1315 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1315) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1327 = _1283;
          }
          do {
            if (!(!(_1284 >= cbControlRGCParam.YellowThreshold))) {
              float _1335 = _1284 - cbControlRGCParam.YellowThreshold;
              _1347 = ((_1335 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1335) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1347 = _1284;
            }
            _1355 = (_1275 - (_1306 * _1281));
            _1356 = (_1275 - (_1327 * _1281));
            _1357 = (_1275 - (_1347 * _1281));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1355 = _1263;
      _1356 = _1266;
      _1357 = _1269;
    }
  } else {
    _1355 = _1263;
    _1356 = _1266;
    _1357 = _1269;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _147,
        cPassEnabled,
        _1355,
        _1356,
        _1357,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1584,
        _1585,
        _1586);
  #else
  if (_147 && (bool)((cPassEnabled & 4) != 0)) {
    float _1408 = (((log2(select((_1355 < 3.0517578125e-05f), ((_1355 * 0.5f) + 1.52587890625e-05f), _1355)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1409 = (((log2(select((_1356 < 3.0517578125e-05f), ((_1356 * 0.5f) + 1.52587890625e-05f), _1356)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1410 = (((log2(select((_1357 < 3.0517578125e-05f), ((_1357 * 0.5f) + 1.52587890625e-05f), _1357)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1413 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1408, _1409, _1410), 0.0f);
    float _1426 = max(exp2((_1413.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1427 = max(exp2((_1413.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1428 = max(exp2((_1413.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1430 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1433 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1408, _1409, _1410), 0.0f);
        float _1455 = ((max(exp2((_1433.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1426) * fTextureBlendRate) + _1426;
        float _1456 = ((max(exp2((_1433.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1427) * fTextureBlendRate) + _1427;
        float _1457 = ((max(exp2((_1433.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1428) * fTextureBlendRate) + _1428;
        if (_1430) {
          float4 _1487 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1455 < 3.0517578125e-05f), ((_1455 * 0.5f) + 1.52587890625e-05f), _1455)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1456 < 3.0517578125e-05f), ((_1456 * 0.5f) + 1.52587890625e-05f), _1456)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1457 < 3.0517578125e-05f), ((_1457 * 0.5f) + 1.52587890625e-05f), _1457)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1568 = (((max(exp2((_1487.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1455) * fTextureBlendRate2) + _1455);
          _1569 = (((max(exp2((_1487.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1456) * fTextureBlendRate2) + _1456);
          _1570 = (((max(exp2((_1487.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1457) * fTextureBlendRate2) + _1457);
        } else {
          _1568 = _1455;
          _1569 = _1456;
          _1570 = _1457;
        }
      } else {
        if (_1430) {
          float4 _1542 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1426 < 3.0517578125e-05f), ((_1426 * 0.5f) + 1.52587890625e-05f), _1426)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1427 < 3.0517578125e-05f), ((_1427 * 0.5f) + 1.52587890625e-05f), _1427)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1428 < 3.0517578125e-05f), ((_1428 * 0.5f) + 1.52587890625e-05f), _1428)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1568 = (((max(exp2((_1542.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1426) * fTextureBlendRate2) + _1426);
          _1569 = (((max(exp2((_1542.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1427) * fTextureBlendRate2) + _1427);
          _1570 = (((max(exp2((_1542.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1428) * fTextureBlendRate2) + _1428);
        } else {
          _1568 = _1426;
          _1569 = _1427;
          _1570 = _1428;
        }
      }
      _1584 = (mad(_1570, (fColorMatrix[2].x), mad(_1569, (fColorMatrix[1].x), (_1568 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1585 = (mad(_1570, (fColorMatrix[2].y), mad(_1569, (fColorMatrix[1].y), (_1568 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1586 = (mad(_1570, (fColorMatrix[2].z), mad(_1569, (fColorMatrix[1].z), (_1568 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1584 = _1355;
    _1585 = _1356;
    _1586 = _1357;
  }
  #endif
  if (_147 && (bool)((cPassEnabled & 8) != 0)) {
    _1619 = (((cvdR.x * _1584) + (cvdR.y * _1585)) + (cvdR.z * _1586));
    _1620 = (((cvdG.x * _1584) + (cvdG.y * _1585)) + (cvdG.z * _1586));
    _1621 = (((cvdB.x * _1584) + (cvdB.y * _1585)) + (cvdB.z * _1586));
  } else {
    _1619 = _1584;
    _1620 = _1585;
    _1621 = _1586;
  }
  float _1625 = screenInverseSize.x * SV_Position.x;
  float _1626 = screenInverseSize.y * SV_Position.y;
  float4 _1632 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1625, _1626), 0.0f);
  if (_147 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1646 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1625, _1626), 0.0f);
    float _1652 = ColorParam.x * _1632.x;
    float _1653 = ColorParam.y * _1632.y;
    float _1654 = ColorParam.z * _1632.z;
    float _1659 = (ColorParam.w * _1632.w) * saturate((_1646.x * Levels_Rate) + Levels_Range);
    do {
      if (_1652 < 0.5f) {
        _1671 = ((_1619 * 2.0f) * _1652);
      } else {
        _1671 = (1.0f - (((1.0f - _1619) * 2.0f) * (1.0f - _1652)));
      }
      do {
        if (_1653 < 0.5f) {
          _1683 = ((_1620 * 2.0f) * _1653);
        } else {
          _1683 = (1.0f - (((1.0f - _1620) * 2.0f) * (1.0f - _1653)));
        }
        do {
          if (_1654 < 0.5f) {
            _1695 = ((_1621 * 2.0f) * _1654);
          } else {
            _1695 = (1.0f - (((1.0f - _1621) * 2.0f) * (1.0f - _1654)));
          }
          _1706 = (lerp(_1619, _1671, _1659));
          _1707 = (lerp(_1620, _1683, _1659));
          _1708 = (lerp(_1621, _1695, _1659));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1706 = _1619;
    _1707 = _1620;
    _1708 = _1621;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _1748 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _1708, mad((RGBToXYZViaCrosstalkMatrix[0].y), _1707, ((RGBToXYZViaCrosstalkMatrix[0].x) * _1706)));
      float _1751 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _1708, mad((RGBToXYZViaCrosstalkMatrix[1].y), _1707, ((RGBToXYZViaCrosstalkMatrix[1].x) * _1706)));
      float _1756 = (_1751 + _1748) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _1708, mad((RGBToXYZViaCrosstalkMatrix[2].y), _1707, ((RGBToXYZViaCrosstalkMatrix[2].x) * _1706)));
      float _1757 = _1748 / _1756;
      float _1758 = _1751 / _1756;
      do {
        if (_1751 < curve_HDRip) {
          _1769 = (_1751 * exposureScale);
        } else {
          _1769 = ((log2((_1751 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _1771 = (_1757 / _1758) * _1769;
        float _1775 = (((1.0f - _1757) - _1758) / _1758) * _1769;
        _1824 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _1775, mad((XYZToRGBViaCrosstalkMatrix[0].y), _1769, (_1771 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _1825 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _1775, mad((XYZToRGBViaCrosstalkMatrix[1].y), _1769, (_1771 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _1826 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _1775, mad((XYZToRGBViaCrosstalkMatrix[2].y), _1769, (_1771 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_1706 < curve_HDRip) {
          _1802 = (exposureScale * _1706);
        } else {
          _1802 = ((log2((_1706 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_1707 < curve_HDRip) {
            _1813 = (exposureScale * _1707);
          } else {
            _1813 = ((log2((_1707 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_1708 < curve_HDRip) {
            _1824 = _1802;
            _1825 = _1813;
            _1826 = (exposureScale * _1708);
          } else {
            _1824 = _1802;
            _1825 = _1813;
            _1826 = ((log2((_1708 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _1824 = _1706;
    _1825 = _1707;
    _1826 = _1708;
  }
  float _1833 = select((VAR_Flicker_Gradation < 0.5f), 0.0f, 1.0f);
  float _1842 = exp2(log2(max(((_1833 * ((0.5f - _59) - _60)) + _60), 9.999999974752427e-07f)) * (1.0f - abs((VAR_Flicker_Gradation * 2.0f) + -0.9960784316062927f)));
  float _1846 = ((1.0f - (_1842 * 2.0f)) * _1833) + _1842;
  float _1851 = VAR_Flicker_Color.x * _1824;
  float _1852 = VAR_Flicker_Color.y * _1825;
  float _1853 = VAR_Flicker_Color.z * _1826;
  SV_Target.x = ((((_1851 - _1824) + ((_1824 - _1851) * _1846)) * VAR_Flicker_Opacity) + _1824);
  SV_Target.y = ((((_1852 - _1825) + ((_1825 - _1852) * _1846)) * VAR_Flicker_Opacity) + _1825);
  SV_Target.z = ((((_1853 - _1826) + (_1846 * (_1826 - _1853))) * VAR_Flicker_Opacity) + _1826);
  SV_Target.w = 1.0f;
  return SV_Target;
}
