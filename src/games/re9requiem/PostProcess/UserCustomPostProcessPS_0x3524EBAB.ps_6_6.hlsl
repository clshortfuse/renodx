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

cbuffer LDRPostProcessParam : register(b3) {
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

cbuffer CBControl : register(b4) {
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

cbuffer UserShaderLDRPostProcessSettings : register(b5) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b6) {
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
  float _41 = (float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Animation_RefreshRate;
  float _43 = floor(_41);
  float _47 = _43 * 0.5f;
  float _48 = floor(_41 * 0.5f) * 0.5f;
  float _55 = frac(abs(_47));
  float _56 = frac(abs(_48));
  float _76 = ((select((_48 >= (-0.0f - _48)), _56, (-0.0f - _56)) * 4.0f) + -1.0f) * ((screenInverseSize.y * SV_Position.y) + -0.5f);
  float _78 = ((screenSize.x / screenSize.y) * ((screenInverseSize.x * SV_Position.x) + -0.5f)) * ((select((_47 >= (-0.0f - _47)), _55, (-0.0f - _55)) * 4.0f) + -1.0f);
  float _92 = (_78 + frac(_43 * 0.4274809956550598f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.x));
  float _93 = (_76 + frac(_43 * 0.5725190043449402f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.y));
  float4 _107 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_92, _93), float2((cbr.x * ddx_coarse(_92)), (cbr.x * ddx_coarse(_93))), float2((cbr.y * ddy_coarse(_92)), (cbr.y * ddy_coarse(_93))), int2(0, 0));
  float _144;
  float _145;
  float _251;
  float _552;
  float _553;
  float _554;
  float _644;
  float _1199;
  float _1200;
  float _1201;
  float _1232;
  float _1233;
  float _1234;
  float _1245;
  float _1246;
  float _1247;
  float _1277;
  float _1293;
  float _1309;
  float _1337;
  float _1338;
  float _1339;
  float _1397;
  float _1418;
  float _1438;
  float _1446;
  float _1447;
  float _1448;
  float _1659;
  float _1660;
  float _1661;
  float _1675;
  float _1676;
  float _1677;
  float _1710;
  float _1711;
  float _1712;
  float _1762;
  float _1774;
  float _1786;
  float _1797;
  float _1798;
  float _1799;
  float _1829;
  float _1841;
  float _1853;
  [branch]
  if (VAR_FilmGrain_Saturate > 0.0f) {
    float _113 = _92 + 0.3330000042915344f;
    float _114 = _93 + 0.6660000085830688f;
    float _115 = _92 + 0.6660000085830688f;
    float _116 = _93 + 0.3330000042915344f;
    float4 _125 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_113, _114), float2((ddx_coarse(_113) * cbr.x), (ddx_coarse(_114) * cbr.x)), float2((ddy_coarse(_113) * cbr.y), (ddy_coarse(_114) * cbr.y)), int2(0, 0));
    float4 _135 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_115, _116), float2((ddx_coarse(_115) * cbr.x), (ddx_coarse(_116) * cbr.x)), float2((ddy_coarse(_115) * cbr.y), (ddy_coarse(_116) * cbr.y)), int2(0, 0));
    _144 = (lerp(_107.x, _125.x, VAR_FilmGrain_Saturate));
    _145 = (lerp(_107.x, _135.x, VAR_FilmGrain_Saturate));
  } else {
    _144 = _107.x;
    _145 = _107.x;
  }
  float _147 = 1.0f - VAR_FilmGrain_Curve;
  float _152 = select((_147 < 0.5f), 0.0f, 1.0f);
  float _153 = 1.0f - abs((_147 * 2.0f) + -0.9960784316062927f);
  float _175 = exp2(log2(max((((1.0f - (_144 * 2.0f)) * _152) + _144), 9.999999974752427e-07f)) * _153);
  float _176 = exp2(log2(max((((1.0f - (_145 * 2.0f)) * _152) + _145), 9.999999974752427e-07f)) * _153);
  float _177 = exp2(log2(max(((_152 * (1.0f - (_107.x * 2.0f))) + _107.x), 9.999999974752427e-07f)) * _153);
  float _187 = ((1.0f - (_175 * 2.0f)) * _152) + _175;
  float _188 = ((1.0f - (_176 * 2.0f)) * _152) + _176;
  float _189 = ((1.0f - (_177 * 2.0f)) * _152) + _177;
  float _199 = (exp2(log2(max(VAR_FilmGrain_Contrast, 9.999999974752427e-07f)) * 10.0f) * -1428.26806640625f) + -14.426950454711914f;
  float _221 = ((saturate(1.0f / (exp2(_199 * (_187 + -0.5f)) + 1.0f)) - _187) * VAR_FilmGrain_Contrast) + _187;
  float _222 = ((saturate(1.0f / (exp2(_199 * (_188 + -0.5f)) + 1.0f)) - _188) * VAR_FilmGrain_Contrast) + _188;
  float _223 = ((saturate(1.0f / (exp2(_199 * (_189 + -0.5f)) + 1.0f)) - _189) * VAR_FilmGrain_Contrast) + _189;
  [branch]
  if (VAR_FilmDamage_Opacity > 0.0f) {
    float _236 = (frac(_43 * 0.44094499945640564f) + _78) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.x * VAR_FilmDamage_Size));
    float _237 = (frac(_43 * 0.5511810183525085f) + _76) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.y * VAR_FilmDamage_Size));
    float4 _247 = FilmDamage_Texture.SampleGrad(BilinearWrap, float2(_236, _237), float2((ddx_coarse(_236) * cbr.x), (ddx_coarse(_237) * cbr.x)), float2((ddy_coarse(_236) * cbr.y), (ddy_coarse(_237) * cbr.y)), int2(0, 0));
    _251 = (_247.x * VAR_FilmDamage_Opacity);
  } else {
    _251 = 0.0f;
  }
  float _253 = 1.0f - VAR_FilmDamage_Curve;
  float _258 = select((_253 < 0.5f), 0.0f, 1.0f);
  float _267 = exp2(log2(max((((1.0f - (_251 * 2.0f)) * _258) + _251), 9.999999974752427e-07f)) * (1.0f - abs((_253 * 2.0f) + -0.9960784316062927f)));
  float _271 = ((1.0f - (_267 * 2.0f)) * _258) + _267;
  uint _303 = uint(float((uint)(int)(distortionType)));
  bool _308 = (LDRPPSettings_enabled != 0);
  bool _309 = ((cPassEnabled & 1) != 0);
  if (!(_309 && _308)) {
    float4 _319 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _552 = _319.x;
    _553 = _319.y;
    _554 = _319.z;
  } else {
    if (_303 == 0) {
      float _331 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _332 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _333 = dot(float2(_331, _332), float2(_331, _332));
      float _335 = (_333 * fDistortionCoef) + 1.0f;
      float _336 = _331 * fCorrectCoef;
      float _338 = _332 * fCorrectCoef;
      float _340 = (_336 * _335) + 0.5f;
      float _341 = (_338 * _335) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _346 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_340, _341));
        _552 = _346.x;
        _553 = _346.y;
        _554 = _346.z;
      } else {
        float _362 = ((saturate((sqrt((_331 * _331) + (_332 * _332)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        float _363 = _362 + _333;
        float _365 = (_363 * fDistortionCoef) + 1.0f;
        float _368 = ((_363 + _362) * fDistortionCoef) + 1.0f;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _378 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _379 = _362 * 2.0f;
          float _383 = (((_378 * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _388 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_383 * _336) + 0.5f), ((_383 * _338) + 0.5f)));
          float _394 = ((((_378 + 0.125f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _399 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_394 * _336) + 0.5f), ((_394 * _338) + 0.5f)));
          float _406 = ((((_378 + 0.25f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _411 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_406 * _336) + 0.5f), ((_406 * _338) + 0.5f)));
          float _420 = ((((_378 + 0.375f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _425 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_420 * _336) + 0.5f), ((_420 * _338) + 0.5f)));
          float _434 = ((((_378 + 0.5f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _439 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_434 * _336) + 0.5f), ((_434 * _338) + 0.5f)));
          float _445 = ((((_378 + 0.625f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _450 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_445 * _336) + 0.5f), ((_445 * _338) + 0.5f)));
          float _458 = ((((_378 + 0.75f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _463 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_458 * _336) + 0.5f), ((_458 * _338) + 0.5f)));
          float _478 = ((((_378 + 0.875f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _483 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_478 * _336) + 0.5f), ((_478 * _338) + 0.5f)));
          float _490 = ((((_378 + 1.0f) * _379) + _333) * fDistortionCoef) + 1.0f;
          float4 _495 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_490 * _336) + 0.5f), ((_490 * _338) + 0.5f)));
          _552 = ((((_399.x + _388.x) + (_411.x * 0.75f)) + (_425.x * 0.375f)) * 0.3199999928474426f);
          _553 = (((((_450.y + _425.y) * 0.625f) + _439.y) + ((_463.y + _411.y) * 0.25f)) * 0.3636363744735718f);
          _554 = (((((_463.z * 0.75f) + (_450.z * 0.375f)) + _483.z) + _495.z) * 0.3199999928474426f);
        } else {
          float4 _510 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_340, _341));
          float4 _512 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_365 * _336) + 0.5f), ((_365 * _338) + 0.5f)));
          float4 _514 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_368 * _336) + 0.5f), ((_368 * _338) + 0.5f)));
          _552 = _510.x;
          _553 = _512.y;
          _554 = _514.z;
        }
      }
    } else {
      if (_303 == 1) {
        float _526 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _530 = sqrt((_526 * _526) + 1.0f);
        float _531 = 1.0f / _530;
        float _539 = ((_530 * fOptimizedParam.z) * (_531 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _547 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_539 * _526) + 0.5f), (((_539 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_531 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _552 = _547.x;
        _553 = _547.y;
        _554 = _547.z;
      } else {
        _552 = 0.0f;
        _553 = 0.0f;
        _554 = 0.0f;
      }
    }
  }
  if (_308 && (bool)((cPassEnabled & 32) != 0)) {
    float _594 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _598 = ComputeResultSRV[0].computeAlpha;
    float _601 = ((1.0f - _594) + (_598 * _594)) * cbRadialColor.w;
    if (!(_601 == 0.0f)) {
      float _607 = screenInverseSize.x * SV_Position.x;
      float _608 = screenInverseSize.y * SV_Position.y;
      float _610 = _607 + (-0.5f - cbRadialScreenPos.x);
      float _612 = _608 + (-0.5f - cbRadialScreenPos.y);
      float _615 = select((_610 < 0.0f), (1.0f - _607), _607);
      float _618 = select((_612 < 0.0f), (1.0f - _608), _608);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _624 = rsqrt(dot(float2(_610, _612), float2(_610, _612))) * cbRadialSharpRange;
          uint _631 = uint(abs(_624 * _612)) + uint(abs(_624 * _610));
          uint _635 = ((_631 ^ 61) ^ ((uint)(_631) >> 16)) * 9;
          uint _638 = (((uint)(_635) >> 4) ^ _635) * 668265261;
          _644 = (float((uint)((int)(((uint)(_638) >> 15) ^ _638))) * 2.3283064365386963e-10f);
        } else {
          _644 = 1.0f;
        }
        float _648 = sqrt((_610 * _610) + (_612 * _612));
        float _650 = 1.0f / max(1.0f, _648);
        float _651 = _644 * _615;
        float _652 = cbRadialBlurPower * _650;
        float _653 = _652 * -0.0011111111380159855f;
        float _655 = _644 * _618;
        float _659 = ((_653 * _651) + 1.0f) * _610;
        float _660 = ((_653 * _655) + 1.0f) * _612;
        float _662 = _652 * -0.002222222276031971f;
        float _667 = ((_662 * _651) + 1.0f) * _610;
        float _668 = ((_662 * _655) + 1.0f) * _612;
        float _669 = _652 * -0.0033333334140479565f;
        float _674 = ((_669 * _651) + 1.0f) * _610;
        float _675 = ((_669 * _655) + 1.0f) * _612;
        float _676 = _652 * -0.004444444552063942f;
        float _681 = ((_676 * _651) + 1.0f) * _610;
        float _682 = ((_676 * _655) + 1.0f) * _612;
        float _683 = _652 * -0.0055555556900799274f;
        float _688 = ((_683 * _651) + 1.0f) * _610;
        float _689 = ((_683 * _655) + 1.0f) * _612;
        float _690 = _652 * -0.006666666828095913f;
        float _695 = ((_690 * _651) + 1.0f) * _610;
        float _696 = ((_690 * _655) + 1.0f) * _612;
        float _697 = _652 * -0.007777777966111898f;
        float _702 = ((_697 * _651) + 1.0f) * _610;
        float _703 = ((_697 * _655) + 1.0f) * _612;
        float _704 = _652 * -0.008888889104127884f;
        float _709 = ((_704 * _651) + 1.0f) * _610;
        float _710 = ((_704 * _655) + 1.0f) * _612;
        float _713 = _650 * ((cbRadialBlurPower * -0.009999999776482582f) * _644);
        float _718 = ((_713 * _615) + 1.0f) * _610;
        float _719 = ((_713 * _618) + 1.0f) * _612;
        do {
          if (_309 && (bool)(_303 == 0)) {
            float _721 = _659 + cbRadialScreenPos.x;
            float _722 = _660 + cbRadialScreenPos.y;
            float _726 = ((dot(float2(_721, _722), float2(_721, _722)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _732 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_726 * _721) + 0.5f), ((_726 * _722) + 0.5f)), 0.0f);
            float _736 = _667 + cbRadialScreenPos.x;
            float _737 = _668 + cbRadialScreenPos.y;
            float _741 = ((dot(float2(_736, _737), float2(_736, _737)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _746 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_741 * _736) + 0.5f), ((_741 * _737) + 0.5f)), 0.0f);
            float _753 = _674 + cbRadialScreenPos.x;
            float _754 = _675 + cbRadialScreenPos.y;
            float _758 = ((dot(float2(_753, _754), float2(_753, _754)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _763 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_758 * _753) + 0.5f), ((_758 * _754) + 0.5f)), 0.0f);
            float _770 = _681 + cbRadialScreenPos.x;
            float _771 = _682 + cbRadialScreenPos.y;
            float _775 = ((dot(float2(_770, _771), float2(_770, _771)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _780 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_775 * _770) + 0.5f), ((_775 * _771) + 0.5f)), 0.0f);
            float _787 = _688 + cbRadialScreenPos.x;
            float _788 = _689 + cbRadialScreenPos.y;
            float _792 = ((dot(float2(_787, _788), float2(_787, _788)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _797 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_792 * _787) + 0.5f), ((_792 * _788) + 0.5f)), 0.0f);
            float _804 = _695 + cbRadialScreenPos.x;
            float _805 = _696 + cbRadialScreenPos.y;
            float _809 = ((dot(float2(_804, _805), float2(_804, _805)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _814 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_809 * _804) + 0.5f), ((_809 * _805) + 0.5f)), 0.0f);
            float _821 = _702 + cbRadialScreenPos.x;
            float _822 = _703 + cbRadialScreenPos.y;
            float _826 = ((dot(float2(_821, _822), float2(_821, _822)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _831 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_826 * _821) + 0.5f), ((_826 * _822) + 0.5f)), 0.0f);
            float _838 = _709 + cbRadialScreenPos.x;
            float _839 = _710 + cbRadialScreenPos.y;
            float _843 = ((dot(float2(_838, _839), float2(_838, _839)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _848 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_843 * _838) + 0.5f), ((_843 * _839) + 0.5f)), 0.0f);
            float _855 = _718 + cbRadialScreenPos.x;
            float _856 = _719 + cbRadialScreenPos.y;
            float _860 = ((dot(float2(_855, _856), float2(_855, _856)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _865 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_860 * _855) + 0.5f), ((_860 * _856) + 0.5f)), 0.0f);
            _1199 = ((((((((_746.x + _732.x) + _763.x) + _780.x) + _797.x) + _814.x) + _831.x) + _848.x) + _865.x);
            _1200 = ((((((((_746.y + _732.y) + _763.y) + _780.y) + _797.y) + _814.y) + _831.y) + _848.y) + _865.y);
            _1201 = ((((((((_746.z + _732.z) + _763.z) + _780.z) + _797.z) + _814.z) + _831.z) + _848.z) + _865.z);
          } else {
            float _873 = cbRadialScreenPos.x + 0.5f;
            float _874 = _659 + _873;
            float _875 = cbRadialScreenPos.y + 0.5f;
            float _876 = _660 + _875;
            float _877 = _667 + _873;
            float _878 = _668 + _875;
            float _879 = _674 + _873;
            float _880 = _675 + _875;
            float _881 = _681 + _873;
            float _882 = _682 + _875;
            float _883 = _688 + _873;
            float _884 = _689 + _875;
            float _885 = _695 + _873;
            float _886 = _696 + _875;
            float _887 = _702 + _873;
            float _888 = _703 + _875;
            float _889 = _709 + _873;
            float _890 = _710 + _875;
            float _891 = _718 + _873;
            float _892 = _719 + _875;
            if (_309 && (bool)(_303 == 1)) {
              float _896 = (_874 * 2.0f) + -1.0f;
              float _900 = sqrt((_896 * _896) + 1.0f);
              float _901 = 1.0f / _900;
              float _908 = fOptimizedParam.w * 0.5f;
              float _909 = ((_900 * fOptimizedParam.z) * (_901 + fOptimizedParam.x)) * _908;
              float4 _916 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_909 * _896) + 0.5f), (((_909 * ((_876 * 2.0f) + -1.0f)) * (((_901 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _922 = (_877 * 2.0f) + -1.0f;
              float _926 = sqrt((_922 * _922) + 1.0f);
              float _927 = 1.0f / _926;
              float _934 = ((_926 * fOptimizedParam.z) * (_927 + fOptimizedParam.x)) * _908;
              float4 _940 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_934 * _922) + 0.5f), (((_934 * ((_878 * 2.0f) + -1.0f)) * (((_927 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _949 = (_879 * 2.0f) + -1.0f;
              float _953 = sqrt((_949 * _949) + 1.0f);
              float _954 = 1.0f / _953;
              float _961 = ((_953 * fOptimizedParam.z) * (_954 + fOptimizedParam.x)) * _908;
              float4 _967 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_961 * _949) + 0.5f), (((_961 * ((_880 * 2.0f) + -1.0f)) * (((_954 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _976 = (_881 * 2.0f) + -1.0f;
              float _980 = sqrt((_976 * _976) + 1.0f);
              float _981 = 1.0f / _980;
              float _988 = ((_980 * fOptimizedParam.z) * (_981 + fOptimizedParam.x)) * _908;
              float4 _994 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_988 * _976) + 0.5f), (((_988 * ((_882 * 2.0f) + -1.0f)) * (((_981 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1003 = (_883 * 2.0f) + -1.0f;
              float _1007 = sqrt((_1003 * _1003) + 1.0f);
              float _1008 = 1.0f / _1007;
              float _1015 = ((_1007 * fOptimizedParam.z) * (_1008 + fOptimizedParam.x)) * _908;
              float4 _1021 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1015 * _1003) + 0.5f), (((_1015 * ((_884 * 2.0f) + -1.0f)) * (((_1008 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1030 = (_885 * 2.0f) + -1.0f;
              float _1034 = sqrt((_1030 * _1030) + 1.0f);
              float _1035 = 1.0f / _1034;
              float _1042 = ((_1034 * fOptimizedParam.z) * (_1035 + fOptimizedParam.x)) * _908;
              float4 _1048 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1042 * _1030) + 0.5f), (((_1042 * ((_886 * 2.0f) + -1.0f)) * (((_1035 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1057 = (_887 * 2.0f) + -1.0f;
              float _1061 = sqrt((_1057 * _1057) + 1.0f);
              float _1062 = 1.0f / _1061;
              float _1069 = ((_1061 * fOptimizedParam.z) * (_1062 + fOptimizedParam.x)) * _908;
              float4 _1075 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1069 * _1057) + 0.5f), (((_1069 * ((_888 * 2.0f) + -1.0f)) * (((_1062 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1084 = (_889 * 2.0f) + -1.0f;
              float _1088 = sqrt((_1084 * _1084) + 1.0f);
              float _1089 = 1.0f / _1088;
              float _1096 = ((_1088 * fOptimizedParam.z) * (_1089 + fOptimizedParam.x)) * _908;
              float4 _1102 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1096 * _1084) + 0.5f), (((_1096 * ((_890 * 2.0f) + -1.0f)) * (((_1089 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1111 = (_891 * 2.0f) + -1.0f;
              float _1115 = sqrt((_1111 * _1111) + 1.0f);
              float _1116 = 1.0f / _1115;
              float _1123 = ((_1115 * fOptimizedParam.z) * (_1116 + fOptimizedParam.x)) * _908;
              float4 _1129 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1123 * _1111) + 0.5f), (((_1123 * ((_892 * 2.0f) + -1.0f)) * (((_1116 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1199 = ((((((((_940.x + _916.x) + _967.x) + _994.x) + _1021.x) + _1048.x) + _1075.x) + _1102.x) + _1129.x);
              _1200 = ((((((((_940.y + _916.y) + _967.y) + _994.y) + _1021.y) + _1048.y) + _1075.y) + _1102.y) + _1129.y);
              _1201 = ((((((((_940.z + _916.z) + _967.z) + _994.z) + _1021.z) + _1048.z) + _1075.z) + _1102.z) + _1129.z);
            } else {
              float4 _1138 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_874, _876), 0.0f);
              float4 _1142 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_877, _878), 0.0f);
              float4 _1149 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_879, _880), 0.0f);
              float4 _1156 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_881, _882), 0.0f);
              float4 _1163 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_883, _884), 0.0f);
              float4 _1170 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_885, _886), 0.0f);
              float4 _1177 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_887, _888), 0.0f);
              float4 _1184 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_889, _890), 0.0f);
              float4 _1191 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_891, _892), 0.0f);
              _1199 = ((((((((_1142.x + _1138.x) + _1149.x) + _1156.x) + _1163.x) + _1170.x) + _1177.x) + _1184.x) + _1191.x);
              _1200 = ((((((((_1142.y + _1138.y) + _1149.y) + _1156.y) + _1163.y) + _1170.y) + _1177.y) + _1184.y) + _1191.y);
              _1201 = ((((((((_1142.z + _1138.z) + _1149.z) + _1156.z) + _1163.z) + _1170.z) + _1177.z) + _1184.z) + _1191.z);
            }
          }
          float _1208 = ((_552 + _1199) * 0.10000000149011612f) * cbRadialColor.x;
          float _1209 = ((_553 + _1200) * 0.10000000149011612f) * cbRadialColor.y;
          float _1210 = ((_554 + _1201) * 0.10000000149011612f) * cbRadialColor.z;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1215 = saturate((_648 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1221 = (((_1215 * _1215) * cbRadialMaskRate.x) * (3.0f - (_1215 * 2.0f))) + cbRadialMaskRate.y;
              _1232 = ((_1221 * (_1208 - _552)) + _552);
              _1233 = ((_1221 * (_1209 - _553)) + _553);
              _1234 = ((_1221 * (_1210 - _554)) + _554);
            } else {
              _1232 = _1208;
              _1233 = _1209;
              _1234 = _1210;
            }
            _1245 = (lerp(_552, _1232, _601));
            _1246 = (lerp(_553, _1233, _601));
            _1247 = (lerp(_554, _1234, _601));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1245 = _552;
      _1246 = _553;
      _1247 = _554;
    }
  } else {
    _1245 = _552;
    _1246 = _553;
    _1247 = _554;
  }
  if (_308 && (bool)((cPassEnabled & 2) != 0)) {
    float _1255 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1257 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1263 = frac(frac((_1257 * 0.005837149918079376f) + (_1255 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1263 < fNoiseDensity) {
        int _1268 = (uint)(uint(_1257 * _1255)) ^ 12345391;
        uint _1269 = _1268 * 3635641;
        _1277 = (float((uint)((int)((((uint)(_1269) >> 26) | ((uint)(_1268 * 232681024))) ^ _1269))) * 2.3283064365386963e-10f);
      } else {
        _1277 = 0.0f;
      }
      float _1279 = frac(_1263 * 757.4846801757812f);
      do {
        if (_1279 < fNoiseDensity) {
          int _1283 = asint(_1279) ^ 12345391;
          uint _1284 = _1283 * 3635641;
          _1293 = ((float((uint)((int)((((uint)(_1284) >> 26) | ((uint)(_1283 * 232681024))) ^ _1284))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1293 = 0.0f;
        }
        float _1295 = frac(_1279 * 757.4846801757812f);
        do {
          if (_1295 < fNoiseDensity) {
            int _1299 = asint(_1295) ^ 12345391;
            uint _1300 = _1299 * 3635641;
            _1309 = ((float((uint)((int)((((uint)(_1300) >> 26) | ((uint)(_1299 * 232681024))) ^ _1300))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1309 = 0.0f;
          }
          float _1310 = _1277 * fNoisePower.x * CUSTOM_NOISE;
          float _1311 = _1309 * fNoisePower.y * CUSTOM_NOISE;
          float _1312 = _1293 * fNoisePower.y * CUSTOM_NOISE;
          float _1326 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1245), saturate(_1246), saturate(_1247)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1337 = ((_1326 * (mad(_1312, 1.4019999504089355f, _1310) - _1245)) + _1245);
          _1338 = ((_1326 * (mad(_1312, -0.7139999866485596f, mad(_1311, -0.3440000116825104f, _1310)) - _1246)) + _1246);
          _1339 = ((_1326 * (mad(_1311, 1.7719999551773071f, _1310) - _1247)) + _1247);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1337 = _1245;
    _1338 = _1246;
    _1339 = _1247;
  }
  float _1354 = mad(_1339, (fOCIOTransformMatrix[2].x), mad(_1338, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1337)));
  float _1357 = mad(_1339, (fOCIOTransformMatrix[2].y), mad(_1338, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1337)));
  float _1360 = mad(_1339, (fOCIOTransformMatrix[2].z), mad(_1338, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1337)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1366 = max(max(_1354, _1357), _1360);
    if (!(_1366 == 0.0f)) {
      float _1372 = abs(_1366);
      float _1373 = (_1366 - _1354) / _1372;
      float _1374 = (_1366 - _1357) / _1372;
      float _1375 = (_1366 - _1360) / _1372;
      do {
        if (!(!(_1373 >= cbControlRGCParam.CyanThreshold))) {
          float _1385 = _1373 - cbControlRGCParam.CyanThreshold;
          _1397 = ((_1385 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1385) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1397 = _1373;
        }
        do {
          if (!(!(_1374 >= cbControlRGCParam.MagentaThreshold))) {
            float _1406 = _1374 - cbControlRGCParam.MagentaThreshold;
            _1418 = ((_1406 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1406) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1418 = _1374;
          }
          do {
            if (!(!(_1375 >= cbControlRGCParam.YellowThreshold))) {
              float _1426 = _1375 - cbControlRGCParam.YellowThreshold;
              _1438 = ((_1426 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1426) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1438 = _1375;
            }
            _1446 = (_1366 - (_1397 * _1372));
            _1447 = (_1366 - (_1418 * _1372));
            _1448 = (_1366 - (_1438 * _1372));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1446 = _1354;
      _1447 = _1357;
      _1448 = _1360;
    }
  } else {
    _1446 = _1354;
    _1447 = _1357;
    _1448 = _1360;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _308,
        cPassEnabled,
        _1446,
        _1447,
        _1448,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1675,
        _1676,
        _1677);
  #else
  if (_308 && (bool)((cPassEnabled & 4) != 0)) {
    float _1499 = (((log2(select((_1446 < 3.0517578125e-05f), ((_1446 * 0.5f) + 1.52587890625e-05f), _1446)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1500 = (((log2(select((_1447 < 3.0517578125e-05f), ((_1447 * 0.5f) + 1.52587890625e-05f), _1447)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1501 = (((log2(select((_1448 < 3.0517578125e-05f), ((_1448 * 0.5f) + 1.52587890625e-05f), _1448)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1504 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1499, _1500, _1501), 0.0f);
    float _1517 = max(exp2((_1504.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1518 = max(exp2((_1504.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1519 = max(exp2((_1504.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1521 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1524 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1499, _1500, _1501), 0.0f);
        float _1546 = ((max(exp2((_1524.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1517) * fTextureBlendRate) + _1517;
        float _1547 = ((max(exp2((_1524.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1518) * fTextureBlendRate) + _1518;
        float _1548 = ((max(exp2((_1524.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1519) * fTextureBlendRate) + _1519;
        if (_1521) {
          float4 _1578 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1546 < 3.0517578125e-05f), ((_1546 * 0.5f) + 1.52587890625e-05f), _1546)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1547 < 3.0517578125e-05f), ((_1547 * 0.5f) + 1.52587890625e-05f), _1547)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1548 < 3.0517578125e-05f), ((_1548 * 0.5f) + 1.52587890625e-05f), _1548)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1659 = (((max(exp2((_1578.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1546) * fTextureBlendRate2) + _1546);
          _1660 = (((max(exp2((_1578.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1547) * fTextureBlendRate2) + _1547);
          _1661 = (((max(exp2((_1578.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1548) * fTextureBlendRate2) + _1548);
        } else {
          _1659 = _1546;
          _1660 = _1547;
          _1661 = _1548;
        }
      } else {
        if (_1521) {
          float4 _1633 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1517 < 3.0517578125e-05f), ((_1517 * 0.5f) + 1.52587890625e-05f), _1517)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1518 < 3.0517578125e-05f), ((_1518 * 0.5f) + 1.52587890625e-05f), _1518)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1519 < 3.0517578125e-05f), ((_1519 * 0.5f) + 1.52587890625e-05f), _1519)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1659 = (((max(exp2((_1633.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1517) * fTextureBlendRate2) + _1517);
          _1660 = (((max(exp2((_1633.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1518) * fTextureBlendRate2) + _1518);
          _1661 = (((max(exp2((_1633.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1519) * fTextureBlendRate2) + _1519);
        } else {
          _1659 = _1517;
          _1660 = _1518;
          _1661 = _1519;
        }
      }
      _1675 = (mad(_1661, (fColorMatrix[2].x), mad(_1660, (fColorMatrix[1].x), (_1659 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1676 = (mad(_1661, (fColorMatrix[2].y), mad(_1660, (fColorMatrix[1].y), (_1659 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1677 = (mad(_1661, (fColorMatrix[2].z), mad(_1660, (fColorMatrix[1].z), (_1659 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1675 = _1446;
    _1676 = _1447;
    _1677 = _1448;
  }
  #endif
  if (_308 && (bool)((cPassEnabled & 8) != 0)) {
    _1710 = (((cvdR.x * _1675) + (cvdR.y * _1676)) + (cvdR.z * _1677));
    _1711 = (((cvdG.x * _1675) + (cvdG.y * _1676)) + (cvdG.z * _1677));
    _1712 = (((cvdB.x * _1675) + (cvdB.y * _1676)) + (cvdB.z * _1677));
  } else {
    _1710 = _1675;
    _1711 = _1676;
    _1712 = _1677;
  }
  float _1716 = screenInverseSize.x * SV_Position.x;
  float _1717 = screenInverseSize.y * SV_Position.y;
  float4 _1723 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1716, _1717), 0.0f);
  if (_308 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1737 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1716, _1717), 0.0f);
    float _1743 = ColorParam.x * _1723.x;
    float _1744 = ColorParam.y * _1723.y;
    float _1745 = ColorParam.z * _1723.z;
    float _1750 = (ColorParam.w * _1723.w) * saturate((_1737.x * Levels_Rate) + Levels_Range);
    do {
      if (_1743 < 0.5f) {
        _1762 = ((_1710 * 2.0f) * _1743);
      } else {
        _1762 = (1.0f - (((1.0f - _1710) * 2.0f) * (1.0f - _1743)));
      }
      do {
        if (_1744 < 0.5f) {
          _1774 = ((_1711 * 2.0f) * _1744);
        } else {
          _1774 = (1.0f - (((1.0f - _1711) * 2.0f) * (1.0f - _1744)));
        }
        do {
          if (_1745 < 0.5f) {
            _1786 = ((_1712 * 2.0f) * _1745);
          } else {
            _1786 = (1.0f - (((1.0f - _1712) * 2.0f) * (1.0f - _1745)));
          }
          _1797 = (lerp(_1710, _1762, _1750));
          _1798 = (lerp(_1711, _1774, _1750));
          _1799 = (lerp(_1712, _1786, _1750));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1797 = _1710;
    _1798 = _1711;
    _1799 = _1712;
  }
  float _1817 = ((saturate(1.0f / (exp2(((_271 + -0.5f) * -1.4426950216293335f) * ((exp2(log2(max(VAR_FilmDamage_Contrast, 9.999999974752427e-07f)) * 10.0f) * 990.0f) + 10.0f)) + 1.0f)) - _271) * VAR_FilmDamage_Contrast) + _271;
  if (_1797 < 0.5f) {
    _1829 = ((_221 * 2.0f) * _1797);
  } else {
    _1829 = (1.0f - (((1.0f - _221) * 2.0f) * (1.0f - _1797)));
  }
  if (_1798 < 0.5f) {
    _1841 = ((_222 * 2.0f) * _1798);
  } else {
    _1841 = (1.0f - (((1.0f - _222) * 2.0f) * (1.0f - _1798)));
  }
  if (_1799 < 0.5f) {
    _1853 = ((_223 * 2.0f) * _1799);
  } else {
    _1853 = (1.0f - (((1.0f - _223) * 2.0f) * (1.0f - _1799)));
  }
  float _1862 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1829 - _1797)) + _1797;
  float _1863 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1841 - _1798)) + _1798;
  float _1864 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1853 - _1799)) + _1799;
  float _1875 = ((VAR_FilmDamage_Color.x - _1862) * _1817) + _1862;
  float _1876 = ((VAR_FilmDamage_Color.y - _1863) * _1817) + _1863;
  float _1877 = ((VAR_FilmDamage_Color.z - _1864) * _1817) + _1864;
  float _1885 = ((_221 - _1875) * VAR_Debug_FilmGrain_Texture) + _1875;
  float _1886 = ((_222 - _1876) * VAR_Debug_FilmGrain_Texture) + _1876;
  float _1887 = ((_223 - _1877) * VAR_Debug_FilmGrain_Texture) + _1877;
  SV_Target.x = (lerp(_1885, _1817, VAR_Debug_FilmDamage_Texture));
  SV_Target.y = (lerp(_1886, _1817, VAR_Debug_FilmDamage_Texture));
  SV_Target.z = (lerp(_1887, _1817, VAR_Debug_FilmDamage_Texture));
  SV_Target.w = 1.0f;
  return SV_Target;
}
