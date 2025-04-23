#include "./common.hlsl"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

struct RadialBlurComputeResult {
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t4);

Texture3D<float4> tTextureMap0 : register(t5);

Texture3D<float4> tTextureMap1 : register(t6);

Texture3D<float4> tTextureMap2 : register(t7);

Texture2D<float4> ImagePlameBase : register(t8);

Texture2D<float> ImagePlameAlpha : register(t9);

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float2 projectionSpaceJitterOffset : packoffset(c037.x);
  float2 SceneInfo_Reserve2 : packoffset(c037.z);
};

cbuffer Tonemap : register(b1) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float specularSuppression : packoffset(c000.z);
  float sharpness : packoffset(c000.w);
  float preTonemapRange : packoffset(c001.x);
  int useAutoExposure : packoffset(c001.y);
  float echoBlend : packoffset(c001.z);
  float AABlend : packoffset(c001.w);
  float AASubPixel : packoffset(c002.x);
  float ResponsiveAARate : packoffset(c002.y);
  float VelocityWeightRate : packoffset(c002.z);
  float DepthRejectionRate : packoffset(c002.w);
  float ContrastTrackingRate : packoffset(c003.x);
  float ContrastTrackingThreshold : packoffset(c003.y);
  float LEHighlightContrast : packoffset(c003.z);
  float LEShadowContrast : packoffset(c003.w);
  float LEDetailStrength : packoffset(c004.x);
  float LEMiddleGreyLog : packoffset(c004.y);
  float LEBilateralGridScale : packoffset(c004.z);
  float LEBilateralGridBias : packoffset(c004.w);
  float LEPreExposureLog : packoffset(c005.x);
};

cbuffer CBHazeFilterParams : register(b2) {
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
  uint fHazeFilterReserved1 : packoffset(c003.y);
  uint fHazeFilterReserved2 : packoffset(c003.z);
  uint fHazeFilterReserved3 : packoffset(c003.w);
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
  float fHalfTextureInverseSize : packoffset(c001.x);
  float fOneMinusTextureInverseSize : packoffset(c001.y);
  float fColorCorrectTextureReserve : packoffset(c001.z);
  float fColorCorrectTextureReserve2 : packoffset(c001.w);
  row_major float4x4 fColorMatrix : packoffset(c002.x);
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
  }
