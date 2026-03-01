#include "./PostProcess.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

Texture2D<float2> HazeNoiseResult : register(t4);

struct RadialBlurComputeResult {
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t5);

Texture3D<float4> tTextureMap0 : register(t6);

Texture3D<float4> tTextureMap1 : register(t7);

Texture3D<float4> tTextureMap2 : register(t8);

Texture2D<float4> ImagePlameBase : register(t9);

Texture2D<float> ImagePlameAlpha : register(t10);

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

SamplerState PointClamp : register(s1, space32);

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
  bool _31 = ((cPassEnabled & 1) == 0);
  bool _37;
  bool _43;
  float _188;
  float _189;
  float _210;
  float _332;
  float _333;
  float _341;
  float _342;
  float _662;
  float _663;
  float _684;
  float _806;
  float _807;
  float _815;
  float _816;
  float _944;
  float _945;
  float _968;
  float _1090;
  float _1091;
  float _1097;
  float _1098;
  float _1108;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1115;
  float _1116;
  float _1189;
  float _1744;
  float _1745;
  float _1746;
  float _1780;
  float _1781;
  float _1782;
  float _1793;
  float _1794;
  float _1795;
  float _1834;
  float _1850;
  float _1866;
  float _1894;
  float _1895;
  float _1896;
  float _1954;
  float _1975;
  float _1995;
  float _2003;
  float _2004;
  float _2005;
  float _2215;
  float _2216;
  float _2217;
  float _2231;
  float _2232;
  float _2233;
  float _2268;
  float _2269;
  float _2270;
  float _2313;
  float _2325;
  float _2337;
  float _2348;
  float _2349;
  float _2350;
  float _2411;
  float _2444;
  float _2455;
  float _2466;
  float _2467;
  float _2468;
  if (!_31) {
    _37 = (distortionType == 0);
  } else {
    _37 = false;
  }
  if (!_31) {
    _43 = (distortionType == 1);
  } else {
    _43 = false;
  }
  bool _45 = ((cPassEnabled & 64) != 0);
  if (_37) {
    float _62 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _63 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _64 = dot(float2(_62, _63), float2(_62, _63));
    float _66 = (_64 * fDistortionCoef) + 1.0f;
    float _67 = fCorrectCoef * _62;
    float _68 = _66 * _67;
    float _69 = fCorrectCoef * _63;
    float _70 = _66 * _69;
    float _71 = _68 + 0.5f;
    float _72 = _70 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _82 = HazeNoiseResult.Sample(BilinearWrap, float2(_71, _72));
            _341 = ((fHazeFilterScale * _82.x) + _71);
            _342 = ((fHazeFilterScale * _82.y) + _72);
          } else {
            bool _94 = ((fHazeFilterAttribute & 2) != 0);
            float _98 = tFilterTempMap1.Sample(BilinearWrap, float2(_71, _72));
            do {
              if (_94) {
                float _105 = ReadonlyDepth.SampleLevel(PointClamp, float2(_71, _72), 0.0f);
                float _113 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _71) + -1.0f;
                float _114 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _72);
                float _151 = 1.0f / (mad(_105.x, (viewProjInvMat[2].w), mad(_114, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _113))) + (viewProjInvMat[3].w));
                float _153 = _151 * (mad(_105.x, (viewProjInvMat[2].y), mad(_114, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _113))) + (viewProjInvMat[3].y));
                float _161 = (_151 * (mad(_105.x, (viewProjInvMat[2].x), mad(_114, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _113))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _162 = _153 - (transposeViewInvMat[1].w);
                float _163 = (_151 * (mad(_105.x, (viewProjInvMat[2].z), mad(_114, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _113))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _188 = saturate(max(((sqrt(((_162 * _162) + (_161 * _161)) + (_163 * _163)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_153 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _98.x);
                _189 = _105.x;
              } else {
                _188 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _98.x), _98.x);
                _189 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _203 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _210 = (1.0f - saturate(max((_203 * min(max((abs(_68) - fHazeFilterBorder), 0.0f), 1.0f)), (_203 * min(max((abs(_70) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _210 = 1.0f;
                }
                float _211 = _210 * _188;
                do {
                  if (!(_211 <= 9.999999747378752e-06f)) {
                    float _218 = -0.0f - _72;
                    float _241 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_218, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _71))) * fHazeFilterUVWOffset.w;
                    float _242 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_218, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _71))) * fHazeFilterUVWOffset.w;
                    float _243 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_218, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _71))) * fHazeFilterUVWOffset.w;
                    float _248 = tVolumeMap.Sample(BilinearWrap, float3((_241 + fHazeFilterUVWOffset.x), (_242 + fHazeFilterUVWOffset.y), (_243 + fHazeFilterUVWOffset.z)));
                    float _251 = _241 * 2.0f;
                    float _252 = _242 * 2.0f;
                    float _253 = _243 * 2.0f;
                    float _257 = tVolumeMap.Sample(BilinearWrap, float3((_251 + fHazeFilterUVWOffset.x), (_252 + fHazeFilterUVWOffset.y), (_253 + fHazeFilterUVWOffset.z)));
                    float _261 = _241 * 4.0f;
                    float _262 = _242 * 4.0f;
                    float _263 = _243 * 4.0f;
                    float _267 = tVolumeMap.Sample(BilinearWrap, float3((_261 + fHazeFilterUVWOffset.x), (_262 + fHazeFilterUVWOffset.y), (_263 + fHazeFilterUVWOffset.z)));
                    float _271 = _241 * 8.0f;
                    float _272 = _242 * 8.0f;
                    float _273 = _243 * 8.0f;
                    float _277 = tVolumeMap.Sample(BilinearWrap, float3((_271 + fHazeFilterUVWOffset.x), (_272 + fHazeFilterUVWOffset.y), (_273 + fHazeFilterUVWOffset.z)));
                    float _281 = fHazeFilterUVWOffset.x + 0.5f;
                    float _282 = fHazeFilterUVWOffset.y + 0.5f;
                    float _283 = fHazeFilterUVWOffset.z + 0.5f;
                    float _287 = tVolumeMap.Sample(BilinearWrap, float3((_241 + _281), (_242 + _282), (_243 + _283)));
                    float _293 = tVolumeMap.Sample(BilinearWrap, float3((_251 + _281), (_252 + _282), (_253 + _283)));
                    float _300 = tVolumeMap.Sample(BilinearWrap, float3((_261 + _281), (_262 + _282), (_263 + _283)));
                    float _307 = tVolumeMap.Sample(BilinearWrap, float3((_271 + _281), (_272 + _282), (_273 + _283)));
                    float _315 = ((((((_257.x * 0.25f) + (_248.x * 0.5f)) + (_267.x * 0.125f)) + (_277.x * 0.0625f)) * 2.0f) + -1.0f) * _211;
                    float _316 = ((((((_293.x * 0.25f) + (_287.x * 0.5f)) + (_300.x * 0.125f)) + (_307.x * 0.0625f)) * 2.0f) + -1.0f) * _211;
                    if (_94) {
                      float _325 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _315) + _71), ((fHazeFilterScale * _316) + _72)));
                      if (!((_325.x - _189) >= fHazeFilterDepthDiffBias)) {
                        _332 = _315;
                        _333 = _316;
                      } else {
                        _332 = 0.0f;
                        _333 = 0.0f;
                      }
                    } else {
                      _332 = _315;
                      _333 = _316;
                    }
                  } else {
                    _332 = 0.0f;
                    _333 = 0.0f;
                  }
                  _341 = ((fHazeFilterScale * _332) + _71);
                  _342 = ((fHazeFilterScale * _333) + _72);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _341 = _71;
          _342 = _72;
        }
        float4 _345 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_341, _342));
        _1108 = _345.x;
        _1109 = _345.y;
        _1110 = _345.z;
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      } while (false);
    } else {
      float _365 = ((saturate((sqrt((_62 * _62) + (_63 * _63)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        float _377 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        float _378 = _365 * 2.0f;
        float _382 = (((_377 * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _387 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_382 * _67) + 0.5f), ((_382 * _69) + 0.5f)));
        float _393 = ((((_377 + 0.125f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _398 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_393 * _67) + 0.5f), ((_393 * _69) + 0.5f)));
        float _405 = ((((_377 + 0.25f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _410 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_405 * _67) + 0.5f), ((_405 * _69) + 0.5f)));
        float _419 = ((((_377 + 0.375f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _424 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_419 * _67) + 0.5f), ((_419 * _69) + 0.5f)));
        float _433 = ((((_377 + 0.5f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _438 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_433 * _67) + 0.5f), ((_433 * _69) + 0.5f)));
        float _444 = ((((_377 + 0.625f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _449 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_444 * _67) + 0.5f), ((_444 * _69) + 0.5f)));
        float _457 = ((((_377 + 0.75f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _462 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_457 * _67) + 0.5f), ((_457 * _69) + 0.5f)));
        float _477 = ((((_377 + 0.875f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _482 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_477 * _67) + 0.5f), ((_477 * _69) + 0.5f)));
        float _489 = ((((_377 + 1.0f) * _378) + _64) * fDistortionCoef) + 1.0f;
        float4 _494 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_489 * _67) + 0.5f), ((_489 * _69) + 0.5f)));
        _1108 = ((((_398.x + _387.x) + (_410.x * 0.75f)) + (_424.x * 0.375f)) * 0.3199999928474426f);
        _1109 = (((((_449.y + _424.y) * 0.625f) + _438.y) + ((_462.y + _410.y) * 0.25f)) * 0.3636363744735718f);
        _1110 = (((((_462.z * 0.75f) + (_449.z * 0.375f)) + _482.z) + _494.z) * 0.3199999928474426f);
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      } else {
        float _501 = _365 + _64;
        float _503 = (_501 * fDistortionCoef) + 1.0f;
        float _510 = ((_501 + _365) * fDistortionCoef) + 1.0f;
        float4 _515 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_71, _72));
        float4 _517 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_503 * _67) + 0.5f), ((_503 * _69) + 0.5f)));
        float4 _519 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_510 * _67) + 0.5f), ((_510 * _69) + 0.5f)));
        _1108 = _515.x;
        _1109 = _517.y;
        _1110 = _519.z;
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      }
    }
  } else {
    if (_43) {
      float _528 = screenInverseSize.x * 2.0f;
      float _530 = screenInverseSize.y * 2.0f;
      float _532 = (_528 * SV_Position.x) + -1.0f;
      float _536 = sqrt((_532 * _532) + 1.0f);
      float _537 = 1.0f / _536;
      float _545 = ((_536 * fOptimizedParam.z) * (_537 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      float _546 = _545 * _532;
      float _548 = (_545 * ((_530 * SV_Position.y) + -1.0f)) * (((_537 + -1.0f) * fOptimizedParam.y) + 1.0f);
      float _549 = _546 + 0.5f;
      float _550 = _548 + 0.5f;
      do {
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _558 = HazeNoiseResult.Sample(BilinearWrap, float2(_549, _550));
            _815 = ((fHazeFilterScale * _558.x) + _549);
            _816 = ((fHazeFilterScale * _558.y) + _550);
          } else {
            bool _570 = ((fHazeFilterAttribute & 2) != 0);
            float _574 = tFilterTempMap1.Sample(BilinearWrap, float2(_549, _550));
            do {
              if (_570) {
                float _581 = ReadonlyDepth.SampleLevel(PointClamp, float2(_549, _550), 0.0f);
                float _587 = ((_528 * screenSize.x) * _549) + -1.0f;
                float _588 = 1.0f - ((_530 * screenSize.y) * _550);
                float _625 = 1.0f / (mad(_581.x, (viewProjInvMat[2].w), mad(_588, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _587))) + (viewProjInvMat[3].w));
                float _627 = _625 * (mad(_581.x, (viewProjInvMat[2].y), mad(_588, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _587))) + (viewProjInvMat[3].y));
                float _635 = (_625 * (mad(_581.x, (viewProjInvMat[2].x), mad(_588, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _587))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _636 = _627 - (transposeViewInvMat[1].w);
                float _637 = (_625 * (mad(_581.x, (viewProjInvMat[2].z), mad(_588, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _587))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _662 = saturate(max(((sqrt(((_636 * _636) + (_635 * _635)) + (_637 * _637)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_627 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _574.x);
                _663 = _581.x;
              } else {
                _662 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _574.x), _574.x);
                _663 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _677 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _684 = (1.0f - saturate(max((_677 * min(max((abs(_546) - fHazeFilterBorder), 0.0f), 1.0f)), (_677 * min(max((abs(_548) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _684 = 1.0f;
                }
                float _685 = _684 * _662;
                do {
                  if (!(_685 <= 9.999999747378752e-06f)) {
                    float _692 = -0.0f - _550;
                    float _715 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_692, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _549))) * fHazeFilterUVWOffset.w;
                    float _716 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_692, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _549))) * fHazeFilterUVWOffset.w;
                    float _717 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_692, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _549))) * fHazeFilterUVWOffset.w;
                    float _722 = tVolumeMap.Sample(BilinearWrap, float3((_715 + fHazeFilterUVWOffset.x), (_716 + fHazeFilterUVWOffset.y), (_717 + fHazeFilterUVWOffset.z)));
                    float _725 = _715 * 2.0f;
                    float _726 = _716 * 2.0f;
                    float _727 = _717 * 2.0f;
                    float _731 = tVolumeMap.Sample(BilinearWrap, float3((_725 + fHazeFilterUVWOffset.x), (_726 + fHazeFilterUVWOffset.y), (_727 + fHazeFilterUVWOffset.z)));
                    float _735 = _715 * 4.0f;
                    float _736 = _716 * 4.0f;
                    float _737 = _717 * 4.0f;
                    float _741 = tVolumeMap.Sample(BilinearWrap, float3((_735 + fHazeFilterUVWOffset.x), (_736 + fHazeFilterUVWOffset.y), (_737 + fHazeFilterUVWOffset.z)));
                    float _745 = _715 * 8.0f;
                    float _746 = _716 * 8.0f;
                    float _747 = _717 * 8.0f;
                    float _751 = tVolumeMap.Sample(BilinearWrap, float3((_745 + fHazeFilterUVWOffset.x), (_746 + fHazeFilterUVWOffset.y), (_747 + fHazeFilterUVWOffset.z)));
                    float _755 = fHazeFilterUVWOffset.x + 0.5f;
                    float _756 = fHazeFilterUVWOffset.y + 0.5f;
                    float _757 = fHazeFilterUVWOffset.z + 0.5f;
                    float _761 = tVolumeMap.Sample(BilinearWrap, float3((_715 + _755), (_716 + _756), (_717 + _757)));
                    float _767 = tVolumeMap.Sample(BilinearWrap, float3((_725 + _755), (_726 + _756), (_727 + _757)));
                    float _774 = tVolumeMap.Sample(BilinearWrap, float3((_735 + _755), (_736 + _756), (_737 + _757)));
                    float _781 = tVolumeMap.Sample(BilinearWrap, float3((_745 + _755), (_746 + _756), (_747 + _757)));
                    float _789 = ((((((_731.x * 0.25f) + (_722.x * 0.5f)) + (_741.x * 0.125f)) + (_751.x * 0.0625f)) * 2.0f) + -1.0f) * _685;
                    float _790 = ((((((_767.x * 0.25f) + (_761.x * 0.5f)) + (_774.x * 0.125f)) + (_781.x * 0.0625f)) * 2.0f) + -1.0f) * _685;
                    if (_570) {
                      float _799 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _789) + _549), ((fHazeFilterScale * _790) + _550)));
                      if (!((_799.x - _663) >= fHazeFilterDepthDiffBias)) {
                        _806 = _789;
                        _807 = _790;
                      } else {
                        _806 = 0.0f;
                        _807 = 0.0f;
                      }
                    } else {
                      _806 = _789;
                      _807 = _790;
                    }
                  } else {
                    _806 = 0.0f;
                    _807 = 0.0f;
                  }
                  _815 = ((fHazeFilterScale * _806) + _549);
                  _816 = ((fHazeFilterScale * _807) + _550);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _815 = _549;
          _816 = _550;
        }
        float4 _819 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_815, _816));
        _1108 = _819.x;
        _1109 = _819.y;
        _1110 = _819.z;
        _1111 = 0.0f;
        _1112 = fOptimizedParam.x;
        _1113 = fOptimizedParam.y;
        _1114 = fOptimizedParam.z;
        _1115 = fOptimizedParam.w;
        _1116 = 1.0f;
      } while (false);
    } else {
      float _824 = screenInverseSize.x * SV_Position.x;
      float _825 = screenInverseSize.y * SV_Position.y;
      if (!_45) {
        float4 _829 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_824, _825));
        _1108 = _829.x;
        _1109 = _829.y;
        _1110 = _829.z;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = 1.0f;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _840 = HazeNoiseResult.Sample(BilinearWrap, float2(_824, _825));
            _1097 = (fHazeFilterScale * _840.x);
            _1098 = (fHazeFilterScale * _840.y);
          } else {
            bool _850 = ((fHazeFilterAttribute & 2) != 0);
            float _854 = tFilterTempMap1.Sample(BilinearWrap, float2(_824, _825));
            do {
              if (_850) {
                float _861 = ReadonlyDepth.SampleLevel(PointClamp, float2(_824, _825), 0.0f);
                float _869 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _824) + -1.0f;
                float _870 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _825);
                float _907 = 1.0f / (mad(_861.x, (viewProjInvMat[2].w), mad(_870, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _869))) + (viewProjInvMat[3].w));
                float _909 = _907 * (mad(_861.x, (viewProjInvMat[2].y), mad(_870, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _869))) + (viewProjInvMat[3].y));
                float _917 = (_907 * (mad(_861.x, (viewProjInvMat[2].x), mad(_870, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _869))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _918 = _909 - (transposeViewInvMat[1].w);
                float _919 = (_907 * (mad(_861.x, (viewProjInvMat[2].z), mad(_870, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _869))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _944 = saturate(max(((sqrt(((_918 * _918) + (_917 * _917)) + (_919 * _919)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_909 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _854.x);
                _945 = _861.x;
              } else {
                _944 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _854.x), _854.x);
                _945 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _961 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _968 = (1.0f - saturate(max((_961 * min(max((abs(_824 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_961 * min(max((abs(_825 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _968 = 1.0f;
                }
                float _969 = _968 * _944;
                do {
                  if (!(_969 <= 9.999999747378752e-06f)) {
                    float _976 = -0.0f - _825;
                    float _999 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_976, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _824))) * fHazeFilterUVWOffset.w;
                    float _1000 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_976, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _824))) * fHazeFilterUVWOffset.w;
                    float _1001 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_976, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _824))) * fHazeFilterUVWOffset.w;
                    float _1006 = tVolumeMap.Sample(BilinearWrap, float3((_999 + fHazeFilterUVWOffset.x), (_1000 + fHazeFilterUVWOffset.y), (_1001 + fHazeFilterUVWOffset.z)));
                    float _1009 = _999 * 2.0f;
                    float _1010 = _1000 * 2.0f;
                    float _1011 = _1001 * 2.0f;
                    float _1015 = tVolumeMap.Sample(BilinearWrap, float3((_1009 + fHazeFilterUVWOffset.x), (_1010 + fHazeFilterUVWOffset.y), (_1011 + fHazeFilterUVWOffset.z)));
                    float _1019 = _999 * 4.0f;
                    float _1020 = _1000 * 4.0f;
                    float _1021 = _1001 * 4.0f;
                    float _1025 = tVolumeMap.Sample(BilinearWrap, float3((_1019 + fHazeFilterUVWOffset.x), (_1020 + fHazeFilterUVWOffset.y), (_1021 + fHazeFilterUVWOffset.z)));
                    float _1029 = _999 * 8.0f;
                    float _1030 = _1000 * 8.0f;
                    float _1031 = _1001 * 8.0f;
                    float _1035 = tVolumeMap.Sample(BilinearWrap, float3((_1029 + fHazeFilterUVWOffset.x), (_1030 + fHazeFilterUVWOffset.y), (_1031 + fHazeFilterUVWOffset.z)));
                    float _1039 = fHazeFilterUVWOffset.x + 0.5f;
                    float _1040 = fHazeFilterUVWOffset.y + 0.5f;
                    float _1041 = fHazeFilterUVWOffset.z + 0.5f;
                    float _1045 = tVolumeMap.Sample(BilinearWrap, float3((_999 + _1039), (_1000 + _1040), (_1001 + _1041)));
                    float _1051 = tVolumeMap.Sample(BilinearWrap, float3((_1009 + _1039), (_1010 + _1040), (_1011 + _1041)));
                    float _1058 = tVolumeMap.Sample(BilinearWrap, float3((_1019 + _1039), (_1020 + _1040), (_1021 + _1041)));
                    float _1065 = tVolumeMap.Sample(BilinearWrap, float3((_1029 + _1039), (_1030 + _1040), (_1031 + _1041)));
                    float _1073 = ((((((_1015.x * 0.25f) + (_1006.x * 0.5f)) + (_1025.x * 0.125f)) + (_1035.x * 0.0625f)) * 2.0f) + -1.0f) * _969;
                    float _1074 = ((((((_1051.x * 0.25f) + (_1045.x * 0.5f)) + (_1058.x * 0.125f)) + (_1065.x * 0.0625f)) * 2.0f) + -1.0f) * _969;
                    if (_850) {
                      float _1083 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1073) + _824), ((fHazeFilterScale * _1074) + _825)));
                      if (!((_1083.x - _945) >= fHazeFilterDepthDiffBias)) {
                        _1090 = _1073;
                        _1091 = _1074;
                      } else {
                        _1090 = 0.0f;
                        _1091 = 0.0f;
                      }
                    } else {
                      _1090 = _1073;
                      _1091 = _1074;
                    }
                  } else {
                    _1090 = 0.0f;
                    _1091 = 0.0f;
                  }
                  _1097 = (fHazeFilterScale * _1090);
                  _1098 = (fHazeFilterScale * _1091);
                } while (false);
              } while (false);
            } while (false);
          }
          float4 _1103 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1097 + _824), (_1098 + _825)));
          _1108 = _1103.x;
          _1109 = _1103.y;
          _1110 = _1103.z;
          _1111 = 0.0f;
          _1112 = 0.0f;
          _1113 = 0.0f;
          _1114 = 0.0f;
          _1115 = 0.0f;
          _1116 = 1.0f;
        } while (false);
      }
    }
  }
  float _1117 = Exposure * _1110;
  float _1118 = Exposure * _1109;
  float _1119 = Exposure * _1108;
  if (!((cPassEnabled & 32) == 0)) {
    float _1142 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1146 = ComputeResultSRV[0].computeAlpha;
    float _1149 = ((1.0f - _1142) + (_1146 * _1142)) * cbRadialColor.w;
    if (!(_1149 == 0.0f)) {
      float _1152 = screenInverseSize.x * SV_Position.x;
      float _1153 = screenInverseSize.y * SV_Position.y;
      float _1155 = _1152 + (-0.5f - cbRadialScreenPos.x);
      float _1157 = _1153 + (-0.5f - cbRadialScreenPos.y);
      float _1160 = select((_1155 < 0.0f), (1.0f - _1152), _1152);
      float _1163 = select((_1157 < 0.0f), (1.0f - _1153), _1153);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1169 = rsqrt(dot(float2(_1155, _1157), float2(_1155, _1157))) * cbRadialSharpRange;
          uint _1176 = uint(abs(_1169 * _1157)) + uint(abs(_1169 * _1155));
          uint _1180 = ((_1176 ^ 61) ^ ((uint)(_1176) >> 16)) * 9;
          uint _1183 = (((uint)(_1180) >> 4) ^ _1180) * 668265261;
          _1189 = (float((uint)((int)(((uint)(_1183) >> 15) ^ _1183))) * 2.3283064365386963e-10f);
        } else {
          _1189 = 1.0f;
        }
        float _1193 = sqrt((_1155 * _1155) + (_1157 * _1157));
        float _1195 = 1.0f / max(1.0f, _1193);
        float _1196 = _1189 * _1160;
        float _1197 = cbRadialBlurPower * _1195;
        float _1198 = _1197 * -0.0011111111380159855f;
        float _1200 = _1189 * _1163;
        float _1204 = ((_1198 * _1196) + 1.0f) * _1155;
        float _1205 = ((_1198 * _1200) + 1.0f) * _1157;
        float _1207 = _1197 * -0.002222222276031971f;
        float _1212 = ((_1207 * _1196) + 1.0f) * _1155;
        float _1213 = ((_1207 * _1200) + 1.0f) * _1157;
        float _1214 = _1197 * -0.0033333334140479565f;
        float _1219 = ((_1214 * _1196) + 1.0f) * _1155;
        float _1220 = ((_1214 * _1200) + 1.0f) * _1157;
        float _1221 = _1197 * -0.004444444552063942f;
        float _1226 = ((_1221 * _1196) + 1.0f) * _1155;
        float _1227 = ((_1221 * _1200) + 1.0f) * _1157;
        float _1228 = _1197 * -0.0055555556900799274f;
        float _1233 = ((_1228 * _1196) + 1.0f) * _1155;
        float _1234 = ((_1228 * _1200) + 1.0f) * _1157;
        float _1235 = _1197 * -0.006666666828095913f;
        float _1240 = ((_1235 * _1196) + 1.0f) * _1155;
        float _1241 = ((_1235 * _1200) + 1.0f) * _1157;
        float _1242 = _1197 * -0.007777777966111898f;
        float _1247 = ((_1242 * _1196) + 1.0f) * _1155;
        float _1248 = ((_1242 * _1200) + 1.0f) * _1157;
        float _1249 = _1197 * -0.008888889104127884f;
        float _1254 = ((_1249 * _1196) + 1.0f) * _1155;
        float _1255 = ((_1249 * _1200) + 1.0f) * _1157;
        float _1258 = _1195 * ((cbRadialBlurPower * -0.009999999776482582f) * _1189);
        float _1263 = ((_1258 * _1160) + 1.0f) * _1155;
        float _1264 = ((_1258 * _1163) + 1.0f) * _1157;
        do {
          if (_37) {
            float _1266 = _1204 + cbRadialScreenPos.x;
            float _1267 = _1205 + cbRadialScreenPos.y;
            float _1271 = ((dot(float2(_1266, _1267), float2(_1266, _1267)) * _1111) + 1.0f) * _1116;
            float4 _1277 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1271 * _1266) + 0.5f), ((_1271 * _1267) + 0.5f)), 0.0f);
            float _1281 = _1212 + cbRadialScreenPos.x;
            float _1282 = _1213 + cbRadialScreenPos.y;
            float _1286 = ((dot(float2(_1281, _1282), float2(_1281, _1282)) * _1111) + 1.0f) * _1116;
            float4 _1291 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1286 * _1281) + 0.5f), ((_1286 * _1282) + 0.5f)), 0.0f);
            float _1298 = _1219 + cbRadialScreenPos.x;
            float _1299 = _1220 + cbRadialScreenPos.y;
            float _1303 = ((dot(float2(_1298, _1299), float2(_1298, _1299)) * _1111) + 1.0f) * _1116;
            float4 _1308 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1303 * _1298) + 0.5f), ((_1303 * _1299) + 0.5f)), 0.0f);
            float _1315 = _1226 + cbRadialScreenPos.x;
            float _1316 = _1227 + cbRadialScreenPos.y;
            float _1320 = ((dot(float2(_1315, _1316), float2(_1315, _1316)) * _1111) + 1.0f) * _1116;
            float4 _1325 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1320 * _1315) + 0.5f), ((_1320 * _1316) + 0.5f)), 0.0f);
            float _1332 = _1233 + cbRadialScreenPos.x;
            float _1333 = _1234 + cbRadialScreenPos.y;
            float _1337 = ((dot(float2(_1332, _1333), float2(_1332, _1333)) * _1111) + 1.0f) * _1116;
            float4 _1342 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1337 * _1332) + 0.5f), ((_1337 * _1333) + 0.5f)), 0.0f);
            float _1349 = _1240 + cbRadialScreenPos.x;
            float _1350 = _1241 + cbRadialScreenPos.y;
            float _1354 = ((dot(float2(_1349, _1350), float2(_1349, _1350)) * _1111) + 1.0f) * _1116;
            float4 _1359 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1354 * _1349) + 0.5f), ((_1354 * _1350) + 0.5f)), 0.0f);
            float _1366 = _1247 + cbRadialScreenPos.x;
            float _1367 = _1248 + cbRadialScreenPos.y;
            float _1371 = ((dot(float2(_1366, _1367), float2(_1366, _1367)) * _1111) + 1.0f) * _1116;
            float4 _1376 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1371 * _1366) + 0.5f), ((_1371 * _1367) + 0.5f)), 0.0f);
            float _1383 = _1254 + cbRadialScreenPos.x;
            float _1384 = _1255 + cbRadialScreenPos.y;
            float _1388 = ((dot(float2(_1383, _1384), float2(_1383, _1384)) * _1111) + 1.0f) * _1116;
            float4 _1393 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1388 * _1383) + 0.5f), ((_1388 * _1384) + 0.5f)), 0.0f);
            float _1400 = _1263 + cbRadialScreenPos.x;
            float _1401 = _1264 + cbRadialScreenPos.y;
            float _1405 = ((dot(float2(_1400, _1401), float2(_1400, _1401)) * _1111) + 1.0f) * _1116;
            float4 _1410 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1405 * _1400) + 0.5f), ((_1405 * _1401) + 0.5f)), 0.0f);
            _1744 = ((((((((_1291.x + _1277.x) + _1308.x) + _1325.x) + _1342.x) + _1359.x) + _1376.x) + _1393.x) + _1410.x);
            _1745 = ((((((((_1291.y + _1277.y) + _1308.y) + _1325.y) + _1342.y) + _1359.y) + _1376.y) + _1393.y) + _1410.y);
            _1746 = ((((((((_1291.z + _1277.z) + _1308.z) + _1325.z) + _1342.z) + _1359.z) + _1376.z) + _1393.z) + _1410.z);
          } else {
            float _1418 = cbRadialScreenPos.x + 0.5f;
            float _1419 = _1204 + _1418;
            float _1420 = cbRadialScreenPos.y + 0.5f;
            float _1421 = _1205 + _1420;
            float _1422 = _1212 + _1418;
            float _1423 = _1213 + _1420;
            float _1424 = _1219 + _1418;
            float _1425 = _1220 + _1420;
            float _1426 = _1226 + _1418;
            float _1427 = _1227 + _1420;
            float _1428 = _1233 + _1418;
            float _1429 = _1234 + _1420;
            float _1430 = _1240 + _1418;
            float _1431 = _1241 + _1420;
            float _1432 = _1247 + _1418;
            float _1433 = _1248 + _1420;
            float _1434 = _1254 + _1418;
            float _1435 = _1255 + _1420;
            float _1436 = _1263 + _1418;
            float _1437 = _1264 + _1420;
            if (_43) {
              float _1441 = (_1419 * 2.0f) + -1.0f;
              float _1445 = sqrt((_1441 * _1441) + 1.0f);
              float _1446 = 1.0f / _1445;
              float _1453 = _1115 * 0.5f;
              float _1454 = ((_1445 * _1114) * (_1446 + _1112)) * _1453;
              float4 _1461 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1454 * _1441) + 0.5f), (((_1454 * ((_1421 * 2.0f) + -1.0f)) * (((_1446 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1467 = (_1422 * 2.0f) + -1.0f;
              float _1471 = sqrt((_1467 * _1467) + 1.0f);
              float _1472 = 1.0f / _1471;
              float _1479 = ((_1471 * _1114) * (_1472 + _1112)) * _1453;
              float4 _1485 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1479 * _1467) + 0.5f), (((_1479 * ((_1423 * 2.0f) + -1.0f)) * (((_1472 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1494 = (_1424 * 2.0f) + -1.0f;
              float _1498 = sqrt((_1494 * _1494) + 1.0f);
              float _1499 = 1.0f / _1498;
              float _1506 = ((_1498 * _1114) * (_1499 + _1112)) * _1453;
              float4 _1512 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1506 * _1494) + 0.5f), (((_1506 * ((_1425 * 2.0f) + -1.0f)) * (((_1499 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1521 = (_1426 * 2.0f) + -1.0f;
              float _1525 = sqrt((_1521 * _1521) + 1.0f);
              float _1526 = 1.0f / _1525;
              float _1533 = ((_1525 * _1114) * (_1526 + _1112)) * _1453;
              float4 _1539 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1533 * _1521) + 0.5f), (((_1533 * ((_1427 * 2.0f) + -1.0f)) * (((_1526 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1548 = (_1428 * 2.0f) + -1.0f;
              float _1552 = sqrt((_1548 * _1548) + 1.0f);
              float _1553 = 1.0f / _1552;
              float _1560 = ((_1552 * _1114) * (_1553 + _1112)) * _1453;
              float4 _1566 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1560 * _1548) + 0.5f), (((_1560 * ((_1429 * 2.0f) + -1.0f)) * (((_1553 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1575 = (_1430 * 2.0f) + -1.0f;
              float _1579 = sqrt((_1575 * _1575) + 1.0f);
              float _1580 = 1.0f / _1579;
              float _1587 = ((_1579 * _1114) * (_1580 + _1112)) * _1453;
              float4 _1593 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1587 * _1575) + 0.5f), (((_1587 * ((_1431 * 2.0f) + -1.0f)) * (((_1580 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1602 = (_1432 * 2.0f) + -1.0f;
              float _1606 = sqrt((_1602 * _1602) + 1.0f);
              float _1607 = 1.0f / _1606;
              float _1614 = ((_1606 * _1114) * (_1607 + _1112)) * _1453;
              float4 _1620 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1614 * _1602) + 0.5f), (((_1614 * ((_1433 * 2.0f) + -1.0f)) * (((_1607 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1629 = (_1434 * 2.0f) + -1.0f;
              float _1633 = sqrt((_1629 * _1629) + 1.0f);
              float _1634 = 1.0f / _1633;
              float _1641 = ((_1633 * _1114) * (_1634 + _1112)) * _1453;
              float4 _1647 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1641 * _1629) + 0.5f), (((_1641 * ((_1435 * 2.0f) + -1.0f)) * (((_1634 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              float _1656 = (_1436 * 2.0f) + -1.0f;
              float _1660 = sqrt((_1656 * _1656) + 1.0f);
              float _1661 = 1.0f / _1660;
              float _1668 = ((_1660 * _1114) * (_1661 + _1112)) * _1453;
              float4 _1674 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1668 * _1656) + 0.5f), (((_1668 * ((_1437 * 2.0f) + -1.0f)) * (((_1661 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1744 = ((((((((_1485.x + _1461.x) + _1512.x) + _1539.x) + _1566.x) + _1593.x) + _1620.x) + _1647.x) + _1674.x);
              _1745 = ((((((((_1485.y + _1461.y) + _1512.y) + _1539.y) + _1566.y) + _1593.y) + _1620.y) + _1647.y) + _1674.y);
              _1746 = ((((((((_1485.z + _1461.z) + _1512.z) + _1539.z) + _1566.z) + _1593.z) + _1620.z) + _1647.z) + _1674.z);
            } else {
              float4 _1683 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1419, _1421), 0.0f);
              float4 _1687 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1422, _1423), 0.0f);
              float4 _1694 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1424, _1425), 0.0f);
              float4 _1701 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1426, _1427), 0.0f);
              float4 _1708 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1428, _1429), 0.0f);
              float4 _1715 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1430, _1431), 0.0f);
              float4 _1722 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1432, _1433), 0.0f);
              float4 _1729 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1434, _1435), 0.0f);
              float4 _1736 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1436, _1437), 0.0f);
              _1744 = ((((((((_1687.x + _1683.x) + _1694.x) + _1701.x) + _1708.x) + _1715.x) + _1722.x) + _1729.x) + _1736.x);
              _1745 = ((((((((_1687.y + _1683.y) + _1694.y) + _1701.y) + _1708.y) + _1715.y) + _1722.y) + _1729.y) + _1736.y);
              _1746 = ((((((((_1687.z + _1683.z) + _1694.z) + _1701.z) + _1708.z) + _1715.z) + _1722.z) + _1729.z) + _1736.z);
            }
          }
          float _1756 = (cbRadialColor.z * (Exposure * (_1110 + _1746))) * 0.10000000149011612f;
          float _1757 = (cbRadialColor.y * (Exposure * (_1109 + _1745))) * 0.10000000149011612f;
          float _1758 = (cbRadialColor.x * (Exposure * (_1108 + _1744))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1763 = saturate((_1193 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1769 = (((_1763 * _1763) * cbRadialMaskRate.x) * (3.0f - (_1763 * 2.0f))) + cbRadialMaskRate.y;
              _1780 = ((_1769 * (_1758 - _1119)) + _1119);
              _1781 = ((_1769 * (_1757 - _1118)) + _1118);
              _1782 = ((_1769 * (_1756 - _1117)) + _1117);
            } else {
              _1780 = _1758;
              _1781 = _1757;
              _1782 = _1756;
            }
            _1793 = (lerp(_1119, _1780, _1149));
            _1794 = (lerp(_1118, _1781, _1149));
            _1795 = (lerp(_1117, _1782, _1149));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1793 = _1119;
      _1794 = _1118;
      _1795 = _1117;
    }
  } else {
    _1793 = _1119;
    _1794 = _1118;
    _1795 = _1117;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1812 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1814 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1820 = frac(frac((_1814 * 0.005837149918079376f) + (_1812 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1820 < fNoiseDensity) {
        int _1825 = (uint)(uint(_1814 * _1812)) ^ 12345391;
        uint _1826 = _1825 * 3635641;
        _1834 = (float((uint)((int)((((uint)(_1826) >> 26) | ((uint)(_1825 * 232681024))) ^ _1826))) * 2.3283064365386963e-10f);
      } else {
        _1834 = 0.0f;
      }
      float _1836 = frac(_1820 * 757.4846801757812f);
      do {
        if (_1836 < fNoiseDensity) {
          int _1840 = asint(_1836) ^ 12345391;
          uint _1841 = _1840 * 3635641;
          _1850 = ((float((uint)((int)((((uint)(_1841) >> 26) | ((uint)(_1840 * 232681024))) ^ _1841))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1850 = 0.0f;
        }
        float _1852 = frac(_1836 * 757.4846801757812f);
        do {
          if (_1852 < fNoiseDensity) {
            int _1856 = asint(_1852) ^ 12345391;
            uint _1857 = _1856 * 3635641;
            _1866 = ((float((uint)((int)((((uint)(_1857) >> 26) | ((uint)(_1856 * 232681024))) ^ _1857))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1866 = 0.0f;
          }
          float _1867 = _1834 * fNoisePower.x * CUSTOM_NOISE;
          float _1868 = _1866 * fNoisePower.y * CUSTOM_NOISE;
          float _1869 = _1850 * fNoisePower.y * CUSTOM_NOISE;
          float _1883 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1793), saturate(_1794), saturate(_1795)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1894 = ((_1883 * (mad(_1869, 1.4019999504089355f, _1867) - _1793)) + _1793);
          _1895 = ((_1883 * (mad(_1869, -0.7139999866485596f, mad(_1868, -0.3440000116825104f, _1867)) - _1794)) + _1794);
          _1896 = ((_1883 * (mad(_1868, 1.7719999551773071f, _1867) - _1795)) + _1795);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1894 = _1793;
    _1895 = _1794;
    _1896 = _1795;
  }
  float _1911 = mad(_1896, (fOCIOTransformMatrix[2].x), mad(_1895, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1894)));
  float _1914 = mad(_1896, (fOCIOTransformMatrix[2].y), mad(_1895, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1894)));
  float _1917 = mad(_1896, (fOCIOTransformMatrix[2].z), mad(_1895, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1894)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1923 = max(max(_1911, _1914), _1917);
    if (!(_1923 == 0.0f)) {
      float _1929 = abs(_1923);
      float _1930 = (_1923 - _1911) / _1929;
      float _1931 = (_1923 - _1914) / _1929;
      float _1932 = (_1923 - _1917) / _1929;
      do {
        if (!(!(_1930 >= cbControlRGCParam.CyanThreshold))) {
          float _1942 = _1930 - cbControlRGCParam.CyanThreshold;
          _1954 = ((_1942 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1942) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1954 = _1930;
        }
        do {
          if (!(!(_1931 >= cbControlRGCParam.MagentaThreshold))) {
            float _1963 = _1931 - cbControlRGCParam.MagentaThreshold;
            _1975 = ((_1963 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1963) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1975 = _1931;
          }
          do {
            if (!(!(_1932 >= cbControlRGCParam.YellowThreshold))) {
              float _1983 = _1932 - cbControlRGCParam.YellowThreshold;
              _1995 = ((_1983 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1983) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1995 = _1932;
            }
            _2003 = (_1923 - (_1954 * _1929));
            _2004 = (_1923 - (_1975 * _1929));
            _2005 = (_1923 - (_1995 * _1929));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2003 = _1911;
      _2004 = _1914;
      _2005 = _1917;
    }
  } else {
    _2003 = _1911;
    _2004 = _1914;
    _2005 = _1917;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        true,
        cPassEnabled,
        _2003,
        _2004,
        _2005,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _2231,
        _2232,
        _2233);
  #else
  if (!((cPassEnabled & 4) == 0)) {
    float _2055 = (((log2(select((_2003 < 3.0517578125e-05f), ((_2003 * 0.5f) + 1.52587890625e-05f), _2003)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2056 = (((log2(select((_2004 < 3.0517578125e-05f), ((_2004 * 0.5f) + 1.52587890625e-05f), _2004)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2057 = (((log2(select((_2005 < 3.0517578125e-05f), ((_2005 * 0.5f) + 1.52587890625e-05f), _2005)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _2060 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2055, _2056, _2057), 0.0f);
    float _2073 = max(exp2((_2060.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2074 = max(exp2((_2060.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2075 = max(exp2((_2060.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _2077 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _2080 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2055, _2056, _2057), 0.0f);
        float _2102 = ((max(exp2((_2080.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2073) * fTextureBlendRate) + _2073;
        float _2103 = ((max(exp2((_2080.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2074) * fTextureBlendRate) + _2074;
        float _2104 = ((max(exp2((_2080.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2075) * fTextureBlendRate) + _2075;
        if (_2077) {
          float4 _2134 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2102 < 3.0517578125e-05f), ((_2102 * 0.5f) + 1.52587890625e-05f), _2102)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2103 < 3.0517578125e-05f), ((_2103 * 0.5f) + 1.52587890625e-05f), _2103)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2104 < 3.0517578125e-05f), ((_2104 * 0.5f) + 1.52587890625e-05f), _2104)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2215 = (((max(exp2((_2134.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2102) * fTextureBlendRate2) + _2102);
          _2216 = (((max(exp2((_2134.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2103) * fTextureBlendRate2) + _2103);
          _2217 = (((max(exp2((_2134.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2104) * fTextureBlendRate2) + _2104);
        } else {
          _2215 = _2102;
          _2216 = _2103;
          _2217 = _2104;
        }
      } else {
        if (_2077) {
          float4 _2189 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2073 < 3.0517578125e-05f), ((_2073 * 0.5f) + 1.52587890625e-05f), _2073)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2074 < 3.0517578125e-05f), ((_2074 * 0.5f) + 1.52587890625e-05f), _2074)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2075 < 3.0517578125e-05f), ((_2075 * 0.5f) + 1.52587890625e-05f), _2075)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2215 = (((max(exp2((_2189.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2073) * fTextureBlendRate2) + _2073);
          _2216 = (((max(exp2((_2189.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2074) * fTextureBlendRate2) + _2074);
          _2217 = (((max(exp2((_2189.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2075) * fTextureBlendRate2) + _2075);
        } else {
          _2215 = _2073;
          _2216 = _2074;
          _2217 = _2075;
        }
      }
      _2231 = (mad(_2217, (fColorMatrix[2].x), mad(_2216, (fColorMatrix[1].x), (_2215 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _2232 = (mad(_2217, (fColorMatrix[2].y), mad(_2216, (fColorMatrix[1].y), (_2215 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _2233 = (mad(_2217, (fColorMatrix[2].z), mad(_2216, (fColorMatrix[1].z), (_2215 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _2231 = _2003;
    _2232 = _2004;
    _2233 = _2005;
  }
  #endif
  float _2234 = min(_2231, 65000.0f);
  float _2235 = min(_2232, 65000.0f);
  float _2236 = min(_2233, 65000.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2268 = (((cvdR.x * _2234) + (cvdR.y * _2235)) + (cvdR.z * _2236));
    _2269 = (((cvdG.x * _2234) + (cvdG.y * _2235)) + (cvdG.z * _2236));
    _2270 = (((cvdB.x * _2234) + (cvdB.y * _2235)) + (cvdB.z * _2236));
  } else {
    _2268 = _2234;
    _2269 = _2235;
    _2270 = _2236;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2282 = screenInverseSize.x * SV_Position.x;
    float _2283 = screenInverseSize.y * SV_Position.y;
    float4 _2286 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2282, _2283), 0.0f);
    float _2291 = _2286.x * ColorParam.x;
    float _2292 = _2286.y * ColorParam.y;
    float _2293 = _2286.z * ColorParam.z;
    float _2296 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2282, _2283), 0.0f);
    float _2301 = (_2286.w * ColorParam.w) * saturate((_2296.x * Levels_Rate) + Levels_Range);
    do {
      if (_2291 < 0.5f) {
        _2313 = ((_2268 * 2.0f) * _2291);
      } else {
        _2313 = (1.0f - (((1.0f - _2268) * 2.0f) * (1.0f - _2291)));
      }
      do {
        if (_2292 < 0.5f) {
          _2325 = ((_2269 * 2.0f) * _2292);
        } else {
          _2325 = (1.0f - (((1.0f - _2269) * 2.0f) * (1.0f - _2292)));
        }
        do {
          if (_2293 < 0.5f) {
            _2337 = ((_2270 * 2.0f) * _2293);
          } else {
            _2337 = (1.0f - (((1.0f - _2270) * 2.0f) * (1.0f - _2293)));
          }
          _2348 = (lerp(_2268, _2313, _2301));
          _2349 = (lerp(_2269, _2325, _2301));
          _2350 = (lerp(_2270, _2337, _2301));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2348 = _2268;
    _2349 = _2269;
    _2350 = _2270;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _2390 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _2350, mad((RGBToXYZViaCrosstalkMatrix[0].y), _2349, ((RGBToXYZViaCrosstalkMatrix[0].x) * _2348)));
      float _2393 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _2350, mad((RGBToXYZViaCrosstalkMatrix[1].y), _2349, ((RGBToXYZViaCrosstalkMatrix[1].x) * _2348)));
      float _2398 = (_2393 + _2390) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _2350, mad((RGBToXYZViaCrosstalkMatrix[2].y), _2349, ((RGBToXYZViaCrosstalkMatrix[2].x) * _2348)));
      float _2399 = _2390 / _2398;
      float _2400 = _2393 / _2398;
      do {
        if (_2393 < curve_HDRip) {
          _2411 = (_2393 * exposureScale);
        } else {
          _2411 = ((log2((_2393 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _2413 = (_2399 / _2400) * _2411;
        float _2417 = (((1.0f - _2399) - _2400) / _2400) * _2411;
        _2466 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _2417, mad((XYZToRGBViaCrosstalkMatrix[0].y), _2411, (_2413 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _2467 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _2417, mad((XYZToRGBViaCrosstalkMatrix[1].y), _2411, (_2413 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _2468 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _2417, mad((XYZToRGBViaCrosstalkMatrix[2].y), _2411, (_2413 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_2348 < curve_HDRip) {
          _2444 = (exposureScale * _2348);
        } else {
          _2444 = ((log2((_2348 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_2349 < curve_HDRip) {
            _2455 = (exposureScale * _2349);
          } else {
            _2455 = ((log2((_2349 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_2350 < curve_HDRip) {
            _2466 = _2444;
            _2467 = _2455;
            _2468 = (exposureScale * _2350);
          } else {
            _2466 = _2444;
            _2467 = _2455;
            _2468 = ((log2((_2350 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _2466 = _2348;
    _2467 = _2349;
    _2468 = _2350;
  }
  SV_Target.x = _2466;
  SV_Target.y = _2467;
  SV_Target.z = _2468;
  SV_Target.w = 0.0f;
  return SV_Target;
}
