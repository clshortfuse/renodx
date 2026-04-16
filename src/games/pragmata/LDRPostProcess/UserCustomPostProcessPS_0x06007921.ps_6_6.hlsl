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
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  uint sceneInfoAdditionalFlags : packoffset(c039.x);
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

// clang-format off
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
  } cbControlRGCParam: packoffset(c005.x);
};
// clang-format on

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
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  uint _55 = uint(float((uint)(int)(distortionType)));
  bool _60 = (LDRPPSettings_enabled != 0);
  bool _61 = ((cPassEnabled & 1) != 0);
  float _327;
  float _328;
  float _329;
  float _419;
  float _974;
  float _975;
  float _976;
  float _1010;
  float _1011;
  float _1012;
  float _1023;
  float _1024;
  float _1025;
  float _1055;
  float _1071;
  float _1087;
  float _1115;
  float _1116;
  float _1117;
  float _1175;
  float _1196;
  float _1216;
  float _1224;
  float _1225;
  float _1226;
  float _1262;
  float _1272;
  float _1282;
  float _1308;
  float _1322;
  float _1336;
  float _1350;
  float _1359;
  float _1368;
  float _1393;
  float _1407;
  float _1421;
  float _1445;
  float _1455;
  float _1465;
  float _1490;
  float _1504;
  float _1518;
  float _1543;
  float _1553;
  float _1563;
  float _1588;
  float _1602;
  float _1616;
  float _1630;
  float _1631;
  float _1632;
  float _1646;
  float _1647;
  float _1648;
  float _1681;
  float _1682;
  float _1683;
  float _1733;
  float _1745;
  float _1757;
  float _1768;
  float _1769;
  float _1770;
  float _1786;
  float _1795;
  float _1804;
  float _1875;
  float _1876;
  float _1877;
  if (!(_61 && _60)) {
    float4 _71 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    float _78 = min(_71.x, 65000.0f) * Exposure;
    float _79 = min(_71.y, 65000.0f) * Exposure;
    float _80 = min(_71.z, 65000.0f) * Exposure;
    bool _83 = isfinite(max(max(_78, _79), _80));
    _327 = select(_83, _78, 1.0f);
    _328 = select(_83, _79, 1.0f);
    _329 = select(_83, _80, 1.0f);
  } else {
    if (_55 == 0) {
      float _95 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _96 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _97 = dot(float2(_95, _96), float2(_95, _96));
      float _99 = (_97 * fDistortionCoef) + 1.0f;
      float _100 = _95 * fCorrectCoef;
      float _102 = _96 * fCorrectCoef;
      float _104 = (_100 * _99) + 0.5f;
      float _105 = (_102 * _99) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _110 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_104, _105));
        _327 = (_110.x * Exposure);
        _328 = (_110.y * Exposure);
        _329 = (_110.z * Exposure);
      } else {
        float _129 = ((saturate((sqrt((_95 * _95) + (_96 * _96)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _139 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _140 = _129 * 2.0f;
          float _144 = (((_139 * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _149 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_144 * _100) + 0.5f), ((_144 * _102) + 0.5f)));
          float _155 = ((((_139 + 0.125f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _160 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_155 * _100) + 0.5f), ((_155 * _102) + 0.5f)));
          float _167 = ((((_139 + 0.25f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _172 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_167 * _100) + 0.5f), ((_167 * _102) + 0.5f)));
          float _181 = ((((_139 + 0.375f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _186 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_181 * _100) + 0.5f), ((_181 * _102) + 0.5f)));
          float _195 = ((((_139 + 0.5f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _200 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_195 * _100) + 0.5f), ((_195 * _102) + 0.5f)));
          float _206 = ((((_139 + 0.625f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _211 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_206 * _100) + 0.5f), ((_206 * _102) + 0.5f)));
          float _219 = ((((_139 + 0.75f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _224 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_219 * _100) + 0.5f), ((_219 * _102) + 0.5f)));
          float _239 = ((((_139 + 0.875f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _244 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_239 * _100) + 0.5f), ((_239 * _102) + 0.5f)));
          float _251 = ((((_139 + 1.0f) * _140) + _97) * fDistortionCoef) + 1.0f;
          float4 _256 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_251 * _100) + 0.5f), ((_251 * _102) + 0.5f)));
          float _259 = Exposure * 0.3199999928474426f;
          _327 = ((((_160.x + _149.x) + (_172.x * 0.75f)) + (_186.x * 0.375f)) * _259);
          _328 = ((Exposure * 0.3636363744735718f) * ((((_211.y + _186.y) * 0.625f) + _200.y) + ((_224.y + _172.y) * 0.25f)));
          _329 = (((((_224.z * 0.75f) + (_211.z * 0.375f)) + _244.z) + _256.z) * _259);
        } else {
          float _265 = _129 + _97;
          float _267 = (_265 * fDistortionCoef) + 1.0f;
          float _274 = ((_265 + _129) * fDistortionCoef) + 1.0f;
          float4 _279 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_104, _105));
          float4 _282 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_267 * _100) + 0.5f), ((_267 * _102) + 0.5f)));
          float4 _285 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_274 * _100) + 0.5f), ((_274 * _102) + 0.5f)));
          _327 = (_279.x * Exposure);
          _328 = (_282.y * Exposure);
          _329 = (_285.z * Exposure);
        }
      }
    } else {
      if (_55 == 1) {
        float _298 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _302 = sqrt((_298 * _298) + 1.0f);
        float _303 = 1.0f / _302;
        float _311 = ((_302 * fOptimizedParam.z) * (_303 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _319 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_311 * _298) + 0.5f), (((_311 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_303 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _327 = (_319.x * Exposure);
        _328 = (_319.y * Exposure);
        _329 = (_319.z * Exposure);
      } else {
        _327 = 0.0f;
        _328 = 0.0f;
        _329 = 0.0f;
      }
    }
  }
  if (_60 && (bool)((cPassEnabled & 32) != 0)) {
    float _369 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _373 = ComputeResultSRV[0].computeAlpha;
    float _376 = ((1.0f - _369) + (_373 * _369)) * cbRadialColor.w;
    if (!(_376 == 0.0f)) {
      float _382 = screenInverseSize.x * SV_Position.x;
      float _383 = screenInverseSize.y * SV_Position.y;
      float _385 = _382 + (-0.5f - cbRadialScreenPos.x);
      float _387 = _383 + (-0.5f - cbRadialScreenPos.y);
      float _390 = select((_385 < 0.0f), (1.0f - _382), _382);
      float _393 = select((_387 < 0.0f), (1.0f - _383), _383);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _399 = rsqrt(dot(float2(_385, _387), float2(_385, _387))) * cbRadialSharpRange;
          uint _406 = uint(abs(_399 * _387)) + uint(abs(_399 * _385));
          uint _410 = ((_406 ^ 61) ^ ((uint)(_406) >> 16)) * 9;
          uint _413 = (((uint)(_410) >> 4) ^ _410) * 668265261;
          _419 = (float((uint)((int)(((uint)(_413) >> 15) ^ _413))) * 2.3283064365386963e-10f);
        } else {
          _419 = 1.0f;
        }
        float _423 = sqrt((_385 * _385) + (_387 * _387));
        float _425 = 1.0f / max(1.0f, _423);
        float _426 = _419 * _390;
        float _427 = cbRadialBlurPower * _425;
        float _428 = _427 * -0.0011111111380159855f;
        float _430 = _419 * _393;
        float _434 = ((_428 * _426) + 1.0f) * _385;
        float _435 = ((_428 * _430) + 1.0f) * _387;
        float _437 = _427 * -0.002222222276031971f;
        float _442 = ((_437 * _426) + 1.0f) * _385;
        float _443 = ((_437 * _430) + 1.0f) * _387;
        float _444 = _427 * -0.0033333334140479565f;
        float _449 = ((_444 * _426) + 1.0f) * _385;
        float _450 = ((_444 * _430) + 1.0f) * _387;
        float _451 = _427 * -0.004444444552063942f;
        float _456 = ((_451 * _426) + 1.0f) * _385;
        float _457 = ((_451 * _430) + 1.0f) * _387;
        float _458 = _427 * -0.0055555556900799274f;
        float _463 = ((_458 * _426) + 1.0f) * _385;
        float _464 = ((_458 * _430) + 1.0f) * _387;
        float _465 = _427 * -0.006666666828095913f;
        float _470 = ((_465 * _426) + 1.0f) * _385;
        float _471 = ((_465 * _430) + 1.0f) * _387;
        float _472 = _427 * -0.007777777966111898f;
        float _477 = ((_472 * _426) + 1.0f) * _385;
        float _478 = ((_472 * _430) + 1.0f) * _387;
        float _479 = _427 * -0.008888889104127884f;
        float _484 = ((_479 * _426) + 1.0f) * _385;
        float _485 = ((_479 * _430) + 1.0f) * _387;
        float _488 = _425 * ((cbRadialBlurPower * -0.009999999776482582f) * _419);
        float _493 = ((_488 * _390) + 1.0f) * _385;
        float _494 = ((_488 * _393) + 1.0f) * _387;
        do {
          if (_61 && (bool)(_55 == 0)) {
            float _496 = _434 + cbRadialScreenPos.x;
            float _497 = _435 + cbRadialScreenPos.y;
            float _501 = ((dot(float2(_496, _497), float2(_496, _497)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _507 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_501 * _496) + 0.5f), ((_501 * _497) + 0.5f)), 0.0f);
            float _511 = _442 + cbRadialScreenPos.x;
            float _512 = _443 + cbRadialScreenPos.y;
            float _516 = ((dot(float2(_511, _512), float2(_511, _512)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _521 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_516 * _511) + 0.5f), ((_516 * _512) + 0.5f)), 0.0f);
            float _528 = _449 + cbRadialScreenPos.x;
            float _529 = _450 + cbRadialScreenPos.y;
            float _533 = ((dot(float2(_528, _529), float2(_528, _529)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _538 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_533 * _528) + 0.5f), ((_533 * _529) + 0.5f)), 0.0f);
            float _545 = _456 + cbRadialScreenPos.x;
            float _546 = _457 + cbRadialScreenPos.y;
            float _550 = ((dot(float2(_545, _546), float2(_545, _546)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _555 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_550 * _545) + 0.5f), ((_550 * _546) + 0.5f)), 0.0f);
            float _562 = _463 + cbRadialScreenPos.x;
            float _563 = _464 + cbRadialScreenPos.y;
            float _567 = ((dot(float2(_562, _563), float2(_562, _563)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _572 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_567 * _562) + 0.5f), ((_567 * _563) + 0.5f)), 0.0f);
            float _579 = _470 + cbRadialScreenPos.x;
            float _580 = _471 + cbRadialScreenPos.y;
            float _584 = ((dot(float2(_579, _580), float2(_579, _580)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _589 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_584 * _579) + 0.5f), ((_584 * _580) + 0.5f)), 0.0f);
            float _596 = _477 + cbRadialScreenPos.x;
            float _597 = _478 + cbRadialScreenPos.y;
            float _601 = ((dot(float2(_596, _597), float2(_596, _597)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _606 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_601 * _596) + 0.5f), ((_601 * _597) + 0.5f)), 0.0f);
            float _613 = _484 + cbRadialScreenPos.x;
            float _614 = _485 + cbRadialScreenPos.y;
            float _618 = ((dot(float2(_613, _614), float2(_613, _614)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _623 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_618 * _613) + 0.5f), ((_618 * _614) + 0.5f)), 0.0f);
            float _630 = _493 + cbRadialScreenPos.x;
            float _631 = _494 + cbRadialScreenPos.y;
            float _635 = ((dot(float2(_630, _631), float2(_630, _631)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _640 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_635 * _630) + 0.5f), ((_635 * _631) + 0.5f)), 0.0f);
            _974 = ((((((((_521.x + _507.x) + _538.x) + _555.x) + _572.x) + _589.x) + _606.x) + _623.x) + _640.x);
            _975 = ((((((((_521.y + _507.y) + _538.y) + _555.y) + _572.y) + _589.y) + _606.y) + _623.y) + _640.y);
            _976 = ((((((((_521.z + _507.z) + _538.z) + _555.z) + _572.z) + _589.z) + _606.z) + _623.z) + _640.z);
          } else {
            float _648 = cbRadialScreenPos.x + 0.5f;
            float _649 = _434 + _648;
            float _650 = cbRadialScreenPos.y + 0.5f;
            float _651 = _435 + _650;
            float _652 = _442 + _648;
            float _653 = _443 + _650;
            float _654 = _449 + _648;
            float _655 = _450 + _650;
            float _656 = _456 + _648;
            float _657 = _457 + _650;
            float _658 = _463 + _648;
            float _659 = _464 + _650;
            float _660 = _470 + _648;
            float _661 = _471 + _650;
            float _662 = _477 + _648;
            float _663 = _478 + _650;
            float _664 = _484 + _648;
            float _665 = _485 + _650;
            float _666 = _493 + _648;
            float _667 = _494 + _650;
            if (_61 && (bool)(_55 == 1)) {
              float _671 = (_649 * 2.0f) + -1.0f;
              float _675 = sqrt((_671 * _671) + 1.0f);
              float _676 = 1.0f / _675;
              float _683 = fOptimizedParam.w * 0.5f;
              float _684 = ((_675 * fOptimizedParam.z) * (_676 + fOptimizedParam.x)) * _683;
              float4 _691 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_684 * _671) + 0.5f), (((_684 * ((_651 * 2.0f) + -1.0f)) * (((_676 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _697 = (_652 * 2.0f) + -1.0f;
              float _701 = sqrt((_697 * _697) + 1.0f);
              float _702 = 1.0f / _701;
              float _709 = ((_701 * fOptimizedParam.z) * (_702 + fOptimizedParam.x)) * _683;
              float4 _715 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_709 * _697) + 0.5f), (((_709 * ((_653 * 2.0f) + -1.0f)) * (((_702 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _724 = (_654 * 2.0f) + -1.0f;
              float _728 = sqrt((_724 * _724) + 1.0f);
              float _729 = 1.0f / _728;
              float _736 = ((_728 * fOptimizedParam.z) * (_729 + fOptimizedParam.x)) * _683;
              float4 _742 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_736 * _724) + 0.5f), (((_736 * ((_655 * 2.0f) + -1.0f)) * (((_729 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _751 = (_656 * 2.0f) + -1.0f;
              float _755 = sqrt((_751 * _751) + 1.0f);
              float _756 = 1.0f / _755;
              float _763 = ((_755 * fOptimizedParam.z) * (_756 + fOptimizedParam.x)) * _683;
              float4 _769 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_763 * _751) + 0.5f), (((_763 * ((_657 * 2.0f) + -1.0f)) * (((_756 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _778 = (_658 * 2.0f) + -1.0f;
              float _782 = sqrt((_778 * _778) + 1.0f);
              float _783 = 1.0f / _782;
              float _790 = ((_782 * fOptimizedParam.z) * (_783 + fOptimizedParam.x)) * _683;
              float4 _796 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_790 * _778) + 0.5f), (((_790 * ((_659 * 2.0f) + -1.0f)) * (((_783 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _805 = (_660 * 2.0f) + -1.0f;
              float _809 = sqrt((_805 * _805) + 1.0f);
              float _810 = 1.0f / _809;
              float _817 = ((_809 * fOptimizedParam.z) * (_810 + fOptimizedParam.x)) * _683;
              float4 _823 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_817 * _805) + 0.5f), (((_817 * ((_661 * 2.0f) + -1.0f)) * (((_810 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _832 = (_662 * 2.0f) + -1.0f;
              float _836 = sqrt((_832 * _832) + 1.0f);
              float _837 = 1.0f / _836;
              float _844 = ((_836 * fOptimizedParam.z) * (_837 + fOptimizedParam.x)) * _683;
              float4 _850 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_844 * _832) + 0.5f), (((_844 * ((_663 * 2.0f) + -1.0f)) * (((_837 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _859 = (_664 * 2.0f) + -1.0f;
              float _863 = sqrt((_859 * _859) + 1.0f);
              float _864 = 1.0f / _863;
              float _871 = ((_863 * fOptimizedParam.z) * (_864 + fOptimizedParam.x)) * _683;
              float4 _877 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_871 * _859) + 0.5f), (((_871 * ((_665 * 2.0f) + -1.0f)) * (((_864 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _886 = (_666 * 2.0f) + -1.0f;
              float _890 = sqrt((_886 * _886) + 1.0f);
              float _891 = 1.0f / _890;
              float _898 = ((_890 * fOptimizedParam.z) * (_891 + fOptimizedParam.x)) * _683;
              float4 _904 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_898 * _886) + 0.5f), (((_898 * ((_667 * 2.0f) + -1.0f)) * (((_891 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _974 = ((((((((_715.x + _691.x) + _742.x) + _769.x) + _796.x) + _823.x) + _850.x) + _877.x) + _904.x);
              _975 = ((((((((_715.y + _691.y) + _742.y) + _769.y) + _796.y) + _823.y) + _850.y) + _877.y) + _904.y);
              _976 = ((((((((_715.z + _691.z) + _742.z) + _769.z) + _796.z) + _823.z) + _850.z) + _877.z) + _904.z);
            } else {
              float4 _913 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_649, _651), 0.0f);
              float4 _917 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_652, _653), 0.0f);
              float4 _924 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_654, _655), 0.0f);
              float4 _931 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_656, _657), 0.0f);
              float4 _938 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_658, _659), 0.0f);
              float4 _945 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_660, _661), 0.0f);
              float4 _952 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_662, _663), 0.0f);
              float4 _959 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_664, _665), 0.0f);
              float4 _966 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_666, _667), 0.0f);
              _974 = ((((((((_917.x + _913.x) + _924.x) + _931.x) + _938.x) + _945.x) + _952.x) + _959.x) + _966.x);
              _975 = ((((((((_917.y + _913.y) + _924.y) + _931.y) + _938.y) + _945.y) + _952.y) + _959.y) + _966.y);
              _976 = ((((((((_917.z + _913.z) + _924.z) + _931.z) + _938.z) + _945.z) + _952.z) + _959.z) + _966.z);
            }
          }
          float _986 = (cbRadialColor.z * (_329 + (Exposure * _976))) * 0.10000000149011612f;
          float _987 = (cbRadialColor.y * (_328 + (Exposure * _975))) * 0.10000000149011612f;
          float _988 = (cbRadialColor.x * (_327 + (Exposure * _974))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _993 = saturate((_423 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _999 = (((_993 * _993) * cbRadialMaskRate.x) * (3.0f - (_993 * 2.0f))) + cbRadialMaskRate.y;
              _1010 = ((_999 * (_988 - _327)) + _327);
              _1011 = ((_999 * (_987 - _328)) + _328);
              _1012 = ((_999 * (_986 - _329)) + _329);
            } else {
              _1010 = _988;
              _1011 = _987;
              _1012 = _986;
            }
            _1023 = (lerp(_327, _1010, _376));
            _1024 = (lerp(_328, _1011, _376));
            _1025 = (lerp(_329, _1012, _376));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1023 = _327;
      _1024 = _328;
      _1025 = _329;
    }
  } else {
    _1023 = _327;
    _1024 = _328;
    _1025 = _329;
  }
  if (_60 && (bool)((cPassEnabled & 2) != 0)) {
    float _1033 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1035 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1041 = frac(frac((_1035 * 0.005837149918079376f) + (_1033 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1041 < fNoiseDensity) {
        int _1046 = (uint)(uint(_1035 * _1033)) ^ 12345391;
        uint _1047 = _1046 * 3635641;
        _1055 = (float((uint)((int)((((uint)(_1047) >> 26) | ((uint)(_1046 * 232681024))) ^ _1047))) * 2.3283064365386963e-10f);
      } else {
        _1055 = 0.0f;
      }
      float _1057 = frac(_1041 * 757.4846801757812f);
      do {
        if (_1057 < fNoiseDensity) {
          int _1061 = asint(_1057) ^ 12345391;
          uint _1062 = _1061 * 3635641;
          _1071 = ((float((uint)((int)((((uint)(_1062) >> 26) | ((uint)(_1061 * 232681024))) ^ _1062))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1071 = 0.0f;
        }
        float _1073 = frac(_1057 * 757.4846801757812f);
        do {
          if (_1073 < fNoiseDensity) {
            int _1077 = asint(_1073) ^ 12345391;
            uint _1078 = _1077 * 3635641;
            _1087 = ((float((uint)((int)((((uint)(_1078) >> 26) | ((uint)(_1077 * 232681024))) ^ _1078))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1087 = 0.0f;
          }
          float _1088 = _1055 * CUSTOM_NOISE * fNoisePower.x;
          float _1089 = _1087 * CUSTOM_NOISE * fNoisePower.y;
          float _1090 = _1071 * CUSTOM_NOISE * fNoisePower.y;
          float _1104 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1023), saturate(_1024), saturate(_1025)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1115 = ((_1104 * (mad(_1090, 1.4019999504089355f, _1088) - _1023)) + _1023);
          _1116 = ((_1104 * (mad(_1090, -0.7139999866485596f, mad(_1089, -0.3440000116825104f, _1088)) - _1024)) + _1024);
          _1117 = ((_1104 * (mad(_1089, 1.7719999551773071f, _1088) - _1025)) + _1025);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1115 = _1023;
    _1116 = _1024;
    _1117 = _1025;
  }
  float _1132 = mad(_1117, (fOCIOTransformMatrix[2].x), mad(_1116, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1115)));
  float _1135 = mad(_1117, (fOCIOTransformMatrix[2].y), mad(_1116, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1115)));
  float _1138 = mad(_1117, (fOCIOTransformMatrix[2].z), mad(_1116, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1115)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1144 = max(max(_1132, _1135), _1138);
    if (!(_1144 == 0.0f)) {
      float _1150 = abs(_1144);
      float _1151 = (_1144 - _1132) / _1150;
      float _1152 = (_1144 - _1135) / _1150;
      float _1153 = (_1144 - _1138) / _1150;
      do {
        if (!(!(_1151 >= cbControlRGCParam.CyanThreshold))) {
          float _1163 = _1151 - cbControlRGCParam.CyanThreshold;
          _1175 = ((_1163 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1163) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1175 = _1151;
        }
        do {
          if (!(!(_1152 >= cbControlRGCParam.MagentaThreshold))) {
            float _1184 = _1152 - cbControlRGCParam.MagentaThreshold;
            _1196 = ((_1184 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1184) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1196 = _1152;
          }
          do {
            if (!(!(_1153 >= cbControlRGCParam.YellowThreshold))) {
              float _1204 = _1153 - cbControlRGCParam.YellowThreshold;
              _1216 = ((_1204 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1204) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1216 = _1153;
            }
            _1224 = (_1144 - (_1175 * _1150));
            _1225 = (_1144 - (_1196 * _1150));
            _1226 = (_1144 - (_1216 * _1150));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1224 = _1132;
      _1225 = _1135;
      _1226 = _1138;
    }
  } else {
    _1224 = _1132;
    _1225 = _1135;
    _1226 = _1138;
  }
  if (_60 && (bool)((cPassEnabled & 4) != 0)) {
    bool _1253 = !(_1224 <= 0.0078125f);
    do {
      if (!_1253) {
        _1262 = ((_1224 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _1262 = ((log2(_1224) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _1263 = !(_1225 <= 0.0078125f);
      do {
        if (!_1263) {
          _1272 = ((_1225 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1272 = ((log2(_1225) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _1273 = !(_1226 <= 0.0078125f);
        do {
          if (!_1273) {
            _1282 = ((_1226 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1282 = ((log2(_1226) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _1291 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_1262 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1272 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1282 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_1291.x < 0.155251145362854f) {
              _1308 = ((_1291.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_1291.x >= 0.155251145362854f) && (bool)(_1291.x < 1.4679962396621704f)) {
                _1308 = exp2((_1291.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _1308 = 65504.0f;
              }
            }
            do {
              if (_1291.y < 0.155251145362854f) {
                _1322 = ((_1291.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_1291.y >= 0.155251145362854f) && (bool)(_1291.y < 1.4679962396621704f)) {
                  _1322 = exp2((_1291.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1322 = 65504.0f;
                }
              }
              do {
                if (_1291.z < 0.155251145362854f) {
                  _1336 = ((_1291.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_1291.z >= 0.155251145362854f) && (bool)(_1291.z < 1.4679962396621704f)) {
                    _1336 = exp2((_1291.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1336 = 65504.0f;
                  }
                }
                float _1337 = max(_1308, 0.0f);
                float _1338 = max(_1322, 0.0f);
                float _1339 = max(_1336, 0.0f);
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!_1253) {
                        _1350 = ((_1224 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _1350 = ((log2(_1224) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_1263) {
                          _1359 = ((_1225 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1359 = ((log2(_1225) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_1273) {
                            _1368 = ((_1226 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1368 = ((log2(_1226) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          float4 _1376 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_1350 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1359 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1368 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_1376.x < 0.155251145362854f) {
                              _1393 = ((_1376.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_1376.x >= 0.155251145362854f) && (bool)(_1376.x < 1.4679962396621704f)) {
                                _1393 = exp2((_1376.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _1393 = 65504.0f;
                              }
                            }
                            do {
                              if (_1376.y < 0.155251145362854f) {
                                _1407 = ((_1376.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_1376.y >= 0.155251145362854f) && (bool)(_1376.y < 1.4679962396621704f)) {
                                  _1407 = exp2((_1376.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1407 = 65504.0f;
                                }
                              }
                              do {
                                if (_1376.z < 0.155251145362854f) {
                                  _1421 = ((_1376.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_1376.z >= 0.155251145362854f) && (bool)(_1376.z < 1.4679962396621704f)) {
                                    _1421 = exp2((_1376.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1421 = 65504.0f;
                                  }
                                }
                                float _1431 = ((max(_1393, 0.0f) - _1337) * fTextureBlendRate) + _1337;
                                float _1432 = ((max(_1407, 0.0f) - _1338) * fTextureBlendRate) + _1338;
                                float _1433 = ((max(_1421, 0.0f) - _1339) * fTextureBlendRate) + _1339;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_1431 <= 0.0078125f))) {
                                      _1445 = ((_1431 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _1445 = ((log2(_1431) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_1432 <= 0.0078125f))) {
                                        _1455 = ((_1432 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _1455 = ((log2(_1432) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_1433 <= 0.0078125f))) {
                                          _1465 = ((_1433 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _1465 = ((log2(_1433) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        float4 _1473 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1445 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1455 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1465 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_1473.x < 0.155251145362854f) {
                                            _1490 = ((_1473.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((bool)(_1473.x >= 0.155251145362854f) && (bool)(_1473.x < 1.4679962396621704f)) {
                                              _1490 = exp2((_1473.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _1490 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_1473.y < 0.155251145362854f) {
                                              _1504 = ((_1473.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((bool)(_1473.y >= 0.155251145362854f) && (bool)(_1473.y < 1.4679962396621704f)) {
                                                _1504 = exp2((_1473.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _1504 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_1473.z < 0.155251145362854f) {
                                                _1518 = ((_1473.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((bool)(_1473.z >= 0.155251145362854f) && (bool)(_1473.z < 1.4679962396621704f)) {
                                                  _1518 = exp2((_1473.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _1518 = 65504.0f;
                                                }
                                              }
                                              _1630 = (((max(_1490, 0.0f) - _1431) * fTextureBlendRate2) + _1431);
                                              _1631 = (((max(_1504, 0.0f) - _1432) * fTextureBlendRate2) + _1432);
                                              _1632 = (((max(_1518, 0.0f) - _1433) * fTextureBlendRate2) + _1433);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1630 = _1431;
                                  _1631 = _1432;
                                  _1632 = _1433;
                                }
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } else {
                    if (fTextureBlendRate2 > 0.0f) {
                      do {
                        if (!(!(_1337 <= 0.0078125f))) {
                          _1543 = ((_1337 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1543 = ((log2(_1337) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_1338 <= 0.0078125f))) {
                            _1553 = ((_1338 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1553 = ((log2(_1338) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_1339 <= 0.0078125f))) {
                              _1563 = ((_1339 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _1563 = ((log2(_1339) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _1571 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1543 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1553 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1563 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_1571.x < 0.155251145362854f) {
                                _1588 = ((_1571.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_1571.x >= 0.155251145362854f) && (bool)(_1571.x < 1.4679962396621704f)) {
                                  _1588 = exp2((_1571.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1588 = 65504.0f;
                                }
                              }
                              do {
                                if (_1571.y < 0.155251145362854f) {
                                  _1602 = ((_1571.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_1571.y >= 0.155251145362854f) && (bool)(_1571.y < 1.4679962396621704f)) {
                                    _1602 = exp2((_1571.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1602 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_1571.z < 0.155251145362854f) {
                                    _1616 = ((_1571.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((bool)(_1571.z >= 0.155251145362854f) && (bool)(_1571.z < 1.4679962396621704f)) {
                                      _1616 = exp2((_1571.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _1616 = 65504.0f;
                                    }
                                  }
                                  _1630 = (((max(_1588, 0.0f) - _1337) * fTextureBlendRate2) + _1337);
                                  _1631 = (((max(_1602, 0.0f) - _1338) * fTextureBlendRate2) + _1338);
                                  _1632 = (((max(_1616, 0.0f) - _1339) * fTextureBlendRate2) + _1339);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _1630 = _1337;
                      _1631 = _1338;
                      _1632 = _1339;
                    }
                  }
                  _1646 = (mad(_1632, (fColorMatrix[2].x), mad(_1631, (fColorMatrix[1].x), (_1630 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _1647 = (mad(_1632, (fColorMatrix[2].y), mad(_1631, (fColorMatrix[1].y), (_1630 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _1648 = (mad(_1632, (fColorMatrix[2].z), mad(_1631, (fColorMatrix[1].z), (_1630 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1646 = _1224;
    _1647 = _1225;
    _1648 = _1226;
  }
  if (_60 && (bool)((cPassEnabled & 8) != 0)) {
    _1681 = (((cvdR.x * _1646) + (cvdR.y * _1647)) + (cvdR.z * _1648));
    _1682 = (((cvdG.x * _1646) + (cvdG.y * _1647)) + (cvdG.z * _1648));
    _1683 = (((cvdB.x * _1646) + (cvdB.y * _1647)) + (cvdB.z * _1648));
  } else {
    _1681 = _1646;
    _1682 = _1647;
    _1683 = _1648;
  }
  float _1687 = screenInverseSize.x * SV_Position.x;
  float _1688 = screenInverseSize.y * SV_Position.y;
  float4 _1694 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1687, _1688), 0.0f);
  if (_60 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1708 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1687, _1688), 0.0f);
    float _1714 = ColorParam.x * _1694.x;
    float _1715 = ColorParam.y * _1694.y;
    float _1716 = ColorParam.z * _1694.z;
    float _1721 = (ColorParam.w * _1694.w) * saturate((_1708.x * Levels_Rate) + Levels_Range);
    do {
      if (_1714 < 0.5f) {
        _1733 = ((_1681 * 2.0f) * _1714);
      } else {
        _1733 = (1.0f - (((1.0f - _1681) * 2.0f) * (1.0f - _1714)));
      }
      do {
        if (_1715 < 0.5f) {
          _1745 = ((_1682 * 2.0f) * _1715);
        } else {
          _1745 = (1.0f - (((1.0f - _1682) * 2.0f) * (1.0f - _1715)));
        }
        do {
          if (_1716 < 0.5f) {
            _1757 = ((_1683 * 2.0f) * _1716);
          } else {
            _1757 = (1.0f - (((1.0f - _1683) * 2.0f) * (1.0f - _1716)));
          }
          _1768 = (lerp(_1681, _1733, _1721));
          _1769 = (lerp(_1682, _1745, _1721));
          _1770 = (lerp(_1683, _1757, _1721));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1768 = _1681;
    _1769 = _1682;
    _1770 = _1683;
  }
  if (tonemapParam_isHDRMode == 0.0f) {
    float _1778 = invLinearBegin * _1768;
    do {
      if (!(_1768 >= linearBegin)) {
        _1786 = ((_1778 * _1778) * (3.0f - (_1778 * 2.0f)));
      } else {
        _1786 = 1.0f;
      }
      float _1787 = invLinearBegin * _1769;
      do {
        if (!(_1769 >= linearBegin)) {
          _1795 = ((_1787 * _1787) * (3.0f - (_1787 * 2.0f)));
        } else {
          _1795 = 1.0f;
        }
        float _1796 = invLinearBegin * _1770;
        do {
          if (!(_1770 >= linearBegin)) {
            _1804 = ((_1796 * _1796) * (3.0f - (_1796 * 2.0f)));
          } else {
            _1804 = 1.0f;
          }
          float _1813 = select((_1768 < linearStart), 0.0f, 1.0f);
          float _1814 = select((_1769 < linearStart), 0.0f, 1.0f);
          float _1815 = select((_1770 < linearStart), 0.0f, 1.0f);
          _1875 = (((((1.0f - _1786) * linearBegin) * (pow(_1778, toe))) + ((_1786 - _1813) * ((contrast * _1768) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1768) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1813));
          _1876 = (((((1.0f - _1795) * linearBegin) * (pow(_1787, toe))) + ((_1795 - _1814) * ((contrast * _1769) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1769) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1814));
          _1877 = (((((1.0f - _1804) * linearBegin) * (pow(_1796, toe))) + ((_1804 - _1815) * ((contrast * _1770) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1770) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1815));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1875 = _1768;
    _1876 = _1769;
    _1877 = _1770;
  }
  SV_Target.x = _1875;
  SV_Target.y = _1876;
  SV_Target.z = _1877;
  SV_Target.w = 1.0f;
  return SV_Target;
}
