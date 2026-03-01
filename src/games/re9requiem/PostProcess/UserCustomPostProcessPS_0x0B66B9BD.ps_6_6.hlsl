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
  float _42 = (float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Animation_RefreshRate;
  float _44 = floor(_42);
  float _48 = _44 * 0.5f;
  float _49 = floor(_42 * 0.5f) * 0.5f;
  float _56 = frac(abs(_48));
  float _57 = frac(abs(_49));
  float _77 = ((select((_49 >= (-0.0f - _49)), _57, (-0.0f - _57)) * 4.0f) + -1.0f) * ((screenInverseSize.y * SV_Position.y) + -0.5f);
  float _79 = ((screenSize.x / screenSize.y) * ((screenInverseSize.x * SV_Position.x) + -0.5f)) * ((select((_48 >= (-0.0f - _48)), _56, (-0.0f - _56)) * 4.0f) + -1.0f);
  float _93 = (_79 + frac(_44 * 0.4274809956550598f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.x));
  float _94 = (_77 + frac(_44 * 0.5725190043449402f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.y));
  float4 _108 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_93, _94), float2((cbr.x * ddx_coarse(_93)), (cbr.x * ddx_coarse(_94))), float2((cbr.y * ddy_coarse(_93)), (cbr.y * ddy_coarse(_94))), int2(0, 0));
  float _145;
  float _146;
  float _252;
  float _570;
  float _571;
  float _572;
  float _662;
  float _1217;
  float _1218;
  float _1219;
  float _1253;
  float _1254;
  float _1255;
  float _1266;
  float _1267;
  float _1268;
  float _1298;
  float _1314;
  float _1330;
  float _1358;
  float _1359;
  float _1360;
  float _1418;
  float _1439;
  float _1459;
  float _1467;
  float _1468;
  float _1469;
  float _1680;
  float _1681;
  float _1682;
  float _1696;
  float _1697;
  float _1698;
  float _1731;
  float _1732;
  float _1733;
  float _1783;
  float _1795;
  float _1807;
  float _1818;
  float _1819;
  float _1820;
  float _1850;
  float _1862;
  float _1874;
  [branch]
  if (VAR_FilmGrain_Saturate > 0.0f) {
    float _114 = _93 + 0.3330000042915344f;
    float _115 = _94 + 0.6660000085830688f;
    float _116 = _93 + 0.6660000085830688f;
    float _117 = _94 + 0.3330000042915344f;
    float4 _126 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_114, _115), float2((ddx_coarse(_114) * cbr.x), (ddx_coarse(_115) * cbr.x)), float2((ddy_coarse(_114) * cbr.y), (ddy_coarse(_115) * cbr.y)), int2(0, 0));
    float4 _136 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_116, _117), float2((ddx_coarse(_116) * cbr.x), (ddx_coarse(_117) * cbr.x)), float2((ddy_coarse(_116) * cbr.y), (ddy_coarse(_117) * cbr.y)), int2(0, 0));
    _145 = (lerp(_108.x, _126.x, VAR_FilmGrain_Saturate));
    _146 = (lerp(_108.x, _136.x, VAR_FilmGrain_Saturate));
  } else {
    _145 = _108.x;
    _146 = _108.x;
  }
  float _148 = 1.0f - VAR_FilmGrain_Curve;
  float _153 = select((_148 < 0.5f), 0.0f, 1.0f);
  float _154 = 1.0f - abs((_148 * 2.0f) + -0.9960784316062927f);
  float _176 = exp2(log2(max((((1.0f - (_145 * 2.0f)) * _153) + _145), 9.999999974752427e-07f)) * _154);
  float _177 = exp2(log2(max((((1.0f - (_146 * 2.0f)) * _153) + _146), 9.999999974752427e-07f)) * _154);
  float _178 = exp2(log2(max(((_153 * (1.0f - (_108.x * 2.0f))) + _108.x), 9.999999974752427e-07f)) * _154);
  float _188 = ((1.0f - (_176 * 2.0f)) * _153) + _176;
  float _189 = ((1.0f - (_177 * 2.0f)) * _153) + _177;
  float _190 = ((1.0f - (_178 * 2.0f)) * _153) + _178;
  float _200 = (exp2(log2(max(VAR_FilmGrain_Contrast, 9.999999974752427e-07f)) * 10.0f) * -1428.26806640625f) + -14.426950454711914f;
  float _222 = ((saturate(1.0f / (exp2(_200 * (_188 + -0.5f)) + 1.0f)) - _188) * VAR_FilmGrain_Contrast) + _188;
  float _223 = ((saturate(1.0f / (exp2(_200 * (_189 + -0.5f)) + 1.0f)) - _189) * VAR_FilmGrain_Contrast) + _189;
  float _224 = ((saturate(1.0f / (exp2(_200 * (_190 + -0.5f)) + 1.0f)) - _190) * VAR_FilmGrain_Contrast) + _190;
  [branch]
  if (VAR_FilmDamage_Opacity > 0.0f) {
    float _237 = (frac(_44 * 0.44094499945640564f) + _79) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.x * VAR_FilmDamage_Size));
    float _238 = (frac(_44 * 0.5511810183525085f) + _77) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.y * VAR_FilmDamage_Size));
    float4 _248 = FilmDamage_Texture.SampleGrad(BilinearWrap, float2(_237, _238), float2((ddx_coarse(_237) * cbr.x), (ddx_coarse(_238) * cbr.x)), float2((ddy_coarse(_237) * cbr.y), (ddy_coarse(_238) * cbr.y)), int2(0, 0));
    _252 = (_248.x * VAR_FilmDamage_Opacity);
  } else {
    _252 = 0.0f;
  }
  float _254 = 1.0f - VAR_FilmDamage_Curve;
  float _259 = select((_254 < 0.5f), 0.0f, 1.0f);
  float _268 = exp2(log2(max((((1.0f - (_252 * 2.0f)) * _259) + _252), 9.999999974752427e-07f)) * (1.0f - abs((_254 * 2.0f) + -0.9960784316062927f)));
  float _272 = ((1.0f - (_268 * 2.0f)) * _259) + _268;
  uint _304 = uint(float((uint)(int)(distortionType)));
  bool _309 = (LDRPPSettings_enabled != 0);
  bool _310 = ((cPassEnabled & 1) != 0);
  if (!(_310 && _309)) {
    float4 _320 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _570 = (min(_320.x, 65000.0f) * Exposure);
    _571 = (min(_320.y, 65000.0f) * Exposure);
    _572 = (min(_320.z, 65000.0f) * Exposure);
  } else {
    if (_304 == 0) {
      float _338 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _339 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _340 = dot(float2(_338, _339), float2(_338, _339));
      float _342 = (_340 * fDistortionCoef) + 1.0f;
      float _343 = _338 * fCorrectCoef;
      float _345 = _339 * fCorrectCoef;
      float _347 = (_343 * _342) + 0.5f;
      float _348 = (_345 * _342) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _353 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_347, _348));
        _570 = (_353.x * Exposure);
        _571 = (_353.y * Exposure);
        _572 = (_353.z * Exposure);
      } else {
        float _372 = ((saturate((sqrt((_338 * _338) + (_339 * _339)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _382 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _383 = _372 * 2.0f;
          float _387 = (((_382 * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _392 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_387 * _343) + 0.5f), ((_387 * _345) + 0.5f)));
          float _398 = ((((_382 + 0.125f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _403 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_398 * _343) + 0.5f), ((_398 * _345) + 0.5f)));
          float _410 = ((((_382 + 0.25f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _415 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_410 * _343) + 0.5f), ((_410 * _345) + 0.5f)));
          float _424 = ((((_382 + 0.375f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _429 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _343) + 0.5f), ((_424 * _345) + 0.5f)));
          float _438 = ((((_382 + 0.5f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _443 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_438 * _343) + 0.5f), ((_438 * _345) + 0.5f)));
          float _449 = ((((_382 + 0.625f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _454 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_449 * _343) + 0.5f), ((_449 * _345) + 0.5f)));
          float _462 = ((((_382 + 0.75f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_462 * _343) + 0.5f), ((_462 * _345) + 0.5f)));
          float _482 = ((((_382 + 0.875f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _487 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_482 * _343) + 0.5f), ((_482 * _345) + 0.5f)));
          float _494 = ((((_382 + 1.0f) * _383) + _340) * fDistortionCoef) + 1.0f;
          float4 _499 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_494 * _343) + 0.5f), ((_494 * _345) + 0.5f)));
          float _502 = Exposure * 0.3199999928474426f;
          _570 = ((((_403.x + _392.x) + (_415.x * 0.75f)) + (_429.x * 0.375f)) * _502);
          _571 = ((Exposure * 0.3636363744735718f) * ((((_454.y + _429.y) * 0.625f) + _443.y) + ((_467.y + _415.y) * 0.25f)));
          _572 = (((((_467.z * 0.75f) + (_454.z * 0.375f)) + _487.z) + _499.z) * _502);
        } else {
          float _508 = _372 + _340;
          float _510 = (_508 * fDistortionCoef) + 1.0f;
          float _517 = ((_508 + _372) * fDistortionCoef) + 1.0f;
          float4 _522 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_347, _348));
          float4 _525 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_510 * _343) + 0.5f), ((_510 * _345) + 0.5f)));
          float4 _528 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_517 * _343) + 0.5f), ((_517 * _345) + 0.5f)));
          _570 = (_522.x * Exposure);
          _571 = (_525.y * Exposure);
          _572 = (_528.z * Exposure);
        }
      }
    } else {
      if (_304 == 1) {
        float _541 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _545 = sqrt((_541 * _541) + 1.0f);
        float _546 = 1.0f / _545;
        float _554 = ((_545 * fOptimizedParam.z) * (_546 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _562 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_554 * _541) + 0.5f), (((_554 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_546 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _570 = (_562.x * Exposure);
        _571 = (_562.y * Exposure);
        _572 = (_562.z * Exposure);
      } else {
        _570 = 0.0f;
        _571 = 0.0f;
        _572 = 0.0f;
      }
    }
  }
  if (_309 && (bool)((cPassEnabled & 32) != 0)) {
    float _612 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _616 = ComputeResultSRV[0].computeAlpha;
    float _619 = ((1.0f - _612) + (_616 * _612)) * cbRadialColor.w;
    if (!(_619 == 0.0f)) {
      float _625 = screenInverseSize.x * SV_Position.x;
      float _626 = screenInverseSize.y * SV_Position.y;
      float _628 = _625 + (-0.5f - cbRadialScreenPos.x);
      float _630 = _626 + (-0.5f - cbRadialScreenPos.y);
      float _633 = select((_628 < 0.0f), (1.0f - _625), _625);
      float _636 = select((_630 < 0.0f), (1.0f - _626), _626);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _642 = rsqrt(dot(float2(_628, _630), float2(_628, _630))) * cbRadialSharpRange;
          uint _649 = uint(abs(_642 * _630)) + uint(abs(_642 * _628));
          uint _653 = ((_649 ^ 61) ^ ((uint)(_649) >> 16)) * 9;
          uint _656 = (((uint)(_653) >> 4) ^ _653) * 668265261;
          _662 = (float((uint)((int)(((uint)(_656) >> 15) ^ _656))) * 2.3283064365386963e-10f);
        } else {
          _662 = 1.0f;
        }
        float _666 = sqrt((_628 * _628) + (_630 * _630));
        float _668 = 1.0f / max(1.0f, _666);
        float _669 = _662 * _633;
        float _670 = cbRadialBlurPower * _668;
        float _671 = _670 * -0.0011111111380159855f;
        float _673 = _662 * _636;
        float _677 = ((_671 * _669) + 1.0f) * _628;
        float _678 = ((_671 * _673) + 1.0f) * _630;
        float _680 = _670 * -0.002222222276031971f;
        float _685 = ((_680 * _669) + 1.0f) * _628;
        float _686 = ((_680 * _673) + 1.0f) * _630;
        float _687 = _670 * -0.0033333334140479565f;
        float _692 = ((_687 * _669) + 1.0f) * _628;
        float _693 = ((_687 * _673) + 1.0f) * _630;
        float _694 = _670 * -0.004444444552063942f;
        float _699 = ((_694 * _669) + 1.0f) * _628;
        float _700 = ((_694 * _673) + 1.0f) * _630;
        float _701 = _670 * -0.0055555556900799274f;
        float _706 = ((_701 * _669) + 1.0f) * _628;
        float _707 = ((_701 * _673) + 1.0f) * _630;
        float _708 = _670 * -0.006666666828095913f;
        float _713 = ((_708 * _669) + 1.0f) * _628;
        float _714 = ((_708 * _673) + 1.0f) * _630;
        float _715 = _670 * -0.007777777966111898f;
        float _720 = ((_715 * _669) + 1.0f) * _628;
        float _721 = ((_715 * _673) + 1.0f) * _630;
        float _722 = _670 * -0.008888889104127884f;
        float _727 = ((_722 * _669) + 1.0f) * _628;
        float _728 = ((_722 * _673) + 1.0f) * _630;
        float _731 = _668 * ((cbRadialBlurPower * -0.009999999776482582f) * _662);
        float _736 = ((_731 * _633) + 1.0f) * _628;
        float _737 = ((_731 * _636) + 1.0f) * _630;
        do {
          if (_310 && (bool)(_304 == 0)) {
            float _739 = _677 + cbRadialScreenPos.x;
            float _740 = _678 + cbRadialScreenPos.y;
            float _744 = ((dot(float2(_739, _740), float2(_739, _740)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _750 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_744 * _739) + 0.5f), ((_744 * _740) + 0.5f)), 0.0f);
            float _754 = _685 + cbRadialScreenPos.x;
            float _755 = _686 + cbRadialScreenPos.y;
            float _759 = ((dot(float2(_754, _755), float2(_754, _755)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _764 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_759 * _754) + 0.5f), ((_759 * _755) + 0.5f)), 0.0f);
            float _771 = _692 + cbRadialScreenPos.x;
            float _772 = _693 + cbRadialScreenPos.y;
            float _776 = ((dot(float2(_771, _772), float2(_771, _772)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _781 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_776 * _771) + 0.5f), ((_776 * _772) + 0.5f)), 0.0f);
            float _788 = _699 + cbRadialScreenPos.x;
            float _789 = _700 + cbRadialScreenPos.y;
            float _793 = ((dot(float2(_788, _789), float2(_788, _789)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _798 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_793 * _788) + 0.5f), ((_793 * _789) + 0.5f)), 0.0f);
            float _805 = _706 + cbRadialScreenPos.x;
            float _806 = _707 + cbRadialScreenPos.y;
            float _810 = ((dot(float2(_805, _806), float2(_805, _806)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _815 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_810 * _805) + 0.5f), ((_810 * _806) + 0.5f)), 0.0f);
            float _822 = _713 + cbRadialScreenPos.x;
            float _823 = _714 + cbRadialScreenPos.y;
            float _827 = ((dot(float2(_822, _823), float2(_822, _823)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _832 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_827 * _822) + 0.5f), ((_827 * _823) + 0.5f)), 0.0f);
            float _839 = _720 + cbRadialScreenPos.x;
            float _840 = _721 + cbRadialScreenPos.y;
            float _844 = ((dot(float2(_839, _840), float2(_839, _840)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _849 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_844 * _839) + 0.5f), ((_844 * _840) + 0.5f)), 0.0f);
            float _856 = _727 + cbRadialScreenPos.x;
            float _857 = _728 + cbRadialScreenPos.y;
            float _861 = ((dot(float2(_856, _857), float2(_856, _857)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _866 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_861 * _856) + 0.5f), ((_861 * _857) + 0.5f)), 0.0f);
            float _873 = _736 + cbRadialScreenPos.x;
            float _874 = _737 + cbRadialScreenPos.y;
            float _878 = ((dot(float2(_873, _874), float2(_873, _874)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _883 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_878 * _873) + 0.5f), ((_878 * _874) + 0.5f)), 0.0f);
            _1217 = ((((((((_764.x + _750.x) + _781.x) + _798.x) + _815.x) + _832.x) + _849.x) + _866.x) + _883.x);
            _1218 = ((((((((_764.y + _750.y) + _781.y) + _798.y) + _815.y) + _832.y) + _849.y) + _866.y) + _883.y);
            _1219 = ((((((((_764.z + _750.z) + _781.z) + _798.z) + _815.z) + _832.z) + _849.z) + _866.z) + _883.z);
          } else {
            float _891 = cbRadialScreenPos.x + 0.5f;
            float _892 = _677 + _891;
            float _893 = cbRadialScreenPos.y + 0.5f;
            float _894 = _678 + _893;
            float _895 = _685 + _891;
            float _896 = _686 + _893;
            float _897 = _692 + _891;
            float _898 = _693 + _893;
            float _899 = _699 + _891;
            float _900 = _700 + _893;
            float _901 = _706 + _891;
            float _902 = _707 + _893;
            float _903 = _713 + _891;
            float _904 = _714 + _893;
            float _905 = _720 + _891;
            float _906 = _721 + _893;
            float _907 = _727 + _891;
            float _908 = _728 + _893;
            float _909 = _736 + _891;
            float _910 = _737 + _893;
            if (_310 && (bool)(_304 == 1)) {
              float _914 = (_892 * 2.0f) + -1.0f;
              float _918 = sqrt((_914 * _914) + 1.0f);
              float _919 = 1.0f / _918;
              float _926 = fOptimizedParam.w * 0.5f;
              float _927 = ((_918 * fOptimizedParam.z) * (_919 + fOptimizedParam.x)) * _926;
              float4 _934 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_927 * _914) + 0.5f), (((_927 * ((_894 * 2.0f) + -1.0f)) * (((_919 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _940 = (_895 * 2.0f) + -1.0f;
              float _944 = sqrt((_940 * _940) + 1.0f);
              float _945 = 1.0f / _944;
              float _952 = ((_944 * fOptimizedParam.z) * (_945 + fOptimizedParam.x)) * _926;
              float4 _958 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_952 * _940) + 0.5f), (((_952 * ((_896 * 2.0f) + -1.0f)) * (((_945 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _967 = (_897 * 2.0f) + -1.0f;
              float _971 = sqrt((_967 * _967) + 1.0f);
              float _972 = 1.0f / _971;
              float _979 = ((_971 * fOptimizedParam.z) * (_972 + fOptimizedParam.x)) * _926;
              float4 _985 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_979 * _967) + 0.5f), (((_979 * ((_898 * 2.0f) + -1.0f)) * (((_972 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _994 = (_899 * 2.0f) + -1.0f;
              float _998 = sqrt((_994 * _994) + 1.0f);
              float _999 = 1.0f / _998;
              float _1006 = ((_998 * fOptimizedParam.z) * (_999 + fOptimizedParam.x)) * _926;
              float4 _1012 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1006 * _994) + 0.5f), (((_1006 * ((_900 * 2.0f) + -1.0f)) * (((_999 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1021 = (_901 * 2.0f) + -1.0f;
              float _1025 = sqrt((_1021 * _1021) + 1.0f);
              float _1026 = 1.0f / _1025;
              float _1033 = ((_1025 * fOptimizedParam.z) * (_1026 + fOptimizedParam.x)) * _926;
              float4 _1039 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1033 * _1021) + 0.5f), (((_1033 * ((_902 * 2.0f) + -1.0f)) * (((_1026 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1048 = (_903 * 2.0f) + -1.0f;
              float _1052 = sqrt((_1048 * _1048) + 1.0f);
              float _1053 = 1.0f / _1052;
              float _1060 = ((_1052 * fOptimizedParam.z) * (_1053 + fOptimizedParam.x)) * _926;
              float4 _1066 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1060 * _1048) + 0.5f), (((_1060 * ((_904 * 2.0f) + -1.0f)) * (((_1053 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1075 = (_905 * 2.0f) + -1.0f;
              float _1079 = sqrt((_1075 * _1075) + 1.0f);
              float _1080 = 1.0f / _1079;
              float _1087 = ((_1079 * fOptimizedParam.z) * (_1080 + fOptimizedParam.x)) * _926;
              float4 _1093 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1087 * _1075) + 0.5f), (((_1087 * ((_906 * 2.0f) + -1.0f)) * (((_1080 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1102 = (_907 * 2.0f) + -1.0f;
              float _1106 = sqrt((_1102 * _1102) + 1.0f);
              float _1107 = 1.0f / _1106;
              float _1114 = ((_1106 * fOptimizedParam.z) * (_1107 + fOptimizedParam.x)) * _926;
              float4 _1120 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1114 * _1102) + 0.5f), (((_1114 * ((_908 * 2.0f) + -1.0f)) * (((_1107 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1129 = (_909 * 2.0f) + -1.0f;
              float _1133 = sqrt((_1129 * _1129) + 1.0f);
              float _1134 = 1.0f / _1133;
              float _1141 = ((_1133 * fOptimizedParam.z) * (_1134 + fOptimizedParam.x)) * _926;
              float4 _1147 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1141 * _1129) + 0.5f), (((_1141 * ((_910 * 2.0f) + -1.0f)) * (((_1134 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1217 = ((((((((_958.x + _934.x) + _985.x) + _1012.x) + _1039.x) + _1066.x) + _1093.x) + _1120.x) + _1147.x);
              _1218 = ((((((((_958.y + _934.y) + _985.y) + _1012.y) + _1039.y) + _1066.y) + _1093.y) + _1120.y) + _1147.y);
              _1219 = ((((((((_958.z + _934.z) + _985.z) + _1012.z) + _1039.z) + _1066.z) + _1093.z) + _1120.z) + _1147.z);
            } else {
              float4 _1156 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_892, _894), 0.0f);
              float4 _1160 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_895, _896), 0.0f);
              float4 _1167 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_897, _898), 0.0f);
              float4 _1174 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_899, _900), 0.0f);
              float4 _1181 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_901, _902), 0.0f);
              float4 _1188 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_903, _904), 0.0f);
              float4 _1195 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_905, _906), 0.0f);
              float4 _1202 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_907, _908), 0.0f);
              float4 _1209 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_909, _910), 0.0f);
              _1217 = ((((((((_1160.x + _1156.x) + _1167.x) + _1174.x) + _1181.x) + _1188.x) + _1195.x) + _1202.x) + _1209.x);
              _1218 = ((((((((_1160.y + _1156.y) + _1167.y) + _1174.y) + _1181.y) + _1188.y) + _1195.y) + _1202.y) + _1209.y);
              _1219 = ((((((((_1160.z + _1156.z) + _1167.z) + _1174.z) + _1181.z) + _1188.z) + _1195.z) + _1202.z) + _1209.z);
            }
          }
          float _1229 = (cbRadialColor.z * (_572 + (Exposure * _1219))) * 0.10000000149011612f;
          float _1230 = (cbRadialColor.y * (_571 + (Exposure * _1218))) * 0.10000000149011612f;
          float _1231 = (cbRadialColor.x * (_570 + (Exposure * _1217))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1236 = saturate((_666 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1242 = (((_1236 * _1236) * cbRadialMaskRate.x) * (3.0f - (_1236 * 2.0f))) + cbRadialMaskRate.y;
              _1253 = ((_1242 * (_1231 - _570)) + _570);
              _1254 = ((_1242 * (_1230 - _571)) + _571);
              _1255 = ((_1242 * (_1229 - _572)) + _572);
            } else {
              _1253 = _1231;
              _1254 = _1230;
              _1255 = _1229;
            }
            _1266 = (lerp(_570, _1253, _619));
            _1267 = (lerp(_571, _1254, _619));
            _1268 = (lerp(_572, _1255, _619));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1266 = _570;
      _1267 = _571;
      _1268 = _572;
    }
  } else {
    _1266 = _570;
    _1267 = _571;
    _1268 = _572;
  }
  if (_309 && (bool)((cPassEnabled & 2) != 0)) {
    float _1276 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1278 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1284 = frac(frac((_1278 * 0.005837149918079376f) + (_1276 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1284 < fNoiseDensity) {
        int _1289 = (uint)(uint(_1278 * _1276)) ^ 12345391;
        uint _1290 = _1289 * 3635641;
        _1298 = (float((uint)((int)((((uint)(_1290) >> 26) | ((uint)(_1289 * 232681024))) ^ _1290))) * 2.3283064365386963e-10f);
      } else {
        _1298 = 0.0f;
      }
      float _1300 = frac(_1284 * 757.4846801757812f);
      do {
        if (_1300 < fNoiseDensity) {
          int _1304 = asint(_1300) ^ 12345391;
          uint _1305 = _1304 * 3635641;
          _1314 = ((float((uint)((int)((((uint)(_1305) >> 26) | ((uint)(_1304 * 232681024))) ^ _1305))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1314 = 0.0f;
        }
        float _1316 = frac(_1300 * 757.4846801757812f);
        do {
          if (_1316 < fNoiseDensity) {
            int _1320 = asint(_1316) ^ 12345391;
            uint _1321 = _1320 * 3635641;
            _1330 = ((float((uint)((int)((((uint)(_1321) >> 26) | ((uint)(_1320 * 232681024))) ^ _1321))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1330 = 0.0f;
          }
          float _1331 = _1298 * fNoisePower.x * CUSTOM_NOISE;
          float _1332 = _1330 * fNoisePower.y * CUSTOM_NOISE;
          float _1333 = _1314 * fNoisePower.y * CUSTOM_NOISE;
          float _1347 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1266), saturate(_1267), saturate(_1268)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1358 = ((_1347 * (mad(_1333, 1.4019999504089355f, _1331) - _1266)) + _1266);
          _1359 = ((_1347 * (mad(_1333, -0.7139999866485596f, mad(_1332, -0.3440000116825104f, _1331)) - _1267)) + _1267);
          _1360 = ((_1347 * (mad(_1332, 1.7719999551773071f, _1331) - _1268)) + _1268);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1358 = _1266;
    _1359 = _1267;
    _1360 = _1268;
  }
  float _1375 = mad(_1360, (fOCIOTransformMatrix[2].x), mad(_1359, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1358)));
  float _1378 = mad(_1360, (fOCIOTransformMatrix[2].y), mad(_1359, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1358)));
  float _1381 = mad(_1360, (fOCIOTransformMatrix[2].z), mad(_1359, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1358)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1387 = max(max(_1375, _1378), _1381);
    if (!(_1387 == 0.0f)) {
      float _1393 = abs(_1387);
      float _1394 = (_1387 - _1375) / _1393;
      float _1395 = (_1387 - _1378) / _1393;
      float _1396 = (_1387 - _1381) / _1393;
      do {
        if (!(!(_1394 >= cbControlRGCParam.CyanThreshold))) {
          float _1406 = _1394 - cbControlRGCParam.CyanThreshold;
          _1418 = ((_1406 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1406) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1418 = _1394;
        }
        do {
          if (!(!(_1395 >= cbControlRGCParam.MagentaThreshold))) {
            float _1427 = _1395 - cbControlRGCParam.MagentaThreshold;
            _1439 = ((_1427 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1427) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1439 = _1395;
          }
          do {
            if (!(!(_1396 >= cbControlRGCParam.YellowThreshold))) {
              float _1447 = _1396 - cbControlRGCParam.YellowThreshold;
              _1459 = ((_1447 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1447) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1459 = _1396;
            }
            _1467 = (_1387 - (_1418 * _1393));
            _1468 = (_1387 - (_1439 * _1393));
            _1469 = (_1387 - (_1459 * _1393));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1467 = _1375;
      _1468 = _1378;
      _1469 = _1381;
    }
  } else {
    _1467 = _1375;
    _1468 = _1378;
    _1469 = _1381;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _309,
        cPassEnabled,
        _1467,
        _1468,
        _1469,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1696,
        _1697,
        _1698);
  #else
  if (_309 && (bool)((cPassEnabled & 4) != 0)) {
    float _1520 = (((log2(select((_1467 < 3.0517578125e-05f), ((_1467 * 0.5f) + 1.52587890625e-05f), _1467)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1521 = (((log2(select((_1468 < 3.0517578125e-05f), ((_1468 * 0.5f) + 1.52587890625e-05f), _1468)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1522 = (((log2(select((_1469 < 3.0517578125e-05f), ((_1469 * 0.5f) + 1.52587890625e-05f), _1469)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1525 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1520, _1521, _1522), 0.0f);
    float _1538 = max(exp2((_1525.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1539 = max(exp2((_1525.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1540 = max(exp2((_1525.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1542 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1545 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1520, _1521, _1522), 0.0f);
        float _1567 = ((max(exp2((_1545.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1538) * fTextureBlendRate) + _1538;
        float _1568 = ((max(exp2((_1545.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1539) * fTextureBlendRate) + _1539;
        float _1569 = ((max(exp2((_1545.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1540) * fTextureBlendRate) + _1540;
        if (_1542) {
          float4 _1599 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1567 < 3.0517578125e-05f), ((_1567 * 0.5f) + 1.52587890625e-05f), _1567)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1568 < 3.0517578125e-05f), ((_1568 * 0.5f) + 1.52587890625e-05f), _1568)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1569 < 3.0517578125e-05f), ((_1569 * 0.5f) + 1.52587890625e-05f), _1569)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1680 = (((max(exp2((_1599.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1567) * fTextureBlendRate2) + _1567);
          _1681 = (((max(exp2((_1599.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1568) * fTextureBlendRate2) + _1568);
          _1682 = (((max(exp2((_1599.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1569) * fTextureBlendRate2) + _1569);
        } else {
          _1680 = _1567;
          _1681 = _1568;
          _1682 = _1569;
        }
      } else {
        if (_1542) {
          float4 _1654 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1538 < 3.0517578125e-05f), ((_1538 * 0.5f) + 1.52587890625e-05f), _1538)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1539 < 3.0517578125e-05f), ((_1539 * 0.5f) + 1.52587890625e-05f), _1539)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1540 < 3.0517578125e-05f), ((_1540 * 0.5f) + 1.52587890625e-05f), _1540)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1680 = (((max(exp2((_1654.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1538) * fTextureBlendRate2) + _1538);
          _1681 = (((max(exp2((_1654.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1539) * fTextureBlendRate2) + _1539);
          _1682 = (((max(exp2((_1654.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1540) * fTextureBlendRate2) + _1540);
        } else {
          _1680 = _1538;
          _1681 = _1539;
          _1682 = _1540;
        }
      }
      _1696 = (mad(_1682, (fColorMatrix[2].x), mad(_1681, (fColorMatrix[1].x), (_1680 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1697 = (mad(_1682, (fColorMatrix[2].y), mad(_1681, (fColorMatrix[1].y), (_1680 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1698 = (mad(_1682, (fColorMatrix[2].z), mad(_1681, (fColorMatrix[1].z), (_1680 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1696 = _1467;
    _1697 = _1468;
    _1698 = _1469;
  }
  #endif
  if (_309 && (bool)((cPassEnabled & 8) != 0)) {
    _1731 = (((cvdR.x * _1696) + (cvdR.y * _1697)) + (cvdR.z * _1698));
    _1732 = (((cvdG.x * _1696) + (cvdG.y * _1697)) + (cvdG.z * _1698));
    _1733 = (((cvdB.x * _1696) + (cvdB.y * _1697)) + (cvdB.z * _1698));
  } else {
    _1731 = _1696;
    _1732 = _1697;
    _1733 = _1698;
  }
  float _1737 = screenInverseSize.x * SV_Position.x;
  float _1738 = screenInverseSize.y * SV_Position.y;
  float4 _1744 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1737, _1738), 0.0f);
  if (_309 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1758 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1737, _1738), 0.0f);
    float _1764 = ColorParam.x * _1744.x;
    float _1765 = ColorParam.y * _1744.y;
    float _1766 = ColorParam.z * _1744.z;
    float _1771 = (ColorParam.w * _1744.w) * saturate((_1758.x * Levels_Rate) + Levels_Range);
    do {
      if (_1764 < 0.5f) {
        _1783 = ((_1731 * 2.0f) * _1764);
      } else {
        _1783 = (1.0f - (((1.0f - _1731) * 2.0f) * (1.0f - _1764)));
      }
      do {
        if (_1765 < 0.5f) {
          _1795 = ((_1732 * 2.0f) * _1765);
        } else {
          _1795 = (1.0f - (((1.0f - _1732) * 2.0f) * (1.0f - _1765)));
        }
        do {
          if (_1766 < 0.5f) {
            _1807 = ((_1733 * 2.0f) * _1766);
          } else {
            _1807 = (1.0f - (((1.0f - _1733) * 2.0f) * (1.0f - _1766)));
          }
          _1818 = (lerp(_1731, _1783, _1771));
          _1819 = (lerp(_1732, _1795, _1771));
          _1820 = (lerp(_1733, _1807, _1771));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1818 = _1731;
    _1819 = _1732;
    _1820 = _1733;
  }
  float _1838 = ((saturate(1.0f / (exp2(((_272 + -0.5f) * -1.4426950216293335f) * ((exp2(log2(max(VAR_FilmDamage_Contrast, 9.999999974752427e-07f)) * 10.0f) * 990.0f) + 10.0f)) + 1.0f)) - _272) * VAR_FilmDamage_Contrast) + _272;
  if (_1818 < 0.5f) {
    _1850 = ((_222 * 2.0f) * _1818);
  } else {
    _1850 = (1.0f - (((1.0f - _222) * 2.0f) * (1.0f - _1818)));
  }
  if (_1819 < 0.5f) {
    _1862 = ((_223 * 2.0f) * _1819);
  } else {
    _1862 = (1.0f - (((1.0f - _223) * 2.0f) * (1.0f - _1819)));
  }
  if (_1820 < 0.5f) {
    _1874 = ((_224 * 2.0f) * _1820);
  } else {
    _1874 = (1.0f - (((1.0f - _224) * 2.0f) * (1.0f - _1820)));
  }
  float _1883 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1850 - _1818)) + _1818;
  float _1884 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1862 - _1819)) + _1819;
  float _1885 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1874 - _1820)) + _1820;
  float _1896 = ((VAR_FilmDamage_Color.x - _1883) * _1838) + _1883;
  float _1897 = ((VAR_FilmDamage_Color.y - _1884) * _1838) + _1884;
  float _1898 = ((VAR_FilmDamage_Color.z - _1885) * _1838) + _1885;
  float _1906 = ((_222 - _1896) * VAR_Debug_FilmGrain_Texture) + _1896;
  float _1907 = ((_223 - _1897) * VAR_Debug_FilmGrain_Texture) + _1897;
  float _1908 = ((_224 - _1898) * VAR_Debug_FilmGrain_Texture) + _1898;
  SV_Target.x = (lerp(_1906, _1838, VAR_Debug_FilmDamage_Texture));
  SV_Target.y = (lerp(_1907, _1838, VAR_Debug_FilmDamage_Texture));
  SV_Target.z = (lerp(_1908, _1838, VAR_Debug_FilmDamage_Texture));
  SV_Target.w = 1.0f;
  return SV_Target;
}
