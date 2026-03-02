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

Texture2D<float4> FilmGrain_Texture : register(t7);

Texture2D<float4> FilmDamage_Texture : register(t8);

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

cbuffer CheckerBoardInfo : register(b2) {
  float2 cbr : packoffset(c000.x);
  float cbr_scale : packoffset(c000.z);
  float cbr_using : packoffset(c000.w);
  float2 cbr_padding : packoffset(c001.x);
  float cbr_mipmapReadjustRatio : packoffset(c001.z);
  int cbr_mipmapReadjustable : packoffset(c001.w);
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
  float4 VAR_FilmGrain_UVScale : packoffset(c000.x);
  float4 VAR_FilmDamage_UVScale : packoffset(c001.x);
  float4 VAR_FilmDamage_Color : packoffset(c002.x);
  float VAR_Animation_RefreshRate : packoffset(c003.x);
  float VAR_Debug_FilmGrain_Texture : packoffset(c003.y);
  float VAR_FilmGrain_Opacity : packoffset(c003.z);
  float VAR_FilmGrain_Size : packoffset(c003.w);
  float VAR_FilmGrain_Contrast : packoffset(c004.x);
  float VAR_FilmGrain_Curve : packoffset(c004.y);
  float VAR_FilmGrain_Saturate : packoffset(c004.z);
  float VAR_Debug_FilmDamage_Texture : packoffset(c004.w);
  float VAR_FilmDamage_Opacity : packoffset(c005.x);
  float VAR_FilmDamage_Size : packoffset(c005.y);
  float VAR_FilmDamage_Contrast : packoffset(c005.z);
  float VAR_FilmDamage_Curve : packoffset(c005.w);
};

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _44 = (float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Animation_RefreshRate;
  float _46 = floor(_44);
  float _50 = _46 * 0.5f;
  float _51 = floor(_44 * 0.5f) * 0.5f;
  float _58 = frac(abs(_50));
  float _59 = frac(abs(_51));
  float _79 = ((select((_51 >= (-0.0f - _51)), _59, (-0.0f - _59)) * 4.0f) + -1.0f) * ((screenInverseSize.y * SV_Position.y) + -0.5f);
  float _81 = ((screenSize.x / screenSize.y) * ((screenInverseSize.x * SV_Position.x) + -0.5f)) * ((select((_50 >= (-0.0f - _50)), _58, (-0.0f - _58)) * 4.0f) + -1.0f);
  float _95 = (_81 + frac(_46 * 0.4274809956550598f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.x));
  float _96 = (_79 + frac(_46 * 0.5725190043449402f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.y));
  float4 _110 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_95, _96), float2((cbr.x * ddx_coarse(_95)), (cbr.x * ddx_coarse(_96))), float2((cbr.y * ddy_coarse(_95)), (cbr.y * ddy_coarse(_96))), int2(0, 0));
  float _147;
  float _148;
  float _254;
  float _572;
  float _573;
  float _574;
  float _664;
  float _1219;
  float _1220;
  float _1221;
  float _1255;
  float _1256;
  float _1257;
  float _1268;
  float _1269;
  float _1270;
  float _1300;
  float _1316;
  float _1332;
  float _1360;
  float _1361;
  float _1362;
  float _1420;
  float _1441;
  float _1461;
  float _1469;
  float _1470;
  float _1471;
  float _1682;
  float _1683;
  float _1684;
  float _1698;
  float _1699;
  float _1700;
  float _1733;
  float _1734;
  float _1735;
  float _1785;
  float _1797;
  float _1809;
  float _1820;
  float _1821;
  float _1822;
  float _1883;
  float _1916;
  float _1927;
  float _1938;
  float _1939;
  float _1940;
  float _1970;
  float _1982;
  float _1994;
  [branch]
  if (VAR_FilmGrain_Saturate > 0.0f) {
    float _116 = _95 + 0.3330000042915344f;
    float _117 = _96 + 0.6660000085830688f;
    float _118 = _95 + 0.6660000085830688f;
    float _119 = _96 + 0.3330000042915344f;
    float4 _128 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_116, _117), float2((ddx_coarse(_116) * cbr.x), (ddx_coarse(_117) * cbr.x)), float2((ddy_coarse(_116) * cbr.y), (ddy_coarse(_117) * cbr.y)), int2(0, 0));
    float4 _138 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_118, _119), float2((ddx_coarse(_118) * cbr.x), (ddx_coarse(_119) * cbr.x)), float2((ddy_coarse(_118) * cbr.y), (ddy_coarse(_119) * cbr.y)), int2(0, 0));
    _147 = (lerp(_110.x, _128.x, VAR_FilmGrain_Saturate));
    _148 = (lerp(_110.x, _138.x, VAR_FilmGrain_Saturate));
  } else {
    _147 = _110.x;
    _148 = _110.x;
  }
  float _150 = 1.0f - VAR_FilmGrain_Curve;
  float _155 = select((_150 < 0.5f), 0.0f, 1.0f);
  float _156 = 1.0f - abs((_150 * 2.0f) + -0.9960784316062927f);
  float _178 = exp2(log2(max((((1.0f - (_147 * 2.0f)) * _155) + _147), 9.999999974752427e-07f)) * _156);
  float _179 = exp2(log2(max((((1.0f - (_148 * 2.0f)) * _155) + _148), 9.999999974752427e-07f)) * _156);
  float _180 = exp2(log2(max(((_155 * (1.0f - (_110.x * 2.0f))) + _110.x), 9.999999974752427e-07f)) * _156);
  float _190 = ((1.0f - (_178 * 2.0f)) * _155) + _178;
  float _191 = ((1.0f - (_179 * 2.0f)) * _155) + _179;
  float _192 = ((1.0f - (_180 * 2.0f)) * _155) + _180;
  float _202 = (exp2(log2(max(VAR_FilmGrain_Contrast, 9.999999974752427e-07f)) * 10.0f) * -1428.26806640625f) + -14.426950454711914f;
  float _224 = ((saturate(1.0f / (exp2(_202 * (_190 + -0.5f)) + 1.0f)) - _190) * VAR_FilmGrain_Contrast) + _190;
  float _225 = ((saturate(1.0f / (exp2(_202 * (_191 + -0.5f)) + 1.0f)) - _191) * VAR_FilmGrain_Contrast) + _191;
  float _226 = ((saturate(1.0f / (exp2(_202 * (_192 + -0.5f)) + 1.0f)) - _192) * VAR_FilmGrain_Contrast) + _192;
  [branch]
  if (VAR_FilmDamage_Opacity > 0.0f) {
    float _239 = (frac(_46 * 0.44094499945640564f) + _81) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.x * VAR_FilmDamage_Size));
    float _240 = (frac(_46 * 0.5511810183525085f) + _79) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.y * VAR_FilmDamage_Size));
    float4 _250 = FilmDamage_Texture.SampleGrad(BilinearWrap, float2(_239, _240), float2((ddx_coarse(_239) * cbr.x), (ddx_coarse(_240) * cbr.x)), float2((ddy_coarse(_239) * cbr.y), (ddy_coarse(_240) * cbr.y)), int2(0, 0));
    _254 = (_250.x * VAR_FilmDamage_Opacity);
  } else {
    _254 = 0.0f;
  }
  float _256 = 1.0f - VAR_FilmDamage_Curve;
  float _261 = select((_256 < 0.5f), 0.0f, 1.0f);
  float _270 = exp2(log2(max((((1.0f - (_254 * 2.0f)) * _261) + _254), 9.999999974752427e-07f)) * (1.0f - abs((_256 * 2.0f) + -0.9960784316062927f)));
  float _274 = ((1.0f - (_270 * 2.0f)) * _261) + _270;
  uint _306 = uint(float((uint)(int)(distortionType)));
  bool _311 = (LDRPPSettings_enabled != 0);
  bool _312 = ((cPassEnabled & 1) != 0);
  if (!(_312 && _311)) {
    float4 _322 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _572 = (min(_322.x, 65000.0f) * Exposure);
    _573 = (min(_322.y, 65000.0f) * Exposure);
    _574 = (min(_322.z, 65000.0f) * Exposure);
  } else {
    if (_306 == 0) {
      float _340 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _341 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _342 = dot(float2(_340, _341), float2(_340, _341));
      float _344 = (_342 * fDistortionCoef) + 1.0f;
      float _345 = _340 * fCorrectCoef;
      float _347 = _341 * fCorrectCoef;
      float _349 = (_345 * _344) + 0.5f;
      float _350 = (_347 * _344) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _355 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_349, _350));
        _572 = (_355.x * Exposure);
        _573 = (_355.y * Exposure);
        _574 = (_355.z * Exposure);
      } else {
        float _374 = ((saturate((sqrt((_340 * _340) + (_341 * _341)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _384 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _385 = _374 * 2.0f;
          float _389 = (((_384 * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _394 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_389 * _345) + 0.5f), ((_389 * _347) + 0.5f)));
          float _400 = ((((_384 + 0.125f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _405 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_400 * _345) + 0.5f), ((_400 * _347) + 0.5f)));
          float _412 = ((((_384 + 0.25f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _417 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_412 * _345) + 0.5f), ((_412 * _347) + 0.5f)));
          float _426 = ((((_384 + 0.375f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _431 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_426 * _345) + 0.5f), ((_426 * _347) + 0.5f)));
          float _440 = ((((_384 + 0.5f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _445 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_440 * _345) + 0.5f), ((_440 * _347) + 0.5f)));
          float _451 = ((((_384 + 0.625f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _456 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_451 * _345) + 0.5f), ((_451 * _347) + 0.5f)));
          float _464 = ((((_384 + 0.75f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _469 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_464 * _345) + 0.5f), ((_464 * _347) + 0.5f)));
          float _484 = ((((_384 + 0.875f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _489 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_484 * _345) + 0.5f), ((_484 * _347) + 0.5f)));
          float _496 = ((((_384 + 1.0f) * _385) + _342) * fDistortionCoef) + 1.0f;
          float4 _501 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_496 * _345) + 0.5f), ((_496 * _347) + 0.5f)));
          float _504 = Exposure * 0.3199999928474426f;
          _572 = ((((_405.x + _394.x) + (_417.x * 0.75f)) + (_431.x * 0.375f)) * _504);
          _573 = ((Exposure * 0.3636363744735718f) * ((((_456.y + _431.y) * 0.625f) + _445.y) + ((_469.y + _417.y) * 0.25f)));
          _574 = (((((_469.z * 0.75f) + (_456.z * 0.375f)) + _489.z) + _501.z) * _504);
        } else {
          float _510 = _374 + _342;
          float _512 = (_510 * fDistortionCoef) + 1.0f;
          float _519 = ((_510 + _374) * fDistortionCoef) + 1.0f;
          float4 _524 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_349, _350));
          float4 _527 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_512 * _345) + 0.5f), ((_512 * _347) + 0.5f)));
          float4 _530 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_519 * _345) + 0.5f), ((_519 * _347) + 0.5f)));
          _572 = (_524.x * Exposure);
          _573 = (_527.y * Exposure);
          _574 = (_530.z * Exposure);
        }
      }
    } else {
      if (_306 == 1) {
        float _543 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _547 = sqrt((_543 * _543) + 1.0f);
        float _548 = 1.0f / _547;
        float _556 = ((_547 * fOptimizedParam.z) * (_548 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _564 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_556 * _543) + 0.5f), (((_556 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_548 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _572 = (_564.x * Exposure);
        _573 = (_564.y * Exposure);
        _574 = (_564.z * Exposure);
      } else {
        _572 = 0.0f;
        _573 = 0.0f;
        _574 = 0.0f;
      }
    }
  }
  if (_311 && (bool)((cPassEnabled & 32) != 0)) {
    float _614 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _618 = ComputeResultSRV[0].computeAlpha;
    float _621 = ((1.0f - _614) + (_618 * _614)) * cbRadialColor.w;
    if (!(_621 == 0.0f)) {
      float _627 = screenInverseSize.x * SV_Position.x;
      float _628 = screenInverseSize.y * SV_Position.y;
      float _630 = _627 + (-0.5f - cbRadialScreenPos.x);
      float _632 = _628 + (-0.5f - cbRadialScreenPos.y);
      float _635 = select((_630 < 0.0f), (1.0f - _627), _627);
      float _638 = select((_632 < 0.0f), (1.0f - _628), _628);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _644 = rsqrt(dot(float2(_630, _632), float2(_630, _632))) * cbRadialSharpRange;
          uint _651 = uint(abs(_644 * _632)) + uint(abs(_644 * _630));
          uint _655 = ((_651 ^ 61) ^ ((uint)(_651) >> 16)) * 9;
          uint _658 = (((uint)(_655) >> 4) ^ _655) * 668265261;
          _664 = (float((uint)((int)(((uint)(_658) >> 15) ^ _658))) * 2.3283064365386963e-10f);
        } else {
          _664 = 1.0f;
        }
        float _668 = sqrt((_630 * _630) + (_632 * _632));
        float _670 = 1.0f / max(1.0f, _668);
        float _671 = _664 * _635;
        float _672 = cbRadialBlurPower * _670;
        float _673 = _672 * -0.0011111111380159855f;
        float _675 = _664 * _638;
        float _679 = ((_673 * _671) + 1.0f) * _630;
        float _680 = ((_673 * _675) + 1.0f) * _632;
        float _682 = _672 * -0.002222222276031971f;
        float _687 = ((_682 * _671) + 1.0f) * _630;
        float _688 = ((_682 * _675) + 1.0f) * _632;
        float _689 = _672 * -0.0033333334140479565f;
        float _694 = ((_689 * _671) + 1.0f) * _630;
        float _695 = ((_689 * _675) + 1.0f) * _632;
        float _696 = _672 * -0.004444444552063942f;
        float _701 = ((_696 * _671) + 1.0f) * _630;
        float _702 = ((_696 * _675) + 1.0f) * _632;
        float _703 = _672 * -0.0055555556900799274f;
        float _708 = ((_703 * _671) + 1.0f) * _630;
        float _709 = ((_703 * _675) + 1.0f) * _632;
        float _710 = _672 * -0.006666666828095913f;
        float _715 = ((_710 * _671) + 1.0f) * _630;
        float _716 = ((_710 * _675) + 1.0f) * _632;
        float _717 = _672 * -0.007777777966111898f;
        float _722 = ((_717 * _671) + 1.0f) * _630;
        float _723 = ((_717 * _675) + 1.0f) * _632;
        float _724 = _672 * -0.008888889104127884f;
        float _729 = ((_724 * _671) + 1.0f) * _630;
        float _730 = ((_724 * _675) + 1.0f) * _632;
        float _733 = _670 * ((cbRadialBlurPower * -0.009999999776482582f) * _664);
        float _738 = ((_733 * _635) + 1.0f) * _630;
        float _739 = ((_733 * _638) + 1.0f) * _632;
        do {
          if (_312 && (bool)(_306 == 0)) {
            float _741 = _679 + cbRadialScreenPos.x;
            float _742 = _680 + cbRadialScreenPos.y;
            float _746 = ((dot(float2(_741, _742), float2(_741, _742)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _752 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_746 * _741) + 0.5f), ((_746 * _742) + 0.5f)), 0.0f);
            float _756 = _687 + cbRadialScreenPos.x;
            float _757 = _688 + cbRadialScreenPos.y;
            float _761 = ((dot(float2(_756, _757), float2(_756, _757)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _766 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_761 * _756) + 0.5f), ((_761 * _757) + 0.5f)), 0.0f);
            float _773 = _694 + cbRadialScreenPos.x;
            float _774 = _695 + cbRadialScreenPos.y;
            float _778 = ((dot(float2(_773, _774), float2(_773, _774)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _783 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_778 * _773) + 0.5f), ((_778 * _774) + 0.5f)), 0.0f);
            float _790 = _701 + cbRadialScreenPos.x;
            float _791 = _702 + cbRadialScreenPos.y;
            float _795 = ((dot(float2(_790, _791), float2(_790, _791)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _800 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_795 * _790) + 0.5f), ((_795 * _791) + 0.5f)), 0.0f);
            float _807 = _708 + cbRadialScreenPos.x;
            float _808 = _709 + cbRadialScreenPos.y;
            float _812 = ((dot(float2(_807, _808), float2(_807, _808)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _817 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_812 * _807) + 0.5f), ((_812 * _808) + 0.5f)), 0.0f);
            float _824 = _715 + cbRadialScreenPos.x;
            float _825 = _716 + cbRadialScreenPos.y;
            float _829 = ((dot(float2(_824, _825), float2(_824, _825)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _834 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_829 * _824) + 0.5f), ((_829 * _825) + 0.5f)), 0.0f);
            float _841 = _722 + cbRadialScreenPos.x;
            float _842 = _723 + cbRadialScreenPos.y;
            float _846 = ((dot(float2(_841, _842), float2(_841, _842)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _851 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_846 * _841) + 0.5f), ((_846 * _842) + 0.5f)), 0.0f);
            float _858 = _729 + cbRadialScreenPos.x;
            float _859 = _730 + cbRadialScreenPos.y;
            float _863 = ((dot(float2(_858, _859), float2(_858, _859)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _868 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_863 * _858) + 0.5f), ((_863 * _859) + 0.5f)), 0.0f);
            float _875 = _738 + cbRadialScreenPos.x;
            float _876 = _739 + cbRadialScreenPos.y;
            float _880 = ((dot(float2(_875, _876), float2(_875, _876)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _885 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_880 * _875) + 0.5f), ((_880 * _876) + 0.5f)), 0.0f);
            _1219 = ((((((((_766.x + _752.x) + _783.x) + _800.x) + _817.x) + _834.x) + _851.x) + _868.x) + _885.x);
            _1220 = ((((((((_766.y + _752.y) + _783.y) + _800.y) + _817.y) + _834.y) + _851.y) + _868.y) + _885.y);
            _1221 = ((((((((_766.z + _752.z) + _783.z) + _800.z) + _817.z) + _834.z) + _851.z) + _868.z) + _885.z);
          } else {
            float _893 = cbRadialScreenPos.x + 0.5f;
            float _894 = _679 + _893;
            float _895 = cbRadialScreenPos.y + 0.5f;
            float _896 = _680 + _895;
            float _897 = _687 + _893;
            float _898 = _688 + _895;
            float _899 = _694 + _893;
            float _900 = _695 + _895;
            float _901 = _701 + _893;
            float _902 = _702 + _895;
            float _903 = _708 + _893;
            float _904 = _709 + _895;
            float _905 = _715 + _893;
            float _906 = _716 + _895;
            float _907 = _722 + _893;
            float _908 = _723 + _895;
            float _909 = _729 + _893;
            float _910 = _730 + _895;
            float _911 = _738 + _893;
            float _912 = _739 + _895;
            if (_312 && (bool)(_306 == 1)) {
              float _916 = (_894 * 2.0f) + -1.0f;
              float _920 = sqrt((_916 * _916) + 1.0f);
              float _921 = 1.0f / _920;
              float _928 = fOptimizedParam.w * 0.5f;
              float _929 = ((_920 * fOptimizedParam.z) * (_921 + fOptimizedParam.x)) * _928;
              float4 _936 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_929 * _916) + 0.5f), (((_929 * ((_896 * 2.0f) + -1.0f)) * (((_921 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _942 = (_897 * 2.0f) + -1.0f;
              float _946 = sqrt((_942 * _942) + 1.0f);
              float _947 = 1.0f / _946;
              float _954 = ((_946 * fOptimizedParam.z) * (_947 + fOptimizedParam.x)) * _928;
              float4 _960 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_954 * _942) + 0.5f), (((_954 * ((_898 * 2.0f) + -1.0f)) * (((_947 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _969 = (_899 * 2.0f) + -1.0f;
              float _973 = sqrt((_969 * _969) + 1.0f);
              float _974 = 1.0f / _973;
              float _981 = ((_973 * fOptimizedParam.z) * (_974 + fOptimizedParam.x)) * _928;
              float4 _987 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_981 * _969) + 0.5f), (((_981 * ((_900 * 2.0f) + -1.0f)) * (((_974 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _996 = (_901 * 2.0f) + -1.0f;
              float _1000 = sqrt((_996 * _996) + 1.0f);
              float _1001 = 1.0f / _1000;
              float _1008 = ((_1000 * fOptimizedParam.z) * (_1001 + fOptimizedParam.x)) * _928;
              float4 _1014 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1008 * _996) + 0.5f), (((_1008 * ((_902 * 2.0f) + -1.0f)) * (((_1001 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1023 = (_903 * 2.0f) + -1.0f;
              float _1027 = sqrt((_1023 * _1023) + 1.0f);
              float _1028 = 1.0f / _1027;
              float _1035 = ((_1027 * fOptimizedParam.z) * (_1028 + fOptimizedParam.x)) * _928;
              float4 _1041 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1035 * _1023) + 0.5f), (((_1035 * ((_904 * 2.0f) + -1.0f)) * (((_1028 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1050 = (_905 * 2.0f) + -1.0f;
              float _1054 = sqrt((_1050 * _1050) + 1.0f);
              float _1055 = 1.0f / _1054;
              float _1062 = ((_1054 * fOptimizedParam.z) * (_1055 + fOptimizedParam.x)) * _928;
              float4 _1068 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1062 * _1050) + 0.5f), (((_1062 * ((_906 * 2.0f) + -1.0f)) * (((_1055 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1077 = (_907 * 2.0f) + -1.0f;
              float _1081 = sqrt((_1077 * _1077) + 1.0f);
              float _1082 = 1.0f / _1081;
              float _1089 = ((_1081 * fOptimizedParam.z) * (_1082 + fOptimizedParam.x)) * _928;
              float4 _1095 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1089 * _1077) + 0.5f), (((_1089 * ((_908 * 2.0f) + -1.0f)) * (((_1082 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1104 = (_909 * 2.0f) + -1.0f;
              float _1108 = sqrt((_1104 * _1104) + 1.0f);
              float _1109 = 1.0f / _1108;
              float _1116 = ((_1108 * fOptimizedParam.z) * (_1109 + fOptimizedParam.x)) * _928;
              float4 _1122 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1116 * _1104) + 0.5f), (((_1116 * ((_910 * 2.0f) + -1.0f)) * (((_1109 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1131 = (_911 * 2.0f) + -1.0f;
              float _1135 = sqrt((_1131 * _1131) + 1.0f);
              float _1136 = 1.0f / _1135;
              float _1143 = ((_1135 * fOptimizedParam.z) * (_1136 + fOptimizedParam.x)) * _928;
              float4 _1149 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1143 * _1131) + 0.5f), (((_1143 * ((_912 * 2.0f) + -1.0f)) * (((_1136 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1219 = ((((((((_960.x + _936.x) + _987.x) + _1014.x) + _1041.x) + _1068.x) + _1095.x) + _1122.x) + _1149.x);
              _1220 = ((((((((_960.y + _936.y) + _987.y) + _1014.y) + _1041.y) + _1068.y) + _1095.y) + _1122.y) + _1149.y);
              _1221 = ((((((((_960.z + _936.z) + _987.z) + _1014.z) + _1041.z) + _1068.z) + _1095.z) + _1122.z) + _1149.z);
            } else {
              float4 _1158 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_894, _896), 0.0f);
              float4 _1162 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_897, _898), 0.0f);
              float4 _1169 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_899, _900), 0.0f);
              float4 _1176 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_901, _902), 0.0f);
              float4 _1183 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_903, _904), 0.0f);
              float4 _1190 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_905, _906), 0.0f);
              float4 _1197 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_907, _908), 0.0f);
              float4 _1204 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_909, _910), 0.0f);
              float4 _1211 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_911, _912), 0.0f);
              _1219 = ((((((((_1162.x + _1158.x) + _1169.x) + _1176.x) + _1183.x) + _1190.x) + _1197.x) + _1204.x) + _1211.x);
              _1220 = ((((((((_1162.y + _1158.y) + _1169.y) + _1176.y) + _1183.y) + _1190.y) + _1197.y) + _1204.y) + _1211.y);
              _1221 = ((((((((_1162.z + _1158.z) + _1169.z) + _1176.z) + _1183.z) + _1190.z) + _1197.z) + _1204.z) + _1211.z);
            }
          }
          float _1231 = (cbRadialColor.z * (_574 + (Exposure * _1221))) * 0.10000000149011612f;
          float _1232 = (cbRadialColor.y * (_573 + (Exposure * _1220))) * 0.10000000149011612f;
          float _1233 = (cbRadialColor.x * (_572 + (Exposure * _1219))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1238 = saturate((_668 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1244 = (((_1238 * _1238) * cbRadialMaskRate.x) * (3.0f - (_1238 * 2.0f))) + cbRadialMaskRate.y;
              _1255 = ((_1244 * (_1233 - _572)) + _572);
              _1256 = ((_1244 * (_1232 - _573)) + _573);
              _1257 = ((_1244 * (_1231 - _574)) + _574);
            } else {
              _1255 = _1233;
              _1256 = _1232;
              _1257 = _1231;
            }
            _1268 = (lerp(_572, _1255, _621));
            _1269 = (lerp(_573, _1256, _621));
            _1270 = (lerp(_574, _1257, _621));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1268 = _572;
      _1269 = _573;
      _1270 = _574;
    }
  } else {
    _1268 = _572;
    _1269 = _573;
    _1270 = _574;
  }
  if (_311 && (bool)((cPassEnabled & 2) != 0)) {
    float _1278 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1280 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1286 = frac(frac((_1280 * 0.005837149918079376f) + (_1278 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1286 < fNoiseDensity) {
        int _1291 = (uint)(uint(_1280 * _1278)) ^ 12345391;
        uint _1292 = _1291 * 3635641;
        _1300 = (float((uint)((int)((((uint)(_1292) >> 26) | ((uint)(_1291 * 232681024))) ^ _1292))) * 2.3283064365386963e-10f);
      } else {
        _1300 = 0.0f;
      }
      float _1302 = frac(_1286 * 757.4846801757812f);
      do {
        if (_1302 < fNoiseDensity) {
          int _1306 = asint(_1302) ^ 12345391;
          uint _1307 = _1306 * 3635641;
          _1316 = ((float((uint)((int)((((uint)(_1307) >> 26) | ((uint)(_1306 * 232681024))) ^ _1307))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1316 = 0.0f;
        }
        float _1318 = frac(_1302 * 757.4846801757812f);
        do {
          if (_1318 < fNoiseDensity) {
            int _1322 = asint(_1318) ^ 12345391;
            uint _1323 = _1322 * 3635641;
            _1332 = ((float((uint)((int)((((uint)(_1323) >> 26) | ((uint)(_1322 * 232681024))) ^ _1323))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1332 = 0.0f;
          }
          float _1333 = _1300 * fNoisePower.x * CUSTOM_NOISE;
          float _1334 = _1332 * fNoisePower.y * CUSTOM_NOISE;
          float _1335 = _1316 * fNoisePower.y * CUSTOM_NOISE;
          float _1349 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1268), saturate(_1269), saturate(_1270)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1360 = ((_1349 * (mad(_1335, 1.4019999504089355f, _1333) - _1268)) + _1268);
          _1361 = ((_1349 * (mad(_1335, -0.7139999866485596f, mad(_1334, -0.3440000116825104f, _1333)) - _1269)) + _1269);
          _1362 = ((_1349 * (mad(_1334, 1.7719999551773071f, _1333) - _1270)) + _1270);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1360 = _1268;
    _1361 = _1269;
    _1362 = _1270;
  }
  float _1377 = mad(_1362, (fOCIOTransformMatrix[2].x), mad(_1361, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1360)));
  float _1380 = mad(_1362, (fOCIOTransformMatrix[2].y), mad(_1361, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1360)));
  float _1383 = mad(_1362, (fOCIOTransformMatrix[2].z), mad(_1361, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1360)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1389 = max(max(_1377, _1380), _1383);
    if (!(_1389 == 0.0f)) {
      float _1395 = abs(_1389);
      float _1396 = (_1389 - _1377) / _1395;
      float _1397 = (_1389 - _1380) / _1395;
      float _1398 = (_1389 - _1383) / _1395;
      do {
        if (!(!(_1396 >= cbControlRGCParam.CyanThreshold))) {
          float _1408 = _1396 - cbControlRGCParam.CyanThreshold;
          _1420 = ((_1408 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1408) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1420 = _1396;
        }
        do {
          if (!(!(_1397 >= cbControlRGCParam.MagentaThreshold))) {
            float _1429 = _1397 - cbControlRGCParam.MagentaThreshold;
            _1441 = ((_1429 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1429) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1441 = _1397;
          }
          do {
            if (!(!(_1398 >= cbControlRGCParam.YellowThreshold))) {
              float _1449 = _1398 - cbControlRGCParam.YellowThreshold;
              _1461 = ((_1449 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1449) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1461 = _1398;
            }
            _1469 = (_1389 - (_1420 * _1395));
            _1470 = (_1389 - (_1441 * _1395));
            _1471 = (_1389 - (_1461 * _1395));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1469 = _1377;
      _1470 = _1380;
      _1471 = _1383;
    }
  } else {
    _1469 = _1377;
    _1470 = _1380;
    _1471 = _1383;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _311,
        cPassEnabled,
        _1469,
        _1470,
        _1471,
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
        _1698,
        _1699,
        _1700);
  #else
  if (_311 && (bool)((cPassEnabled & 4) != 0)) {
    float _1522 = (((log2(select((_1469 < 3.0517578125e-05f), ((_1469 * 0.5f) + 1.52587890625e-05f), _1469)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1523 = (((log2(select((_1470 < 3.0517578125e-05f), ((_1470 * 0.5f) + 1.52587890625e-05f), _1470)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1524 = (((log2(select((_1471 < 3.0517578125e-05f), ((_1471 * 0.5f) + 1.52587890625e-05f), _1471)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1527 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1522, _1523, _1524), 0.0f);
    float _1540 = max(exp2((_1527.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1541 = max(exp2((_1527.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1542 = max(exp2((_1527.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1544 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1547 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1522, _1523, _1524), 0.0f);
        float _1569 = ((max(exp2((_1547.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1540) * fTextureBlendRate) + _1540;
        float _1570 = ((max(exp2((_1547.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1541) * fTextureBlendRate) + _1541;
        float _1571 = ((max(exp2((_1547.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1542) * fTextureBlendRate) + _1542;
        if (_1544) {
          float4 _1601 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1569 < 3.0517578125e-05f), ((_1569 * 0.5f) + 1.52587890625e-05f), _1569)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1570 < 3.0517578125e-05f), ((_1570 * 0.5f) + 1.52587890625e-05f), _1570)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1571 < 3.0517578125e-05f), ((_1571 * 0.5f) + 1.52587890625e-05f), _1571)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1682 = (((max(exp2((_1601.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1569) * fTextureBlendRate2) + _1569);
          _1683 = (((max(exp2((_1601.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1570) * fTextureBlendRate2) + _1570);
          _1684 = (((max(exp2((_1601.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1571) * fTextureBlendRate2) + _1571);
        } else {
          _1682 = _1569;
          _1683 = _1570;
          _1684 = _1571;
        }
      } else {
        if (_1544) {
          float4 _1656 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1540 < 3.0517578125e-05f), ((_1540 * 0.5f) + 1.52587890625e-05f), _1540)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1541 < 3.0517578125e-05f), ((_1541 * 0.5f) + 1.52587890625e-05f), _1541)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1542 < 3.0517578125e-05f), ((_1542 * 0.5f) + 1.52587890625e-05f), _1542)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1682 = (((max(exp2((_1656.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1540) * fTextureBlendRate2) + _1540);
          _1683 = (((max(exp2((_1656.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1541) * fTextureBlendRate2) + _1541);
          _1684 = (((max(exp2((_1656.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1542) * fTextureBlendRate2) + _1542);
        } else {
          _1682 = _1540;
          _1683 = _1541;
          _1684 = _1542;
        }
      }
      _1698 = (mad(_1684, (fColorMatrix[2].x), mad(_1683, (fColorMatrix[1].x), (_1682 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1699 = (mad(_1684, (fColorMatrix[2].y), mad(_1683, (fColorMatrix[1].y), (_1682 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1700 = (mad(_1684, (fColorMatrix[2].z), mad(_1683, (fColorMatrix[1].z), (_1682 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1698 = _1469;
    _1699 = _1470;
    _1700 = _1471;
  }
  #endif
  if (_311 && (bool)((cPassEnabled & 8) != 0)) {
    _1733 = (((cvdR.x * _1698) + (cvdR.y * _1699)) + (cvdR.z * _1700));
    _1734 = (((cvdG.x * _1698) + (cvdG.y * _1699)) + (cvdG.z * _1700));
    _1735 = (((cvdB.x * _1698) + (cvdB.y * _1699)) + (cvdB.z * _1700));
  } else {
    _1733 = _1698;
    _1734 = _1699;
    _1735 = _1700;
  }
  float _1739 = screenInverseSize.x * SV_Position.x;
  float _1740 = screenInverseSize.y * SV_Position.y;
  float4 _1746 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1739, _1740), 0.0f);
  if (_311 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1760 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1739, _1740), 0.0f);
    float _1766 = ColorParam.x * _1746.x;
    float _1767 = ColorParam.y * _1746.y;
    float _1768 = ColorParam.z * _1746.z;
    float _1773 = (ColorParam.w * _1746.w) * saturate((_1760.x * Levels_Rate) + Levels_Range);
    do {
      if (_1766 < 0.5f) {
        _1785 = ((_1733 * 2.0f) * _1766);
      } else {
        _1785 = (1.0f - (((1.0f - _1733) * 2.0f) * (1.0f - _1766)));
      }
      do {
        if (_1767 < 0.5f) {
          _1797 = ((_1734 * 2.0f) * _1767);
        } else {
          _1797 = (1.0f - (((1.0f - _1734) * 2.0f) * (1.0f - _1767)));
        }
        do {
          if (_1768 < 0.5f) {
            _1809 = ((_1735 * 2.0f) * _1768);
          } else {
            _1809 = (1.0f - (((1.0f - _1735) * 2.0f) * (1.0f - _1768)));
          }
          _1820 = (lerp(_1733, _1785, _1773));
          _1821 = (lerp(_1734, _1797, _1773));
          _1822 = (lerp(_1735, _1809, _1773));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1820 = _1733;
    _1821 = _1734;
    _1822 = _1735;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _1862 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _1822, mad((RGBToXYZViaCrosstalkMatrix[0].y), _1821, ((RGBToXYZViaCrosstalkMatrix[0].x) * _1820)));
      float _1865 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _1822, mad((RGBToXYZViaCrosstalkMatrix[1].y), _1821, ((RGBToXYZViaCrosstalkMatrix[1].x) * _1820)));
      float _1870 = (_1865 + _1862) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _1822, mad((RGBToXYZViaCrosstalkMatrix[2].y), _1821, ((RGBToXYZViaCrosstalkMatrix[2].x) * _1820)));
      float _1871 = _1862 / _1870;
      float _1872 = _1865 / _1870;
      do {
        if (_1865 < curve_HDRip) {
          _1883 = (_1865 * exposureScale);
        } else {
          _1883 = ((log2((_1865 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _1885 = (_1871 / _1872) * _1883;
        float _1889 = (((1.0f - _1871) - _1872) / _1872) * _1883;
        _1938 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _1889, mad((XYZToRGBViaCrosstalkMatrix[0].y), _1883, (_1885 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _1939 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _1889, mad((XYZToRGBViaCrosstalkMatrix[1].y), _1883, (_1885 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _1940 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _1889, mad((XYZToRGBViaCrosstalkMatrix[2].y), _1883, (_1885 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_1820 < curve_HDRip) {
          _1916 = (exposureScale * _1820);
        } else {
          _1916 = ((log2((_1820 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_1821 < curve_HDRip) {
            _1927 = (exposureScale * _1821);
          } else {
            _1927 = ((log2((_1821 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_1822 < curve_HDRip) {
            _1938 = _1916;
            _1939 = _1927;
            _1940 = (exposureScale * _1822);
          } else {
            _1938 = _1916;
            _1939 = _1927;
            _1940 = ((log2((_1822 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _1938 = _1820;
    _1939 = _1821;
    _1940 = _1822;
  }
  float _1958 = ((saturate(1.0f / (exp2(((_274 + -0.5f) * -1.4426950216293335f) * ((exp2(log2(max(VAR_FilmDamage_Contrast, 9.999999974752427e-07f)) * 10.0f) * 990.0f) + 10.0f)) + 1.0f)) - _274) * VAR_FilmDamage_Contrast) + _274;
  if (_1938 < 0.5f) {
    _1970 = ((_224 * 2.0f) * _1938);
  } else {
    _1970 = (1.0f - (((1.0f - _224) * 2.0f) * (1.0f - _1938)));
  }
  if (_1939 < 0.5f) {
    _1982 = ((_225 * 2.0f) * _1939);
  } else {
    _1982 = (1.0f - (((1.0f - _225) * 2.0f) * (1.0f - _1939)));
  }
  if (_1940 < 0.5f) {
    _1994 = ((_226 * 2.0f) * _1940);
  } else {
    _1994 = (1.0f - (((1.0f - _226) * 2.0f) * (1.0f - _1940)));
  }
  float _2003 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1970 - _1938)) + _1938;
  float _2004 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1982 - _1939)) + _1939;
  float _2005 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1994 - _1940)) + _1940;
  float _2016 = ((VAR_FilmDamage_Color.x - _2003) * _1958) + _2003;
  float _2017 = ((VAR_FilmDamage_Color.y - _2004) * _1958) + _2004;
  float _2018 = ((VAR_FilmDamage_Color.z - _2005) * _1958) + _2005;
  float _2026 = ((_224 - _2016) * VAR_Debug_FilmGrain_Texture) + _2016;
  float _2027 = ((_225 - _2017) * VAR_Debug_FilmGrain_Texture) + _2017;
  float _2028 = ((_226 - _2018) * VAR_Debug_FilmGrain_Texture) + _2018;
  SV_Target.x = (lerp(_2026, _1958, VAR_Debug_FilmDamage_Texture));
  SV_Target.y = (lerp(_2027, _1958, VAR_Debug_FilmDamage_Texture));
  SV_Target.z = (lerp(_2028, _1958, VAR_Debug_FilmDamage_Texture));
  SV_Target.w = 1.0f;
  return SV_Target;
}
