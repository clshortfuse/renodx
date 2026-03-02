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

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b4) {
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

cbuffer LDRPostProcessParam : register(b5) {
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

cbuffer CBControl : register(b6) {
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

cbuffer UserShaderLDRPostProcessSettings : register(b7) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b8) {
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
  float _50 = (float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Animation_RefreshRate;
  float _52 = floor(_50);
  float _56 = _52 * 0.5f;
  float _57 = floor(_50 * 0.5f) * 0.5f;
  float _64 = frac(abs(_56));
  float _65 = frac(abs(_57));
  float _85 = ((select((_57 >= (-0.0f - _57)), _65, (-0.0f - _65)) * 4.0f) + -1.0f) * ((screenInverseSize.y * SV_Position.y) + -0.5f);
  float _87 = ((screenSize.x / screenSize.y) * ((screenInverseSize.x * SV_Position.x) + -0.5f)) * ((select((_56 >= (-0.0f - _56)), _64, (-0.0f - _64)) * 4.0f) + -1.0f);
  float _101 = (_87 + frac(_52 * 0.4274809956550598f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.x));
  float _102 = (_85 + frac(_52 * 0.5725190043449402f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.y));
  float4 _116 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_101, _102), float2((cbr.x * ddx_coarse(_101)), (cbr.x * ddx_coarse(_102))), float2((cbr.y * ddy_coarse(_101)), (cbr.y * ddy_coarse(_102))), int2(0, 0));
  float _153;
  float _154;
  float _260;
  float _358;
  float _628;
  float _629;
  float _630;
  float _706;
  float _770;
  float _1325;
  float _1326;
  float _1327;
  float _1361;
  float _1362;
  float _1363;
  float _1374;
  float _1375;
  float _1376;
  float _1406;
  float _1422;
  float _1438;
  float _1466;
  float _1467;
  float _1468;
  float _1526;
  float _1547;
  float _1567;
  float _1575;
  float _1576;
  float _1577;
  float _1788;
  float _1789;
  float _1790;
  float _1804;
  float _1805;
  float _1806;
  float _1839;
  float _1840;
  float _1841;
  float _1891;
  float _1903;
  float _1915;
  float _1926;
  float _1927;
  float _1928;
  float _1989;
  float _2022;
  float _2033;
  float _2044;
  float _2045;
  float _2046;
  float _2076;
  float _2088;
  float _2100;
  [branch]
  if (VAR_FilmGrain_Saturate > 0.0f) {
    float _122 = _101 + 0.3330000042915344f;
    float _123 = _102 + 0.6660000085830688f;
    float _124 = _101 + 0.6660000085830688f;
    float _125 = _102 + 0.3330000042915344f;
    float4 _134 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_122, _123), float2((ddx_coarse(_122) * cbr.x), (ddx_coarse(_123) * cbr.x)), float2((ddy_coarse(_122) * cbr.y), (ddy_coarse(_123) * cbr.y)), int2(0, 0));
    float4 _144 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_124, _125), float2((ddx_coarse(_124) * cbr.x), (ddx_coarse(_125) * cbr.x)), float2((ddy_coarse(_124) * cbr.y), (ddy_coarse(_125) * cbr.y)), int2(0, 0));
    _153 = (lerp(_116.x, _134.x, VAR_FilmGrain_Saturate));
    _154 = (lerp(_116.x, _144.x, VAR_FilmGrain_Saturate));
  } else {
    _153 = _116.x;
    _154 = _116.x;
  }
  float _156 = 1.0f - VAR_FilmGrain_Curve;
  float _161 = select((_156 < 0.5f), 0.0f, 1.0f);
  float _162 = 1.0f - abs((_156 * 2.0f) + -0.9960784316062927f);
  float _184 = exp2(log2(max((((1.0f - (_153 * 2.0f)) * _161) + _153), 9.999999974752427e-07f)) * _162);
  float _185 = exp2(log2(max((((1.0f - (_154 * 2.0f)) * _161) + _154), 9.999999974752427e-07f)) * _162);
  float _186 = exp2(log2(max(((_161 * (1.0f - (_116.x * 2.0f))) + _116.x), 9.999999974752427e-07f)) * _162);
  float _196 = ((1.0f - (_184 * 2.0f)) * _161) + _184;
  float _197 = ((1.0f - (_185 * 2.0f)) * _161) + _185;
  float _198 = ((1.0f - (_186 * 2.0f)) * _161) + _186;
  float _208 = (exp2(log2(max(VAR_FilmGrain_Contrast, 9.999999974752427e-07f)) * 10.0f) * -1428.26806640625f) + -14.426950454711914f;
  float _230 = ((saturate(1.0f / (exp2(_208 * (_196 + -0.5f)) + 1.0f)) - _196) * VAR_FilmGrain_Contrast) + _196;
  float _231 = ((saturate(1.0f / (exp2(_208 * (_197 + -0.5f)) + 1.0f)) - _197) * VAR_FilmGrain_Contrast) + _197;
  float _232 = ((saturate(1.0f / (exp2(_208 * (_198 + -0.5f)) + 1.0f)) - _198) * VAR_FilmGrain_Contrast) + _198;
  [branch]
  if (VAR_FilmDamage_Opacity > 0.0f) {
    float _245 = (frac(_52 * 0.44094499945640564f) + _87) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.x * VAR_FilmDamage_Size));
    float _246 = (frac(_52 * 0.5511810183525085f) + _85) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.y * VAR_FilmDamage_Size));
    float4 _256 = FilmDamage_Texture.SampleGrad(BilinearWrap, float2(_245, _246), float2((ddx_coarse(_245) * cbr.x), (ddx_coarse(_246) * cbr.x)), float2((ddy_coarse(_245) * cbr.y), (ddy_coarse(_246) * cbr.y)), int2(0, 0));
    _260 = (_256.x * VAR_FilmDamage_Opacity);
  } else {
    _260 = 0.0f;
  }
  float _262 = 1.0f - VAR_FilmDamage_Curve;
  float _267 = select((_262 < 0.5f), 0.0f, 1.0f);
  float _276 = exp2(log2(max((((1.0f - (_260 * 2.0f)) * _267) + _260), 9.999999974752427e-07f)) * (1.0f - abs((_262 * 2.0f) + -0.9960784316062927f)));
  float _280 = ((1.0f - (_276 * 2.0f)) * _267) + _276;
  [branch]
  if (film_aspect == 0.0f) {
    float _319 = Kerare.x / Kerare.w;
    float _320 = Kerare.y / Kerare.w;
    float _321 = Kerare.z / Kerare.w;
    float _325 = abs(rsqrt(dot(float3(_319, _320, _321), float3(_319, _320, _321))) * _321);
    float _330 = _325 * _325;
    _358 = ((_330 * _330) * (1.0f - saturate((_325 * kerare_scale) + kerare_offset)));
  } else {
    float _341 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _343 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _345 = sqrt(dot(float2(_343, _341), float2(_343, _341)));
    float _353 = (_345 * _345) + 1.0f;
    _358 = ((1.0f / (_353 * _353)) * (1.0f - saturate(((1.0f / (_345 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _361 = saturate(_358 + kerare_brightness) * Exposure;
  uint _362 = uint(float((uint)(int)(distortionType)));
  bool _367 = (LDRPPSettings_enabled != 0);
  bool _368 = ((cPassEnabled & 1) != 0);
  if (!(_368 && _367)) {
    float4 _378 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _628 = (min(_378.x, 65000.0f) * _361);
    _629 = (min(_378.y, 65000.0f) * _361);
    _630 = (min(_378.z, 65000.0f) * _361);
  } else {
    if (_362 == 0) {
      float _396 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _397 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _398 = dot(float2(_396, _397), float2(_396, _397));
      float _400 = (_398 * fDistortionCoef) + 1.0f;
      float _401 = _396 * fCorrectCoef;
      float _403 = _397 * fCorrectCoef;
      float _405 = (_401 * _400) + 0.5f;
      float _406 = (_403 * _400) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _411 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_405, _406));
        _628 = (_411.x * _361);
        _629 = (_411.y * _361);
        _630 = (_411.z * _361);
      } else {
        float _430 = ((saturate((sqrt((_396 * _396) + (_397 * _397)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _440 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _441 = _430 * 2.0f;
          float _445 = (((_440 * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _450 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_445 * _401) + 0.5f), ((_445 * _403) + 0.5f)));
          float _456 = ((((_440 + 0.125f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _461 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_456 * _401) + 0.5f), ((_456 * _403) + 0.5f)));
          float _468 = ((((_440 + 0.25f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _473 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_468 * _401) + 0.5f), ((_468 * _403) + 0.5f)));
          float _482 = ((((_440 + 0.375f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _487 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_482 * _401) + 0.5f), ((_482 * _403) + 0.5f)));
          float _496 = ((((_440 + 0.5f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _501 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_496 * _401) + 0.5f), ((_496 * _403) + 0.5f)));
          float _507 = ((((_440 + 0.625f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _512 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_507 * _401) + 0.5f), ((_507 * _403) + 0.5f)));
          float _520 = ((((_440 + 0.75f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _525 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_520 * _401) + 0.5f), ((_520 * _403) + 0.5f)));
          float _540 = ((((_440 + 0.875f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _545 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_540 * _401) + 0.5f), ((_540 * _403) + 0.5f)));
          float _552 = ((((_440 + 1.0f) * _441) + _398) * fDistortionCoef) + 1.0f;
          float4 _557 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_552 * _401) + 0.5f), ((_552 * _403) + 0.5f)));
          float _560 = _361 * 0.3199999928474426f;
          _628 = ((((_461.x + _450.x) + (_473.x * 0.75f)) + (_487.x * 0.375f)) * _560);
          _629 = ((_361 * 0.3636363744735718f) * ((((_512.y + _487.y) * 0.625f) + _501.y) + ((_525.y + _473.y) * 0.25f)));
          _630 = (((((_525.z * 0.75f) + (_512.z * 0.375f)) + _545.z) + _557.z) * _560);
        } else {
          float _566 = _430 + _398;
          float _568 = (_566 * fDistortionCoef) + 1.0f;
          float _575 = ((_566 + _430) * fDistortionCoef) + 1.0f;
          float4 _580 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_405, _406));
          float4 _583 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_568 * _401) + 0.5f), ((_568 * _403) + 0.5f)));
          float4 _586 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_575 * _401) + 0.5f), ((_575 * _403) + 0.5f)));
          _628 = (_580.x * _361);
          _629 = (_583.y * _361);
          _630 = (_586.z * _361);
        }
      }
    } else {
      if (_362 == 1) {
        float _599 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _603 = sqrt((_599 * _599) + 1.0f);
        float _604 = 1.0f / _603;
        float _612 = ((_603 * fOptimizedParam.z) * (_604 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _620 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_612 * _599) + 0.5f), (((_612 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_604 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _628 = (_620.x * _361);
        _629 = (_620.y * _361);
        _630 = (_620.z * _361);
      } else {
        _628 = 0.0f;
        _629 = 0.0f;
        _630 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _667 = Kerare.x / Kerare.w;
    float _668 = Kerare.y / Kerare.w;
    float _669 = Kerare.z / Kerare.w;
    float _673 = abs(rsqrt(dot(float3(_667, _668, _669), float3(_667, _668, _669))) * _669);
    float _678 = _673 * _673;
    _706 = ((_678 * _678) * (1.0f - saturate((_673 * kerare_scale) + kerare_offset)));
  } else {
    float _689 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _691 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _693 = sqrt(dot(float2(_691, _689), float2(_691, _689)));
    float _701 = (_693 * _693) + 1.0f;
    _706 = ((1.0f / (_701 * _701)) * (1.0f - saturate(((1.0f / (_693 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _709 = saturate(_706 + kerare_brightness) * Exposure;
  if (_367 && (bool)((cPassEnabled & 32) != 0)) {
    float _720 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _724 = ComputeResultSRV[0].computeAlpha;
    float _727 = ((1.0f - _720) + (_724 * _720)) * cbRadialColor.w;
    if (!(_727 == 0.0f)) {
      float _733 = screenInverseSize.x * SV_Position.x;
      float _734 = screenInverseSize.y * SV_Position.y;
      float _736 = _733 + (-0.5f - cbRadialScreenPos.x);
      float _738 = _734 + (-0.5f - cbRadialScreenPos.y);
      float _741 = select((_736 < 0.0f), (1.0f - _733), _733);
      float _744 = select((_738 < 0.0f), (1.0f - _734), _734);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _750 = rsqrt(dot(float2(_736, _738), float2(_736, _738))) * cbRadialSharpRange;
          uint _757 = uint(abs(_750 * _738)) + uint(abs(_750 * _736));
          uint _761 = ((_757 ^ 61) ^ ((uint)(_757) >> 16)) * 9;
          uint _764 = (((uint)(_761) >> 4) ^ _761) * 668265261;
          _770 = (float((uint)((int)(((uint)(_764) >> 15) ^ _764))) * 2.3283064365386963e-10f);
        } else {
          _770 = 1.0f;
        }
        float _774 = sqrt((_736 * _736) + (_738 * _738));
        float _776 = 1.0f / max(1.0f, _774);
        float _777 = _770 * _741;
        float _778 = cbRadialBlurPower * _776;
        float _779 = _778 * -0.0011111111380159855f;
        float _781 = _770 * _744;
        float _785 = ((_779 * _777) + 1.0f) * _736;
        float _786 = ((_779 * _781) + 1.0f) * _738;
        float _788 = _778 * -0.002222222276031971f;
        float _793 = ((_788 * _777) + 1.0f) * _736;
        float _794 = ((_788 * _781) + 1.0f) * _738;
        float _795 = _778 * -0.0033333334140479565f;
        float _800 = ((_795 * _777) + 1.0f) * _736;
        float _801 = ((_795 * _781) + 1.0f) * _738;
        float _802 = _778 * -0.004444444552063942f;
        float _807 = ((_802 * _777) + 1.0f) * _736;
        float _808 = ((_802 * _781) + 1.0f) * _738;
        float _809 = _778 * -0.0055555556900799274f;
        float _814 = ((_809 * _777) + 1.0f) * _736;
        float _815 = ((_809 * _781) + 1.0f) * _738;
        float _816 = _778 * -0.006666666828095913f;
        float _821 = ((_816 * _777) + 1.0f) * _736;
        float _822 = ((_816 * _781) + 1.0f) * _738;
        float _823 = _778 * -0.007777777966111898f;
        float _828 = ((_823 * _777) + 1.0f) * _736;
        float _829 = ((_823 * _781) + 1.0f) * _738;
        float _830 = _778 * -0.008888889104127884f;
        float _835 = ((_830 * _777) + 1.0f) * _736;
        float _836 = ((_830 * _781) + 1.0f) * _738;
        float _839 = _776 * ((cbRadialBlurPower * -0.009999999776482582f) * _770);
        float _844 = ((_839 * _741) + 1.0f) * _736;
        float _845 = ((_839 * _744) + 1.0f) * _738;
        do {
          if (_368 && (bool)(_362 == 0)) {
            float _847 = _785 + cbRadialScreenPos.x;
            float _848 = _786 + cbRadialScreenPos.y;
            float _852 = ((dot(float2(_847, _848), float2(_847, _848)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _858 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_852 * _847) + 0.5f), ((_852 * _848) + 0.5f)), 0.0f);
            float _862 = _793 + cbRadialScreenPos.x;
            float _863 = _794 + cbRadialScreenPos.y;
            float _867 = ((dot(float2(_862, _863), float2(_862, _863)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _872 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_867 * _862) + 0.5f), ((_867 * _863) + 0.5f)), 0.0f);
            float _879 = _800 + cbRadialScreenPos.x;
            float _880 = _801 + cbRadialScreenPos.y;
            float _884 = ((dot(float2(_879, _880), float2(_879, _880)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _889 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_884 * _879) + 0.5f), ((_884 * _880) + 0.5f)), 0.0f);
            float _896 = _807 + cbRadialScreenPos.x;
            float _897 = _808 + cbRadialScreenPos.y;
            float _901 = ((dot(float2(_896, _897), float2(_896, _897)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _906 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_901 * _896) + 0.5f), ((_901 * _897) + 0.5f)), 0.0f);
            float _913 = _814 + cbRadialScreenPos.x;
            float _914 = _815 + cbRadialScreenPos.y;
            float _918 = ((dot(float2(_913, _914), float2(_913, _914)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _923 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_918 * _913) + 0.5f), ((_918 * _914) + 0.5f)), 0.0f);
            float _930 = _821 + cbRadialScreenPos.x;
            float _931 = _822 + cbRadialScreenPos.y;
            float _935 = ((dot(float2(_930, _931), float2(_930, _931)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _940 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_935 * _930) + 0.5f), ((_935 * _931) + 0.5f)), 0.0f);
            float _947 = _828 + cbRadialScreenPos.x;
            float _948 = _829 + cbRadialScreenPos.y;
            float _952 = ((dot(float2(_947, _948), float2(_947, _948)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _957 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_952 * _947) + 0.5f), ((_952 * _948) + 0.5f)), 0.0f);
            float _964 = _835 + cbRadialScreenPos.x;
            float _965 = _836 + cbRadialScreenPos.y;
            float _969 = ((dot(float2(_964, _965), float2(_964, _965)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _974 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_969 * _964) + 0.5f), ((_969 * _965) + 0.5f)), 0.0f);
            float _981 = _844 + cbRadialScreenPos.x;
            float _982 = _845 + cbRadialScreenPos.y;
            float _986 = ((dot(float2(_981, _982), float2(_981, _982)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _991 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_986 * _981) + 0.5f), ((_986 * _982) + 0.5f)), 0.0f);
            _1325 = ((((((((_872.x + _858.x) + _889.x) + _906.x) + _923.x) + _940.x) + _957.x) + _974.x) + _991.x);
            _1326 = ((((((((_872.y + _858.y) + _889.y) + _906.y) + _923.y) + _940.y) + _957.y) + _974.y) + _991.y);
            _1327 = ((((((((_872.z + _858.z) + _889.z) + _906.z) + _923.z) + _940.z) + _957.z) + _974.z) + _991.z);
          } else {
            float _999 = cbRadialScreenPos.x + 0.5f;
            float _1000 = _785 + _999;
            float _1001 = cbRadialScreenPos.y + 0.5f;
            float _1002 = _786 + _1001;
            float _1003 = _793 + _999;
            float _1004 = _794 + _1001;
            float _1005 = _800 + _999;
            float _1006 = _801 + _1001;
            float _1007 = _807 + _999;
            float _1008 = _808 + _1001;
            float _1009 = _814 + _999;
            float _1010 = _815 + _1001;
            float _1011 = _821 + _999;
            float _1012 = _822 + _1001;
            float _1013 = _828 + _999;
            float _1014 = _829 + _1001;
            float _1015 = _835 + _999;
            float _1016 = _836 + _1001;
            float _1017 = _844 + _999;
            float _1018 = _845 + _1001;
            if (_368 && (bool)(_362 == 1)) {
              float _1022 = (_1000 * 2.0f) + -1.0f;
              float _1026 = sqrt((_1022 * _1022) + 1.0f);
              float _1027 = 1.0f / _1026;
              float _1034 = fOptimizedParam.w * 0.5f;
              float _1035 = ((_1026 * fOptimizedParam.z) * (_1027 + fOptimizedParam.x)) * _1034;
              float4 _1042 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1035 * _1022) + 0.5f), (((_1035 * ((_1002 * 2.0f) + -1.0f)) * (((_1027 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1048 = (_1003 * 2.0f) + -1.0f;
              float _1052 = sqrt((_1048 * _1048) + 1.0f);
              float _1053 = 1.0f / _1052;
              float _1060 = ((_1052 * fOptimizedParam.z) * (_1053 + fOptimizedParam.x)) * _1034;
              float4 _1066 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1060 * _1048) + 0.5f), (((_1060 * ((_1004 * 2.0f) + -1.0f)) * (((_1053 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1075 = (_1005 * 2.0f) + -1.0f;
              float _1079 = sqrt((_1075 * _1075) + 1.0f);
              float _1080 = 1.0f / _1079;
              float _1087 = ((_1079 * fOptimizedParam.z) * (_1080 + fOptimizedParam.x)) * _1034;
              float4 _1093 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1087 * _1075) + 0.5f), (((_1087 * ((_1006 * 2.0f) + -1.0f)) * (((_1080 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1102 = (_1007 * 2.0f) + -1.0f;
              float _1106 = sqrt((_1102 * _1102) + 1.0f);
              float _1107 = 1.0f / _1106;
              float _1114 = ((_1106 * fOptimizedParam.z) * (_1107 + fOptimizedParam.x)) * _1034;
              float4 _1120 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1114 * _1102) + 0.5f), (((_1114 * ((_1008 * 2.0f) + -1.0f)) * (((_1107 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1129 = (_1009 * 2.0f) + -1.0f;
              float _1133 = sqrt((_1129 * _1129) + 1.0f);
              float _1134 = 1.0f / _1133;
              float _1141 = ((_1133 * fOptimizedParam.z) * (_1134 + fOptimizedParam.x)) * _1034;
              float4 _1147 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1141 * _1129) + 0.5f), (((_1141 * ((_1010 * 2.0f) + -1.0f)) * (((_1134 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1156 = (_1011 * 2.0f) + -1.0f;
              float _1160 = sqrt((_1156 * _1156) + 1.0f);
              float _1161 = 1.0f / _1160;
              float _1168 = ((_1160 * fOptimizedParam.z) * (_1161 + fOptimizedParam.x)) * _1034;
              float4 _1174 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1168 * _1156) + 0.5f), (((_1168 * ((_1012 * 2.0f) + -1.0f)) * (((_1161 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1183 = (_1013 * 2.0f) + -1.0f;
              float _1187 = sqrt((_1183 * _1183) + 1.0f);
              float _1188 = 1.0f / _1187;
              float _1195 = ((_1187 * fOptimizedParam.z) * (_1188 + fOptimizedParam.x)) * _1034;
              float4 _1201 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1195 * _1183) + 0.5f), (((_1195 * ((_1014 * 2.0f) + -1.0f)) * (((_1188 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1210 = (_1015 * 2.0f) + -1.0f;
              float _1214 = sqrt((_1210 * _1210) + 1.0f);
              float _1215 = 1.0f / _1214;
              float _1222 = ((_1214 * fOptimizedParam.z) * (_1215 + fOptimizedParam.x)) * _1034;
              float4 _1228 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1222 * _1210) + 0.5f), (((_1222 * ((_1016 * 2.0f) + -1.0f)) * (((_1215 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1237 = (_1017 * 2.0f) + -1.0f;
              float _1241 = sqrt((_1237 * _1237) + 1.0f);
              float _1242 = 1.0f / _1241;
              float _1249 = ((_1241 * fOptimizedParam.z) * (_1242 + fOptimizedParam.x)) * _1034;
              float4 _1255 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1249 * _1237) + 0.5f), (((_1249 * ((_1018 * 2.0f) + -1.0f)) * (((_1242 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1325 = ((((((((_1066.x + _1042.x) + _1093.x) + _1120.x) + _1147.x) + _1174.x) + _1201.x) + _1228.x) + _1255.x);
              _1326 = ((((((((_1066.y + _1042.y) + _1093.y) + _1120.y) + _1147.y) + _1174.y) + _1201.y) + _1228.y) + _1255.y);
              _1327 = ((((((((_1066.z + _1042.z) + _1093.z) + _1120.z) + _1147.z) + _1174.z) + _1201.z) + _1228.z) + _1255.z);
            } else {
              float4 _1264 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1000, _1002), 0.0f);
              float4 _1268 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1003, _1004), 0.0f);
              float4 _1275 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1005, _1006), 0.0f);
              float4 _1282 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1007, _1008), 0.0f);
              float4 _1289 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1009, _1010), 0.0f);
              float4 _1296 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1011, _1012), 0.0f);
              float4 _1303 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1013, _1014), 0.0f);
              float4 _1310 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1015, _1016), 0.0f);
              float4 _1317 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1017, _1018), 0.0f);
              _1325 = ((((((((_1268.x + _1264.x) + _1275.x) + _1282.x) + _1289.x) + _1296.x) + _1303.x) + _1310.x) + _1317.x);
              _1326 = ((((((((_1268.y + _1264.y) + _1275.y) + _1282.y) + _1289.y) + _1296.y) + _1303.y) + _1310.y) + _1317.y);
              _1327 = ((((((((_1268.z + _1264.z) + _1275.z) + _1282.z) + _1289.z) + _1296.z) + _1303.z) + _1310.z) + _1317.z);
            }
          }
          float _1337 = (cbRadialColor.z * (_630 + (_709 * _1327))) * 0.10000000149011612f;
          float _1338 = (cbRadialColor.y * (_629 + (_709 * _1326))) * 0.10000000149011612f;
          float _1339 = (cbRadialColor.x * (_628 + (_709 * _1325))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1344 = saturate((_774 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1350 = (((_1344 * _1344) * cbRadialMaskRate.x) * (3.0f - (_1344 * 2.0f))) + cbRadialMaskRate.y;
              _1361 = ((_1350 * (_1339 - _628)) + _628);
              _1362 = ((_1350 * (_1338 - _629)) + _629);
              _1363 = ((_1350 * (_1337 - _630)) + _630);
            } else {
              _1361 = _1339;
              _1362 = _1338;
              _1363 = _1337;
            }
            _1374 = (lerp(_628, _1361, _727));
            _1375 = (lerp(_629, _1362, _727));
            _1376 = (lerp(_630, _1363, _727));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1374 = _628;
      _1375 = _629;
      _1376 = _630;
    }
  } else {
    _1374 = _628;
    _1375 = _629;
    _1376 = _630;
  }
  if (_367 && (bool)((cPassEnabled & 2) != 0)) {
    float _1384 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1386 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1392 = frac(frac((_1386 * 0.005837149918079376f) + (_1384 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1392 < fNoiseDensity) {
        int _1397 = (uint)(uint(_1386 * _1384)) ^ 12345391;
        uint _1398 = _1397 * 3635641;
        _1406 = (float((uint)((int)((((uint)(_1398) >> 26) | ((uint)(_1397 * 232681024))) ^ _1398))) * 2.3283064365386963e-10f);
      } else {
        _1406 = 0.0f;
      }
      float _1408 = frac(_1392 * 757.4846801757812f);
      do {
        if (_1408 < fNoiseDensity) {
          int _1412 = asint(_1408) ^ 12345391;
          uint _1413 = _1412 * 3635641;
          _1422 = ((float((uint)((int)((((uint)(_1413) >> 26) | ((uint)(_1412 * 232681024))) ^ _1413))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1422 = 0.0f;
        }
        float _1424 = frac(_1408 * 757.4846801757812f);
        do {
          if (_1424 < fNoiseDensity) {
            int _1428 = asint(_1424) ^ 12345391;
            uint _1429 = _1428 * 3635641;
            _1438 = ((float((uint)((int)((((uint)(_1429) >> 26) | ((uint)(_1428 * 232681024))) ^ _1429))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1438 = 0.0f;
          }
          float _1439 = _1406 * fNoisePower.x * CUSTOM_NOISE;
          float _1440 = _1438 * fNoisePower.y * CUSTOM_NOISE;
          float _1441 = _1422 * fNoisePower.y * CUSTOM_NOISE;
          float _1455 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1374), saturate(_1375), saturate(_1376)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1466 = ((_1455 * (mad(_1441, 1.4019999504089355f, _1439) - _1374)) + _1374);
          _1467 = ((_1455 * (mad(_1441, -0.7139999866485596f, mad(_1440, -0.3440000116825104f, _1439)) - _1375)) + _1375);
          _1468 = ((_1455 * (mad(_1440, 1.7719999551773071f, _1439) - _1376)) + _1376);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1466 = _1374;
    _1467 = _1375;
    _1468 = _1376;
  }
  float _1483 = mad(_1468, (fOCIOTransformMatrix[2].x), mad(_1467, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1466)));
  float _1486 = mad(_1468, (fOCIOTransformMatrix[2].y), mad(_1467, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1466)));
  float _1489 = mad(_1468, (fOCIOTransformMatrix[2].z), mad(_1467, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1466)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1495 = max(max(_1483, _1486), _1489);
    if (!(_1495 == 0.0f)) {
      float _1501 = abs(_1495);
      float _1502 = (_1495 - _1483) / _1501;
      float _1503 = (_1495 - _1486) / _1501;
      float _1504 = (_1495 - _1489) / _1501;
      do {
        if (!(!(_1502 >= cbControlRGCParam.CyanThreshold))) {
          float _1514 = _1502 - cbControlRGCParam.CyanThreshold;
          _1526 = ((_1514 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1514) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1526 = _1502;
        }
        do {
          if (!(!(_1503 >= cbControlRGCParam.MagentaThreshold))) {
            float _1535 = _1503 - cbControlRGCParam.MagentaThreshold;
            _1547 = ((_1535 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1535) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1547 = _1503;
          }
          do {
            if (!(!(_1504 >= cbControlRGCParam.YellowThreshold))) {
              float _1555 = _1504 - cbControlRGCParam.YellowThreshold;
              _1567 = ((_1555 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1555) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1567 = _1504;
            }
            _1575 = (_1495 - (_1526 * _1501));
            _1576 = (_1495 - (_1547 * _1501));
            _1577 = (_1495 - (_1567 * _1501));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1575 = _1483;
      _1576 = _1486;
      _1577 = _1489;
    }
  } else {
    _1575 = _1483;
    _1576 = _1486;
    _1577 = _1489;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _367,
        cPassEnabled,
        _1575,
        _1576,
        _1577,
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
        _1804,
        _1805,
        _1806);
  #else
  if (_367 && (bool)((cPassEnabled & 4) != 0)) {
    float _1628 = (((log2(select((_1575 < 3.0517578125e-05f), ((_1575 * 0.5f) + 1.52587890625e-05f), _1575)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1629 = (((log2(select((_1576 < 3.0517578125e-05f), ((_1576 * 0.5f) + 1.52587890625e-05f), _1576)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1630 = (((log2(select((_1577 < 3.0517578125e-05f), ((_1577 * 0.5f) + 1.52587890625e-05f), _1577)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1633 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1628, _1629, _1630), 0.0f);
    float _1646 = max(exp2((_1633.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1647 = max(exp2((_1633.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1648 = max(exp2((_1633.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1650 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1653 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1628, _1629, _1630), 0.0f);
        float _1675 = ((max(exp2((_1653.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1646) * fTextureBlendRate) + _1646;
        float _1676 = ((max(exp2((_1653.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1647) * fTextureBlendRate) + _1647;
        float _1677 = ((max(exp2((_1653.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1648) * fTextureBlendRate) + _1648;
        if (_1650) {
          float4 _1707 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1675 < 3.0517578125e-05f), ((_1675 * 0.5f) + 1.52587890625e-05f), _1675)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1676 < 3.0517578125e-05f), ((_1676 * 0.5f) + 1.52587890625e-05f), _1676)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1677 < 3.0517578125e-05f), ((_1677 * 0.5f) + 1.52587890625e-05f), _1677)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1788 = (((max(exp2((_1707.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1675) * fTextureBlendRate2) + _1675);
          _1789 = (((max(exp2((_1707.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1676) * fTextureBlendRate2) + _1676);
          _1790 = (((max(exp2((_1707.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1677) * fTextureBlendRate2) + _1677);
        } else {
          _1788 = _1675;
          _1789 = _1676;
          _1790 = _1677;
        }
      } else {
        if (_1650) {
          float4 _1762 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1646 < 3.0517578125e-05f), ((_1646 * 0.5f) + 1.52587890625e-05f), _1646)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1647 < 3.0517578125e-05f), ((_1647 * 0.5f) + 1.52587890625e-05f), _1647)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1648 < 3.0517578125e-05f), ((_1648 * 0.5f) + 1.52587890625e-05f), _1648)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1788 = (((max(exp2((_1762.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1646) * fTextureBlendRate2) + _1646);
          _1789 = (((max(exp2((_1762.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1647) * fTextureBlendRate2) + _1647);
          _1790 = (((max(exp2((_1762.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1648) * fTextureBlendRate2) + _1648);
        } else {
          _1788 = _1646;
          _1789 = _1647;
          _1790 = _1648;
        }
      }
      _1804 = (mad(_1790, (fColorMatrix[2].x), mad(_1789, (fColorMatrix[1].x), (_1788 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1805 = (mad(_1790, (fColorMatrix[2].y), mad(_1789, (fColorMatrix[1].y), (_1788 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1806 = (mad(_1790, (fColorMatrix[2].z), mad(_1789, (fColorMatrix[1].z), (_1788 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1804 = _1575;
    _1805 = _1576;
    _1806 = _1577;
  }
  #endif
  if (_367 && (bool)((cPassEnabled & 8) != 0)) {
    _1839 = (((cvdR.x * _1804) + (cvdR.y * _1805)) + (cvdR.z * _1806));
    _1840 = (((cvdG.x * _1804) + (cvdG.y * _1805)) + (cvdG.z * _1806));
    _1841 = (((cvdB.x * _1804) + (cvdB.y * _1805)) + (cvdB.z * _1806));
  } else {
    _1839 = _1804;
    _1840 = _1805;
    _1841 = _1806;
  }
  float _1845 = screenInverseSize.x * SV_Position.x;
  float _1846 = screenInverseSize.y * SV_Position.y;
  float4 _1852 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1845, _1846), 0.0f);
  if (_367 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1866 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1845, _1846), 0.0f);
    float _1872 = ColorParam.x * _1852.x;
    float _1873 = ColorParam.y * _1852.y;
    float _1874 = ColorParam.z * _1852.z;
    float _1879 = (ColorParam.w * _1852.w) * saturate((_1866.x * Levels_Rate) + Levels_Range);
    do {
      if (_1872 < 0.5f) {
        _1891 = ((_1839 * 2.0f) * _1872);
      } else {
        _1891 = (1.0f - (((1.0f - _1839) * 2.0f) * (1.0f - _1872)));
      }
      do {
        if (_1873 < 0.5f) {
          _1903 = ((_1840 * 2.0f) * _1873);
        } else {
          _1903 = (1.0f - (((1.0f - _1840) * 2.0f) * (1.0f - _1873)));
        }
        do {
          if (_1874 < 0.5f) {
            _1915 = ((_1841 * 2.0f) * _1874);
          } else {
            _1915 = (1.0f - (((1.0f - _1841) * 2.0f) * (1.0f - _1874)));
          }
          _1926 = (lerp(_1839, _1891, _1879));
          _1927 = (lerp(_1840, _1903, _1879));
          _1928 = (lerp(_1841, _1915, _1879));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1926 = _1839;
    _1927 = _1840;
    _1928 = _1841;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _1968 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _1928, mad((RGBToXYZViaCrosstalkMatrix[0].y), _1927, ((RGBToXYZViaCrosstalkMatrix[0].x) * _1926)));
      float _1971 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _1928, mad((RGBToXYZViaCrosstalkMatrix[1].y), _1927, ((RGBToXYZViaCrosstalkMatrix[1].x) * _1926)));
      float _1976 = (_1971 + _1968) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _1928, mad((RGBToXYZViaCrosstalkMatrix[2].y), _1927, ((RGBToXYZViaCrosstalkMatrix[2].x) * _1926)));
      float _1977 = _1968 / _1976;
      float _1978 = _1971 / _1976;
      do {
        if (_1971 < curve_HDRip) {
          _1989 = (_1971 * exposureScale);
        } else {
          _1989 = ((log2((_1971 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _1991 = (_1977 / _1978) * _1989;
        float _1995 = (((1.0f - _1977) - _1978) / _1978) * _1989;
        _2044 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _1995, mad((XYZToRGBViaCrosstalkMatrix[0].y), _1989, (_1991 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _2045 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _1995, mad((XYZToRGBViaCrosstalkMatrix[1].y), _1989, (_1991 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _2046 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _1995, mad((XYZToRGBViaCrosstalkMatrix[2].y), _1989, (_1991 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_1926 < curve_HDRip) {
          _2022 = (exposureScale * _1926);
        } else {
          _2022 = ((log2((_1926 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_1927 < curve_HDRip) {
            _2033 = (exposureScale * _1927);
          } else {
            _2033 = ((log2((_1927 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_1928 < curve_HDRip) {
            _2044 = _2022;
            _2045 = _2033;
            _2046 = (exposureScale * _1928);
          } else {
            _2044 = _2022;
            _2045 = _2033;
            _2046 = ((log2((_1928 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _2044 = _1926;
    _2045 = _1927;
    _2046 = _1928;
  }
  float _2064 = ((saturate(1.0f / (exp2(((_280 + -0.5f) * -1.4426950216293335f) * ((exp2(log2(max(VAR_FilmDamage_Contrast, 9.999999974752427e-07f)) * 10.0f) * 990.0f) + 10.0f)) + 1.0f)) - _280) * VAR_FilmDamage_Contrast) + _280;
  if (_2044 < 0.5f) {
    _2076 = ((_230 * 2.0f) * _2044);
  } else {
    _2076 = (1.0f - (((1.0f - _230) * 2.0f) * (1.0f - _2044)));
  }
  if (_2045 < 0.5f) {
    _2088 = ((_231 * 2.0f) * _2045);
  } else {
    _2088 = (1.0f - (((1.0f - _231) * 2.0f) * (1.0f - _2045)));
  }
  if (_2046 < 0.5f) {
    _2100 = ((_232 * 2.0f) * _2046);
  } else {
    _2100 = (1.0f - (((1.0f - _232) * 2.0f) * (1.0f - _2046)));
  }
  float _2109 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_2076 - _2044)) + _2044;
  float _2110 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_2088 - _2045)) + _2045;
  float _2111 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_2100 - _2046)) + _2046;
  float _2122 = ((VAR_FilmDamage_Color.x - _2109) * _2064) + _2109;
  float _2123 = ((VAR_FilmDamage_Color.y - _2110) * _2064) + _2110;
  float _2124 = ((VAR_FilmDamage_Color.z - _2111) * _2064) + _2111;
  float _2132 = ((_230 - _2122) * VAR_Debug_FilmGrain_Texture) + _2122;
  float _2133 = ((_231 - _2123) * VAR_Debug_FilmGrain_Texture) + _2123;
  float _2134 = ((_232 - _2124) * VAR_Debug_FilmGrain_Texture) + _2124;
  SV_Target.x = (lerp(_2132, _2064, VAR_Debug_FilmDamage_Texture));
  SV_Target.y = (lerp(_2133, _2064, VAR_Debug_FilmDamage_Texture));
  SV_Target.z = (lerp(_2134, _2064, VAR_Debug_FilmDamage_Texture));
  SV_Target.w = 1.0f;
  return SV_Target;
}