cbControlRGCParam:
  packoffset(c005.x);
};

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure) : SV_Target {
  float4 SV_Target;
  float3 untonemapped;

  bool _44 = (((uint)(cPassEnabled) & 1) == 0);
  bool _50;
  bool _56;
  float _183;
  float _184;
  float _316;
  float _317;
  float _329;
  float _330;
  float _334;
  float _335;
  float _392;
  float _410;
  float _557;
  float _558;
  float _690;
  float _691;
  float _703;
  float _704;
  float _708;
  float _709;
  float _835;
  float _836;
  float _970;
  float _971;
  float _983;
  float _984;
  float _994;
  float _995;
  float _996;
  float _1012;
  float _1013;
  float _1014;
  float _1015;
  float _1016;
  float _1017;
  float _1018;
  float _1019;
  float _1020;
  float _1094;
  float _1380;
  float _1381;
  float _1382;
  float _1680;
  float _1681;
  float _1682;
  float _1769;
  float _1770;
  float _1771;
  float _1782;
  float _1783;
  float _1784;
  float _1810;
  float _1811;
  float _1812;
  float _1823;
  float _1824;
  float _1825;
  float _1862;
  float _1878;
  float _1894;
  float _1922;
  float _1923;
  float _1924;
  float _1956;
  float _1957;
  float _1958;
  float _1970;
  float _1981;
  float _1992;
  float _2034;
  float _2045;
  float _2056;
  float _2083;
  float _2094;
  float _2105;
  float _2121;
  float _2122;
  float _2123;
  float _2141;
  float _2142;
  float _2143;
  float _2178;
  float _2179;
  float _2180;
  float _2226;
  float _2238;
  float _2250;
  float _2261;
  float _2262;
  float _2263;
  if (!_44) {
    _50 = ((uint)(distortionType) == 0);
  } else {
    _50 = false;
  }
  if (!_44) {
    _56 = ((uint)(distortionType) == 1);
  } else {
    _56 = false;
  }
  bool _58 = (((uint)(cPassEnabled) & 64) != 0);
  if (_50) {
    float _72 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _73 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _74 = dot(float2(_72, _73), float2(_72, _73));
    float _77 = ((_74 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _78 = _77 * _72;
    float _79 = _77 * _73;
    float _80 = _78 + 0.5f;
    float _81 = _79 + 0.5f;
    if ((uint)(aberrationEnable) == 0) {
      if (_58) {
        bool _90 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _95 = tFilterTempMap1.Sample(BilinearWrap, float2(_80, _81));
        if (_90) {
          float _100 = ReadonlyDepth.SampleLevel(PointClamp, float2(_80, _81), 0.0f);
          float _108 = (((_80 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
          float _109 = 1.0f - (((_81 * 2.0f) * screenSize.y) * screenInverseSize.y);
          float _146 = 1.0f / (mad(_100.x, (viewProjInvMat[2].w), mad(_109, (viewProjInvMat[1].w), (_108 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _148 = _146 * (mad(_100.x, (viewProjInvMat[2].y), mad(_109, (viewProjInvMat[1].y), (_108 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _156 = (_146 * (mad(_100.x, (viewProjInvMat[2].x), mad(_109, (viewProjInvMat[1].x), (_108 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _157 = _148 - (transposeViewInvMat[1].w);
          float _158 = (_146 * (mad(_100.x, (viewProjInvMat[2].z), mad(_109, (viewProjInvMat[1].z), (_108 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _183 = saturate(_95.x * max(((sqrt(((_157 * _157) + (_156 * _156)) + (_158 * _158)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_148 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _184 = _100.x;
        } else {
          _183 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _95.x), _95.x);
          _184 = 0.0f;
        }
        float _189 = -0.0f - _81;
        float _212 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_189, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _80)));
        float _213 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_189, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _80)));
        float _214 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_189, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _80)));
        float _220 = tVolumeMap.Sample(BilinearWrap, float3((_212 + fHazeFilterUVWOffset.x), (_213 + fHazeFilterUVWOffset.y), (_214 + fHazeFilterUVWOffset.z)));
        float _223 = _212 * 2.0f;
        float _224 = _213 * 2.0f;
        float _225 = _214 * 2.0f;
        float _229 = tVolumeMap.Sample(BilinearWrap, float3((_223 + fHazeFilterUVWOffset.x), (_224 + fHazeFilterUVWOffset.y), (_225 + fHazeFilterUVWOffset.z)));
        float _233 = _212 * 4.0f;
        float _234 = _213 * 4.0f;
        float _235 = _214 * 4.0f;
        float _239 = tVolumeMap.Sample(BilinearWrap, float3((_233 + fHazeFilterUVWOffset.x), (_234 + fHazeFilterUVWOffset.y), (_235 + fHazeFilterUVWOffset.z)));
        float _243 = _212 * 8.0f;
        float _244 = _213 * 8.0f;
        float _245 = _214 * 8.0f;
        float _249 = tVolumeMap.Sample(BilinearWrap, float3((_243 + fHazeFilterUVWOffset.x), (_244 + fHazeFilterUVWOffset.y), (_245 + fHazeFilterUVWOffset.z)));
        float _253 = fHazeFilterUVWOffset.x + 0.5f;
        float _254 = fHazeFilterUVWOffset.y + 0.5f;
        float _255 = fHazeFilterUVWOffset.z + 0.5f;
        float _259 = tVolumeMap.Sample(BilinearWrap, float3((_212 + _253), (_213 + _254), (_214 + _255)));
        float _265 = tVolumeMap.Sample(BilinearWrap, float3((_223 + _253), (_224 + _254), (_225 + _255)));
        float _272 = tVolumeMap.Sample(BilinearWrap, float3((_233 + _253), (_234 + _254), (_235 + _255)));
        float _279 = tVolumeMap.Sample(BilinearWrap, float3((_243 + _253), (_244 + _254), (_245 + _255)));
        float _290 = (((((((_229.x * 0.25f) + (_220.x * 0.5f)) + (_239.x * 0.125f)) + (_249.x * 0.0625f)) * 2.0f) + -1.0f) * _183) * fHazeFilterScale;
        float _292 = (fHazeFilterScale * _183) * ((((((_265.x * 0.25f) + (_259.x * 0.5f)) + (_272.x * 0.125f)) + (_279.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _303 = 0.5f / fHazeFilterBorder;
          float _310 = saturate(max(((_303 * min(max((abs(_78) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_303 * min(max((abs(_79) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _316 = (_290 - (_310 * _290));
          _317 = (_292 - (_310 * _292));
        } else {
          _316 = _290;
          _317 = _292;
        }
        if (_90) {
          float _322 = ReadonlyDepth.Sample(BilinearWrap, float2((_316 + _80), (_317 + _81)));
          if (!(!((_322.x - _184) >= fHazeFilterDepthDiffBias))) {
            _329 = 0.0f;
            _330 = 0.0f;
          } else {
            _329 = _316;
            _330 = _317;
          }
        } else {
          _329 = _316;
          _330 = _317;
        }
        _334 = (_329 + _80);
        _335 = (_330 + _81);
      } else {
        _334 = _80;
        _335 = _81;
      }
      float4 _338 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_334, _335));
      float _342 = _338.x * Exposure;
      float _343 = _338.y * Exposure;
      float _344 = _338.z * Exposure;
      untonemapped = float3(_342, _343, _344);
      float _346 = max(max(_342, _343), _344);
      if (isfinite(_346)) {
        float _352 = (tonemapRange * _346) + 1.0f;
        _1012 = (_342 / _352);
        _1013 = (_343 / _352);
        _1014 = (_344 / _352);
        _1015 = fDistortionCoef;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = fCorrectCoef;
      } else {
        _1012 = 1.0f;
        _1013 = 1.0f;
        _1014 = 1.0f;
        _1015 = fDistortionCoef;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = fCorrectCoef;
      }
    } else {
      float _357 = _74 + fRefraction;
      float _359 = (_357 * fDistortionCoef) + 1.0f;
      float _360 = _72 * fCorrectCoef;
      float _362 = _73 * fCorrectCoef;
      float _368 = ((_357 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _375 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_80, _81));
      float _379 = _375.x * Exposure;
      float _383 = max(max(_379, (_375.y * Exposure)), (_375.z * Exposure));
      if (isfinite(_383)) {
        _392 = (_379 / ((tonemapRange * _383) + 1.0f));
      } else {
        _392 = 1.0f;
      }
      float4 _393 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_360 * _359) + 0.5f), ((_362 * _359) + 0.5f)));
      float _398 = _393.y * Exposure;
      float _401 = max(max((_393.x * Exposure), _398), (_393.z * Exposure));
      if (isfinite(_401)) {
        _410 = (_398 / ((tonemapRange * _401) + 1.0f));
      } else {
        _410 = 1.0f;
      }
      float4 _411 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_360 * _368) + 0.5f), ((_362 * _368) + 0.5f)));
      float _417 = _411.z * Exposure;
      float _419 = max(max((_411.x * Exposure), (_411.y * Exposure)), _417);

      float3 untonemapped = float3(_379, _398, _417);

      if (isfinite(_419)) {
        _1012 = _392;
        _1013 = _410;
        _1014 = (_417 / ((tonemapRange * _419) + 1.0f));
        _1015 = fDistortionCoef;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = fCorrectCoef;
      } else {
        _1012 = _392;
        _1013 = _410;
        _1014 = 1.0f;
        _1015 = fDistortionCoef;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = fCorrectCoef;
      }
    }
  } else {
    if (_56) {
      float _438 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _442 = sqrt((_438 * _438) + 1.0f);
      float _443 = 1.0f / _442;
      float _446 = (_442 * fOptimizedParam.z) * (_443 + fOptimizedParam.x);
      float _450 = fOptimizedParam.w * 0.5f;
      float _452 = (_450 * _438) * _446;
      float _455 = ((_450 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_443 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _446;
      float _456 = _452 + 0.5f;
      float _457 = _455 + 0.5f;
      if (_58) {
        bool _464 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _469 = tFilterTempMap1.Sample(BilinearWrap, float2(_456, _457));
        if (_464) {
          float _474 = ReadonlyDepth.SampleLevel(PointClamp, float2(_456, _457), 0.0f);
          float _482 = (((screenSize.x * 2.0f) * _456) * screenInverseSize.x) + -1.0f;
          float _483 = 1.0f - (((screenSize.y * 2.0f) * _457) * screenInverseSize.y);
          float _520 = 1.0f / (mad(_474.x, (viewProjInvMat[2].w), mad(_483, (viewProjInvMat[1].w), (_482 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _522 = _520 * (mad(_474.x, (viewProjInvMat[2].y), mad(_483, (viewProjInvMat[1].y), (_482 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _530 = (_520 * (mad(_474.x, (viewProjInvMat[2].x), mad(_483, (viewProjInvMat[1].x), (_482 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _531 = _522 - (transposeViewInvMat[1].w);
          float _532 = (_520 * (mad(_474.x, (viewProjInvMat[2].z), mad(_483, (viewProjInvMat[1].z), (_482 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _557 = saturate(_469.x * max(((sqrt(((_531 * _531) + (_530 * _530)) + (_532 * _532)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_522 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _558 = _474.x;
        } else {
          _557 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _469.x), _469.x);
          _558 = 0.0f;
        }
        float _563 = -0.0f - _457;
        float _586 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_563, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _456)));
        float _587 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_563, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _456)));
        float _588 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_563, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _456)));
        float _594 = tVolumeMap.Sample(BilinearWrap, float3((_586 + fHazeFilterUVWOffset.x), (_587 + fHazeFilterUVWOffset.y), (_588 + fHazeFilterUVWOffset.z)));
        float _597 = _586 * 2.0f;
        float _598 = _587 * 2.0f;
        float _599 = _588 * 2.0f;
        float _603 = tVolumeMap.Sample(BilinearWrap, float3((_597 + fHazeFilterUVWOffset.x), (_598 + fHazeFilterUVWOffset.y), (_599 + fHazeFilterUVWOffset.z)));
        float _607 = _586 * 4.0f;
        float _608 = _587 * 4.0f;
        float _609 = _588 * 4.0f;
        float _613 = tVolumeMap.Sample(BilinearWrap, float3((_607 + fHazeFilterUVWOffset.x), (_608 + fHazeFilterUVWOffset.y), (_609 + fHazeFilterUVWOffset.z)));
        float _617 = _586 * 8.0f;
        float _618 = _587 * 8.0f;
        float _619 = _588 * 8.0f;
        float _623 = tVolumeMap.Sample(BilinearWrap, float3((_617 + fHazeFilterUVWOffset.x), (_618 + fHazeFilterUVWOffset.y), (_619 + fHazeFilterUVWOffset.z)));
        float _627 = fHazeFilterUVWOffset.x + 0.5f;
        float _628 = fHazeFilterUVWOffset.y + 0.5f;
        float _629 = fHazeFilterUVWOffset.z + 0.5f;
        float _633 = tVolumeMap.Sample(BilinearWrap, float3((_586 + _627), (_587 + _628), (_588 + _629)));
        float _639 = tVolumeMap.Sample(BilinearWrap, float3((_597 + _627), (_598 + _628), (_599 + _629)));
        float _646 = tVolumeMap.Sample(BilinearWrap, float3((_607 + _627), (_608 + _628), (_609 + _629)));
        float _653 = tVolumeMap.Sample(BilinearWrap, float3((_617 + _627), (_618 + _628), (_619 + _629)));
        float _664 = (((((((_603.x * 0.25f) + (_594.x * 0.5f)) + (_613.x * 0.125f)) + (_623.x * 0.0625f)) * 2.0f) + -1.0f) * _557) * fHazeFilterScale;
        float _666 = (fHazeFilterScale * _557) * ((((((_639.x * 0.25f) + (_633.x * 0.5f)) + (_646.x * 0.125f)) + (_653.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _677 = 0.5f / fHazeFilterBorder;
          float _684 = saturate(max(((_677 * min(max((abs(_452) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_677 * min(max((abs(_455) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _690 = (_664 - (_684 * _664));
          _691 = (_666 - (_684 * _666));
        } else {
          _690 = _664;
          _691 = _666;
        }
        if (_464) {
          float _696 = ReadonlyDepth.Sample(BilinearWrap, float2((_690 + _456), (_691 + _457)));
          if (!(!((_696.x - _558) >= fHazeFilterDepthDiffBias))) {
            _703 = 0.0f;
            _704 = 0.0f;
          } else {
            _703 = _690;
            _704 = _691;
          }
        } else {
          _703 = _690;
          _704 = _691;
        }
        _708 = (_703 + _456);
        _709 = (_704 + _457);
      } else {
        _708 = _456;
        _709 = _457;
      }
      float4 _712 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_708, _709));
      float _716 = _712.x * Exposure;
      float _717 = _712.y * Exposure;
      float _718 = _712.z * Exposure;
      untonemapped = float3(_716, _717, _718);
      float _720 = max(max(_716, _717), _718);
      if (isfinite(_720)) {
        float _726 = (tonemapRange * _720) + 1.0f;
        _1012 = (_716 / _726);
        _1013 = (_717 / _726);
        _1014 = (_718 / _726);
        _1015 = 0.0f;
        _1016 = fOptimizedParam.x;
        _1017 = fOptimizedParam.y;
        _1018 = fOptimizedParam.z;
        _1019 = fOptimizedParam.w;
        _1020 = 1.0f;
      } else {
        _1012 = 1.0f;
        _1013 = 1.0f;
        _1014 = 1.0f;
        _1015 = 0.0f;
        _1016 = fOptimizedParam.x;
        _1017 = fOptimizedParam.y;
        _1018 = fOptimizedParam.z;
        _1019 = fOptimizedParam.w;
        _1020 = 1.0f;
      }
    } else {
      float _731 = screenInverseSize.x * SV_Position.x;
      float _732 = screenInverseSize.y * SV_Position.y;
      if (!_58) {
        float4 _736 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_731, _732));
        _994 = _736.x;
        _995 = _736.y;
        _996 = _736.z;
      } else {
        bool _744 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _749 = tFilterTempMap1.Sample(BilinearWrap, float2(_731, _732));
        if (_744) {
          float _754 = ReadonlyDepth.SampleLevel(PointClamp, float2(_731, _732), 0.0f);
          float _760 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
          float _761 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
          float _798 = 1.0f / (mad(_754.x, (viewProjInvMat[2].w), mad(_761, (viewProjInvMat[1].w), (_760 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _800 = _798 * (mad(_754.x, (viewProjInvMat[2].y), mad(_761, (viewProjInvMat[1].y), (_760 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _808 = (_798 * (mad(_754.x, (viewProjInvMat[2].x), mad(_761, (viewProjInvMat[1].x), (_760 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _809 = _800 - (transposeViewInvMat[1].w);
          float _810 = (_798 * (mad(_754.x, (viewProjInvMat[2].z), mad(_761, (viewProjInvMat[1].z), (_760 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _835 = saturate(_749.x * max(((sqrt(((_809 * _809) + (_808 * _808)) + (_810 * _810)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_800 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _836 = _754.x;
        } else {
          _835 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _749.x), _749.x);
          _836 = 0.0f;
        }
        float _841 = -0.0f - _732;
        float _864 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_841, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _731)));
        float _865 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_841, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _731)));
        float _866 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_841, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _731)));
        float _872 = tVolumeMap.Sample(BilinearWrap, float3((_864 + fHazeFilterUVWOffset.x), (_865 + fHazeFilterUVWOffset.y), (_866 + fHazeFilterUVWOffset.z)));
        float _875 = _864 * 2.0f;
        float _876 = _865 * 2.0f;
        float _877 = _866 * 2.0f;
        float _881 = tVolumeMap.Sample(BilinearWrap, float3((_875 + fHazeFilterUVWOffset.x), (_876 + fHazeFilterUVWOffset.y), (_877 + fHazeFilterUVWOffset.z)));
        float _885 = _864 * 4.0f;
        float _886 = _865 * 4.0f;
        float _887 = _866 * 4.0f;
        float _891 = tVolumeMap.Sample(BilinearWrap, float3((_885 + fHazeFilterUVWOffset.x), (_886 + fHazeFilterUVWOffset.y), (_887 + fHazeFilterUVWOffset.z)));
        float _895 = _864 * 8.0f;
        float _896 = _865 * 8.0f;
        float _897 = _866 * 8.0f;
        float _901 = tVolumeMap.Sample(BilinearWrap, float3((_895 + fHazeFilterUVWOffset.x), (_896 + fHazeFilterUVWOffset.y), (_897 + fHazeFilterUVWOffset.z)));
        float _905 = fHazeFilterUVWOffset.x + 0.5f;
        float _906 = fHazeFilterUVWOffset.y + 0.5f;
        float _907 = fHazeFilterUVWOffset.z + 0.5f;
        float _911 = tVolumeMap.Sample(BilinearWrap, float3((_864 + _905), (_865 + _906), (_866 + _907)));
        float _917 = tVolumeMap.Sample(BilinearWrap, float3((_875 + _905), (_876 + _906), (_877 + _907)));
        float _924 = tVolumeMap.Sample(BilinearWrap, float3((_885 + _905), (_886 + _906), (_887 + _907)));
        float _931 = tVolumeMap.Sample(BilinearWrap, float3((_895 + _905), (_896 + _906), (_897 + _907)));
        float _942 = (((((((_881.x * 0.25f) + (_872.x * 0.5f)) + (_891.x * 0.125f)) + (_901.x * 0.0625f)) * 2.0f) + -1.0f) * _835) * fHazeFilterScale;
        float _944 = (fHazeFilterScale * _835) * ((((((_917.x * 0.25f) + (_911.x * 0.5f)) + (_924.x * 0.125f)) + (_931.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _957 = 0.5f / fHazeFilterBorder;
          float _964 = saturate(max(((_957 * min(max((abs(_731 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_957 * min(max((abs(_732 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _970 = (_942 - (_964 * _942));
          _971 = (_944 - (_964 * _944));
        } else {
          _970 = _942;
          _971 = _944;
        }
        if (_744) {
          float _976 = ReadonlyDepth.Sample(BilinearWrap, float2((_970 + _731), (_971 + _732)));
          if (!(!((_976.x - _836) >= fHazeFilterDepthDiffBias))) {
            _983 = 0.0f;
            _984 = 0.0f;
          } else {
            _983 = _970;
            _984 = _971;
          }
        } else {
          _983 = _970;
          _984 = _971;
        }
        float4 _989 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_983 + _731), (_984 + _732)));
        _994 = _989.x;
        _995 = _989.y;
        _996 = _989.z;
      }
      float _997 = _994 * Exposure;
      float _998 = _995 * Exposure;
      float _999 = _996 * Exposure;
      untonemapped = float3(_997, _998, _999);
      float _1001 = max(max(_997, _998), _999);
      if (isfinite(_1001)) {
        float _1007 = (tonemapRange * _1001) + 1.0f;
        _1012 = (_997 / _1007);
        _1013 = (_998 / _1007);
        _1014 = (_999 / _1007);
        _1015 = 0.0f;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = 1.0f;
      } else {
        _1012 = 1.0f;
        _1013 = 1.0f;
        _1014 = 1.0f;
        _1015 = 0.0f;
        _1016 = 0.0f;
        _1017 = 0.0f;
        _1018 = 0.0f;
        _1019 = 0.0f;
        _1020 = 1.0f;
      }
    }
  }
  if (!(((uint)(cPassEnabled) & 32) == 0)) {
    float _1043 = float((bool)(bool)(((uint)(cbRadialBlurFlags) & 2) != 0));
    float _1047 = ComputeResultSRV[0].computeAlpha;
    float _1050 = ((1.0f - _1043) + (_1047 * _1043)) * cbRadialColor.w;
    if (!(_1050 == 0.0f)) {
      float _1056 = screenInverseSize.x * SV_Position.x;
      float _1057 = screenInverseSize.y * SV_Position.y;
      float _1059 = (-0.5f - cbRadialScreenPos.x) + _1056;
      float _1061 = (-0.5f - cbRadialScreenPos.y) + _1057;
      float _1064 = select((_1059 < 0.0f), (1.0f - _1056), _1056);
      float _1067 = select((_1061 < 0.0f), (1.0f - _1057), _1057);
      if (!(((uint)(cbRadialBlurFlags) & 1) == 0)) {
        float _1072 = rsqrt(dot(float2(_1059, _1061), float2(_1059, _1061)));
        uint _1081 = uint(abs((_1061 * cbRadialSharpRange) * _1072)) + uint(abs((_1059 * cbRadialSharpRange) * _1072));
        uint _1085 = ((_1081 ^ 61) ^ ((uint)(_1081) >> 16)) * 9;
        uint _1088 = (((uint)(_1085) >> 4) ^ _1085) * 668265261;
        _1094 = (float((uint)((int)(((uint)(_1088) >> 15) ^ _1088))) * 2.3283064365386963e-10f);
      } else {
        _1094 = 1.0f;
      }
      float _1100 = 1.0f / max(1.0f, sqrt((_1059 * _1059) + (_1061 * _1061)));
      float _1101 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1110 = ((((_1101 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1111 = ((((_1101 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1113 = cbRadialBlurPower * -0.002222222276031971f;
      float _1122 = ((((_1113 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1123 = ((((_1113 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1124 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1133 = ((((_1124 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1134 = ((((_1124 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1135 = cbRadialBlurPower * -0.004444444552063942f;
      float _1144 = ((((_1135 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1145 = ((((_1135 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1146 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1155 = ((((_1146 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1156 = ((((_1146 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1157 = cbRadialBlurPower * -0.006666666828095913f;
      float _1166 = ((((_1157 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1167 = ((((_1157 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1168 = cbRadialBlurPower * -0.007777777966111898f;
      float _1177 = ((((_1168 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1178 = ((((_1168 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1179 = cbRadialBlurPower * -0.008888889104127884f;
      float _1188 = ((((_1179 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1189 = ((((_1179 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1190 = cbRadialBlurPower * -0.009999999776482582f;
      float _1199 = ((((_1190 * _1064) * _1094) * _1100) + 1.0f) * _1059;
      float _1200 = ((((_1190 * _1067) * _1094) * _1100) + 1.0f) * _1061;
      float _1201 = Exposure * 0.10000000149011612f;
      float _1202 = _1201 * cbRadialColor.x;
      float _1203 = _1201 * cbRadialColor.y;
      float _1204 = _1201 * cbRadialColor.z;
      if (_50) {
        float _1206 = _1110 + cbRadialScreenPos.x;
        float _1207 = _1111 + cbRadialScreenPos.y;
        float _1211 = ((dot(float2(_1206, _1207), float2(_1206, _1207)) * _1015) + 1.0f) * _1020;
        float4 _1217 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1211 * _1206) + 0.5f), ((_1211 * _1207) + 0.5f)), 0.0f);
        float _1221 = _1122 + cbRadialScreenPos.x;
        float _1222 = _1123 + cbRadialScreenPos.y;
        float _1225 = (dot(float2(_1221, _1222), float2(_1221, _1222)) * _1015) + 1.0f;
        float4 _1232 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1221 * _1020) * _1225) + 0.5f), (((_1222 * _1020) * _1225) + 0.5f)), 0.0f);
        float _1239 = _1133 + cbRadialScreenPos.x;
        float _1240 = _1134 + cbRadialScreenPos.y;
        float _1243 = (dot(float2(_1239, _1240), float2(_1239, _1240)) * _1015) + 1.0f;
        float4 _1250 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1239 * _1020) * _1243) + 0.5f), (((_1240 * _1020) * _1243) + 0.5f)), 0.0f);
        float _1257 = _1144 + cbRadialScreenPos.x;
        float _1258 = _1145 + cbRadialScreenPos.y;
        float _1261 = (dot(float2(_1257, _1258), float2(_1257, _1258)) * _1015) + 1.0f;
        float4 _1268 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1257 * _1020) * _1261) + 0.5f), (((_1258 * _1020) * _1261) + 0.5f)), 0.0f);
        float _1275 = _1155 + cbRadialScreenPos.x;
        float _1276 = _1156 + cbRadialScreenPos.y;
        float _1279 = (dot(float2(_1275, _1276), float2(_1275, _1276)) * _1015) + 1.0f;
        float4 _1286 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1275 * _1020) * _1279) + 0.5f), (((_1276 * _1020) * _1279) + 0.5f)), 0.0f);
        float _1293 = _1166 + cbRadialScreenPos.x;
        float _1294 = _1167 + cbRadialScreenPos.y;
        float _1297 = (dot(float2(_1293, _1294), float2(_1293, _1294)) * _1015) + 1.0f;
        float4 _1304 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1293 * _1020) * _1297) + 0.5f), (((_1294 * _1020) * _1297) + 0.5f)), 0.0f);
        float _1311 = _1177 + cbRadialScreenPos.x;
        float _1312 = _1178 + cbRadialScreenPos.y;
        float _1315 = (dot(float2(_1311, _1312), float2(_1311, _1312)) * _1015) + 1.0f;
        float4 _1322 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1311 * _1020) * _1315) + 0.5f), (((_1312 * _1020) * _1315) + 0.5f)), 0.0f);
        float _1329 = _1188 + cbRadialScreenPos.x;
        float _1330 = _1189 + cbRadialScreenPos.y;
        float _1333 = (dot(float2(_1329, _1330), float2(_1329, _1330)) * _1015) + 1.0f;
        float4 _1340 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1329 * _1020) * _1333) + 0.5f), (((_1330 * _1020) * _1333) + 0.5f)), 0.0f);
        float _1347 = _1199 + cbRadialScreenPos.x;
        float _1348 = _1200 + cbRadialScreenPos.y;
        float _1351 = (dot(float2(_1347, _1348), float2(_1347, _1348)) * _1015) + 1.0f;
        float4 _1358 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1347 * _1020) * _1351) + 0.5f), (((_1348 * _1020) * _1351) + 0.5f)), 0.0f);
        float _1365 = _1202 * ((((((((_1232.x + _1217.x) + _1250.x) + _1268.x) + _1286.x) + _1304.x) + _1322.x) + _1340.x) + _1358.x);
        float _1366 = _1203 * ((((((((_1232.y + _1217.y) + _1250.y) + _1268.y) + _1286.y) + _1304.y) + _1322.y) + _1340.y) + _1358.y);
        float _1367 = _1204 * ((((((((_1232.z + _1217.z) + _1250.z) + _1268.z) + _1286.z) + _1304.z) + _1322.z) + _1340.z) + _1358.z);
        float _1369 = max(max(_1365, _1366), _1367);
        if (isfinite(_1369)) {
          float _1375 = (tonemapRange * _1369) + 1.0f;
          _1380 = (_1365 / _1375);
          _1381 = (_1366 / _1375);
          _1382 = (_1367 / _1375);
        } else {
          _1380 = 1.0f;
          _1381 = 1.0f;
          _1382 = 1.0f;
        }
        _1782 = (_1380 + ((_1012 * 0.10000000149011612f) * cbRadialColor.x));
        _1783 = (_1381 + ((_1013 * 0.10000000149011612f) * cbRadialColor.y));
        _1784 = (_1382 + ((_1014 * 0.10000000149011612f) * cbRadialColor.z));
      } else {
        float _1393 = cbRadialScreenPos.x + 0.5f;
        float _1394 = _1393 + _1110;
        float _1395 = cbRadialScreenPos.y + 0.5f;
        float _1396 = _1395 + _1111;
        float _1397 = _1393 + _1122;
        float _1398 = _1395 + _1123;
        float _1399 = _1393 + _1133;
        float _1400 = _1395 + _1134;
        float _1401 = _1393 + _1144;
        float _1402 = _1395 + _1145;
        float _1403 = _1393 + _1155;
        float _1404 = _1395 + _1156;
        float _1405 = _1393 + _1166;
        float _1406 = _1395 + _1167;
        float _1407 = _1393 + _1177;
        float _1408 = _1395 + _1178;
        float _1409 = _1393 + _1188;
        float _1410 = _1395 + _1189;
        float _1411 = _1393 + _1199;
        float _1412 = _1395 + _1200;
        if (_56) {
          float _1416 = (_1394 * 2.0f) + -1.0f;
          float _1420 = sqrt((_1416 * _1416) + 1.0f);
          float _1421 = 1.0f / _1420;
          float _1424 = (_1420 * _1018) * (_1421 + _1016);
          float _1428 = _1019 * 0.5f;
          float4 _1437 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1424) * _1416) + 0.5f), ((((_1428 * (((_1421 + -1.0f) * _1017) + 1.0f)) * _1424) * ((_1396 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
          float _1443 = (_1397 * 2.0f) + -1.0f;
          float _1447 = sqrt((_1443 * _1443) + 1.0f);
          float _1448 = 1.0f / _1447;
          float _1451 = (_1447 * _1018) * (_1448 + _1016);
          float4 _1462 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1443) * _1451) + 0.5f), ((((_1428 * ((_1398 * 2.0f) + -1.0f)) * (((_1448 + -1.0f) * _1017) + 1.0f)) * _1451) + 0.5f)), 0.0f);
          float _1471 = (_1399 * 2.0f) + -1.0f;
          float _1475 = sqrt((_1471 * _1471) + 1.0f);
          float _1476 = 1.0f / _1475;
          float _1479 = (_1475 * _1018) * (_1476 + _1016);
          float4 _1490 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1471) * _1479) + 0.5f), ((((_1428 * ((_1400 * 2.0f) + -1.0f)) * (((_1476 + -1.0f) * _1017) + 1.0f)) * _1479) + 0.5f)), 0.0f);
          float _1499 = (_1401 * 2.0f) + -1.0f;
          float _1503 = sqrt((_1499 * _1499) + 1.0f);
          float _1504 = 1.0f / _1503;
          float _1507 = (_1503 * _1018) * (_1504 + _1016);
          float4 _1518 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1499) * _1507) + 0.5f), ((((_1428 * ((_1402 * 2.0f) + -1.0f)) * (((_1504 + -1.0f) * _1017) + 1.0f)) * _1507) + 0.5f)), 0.0f);
          float _1527 = (_1403 * 2.0f) + -1.0f;
          float _1531 = sqrt((_1527 * _1527) + 1.0f);
          float _1532 = 1.0f / _1531;
          float _1535 = (_1531 * _1018) * (_1532 + _1016);
          float4 _1546 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1527) * _1535) + 0.5f), ((((_1428 * ((_1404 * 2.0f) + -1.0f)) * (((_1532 + -1.0f) * _1017) + 1.0f)) * _1535) + 0.5f)), 0.0f);
          float _1555 = (_1405 * 2.0f) + -1.0f;
          float _1559 = sqrt((_1555 * _1555) + 1.0f);
          float _1560 = 1.0f / _1559;
          float _1563 = (_1559 * _1018) * (_1560 + _1016);
          float4 _1574 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1555) * _1563) + 0.5f), ((((_1428 * ((_1406 * 2.0f) + -1.0f)) * (((_1560 + -1.0f) * _1017) + 1.0f)) * _1563) + 0.5f)), 0.0f);
          float _1583 = (_1407 * 2.0f) + -1.0f;
          float _1587 = sqrt((_1583 * _1583) + 1.0f);
          float _1588 = 1.0f / _1587;
          float _1591 = (_1587 * _1018) * (_1588 + _1016);
          float4 _1602 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1583) * _1591) + 0.5f), ((((_1428 * ((_1408 * 2.0f) + -1.0f)) * (((_1588 + -1.0f) * _1017) + 1.0f)) * _1591) + 0.5f)), 0.0f);
          float _1611 = (_1409 * 2.0f) + -1.0f;
          float _1615 = sqrt((_1611 * _1611) + 1.0f);
          float _1616 = 1.0f / _1615;
          float _1619 = (_1615 * _1018) * (_1616 + _1016);
          float4 _1630 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1611) * _1619) + 0.5f), ((((_1428 * ((_1410 * 2.0f) + -1.0f)) * (((_1616 + -1.0f) * _1017) + 1.0f)) * _1619) + 0.5f)), 0.0f);
          float _1639 = (_1411 * 2.0f) + -1.0f;
          float _1643 = sqrt((_1639 * _1639) + 1.0f);
          float _1644 = 1.0f / _1643;
          float _1647 = (_1643 * _1018) * (_1644 + _1016);
          float4 _1658 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1428 * _1639) * _1647) + 0.5f), ((((_1428 * ((_1412 * 2.0f) + -1.0f)) * (((_1644 + -1.0f) * _1017) + 1.0f)) * _1647) + 0.5f)), 0.0f);
          float _1665 = _1202 * ((((((((_1462.x + _1437.x) + _1490.x) + _1518.x) + _1546.x) + _1574.x) + _1602.x) + _1630.x) + _1658.x);
          float _1666 = _1203 * ((((((((_1462.y + _1437.y) + _1490.y) + _1518.y) + _1546.y) + _1574.y) + _1602.y) + _1630.y) + _1658.y);
          float _1667 = _1204 * ((((((((_1462.z + _1437.z) + _1490.z) + _1518.z) + _1546.z) + _1574.z) + _1602.z) + _1630.z) + _1658.z);
          float _1669 = max(max(_1665, _1666), _1667);
          if (isfinite(_1669)) {
            float _1675 = (tonemapRange * _1669) + 1.0f;
            _1680 = (_1665 / _1675);
            _1681 = (_1666 / _1675);
            _1682 = (_1667 / _1675);
          } else {
            _1680 = 1.0f;
            _1681 = 1.0f;
            _1682 = 1.0f;
          }
          _1782 = (_1680 + ((_1012 * 0.10000000149011612f) * cbRadialColor.x));
          _1783 = (_1681 + ((_1013 * 0.10000000149011612f) * cbRadialColor.y));
          _1784 = (_1682 + ((_1014 * 0.10000000149011612f) * cbRadialColor.z));
        } else {
          float4 _1694 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1394, _1396), 0.0f);
          float4 _1698 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1397, _1398), 0.0f);
          float4 _1705 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1399, _1400), 0.0f);
          float4 _1712 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1401, _1402), 0.0f);
          float4 _1719 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1403, _1404), 0.0f);
          float4 _1726 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1405, _1406), 0.0f);
          float4 _1733 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1407, _1408), 0.0f);
          float4 _1740 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1409, _1410), 0.0f);
          float4 _1747 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1411, _1412), 0.0f);
          float _1754 = _1202 * ((((((((_1698.x + _1694.x) + _1705.x) + _1712.x) + _1719.x) + _1726.x) + _1733.x) + _1740.x) + _1747.x);
          float _1755 = _1203 * ((((((((_1698.y + _1694.y) + _1705.y) + _1712.y) + _1719.y) + _1726.y) + _1733.y) + _1740.y) + _1747.y);
          float _1756 = _1204 * ((((((((_1698.z + _1694.z) + _1705.z) + _1712.z) + _1719.z) + _1726.z) + _1733.z) + _1740.z) + _1747.z);
          float _1758 = max(max(_1754, _1755), _1756);
          if (isfinite(_1758)) {
            float _1764 = (tonemapRange * _1758) + 1.0f;
            _1769 = (_1754 / _1764);
            _1770 = (_1755 / _1764);
            _1771 = (_1756 / _1764);
          } else {
            _1769 = 1.0f;
            _1770 = 1.0f;
            _1771 = 1.0f;
          }
          _1782 = (_1769 + ((_1012 * 0.10000000149011612f) * cbRadialColor.x));
          _1783 = (_1770 + ((_1013 * 0.10000000149011612f) * cbRadialColor.y));
          _1784 = (_1771 + ((_1014 * 0.10000000149011612f) * cbRadialColor.z));
        }
      }
      if (cbRadialMaskRate.x > 0.0f) {
        float _1793 = saturate((sqrt((_1059 * _1059) + (_1061 * _1061)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _1799 = (((_1793 * _1793) * cbRadialMaskRate.x) * (3.0f - (_1793 * 2.0f))) + cbRadialMaskRate.y;
        _1810 = ((_1799 * (_1782 - _1012)) + _1012);
        _1811 = ((_1799 * (_1783 - _1013)) + _1013);
        _1812 = ((_1799 * (_1784 - _1014)) + _1014);
      } else {
        _1810 = _1782;
        _1811 = _1783;
        _1812 = _1784;
      }
      _1823 = (lerp(_1012, _1810, _1050));
      _1824 = (lerp(_1013, _1811, _1050));
      _1825 = (lerp(_1014, _1812, _1050));
    } else {
      _1823 = _1012;
      _1824 = _1013;
      _1825 = _1014;
    }
  } else {
    _1823 = _1012;
    _1824 = _1013;
    _1825 = _1014;
  }
  if (!(((uint)(cPassEnabled) & 2) == 0)) {
    float _1842 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1844 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1848 = frac(frac(dot(float2(_1842, _1844), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    if (_1848 < fNoiseDensity) {
      int _1853 = (uint)(uint(_1844 * _1842)) ^ 12345391;
      uint _1854 = _1853 * 3635641;
      _1862 = (float((uint)((int)((((uint)(_1854) >> 26) | ((uint)(_1853 * 232681024))) ^ _1854))) * 2.3283064365386963e-10f);
    } else {
      _1862 = 0.0f;
    }
    float _1864 = frac(_1848 * 757.4846801757812f);
    if (_1864 < fNoiseDensity) {
      int _1868 = asint(_1864) ^ 12345391;
      uint _1869 = _1868 * 3635641;
      _1878 = ((float((uint)((int)((((uint)(_1869) >> 26) | ((uint)(_1868 * 232681024))) ^ _1869))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _1878 = 0.0f;
    }
    float _1880 = frac(_1864 * 757.4846801757812f);
    if (_1880 < fNoiseDensity) {
      int _1884 = asint(_1880) ^ 12345391;
      uint _1885 = _1884 * 3635641;
      _1894 = ((float((uint)((int)((((uint)(_1885) >> 26) | ((uint)(_1884 * 232681024))) ^ _1885))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _1894 = 0.0f;
    }
    float _1895 = _1862 * fNoisePower.x;
    float _1896 = _1894 * fNoisePower.y;
    float _1897 = _1878 * fNoisePower.y;
    float _1911 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1823), saturate(_1824), saturate(_1825)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
    _1922 = ((_1911 * (mad(_1897, 1.4019999504089355f, _1895) - _1823)) + _1823);
    _1923 = ((_1911 * (mad(_1897, -0.7139999866485596f, mad(_1896, -0.3440000116825104f, _1895)) - _1824)) + _1824);
    _1924 = ((_1911 * (mad(_1896, 1.7719999551773071f, _1895) - _1825)) + _1825);
  } else {
    _1922 = _1823;
    _1923 = _1824;
    _1924 = _1825;
  }
  if (!(((uint)(cPassEnabled) & 4) == 0)) {
    float _1949 = max(max(_1922, _1923), _1924);
    bool _1950 = (_1949 > 1.0f);
    if (_1950) {
      _1956 = (_1922 / _1949);
      _1957 = (_1923 / _1949);
      _1958 = (_1924 / _1949);
    } else {
      _1956 = _1922;
      _1957 = _1923;
      _1958 = _1924;
    }
    float _1959 = fTextureInverseSize * 0.5f;
    [branch]
    if (!(!(_1956 <= 0.0031308000907301903f))) {
      _1970 = (_1956 * 12.920000076293945f);
    } else {
      _1970 = (((pow(_1956, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_1957 <= 0.0031308000907301903f))) {
      _1981 = (_1957 * 12.920000076293945f);
    } else {
      _1981 = (((pow(_1957, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_1958 <= 0.0031308000907301903f))) {
      _1992 = (_1958 * 12.920000076293945f);
    } else {
      _1992 = (((pow(_1958, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    float _1993 = 1.0f - fTextureInverseSize;
    float _1997 = (_1970 * _1993) + _1959;
    float _1998 = (_1981 * _1993) + _1959;
    float _1999 = (_1992 * _1993) + _1959;
    float4 _2002 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1997, _1998, _1999), 0.0f);
    bool _2007 = (fTextureBlendRate2 > 0.0f);
    [branch]
    if (fTextureBlendRate > 0.0f) {
      float4 _2010 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1997, _1998, _1999), 0.0f);
      float _2020 = ((_2010.x - _2002.x) * fTextureBlendRate) + _2002.x;
      float _2021 = ((_2010.y - _2002.y) * fTextureBlendRate) + _2002.y;
      float _2022 = ((_2010.z - _2002.z) * fTextureBlendRate) + _2002.z;
      if (_2007) {
        [branch]
        if (!(!(_2020 <= 0.0031308000907301903f))) {
          _2034 = (_2020 * 12.920000076293945f);
        } else {
          _2034 = (((pow(_2020, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2021 <= 0.0031308000907301903f))) {
          _2045 = (_2021 * 12.920000076293945f);
        } else {
          _2045 = (((pow(_2021, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2022 <= 0.0031308000907301903f))) {
          _2056 = (_2022 * 12.920000076293945f);
        } else {
          _2056 = (((pow(_2022, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _2058 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2034, _2045, _2056), 0.0f);
        _2121 = (lerp(_2020, _2058.x, fTextureBlendRate2));
        _2122 = (lerp(_2021, _2058.y, fTextureBlendRate2));
        _2123 = (lerp(_2022, _2058.z, fTextureBlendRate2));
      } else {
        _2121 = _2020;
        _2122 = _2021;
        _2123 = _2022;
      }
    } else {
      if (_2007) {
        [branch]
        if (!(!(_2002.x <= 0.0031308000907301903f))) {
          _2083 = (_2002.x * 12.920000076293945f);
        } else {
          _2083 = (((pow(_2002.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2002.y <= 0.0031308000907301903f))) {
          _2094 = (_2002.y * 12.920000076293945f);
        } else {
          _2094 = (((pow(_2002.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2002.z <= 0.0031308000907301903f))) {
          _2105 = (_2002.z * 12.920000076293945f);
        } else {
          _2105 = (((pow(_2002.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _2107 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2083, _2094, _2105), 0.0f);
        _2121 = (lerp(_2002.x, _2107.x, fTextureBlendRate2));
        _2122 = (lerp(_2002.y, _2107.y, fTextureBlendRate2));
        _2123 = (lerp(_2002.z, _2107.z, fTextureBlendRate2));
      } else {
        _2121 = _2002.x;
        _2122 = _2002.y;
        _2123 = _2002.z;
      }
    }
    float _2127 = mad(_2123, (fColorMatrix[2].x), mad(_2122, (fColorMatrix[1].x), (_2121 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
    float _2131 = mad(_2123, (fColorMatrix[2].y), mad(_2122, (fColorMatrix[1].y), (_2121 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
    float _2135 = mad(_2123, (fColorMatrix[2].z), mad(_2122, (fColorMatrix[1].z), (_2121 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
    if (_1950) {
      _2141 = (_2127 * _1949);
      _2142 = (_2131 * _1949);
      _2143 = (_2135 * _1949);
    } else {
      _2141 = _2127;
      _2142 = _2131;
      _2143 = _2135;
    }
  } else {
    _2141 = _1922;
    _2142 = _1923;
    _2143 = _1924;
  }
  if (!(((uint)(cPassEnabled) & 8) == 0)) {
    _2178 = saturate(((cvdR.x * _2141) + (cvdR.y * _2142)) + (cvdR.z * _2143));
    _2179 = saturate(((cvdG.x * _2141) + (cvdG.y * _2142)) + (cvdG.z * _2143));
    _2180 = saturate(((cvdB.x * _2141) + (cvdB.y * _2142)) + (cvdB.z * _2143));
  } else {
    _2178 = _2141;
    _2179 = _2142;
    _2180 = _2143;
  }
  if (!(((uint)(cPassEnabled) & 16) == 0)) {
    float _2195 = screenInverseSize.x * SV_Position.x;
    float _2196 = screenInverseSize.y * SV_Position.y;
    float4 _2199 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2195, _2196), 0.0f);
    float _2204 = _2199.x * ColorParam.x;
    float _2205 = _2199.y * ColorParam.y;
    float _2206 = _2199.z * ColorParam.z;
    float _2209 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2195, _2196), 0.0f);
    float _2214 = (_2199.w * ColorParam.w) * saturate((_2209.x * Levels_Rate) + Levels_Range);
    if (_2204 < 0.5f) {
      _2226 = ((_2178 * 2.0f) * _2204);
    } else {
      _2226 = (1.0f - (((1.0f - _2178) * 2.0f) * (1.0f - _2204)));
    }
    if (_2205 < 0.5f) {
      _2238 = ((_2179 * 2.0f) * _2205);
    } else {
      _2238 = (1.0f - (((1.0f - _2179) * 2.0f) * (1.0f - _2205)));
    }
    if (_2206 < 0.5f) {
      _2250 = ((_2180 * 2.0f) * _2206);
    } else {
      _2250 = (1.0f - (((1.0f - _2180) * 2.0f) * (1.0f - _2206)));
    }
    _2261 = (lerp(_2178, _2226, _2214));
    _2262 = (lerp(_2179, _2238, _2214));
    _2263 = (lerp(_2180, _2250, _2214));
  } else {
    _2261 = _2178;
    _2262 = _2179;
    _2263 = _2180;
  }
  SV_Target.x = _2261;
  SV_Target.y = _2262;
  SV_Target.z = _2263;

  SV_Target.rgb = Tonemap(untonemapped, renodx::tonemap::renodrt::NeutralSDR(SV_Target.rgb));

  SV_Target.w = 0.0f;
  return SV_Target;
}
