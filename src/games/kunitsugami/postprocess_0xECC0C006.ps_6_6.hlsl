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

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer CBHazeFilterParams : register(b3) {
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

cbuffer LensDistortionParam : register(b4) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b5) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b6) {
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

cbuffer FilmGrainParam : register(b7) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b8) {
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

cbuffer ColorDeficientTable : register(b9) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b10) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b11) {
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
  float3 untonemapped;
  float3 test = float3(0.0f, 0.0f, 0.0f);

  bool _50 = (((uint)(cPassEnabled) & 1) == 0);
  bool _56;
  bool _62;
  float _111;
  float _239;
  float _240;
  float _372;
  float _373;
  float _385;
  float _386;
  float _390;
  float _391;
  float _448;
  float _466;
  float _613;
  float _614;
  float _746;
  float _747;
  float _759;
  float _760;
  float _764;
  float _765;
  float _891;
  float _892;
  float _1026;
  float _1027;
  float _1039;
  float _1040;
  float _1050;
  float _1051;
  float _1052;
  float _1068;
  float _1069;
  float _1070;
  float _1071;
  float _1072;
  float _1073;
  float _1074;
  float _1075;
  float _1076;
  float _1151;
  float _1437;
  float _1438;
  float _1439;
  float _1737;
  float _1738;
  float _1739;
  float _1826;
  float _1827;
  float _1828;
  float _1839;
  float _1840;
  float _1841;
  float _1867;
  float _1868;
  float _1869;
  float _1880;
  float _1881;
  float _1882;
  float _1919;
  float _1935;
  float _1951;
  float _1979;
  float _1980;
  float _1981;
  float _2013;
  float _2014;
  float _2015;
  float _2027;
  float _2038;
  float _2049;
  float _2091;
  float _2102;
  float _2113;
  float _2140;
  float _2151;
  float _2162;
  float _2178;
  float _2179;
  float _2180;
  float _2198;
  float _2199;
  float _2200;
  float _2235;
  float _2236;
  float _2237;
  float _2283;
  float _2295;
  float _2307;
  float _2318;
  float _2319;
  float _2320;
  if (!_50) {
    _56 = ((uint)(distortionType) == 0);
  } else {
    _56 = false;
  }
  if (!_50) {
    _62 = ((uint)(distortionType) == 1);
  } else {
    _62 = false;
  }
  bool _64 = (((uint)(cPassEnabled) & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    float _72 = Kerare.x / Kerare.w;
    float _73 = Kerare.y / Kerare.w;
    float _74 = Kerare.z / Kerare.w;
    float _78 = abs(rsqrt(dot(float3(_72, _73, _74), float3(_72, _73, _74))) * _74);
    float _83 = _78 * _78;
    _111 = ((_83 * _83) * (1.0f - saturate((kerare_scale * _78) + kerare_offset)));
  } else {
    float _94 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _96 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _98 = sqrt(dot(float2(_96, _94), float2(_96, _94)));
    float _106 = (_98 * _98) + 1.0f;
    _111 = ((1.0f / (_106 * _106)) * (1.0f - saturate((kerare_scale * (1.0f / (_98 + 1.0f))) + kerare_offset)));
  }
  float _113 = saturate(_111 + kerare_brightness);
  float _114 = _113 * Exposure;
  if (_56) {
    float _128 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _129 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _130 = dot(float2(_128, _129), float2(_128, _129));
    float _133 = ((_130 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _134 = _133 * _128;
    float _135 = _133 * _129;
    float _136 = _134 + 0.5f;
    float _137 = _135 + 0.5f;
    if ((uint)(aberrationEnable) == 0) {
      if (_64) {
        bool _146 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _151 = tFilterTempMap1.Sample(BilinearWrap, float2(_136, _137));
        if (_146) {
          float _156 = ReadonlyDepth.SampleLevel(PointClamp, float2(_136, _137), 0.0f);
          float _164 = (((_136 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
          float _165 = 1.0f - (((_137 * 2.0f) * screenSize.y) * screenInverseSize.y);
          float _202 = 1.0f / (mad(_156.x, (viewProjInvMat[2].w), mad(_165, (viewProjInvMat[1].w), (_164 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _204 = _202 * (mad(_156.x, (viewProjInvMat[2].y), mad(_165, (viewProjInvMat[1].y), (_164 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _212 = (_202 * (mad(_156.x, (viewProjInvMat[2].x), mad(_165, (viewProjInvMat[1].x), (_164 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _213 = _204 - (transposeViewInvMat[1].w);
          float _214 = (_202 * (mad(_156.x, (viewProjInvMat[2].z), mad(_165, (viewProjInvMat[1].z), (_164 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _239 = saturate(_151.x * max(((sqrt(((_213 * _213) + (_212 * _212)) + (_214 * _214)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_204 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _240 = _156.x;
        } else {
          _239 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _151.x), _151.x);
          _240 = 0.0f;
        }
        float _245 = -0.0f - _137;
        float _268 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_245, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _136)));
        float _269 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_245, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _136)));
        float _270 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_245, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _136)));
        float _276 = tVolumeMap.Sample(BilinearWrap, float3((_268 + fHazeFilterUVWOffset.x), (_269 + fHazeFilterUVWOffset.y), (_270 + fHazeFilterUVWOffset.z)));
        float _279 = _268 * 2.0f;
        float _280 = _269 * 2.0f;
        float _281 = _270 * 2.0f;
        float _285 = tVolumeMap.Sample(BilinearWrap, float3((_279 + fHazeFilterUVWOffset.x), (_280 + fHazeFilterUVWOffset.y), (_281 + fHazeFilterUVWOffset.z)));
        float _289 = _268 * 4.0f;
        float _290 = _269 * 4.0f;
        float _291 = _270 * 4.0f;
        float _295 = tVolumeMap.Sample(BilinearWrap, float3((_289 + fHazeFilterUVWOffset.x), (_290 + fHazeFilterUVWOffset.y), (_291 + fHazeFilterUVWOffset.z)));
        float _299 = _268 * 8.0f;
        float _300 = _269 * 8.0f;
        float _301 = _270 * 8.0f;
        float _305 = tVolumeMap.Sample(BilinearWrap, float3((_299 + fHazeFilterUVWOffset.x), (_300 + fHazeFilterUVWOffset.y), (_301 + fHazeFilterUVWOffset.z)));
        float _309 = fHazeFilterUVWOffset.x + 0.5f;
        float _310 = fHazeFilterUVWOffset.y + 0.5f;
        float _311 = fHazeFilterUVWOffset.z + 0.5f;
        float _315 = tVolumeMap.Sample(BilinearWrap, float3((_268 + _309), (_269 + _310), (_270 + _311)));
        float _321 = tVolumeMap.Sample(BilinearWrap, float3((_279 + _309), (_280 + _310), (_281 + _311)));
        float _328 = tVolumeMap.Sample(BilinearWrap, float3((_289 + _309), (_290 + _310), (_291 + _311)));
        float _335 = tVolumeMap.Sample(BilinearWrap, float3((_299 + _309), (_300 + _310), (_301 + _311)));
        float _346 = (((((((_285.x * 0.25f) + (_276.x * 0.5f)) + (_295.x * 0.125f)) + (_305.x * 0.0625f)) * 2.0f) + -1.0f) * _239) * fHazeFilterScale;
        float _348 = (fHazeFilterScale * _239) * ((((((_321.x * 0.25f) + (_315.x * 0.5f)) + (_328.x * 0.125f)) + (_335.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _359 = 0.5f / fHazeFilterBorder;
          float _366 = saturate(max(((_359 * min(max((abs(_134) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_359 * min(max((abs(_135) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _372 = (_346 - (_366 * _346));
          _373 = (_348 - (_366 * _348));
        } else {
          _372 = _346;
          _373 = _348;
        }
        if (_146) {
          float _378 = ReadonlyDepth.Sample(BilinearWrap, float2((_372 + _136), (_373 + _137)));
          if (!(!((_378.x - _240) >= fHazeFilterDepthDiffBias))) {
            _385 = 0.0f;
            _386 = 0.0f;
          } else {
            _385 = _372;
            _386 = _373;
          }
        } else {
          _385 = _372;
          _386 = _373;
        }
        _390 = (_385 + _136);
        _391 = (_386 + _137);
      } else {
        _390 = _136;
        _391 = _137;
      }
      float4 _394 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_390, _391));
      float _398 = _394.x * _114;
      float _399 = _394.y * _114;
      float _400 = _394.z * _114;
      untonemapped = float3(_398, _399, _400);

      float _402 = max(max(_398, _399), _400);
      if (isfinite(_402)) {
        float _408 = (tonemapRange * _402) + 1.0f;
        _1068 = (_398 / _408);
        _1069 = (_399 / _408);
        _1070 = (_400 / _408);
        _1071 = fDistortionCoef;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = fCorrectCoef;
      } else {
        _1068 = 1.0f;
        _1069 = 1.0f;
        _1070 = 1.0f;
        _1071 = fDistortionCoef;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = fCorrectCoef;
      }
    } else {
      float _413 = _130 + fRefraction;
      float _415 = (_413 * fDistortionCoef) + 1.0f;
      float _416 = _128 * fCorrectCoef;
      float _418 = _129 * fCorrectCoef;
      float _424 = ((_413 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _431 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_136, _137));
      float _435 = _431.x * _114;
      float _439 = max(max(_435, (_431.y * _114)), (_431.z * _114));
      if (isfinite(_439)) {
        _448 = (_435 / ((tonemapRange * _439) + 1.0f));
      } else {
        _448 = 1.0f;
      }
      float4 _449 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_416 * _415) + 0.5f), ((_418 * _415) + 0.5f)));
      float _454 = _449.y * _114;
      float _457 = max(max((_449.x * _114), _454), (_449.z * _114));
      if (isfinite(_457)) {
        _466 = (_454 / ((tonemapRange * _457) + 1.0f));
      } else {
        _466 = 1.0f;
      }
      float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_416 * _424) + 0.5f), ((_418 * _424) + 0.5f)));
      float _473 = _467.z * _114;
      float _475 = max(max((_467.x * _114), (_467.y * _114)), _473);

      untonemapped = float3(_435, _454, _473);

      if (isfinite(_475)) {
        _1068 = _448;
        _1069 = _466;
        _1070 = (_473 / ((tonemapRange * _475) + 1.0f));
        _1071 = fDistortionCoef;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = fCorrectCoef;
      } else {
        _1068 = _448;
        _1069 = _466;
        _1070 = 1.0f;
        _1071 = fDistortionCoef;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = fCorrectCoef;
      }
    }
  } else {
    if (_62) {
      float _494 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _498 = sqrt((_494 * _494) + 1.0f);
      float _499 = 1.0f / _498;
      float _502 = (_498 * fOptimizedParam.z) * (_499 + fOptimizedParam.x);
      float _506 = fOptimizedParam.w * 0.5f;
      float _508 = (_506 * _494) * _502;
      float _511 = ((_506 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_499 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _502;
      float _512 = _508 + 0.5f;
      float _513 = _511 + 0.5f;
      if (_64) {
        bool _520 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _525 = tFilterTempMap1.Sample(BilinearWrap, float2(_512, _513));
        if (_520) {
          float _530 = ReadonlyDepth.SampleLevel(PointClamp, float2(_512, _513), 0.0f);
          float _538 = (((screenSize.x * 2.0f) * _512) * screenInverseSize.x) + -1.0f;
          float _539 = 1.0f - (((screenSize.y * 2.0f) * _513) * screenInverseSize.y);
          float _576 = 1.0f / (mad(_530.x, (viewProjInvMat[2].w), mad(_539, (viewProjInvMat[1].w), (_538 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _578 = _576 * (mad(_530.x, (viewProjInvMat[2].y), mad(_539, (viewProjInvMat[1].y), (_538 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _586 = (_576 * (mad(_530.x, (viewProjInvMat[2].x), mad(_539, (viewProjInvMat[1].x), (_538 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _587 = _578 - (transposeViewInvMat[1].w);
          float _588 = (_576 * (mad(_530.x, (viewProjInvMat[2].z), mad(_539, (viewProjInvMat[1].z), (_538 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _613 = saturate(_525.x * max(((sqrt(((_587 * _587) + (_586 * _586)) + (_588 * _588)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_578 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _614 = _530.x;
        } else {
          _613 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _525.x), _525.x);
          _614 = 0.0f;
        }
        float _619 = -0.0f - _513;
        float _642 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_619, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _512)));
        float _643 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_619, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _512)));
        float _644 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_619, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _512)));
        float _650 = tVolumeMap.Sample(BilinearWrap, float3((_642 + fHazeFilterUVWOffset.x), (_643 + fHazeFilterUVWOffset.y), (_644 + fHazeFilterUVWOffset.z)));
        float _653 = _642 * 2.0f;
        float _654 = _643 * 2.0f;
        float _655 = _644 * 2.0f;
        float _659 = tVolumeMap.Sample(BilinearWrap, float3((_653 + fHazeFilterUVWOffset.x), (_654 + fHazeFilterUVWOffset.y), (_655 + fHazeFilterUVWOffset.z)));
        float _663 = _642 * 4.0f;
        float _664 = _643 * 4.0f;
        float _665 = _644 * 4.0f;
        float _669 = tVolumeMap.Sample(BilinearWrap, float3((_663 + fHazeFilterUVWOffset.x), (_664 + fHazeFilterUVWOffset.y), (_665 + fHazeFilterUVWOffset.z)));
        float _673 = _642 * 8.0f;
        float _674 = _643 * 8.0f;
        float _675 = _644 * 8.0f;
        float _679 = tVolumeMap.Sample(BilinearWrap, float3((_673 + fHazeFilterUVWOffset.x), (_674 + fHazeFilterUVWOffset.y), (_675 + fHazeFilterUVWOffset.z)));
        float _683 = fHazeFilterUVWOffset.x + 0.5f;
        float _684 = fHazeFilterUVWOffset.y + 0.5f;
        float _685 = fHazeFilterUVWOffset.z + 0.5f;
        float _689 = tVolumeMap.Sample(BilinearWrap, float3((_642 + _683), (_643 + _684), (_644 + _685)));
        float _695 = tVolumeMap.Sample(BilinearWrap, float3((_653 + _683), (_654 + _684), (_655 + _685)));
        float _702 = tVolumeMap.Sample(BilinearWrap, float3((_663 + _683), (_664 + _684), (_665 + _685)));
        float _709 = tVolumeMap.Sample(BilinearWrap, float3((_673 + _683), (_674 + _684), (_675 + _685)));
        float _720 = (((((((_659.x * 0.25f) + (_650.x * 0.5f)) + (_669.x * 0.125f)) + (_679.x * 0.0625f)) * 2.0f) + -1.0f) * _613) * fHazeFilterScale;
        float _722 = (fHazeFilterScale * _613) * ((((((_695.x * 0.25f) + (_689.x * 0.5f)) + (_702.x * 0.125f)) + (_709.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _733 = 0.5f / fHazeFilterBorder;
          float _740 = saturate(max(((_733 * min(max((abs(_508) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_733 * min(max((abs(_511) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _746 = (_720 - (_740 * _720));
          _747 = (_722 - (_740 * _722));
        } else {
          _746 = _720;
          _747 = _722;
        }
        if (_520) {
          float _752 = ReadonlyDepth.Sample(BilinearWrap, float2((_746 + _512), (_747 + _513)));
          if (!(!((_752.x - _614) >= fHazeFilterDepthDiffBias))) {
            _759 = 0.0f;
            _760 = 0.0f;
          } else {
            _759 = _746;
            _760 = _747;
          }
        } else {
          _759 = _746;
          _760 = _747;
        }
        _764 = (_759 + _512);
        _765 = (_760 + _513);
      } else {
        _764 = _512;
        _765 = _513;
      }
      float4 _768 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_764, _765));
      float _772 = _768.x * _114;
      float _773 = _768.y * _114;
      float _774 = _768.z * _114;
      untonemapped = float3(_772, _773, _774);

      float _776 = max(max(_772, _773), _774);
      if (isfinite(_776)) {
        float _782 = (tonemapRange * _776) + 1.0f;
        _1068 = (_772 / _782);
        _1069 = (_773 / _782);
        _1070 = (_774 / _782);
        _1071 = 0.0f;
        _1072 = fOptimizedParam.x;
        _1073 = fOptimizedParam.y;
        _1074 = fOptimizedParam.z;
        _1075 = fOptimizedParam.w;
        _1076 = 1.0f;
      } else {
        _1068 = 1.0f;
        _1069 = 1.0f;
        _1070 = 1.0f;
        _1071 = 0.0f;
        _1072 = fOptimizedParam.x;
        _1073 = fOptimizedParam.y;
        _1074 = fOptimizedParam.z;
        _1075 = fOptimizedParam.w;
        _1076 = 1.0f;
      }
    } else {
      float _787 = screenInverseSize.x * SV_Position.x;
      float _788 = screenInverseSize.y * SV_Position.y;
      if (!_64) {
        float4 _792 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_787, _788));
        _1050 = _792.x;
        _1051 = _792.y;
        _1052 = _792.z;
      } else {
        bool _800 = (((uint)(fHazeFilterAttribute) & 2) != 0);
        float _805 = tFilterTempMap1.Sample(BilinearWrap, float2(_787, _788));
        if (_800) {
          float _810 = ReadonlyDepth.SampleLevel(PointClamp, float2(_787, _788), 0.0f);
          float _816 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
          float _817 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
          float _854 = 1.0f / (mad(_810.x, (viewProjInvMat[2].w), mad(_817, (viewProjInvMat[1].w), (_816 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
          float _856 = _854 * (mad(_810.x, (viewProjInvMat[2].y), mad(_817, (viewProjInvMat[1].y), (_816 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
          float _864 = (_854 * (mad(_810.x, (viewProjInvMat[2].x), mad(_817, (viewProjInvMat[1].x), (_816 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
          float _865 = _856 - (transposeViewInvMat[1].w);
          float _866 = (_854 * (mad(_810.x, (viewProjInvMat[2].z), mad(_817, (viewProjInvMat[1].z), (_816 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
          _891 = saturate(_805.x * max(((sqrt(((_865 * _865) + (_864 * _864)) + (_866 * _866)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_856 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
          _892 = _810.x;
        } else {
          _891 = select((((uint)(fHazeFilterAttribute) & 1) != 0), (1.0f - _805.x), _805.x);
          _892 = 0.0f;
        }
        float _897 = -0.0f - _788;
        float _920 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_897, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _787)));
        float _921 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_897, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _787)));
        float _922 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_897, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _787)));
        float _928 = tVolumeMap.Sample(BilinearWrap, float3((_920 + fHazeFilterUVWOffset.x), (_921 + fHazeFilterUVWOffset.y), (_922 + fHazeFilterUVWOffset.z)));
        float _931 = _920 * 2.0f;
        float _932 = _921 * 2.0f;
        float _933 = _922 * 2.0f;
        float _937 = tVolumeMap.Sample(BilinearWrap, float3((_931 + fHazeFilterUVWOffset.x), (_932 + fHazeFilterUVWOffset.y), (_933 + fHazeFilterUVWOffset.z)));
        float _941 = _920 * 4.0f;
        float _942 = _921 * 4.0f;
        float _943 = _922 * 4.0f;
        float _947 = tVolumeMap.Sample(BilinearWrap, float3((_941 + fHazeFilterUVWOffset.x), (_942 + fHazeFilterUVWOffset.y), (_943 + fHazeFilterUVWOffset.z)));
        float _951 = _920 * 8.0f;
        float _952 = _921 * 8.0f;
        float _953 = _922 * 8.0f;
        float _957 = tVolumeMap.Sample(BilinearWrap, float3((_951 + fHazeFilterUVWOffset.x), (_952 + fHazeFilterUVWOffset.y), (_953 + fHazeFilterUVWOffset.z)));
        float _961 = fHazeFilterUVWOffset.x + 0.5f;
        float _962 = fHazeFilterUVWOffset.y + 0.5f;
        float _963 = fHazeFilterUVWOffset.z + 0.5f;
        float _967 = tVolumeMap.Sample(BilinearWrap, float3((_920 + _961), (_921 + _962), (_922 + _963)));
        float _973 = tVolumeMap.Sample(BilinearWrap, float3((_931 + _961), (_932 + _962), (_933 + _963)));
        float _980 = tVolumeMap.Sample(BilinearWrap, float3((_941 + _961), (_942 + _962), (_943 + _963)));
        float _987 = tVolumeMap.Sample(BilinearWrap, float3((_951 + _961), (_952 + _962), (_953 + _963)));
        float _998 = (((((((_937.x * 0.25f) + (_928.x * 0.5f)) + (_947.x * 0.125f)) + (_957.x * 0.0625f)) * 2.0f) + -1.0f) * _891) * fHazeFilterScale;
        float _1000 = (fHazeFilterScale * _891) * ((((((_973.x * 0.25f) + (_967.x * 0.5f)) + (_980.x * 0.125f)) + (_987.x * 0.0625f)) * 2.0f) + -1.0f);
        if (!(((uint)(fHazeFilterAttribute) & 4) == 0)) {
          float _1013 = 0.5f / fHazeFilterBorder;
          float _1020 = saturate(max(((_1013 * min(max((abs(_787 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1013 * min(max((abs(_788 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
          _1026 = (_998 - (_1020 * _998));
          _1027 = (_1000 - (_1020 * _1000));
        } else {
          _1026 = _998;
          _1027 = _1000;
        }
        if (_800) {
          float _1032 = ReadonlyDepth.Sample(BilinearWrap, float2((_1026 + _787), (_1027 + _788)));
          if (!(!((_1032.x - _892) >= fHazeFilterDepthDiffBias))) {
            _1039 = 0.0f;
            _1040 = 0.0f;
          } else {
            _1039 = _1026;
            _1040 = _1027;
          }
        } else {
          _1039 = _1026;
          _1040 = _1027;
        }
        float4 _1045 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1039 + _787), (_1040 + _788)));
        _1050 = _1045.x;
        _1051 = _1045.y;
        _1052 = _1045.z;
      }
      float _1053 = _1050 * _114;
      float _1054 = _1051 * _114;
      float _1055 = _1052 * _114;
      untonemapped = float3(_1053, _1054, _1055);

      float _1057 = max(max(_1053, _1054), _1055);
      if (isfinite(_1057)) {
        float _1063 = (tonemapRange * _1057) + 1.0f;
        _1068 = (_1053 / _1063);
        _1069 = (_1054 / _1063);
        _1070 = (_1055 / _1063);
        _1071 = 0.0f;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = 1.0f;
      } else {
        _1068 = 1.0f;
        _1069 = 1.0f;
        _1070 = 1.0f;
        _1071 = 0.0f;
        _1072 = 0.0f;
        _1073 = 0.0f;
        _1074 = 0.0f;
        _1075 = 0.0f;
        _1076 = 1.0f;
      }
    }
  }
  if (!(((uint)(cPassEnabled) & 32) == 0)) {
    float _1100 = float((bool)(bool)(((uint)(cbRadialBlurFlags) & 2) != 0));
    float _1104 = ComputeResultSRV[0].computeAlpha;
    float _1107 = ((1.0f - _1100) + (_1104 * _1100)) * cbRadialColor.w;
    if (!(_1107 == 0.0f)) {
      float _1113 = screenInverseSize.x * SV_Position.x;
      float _1114 = screenInverseSize.y * SV_Position.y;
      float _1116 = (-0.5f - cbRadialScreenPos.x) + _1113;
      float _1118 = (-0.5f - cbRadialScreenPos.y) + _1114;
      float _1121 = select((_1116 < 0.0f), (1.0f - _1113), _1113);
      float _1124 = select((_1118 < 0.0f), (1.0f - _1114), _1114);
      if (!(((uint)(cbRadialBlurFlags) & 1) == 0)) {
        float _1129 = rsqrt(dot(float2(_1116, _1118), float2(_1116, _1118)));
        uint _1138 = uint(abs((_1118 * cbRadialSharpRange) * _1129)) + uint(abs((_1116 * cbRadialSharpRange) * _1129));
        uint _1142 = ((_1138 ^ 61) ^ ((uint)(_1138) >> 16)) * 9;
        uint _1145 = (((uint)(_1142) >> 4) ^ _1142) * 668265261;
        _1151 = (float((uint)((int)(((uint)(_1145) >> 15) ^ _1145))) * 2.3283064365386963e-10f);
      } else {
        _1151 = 1.0f;
      }
      float _1157 = 1.0f / max(1.0f, sqrt((_1116 * _1116) + (_1118 * _1118)));
      float _1158 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1167 = ((((_1158 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1168 = ((((_1158 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1170 = cbRadialBlurPower * -0.002222222276031971f;
      float _1179 = ((((_1170 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1180 = ((((_1170 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1181 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1190 = ((((_1181 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1191 = ((((_1181 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1192 = cbRadialBlurPower * -0.004444444552063942f;
      float _1201 = ((((_1192 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1202 = ((((_1192 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1203 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1212 = ((((_1203 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1213 = ((((_1203 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1214 = cbRadialBlurPower * -0.006666666828095913f;
      float _1223 = ((((_1214 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1224 = ((((_1214 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1225 = cbRadialBlurPower * -0.007777777966111898f;
      float _1234 = ((((_1225 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1235 = ((((_1225 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1236 = cbRadialBlurPower * -0.008888889104127884f;
      float _1245 = ((((_1236 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1246 = ((((_1236 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1247 = cbRadialBlurPower * -0.009999999776482582f;
      float _1256 = ((((_1247 * _1121) * _1151) * _1157) + 1.0f) * _1116;
      float _1257 = ((((_1247 * _1124) * _1151) * _1157) + 1.0f) * _1118;
      float _1258 = (_113 * Exposure) * 0.10000000149011612f;
      float _1259 = _1258 * cbRadialColor.x;
      float _1260 = _1258 * cbRadialColor.y;
      float _1261 = _1258 * cbRadialColor.z;
      if (_56) {
        float _1263 = _1167 + cbRadialScreenPos.x;
        float _1264 = _1168 + cbRadialScreenPos.y;
        float _1268 = ((dot(float2(_1263, _1264), float2(_1263, _1264)) * _1071) + 1.0f) * _1076;
        float4 _1274 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1268 * _1263) + 0.5f), ((_1268 * _1264) + 0.5f)), 0.0f);
        float _1278 = _1179 + cbRadialScreenPos.x;
        float _1279 = _1180 + cbRadialScreenPos.y;
        float _1282 = (dot(float2(_1278, _1279), float2(_1278, _1279)) * _1071) + 1.0f;
        float4 _1289 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1278 * _1076) * _1282) + 0.5f), (((_1279 * _1076) * _1282) + 0.5f)), 0.0f);
        float _1296 = _1190 + cbRadialScreenPos.x;
        float _1297 = _1191 + cbRadialScreenPos.y;
        float _1300 = (dot(float2(_1296, _1297), float2(_1296, _1297)) * _1071) + 1.0f;
        float4 _1307 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1296 * _1076) * _1300) + 0.5f), (((_1297 * _1076) * _1300) + 0.5f)), 0.0f);
        float _1314 = _1201 + cbRadialScreenPos.x;
        float _1315 = _1202 + cbRadialScreenPos.y;
        float _1318 = (dot(float2(_1314, _1315), float2(_1314, _1315)) * _1071) + 1.0f;
        float4 _1325 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1314 * _1076) * _1318) + 0.5f), (((_1315 * _1076) * _1318) + 0.5f)), 0.0f);
        float _1332 = _1212 + cbRadialScreenPos.x;
        float _1333 = _1213 + cbRadialScreenPos.y;
        float _1336 = (dot(float2(_1332, _1333), float2(_1332, _1333)) * _1071) + 1.0f;
        float4 _1343 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1332 * _1076) * _1336) + 0.5f), (((_1333 * _1076) * _1336) + 0.5f)), 0.0f);
        float _1350 = _1223 + cbRadialScreenPos.x;
        float _1351 = _1224 + cbRadialScreenPos.y;
        float _1354 = (dot(float2(_1350, _1351), float2(_1350, _1351)) * _1071) + 1.0f;
        float4 _1361 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1350 * _1076) * _1354) + 0.5f), (((_1351 * _1076) * _1354) + 0.5f)), 0.0f);
        float _1368 = _1234 + cbRadialScreenPos.x;
        float _1369 = _1235 + cbRadialScreenPos.y;
        float _1372 = (dot(float2(_1368, _1369), float2(_1368, _1369)) * _1071) + 1.0f;
        float4 _1379 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1368 * _1076) * _1372) + 0.5f), (((_1369 * _1076) * _1372) + 0.5f)), 0.0f);
        float _1386 = _1245 + cbRadialScreenPos.x;
        float _1387 = _1246 + cbRadialScreenPos.y;
        float _1390 = (dot(float2(_1386, _1387), float2(_1386, _1387)) * _1071) + 1.0f;
        float4 _1397 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1386 * _1076) * _1390) + 0.5f), (((_1387 * _1076) * _1390) + 0.5f)), 0.0f);
        float _1404 = _1256 + cbRadialScreenPos.x;
        float _1405 = _1257 + cbRadialScreenPos.y;
        float _1408 = (dot(float2(_1404, _1405), float2(_1404, _1405)) * _1071) + 1.0f;
        float4 _1415 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1404 * _1076) * _1408) + 0.5f), (((_1405 * _1076) * _1408) + 0.5f)), 0.0f);
        float _1422 = _1259 * ((((((((_1289.x + _1274.x) + _1307.x) + _1325.x) + _1343.x) + _1361.x) + _1379.x) + _1397.x) + _1415.x);
        float _1423 = _1260 * ((((((((_1289.y + _1274.y) + _1307.y) + _1325.y) + _1343.y) + _1361.y) + _1379.y) + _1397.y) + _1415.y);
        float _1424 = _1261 * ((((((((_1289.z + _1274.z) + _1307.z) + _1325.z) + _1343.z) + _1361.z) + _1379.z) + _1397.z) + _1415.z);
        float _1426 = max(max(_1422, _1423), _1424);
        if (isfinite(_1426)) {
          float _1432 = (tonemapRange * _1426) + 1.0f;
          _1437 = (_1422 / _1432);
          _1438 = (_1423 / _1432);
          _1439 = (_1424 / _1432);
        } else {
          _1437 = 1.0f;
          _1438 = 1.0f;
          _1439 = 1.0f;
        }
        _1839 = (_1437 + ((_1068 * 0.10000000149011612f) * cbRadialColor.x));
        _1840 = (_1438 + ((_1069 * 0.10000000149011612f) * cbRadialColor.y));
        _1841 = (_1439 + ((_1070 * 0.10000000149011612f) * cbRadialColor.z));
      } else {
        float _1450 = cbRadialScreenPos.x + 0.5f;
        float _1451 = _1450 + _1167;
        float _1452 = cbRadialScreenPos.y + 0.5f;
        float _1453 = _1452 + _1168;
        float _1454 = _1450 + _1179;
        float _1455 = _1452 + _1180;
        float _1456 = _1450 + _1190;
        float _1457 = _1452 + _1191;
        float _1458 = _1450 + _1201;
        float _1459 = _1452 + _1202;
        float _1460 = _1450 + _1212;
        float _1461 = _1452 + _1213;
        float _1462 = _1450 + _1223;
        float _1463 = _1452 + _1224;
        float _1464 = _1450 + _1234;
        float _1465 = _1452 + _1235;
        float _1466 = _1450 + _1245;
        float _1467 = _1452 + _1246;
        float _1468 = _1450 + _1256;
        float _1469 = _1452 + _1257;
        if (_62) {
          float _1473 = (_1451 * 2.0f) + -1.0f;
          float _1477 = sqrt((_1473 * _1473) + 1.0f);
          float _1478 = 1.0f / _1477;
          float _1481 = (_1477 * _1074) * (_1478 + _1072);
          float _1485 = _1075 * 0.5f;
          float4 _1494 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1481) * _1473) + 0.5f), ((((_1485 * (((_1478 + -1.0f) * _1073) + 1.0f)) * _1481) * ((_1453 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
          float _1500 = (_1454 * 2.0f) + -1.0f;
          float _1504 = sqrt((_1500 * _1500) + 1.0f);
          float _1505 = 1.0f / _1504;
          float _1508 = (_1504 * _1074) * (_1505 + _1072);
          float4 _1519 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1500) * _1508) + 0.5f), ((((_1485 * ((_1455 * 2.0f) + -1.0f)) * (((_1505 + -1.0f) * _1073) + 1.0f)) * _1508) + 0.5f)), 0.0f);
          float _1528 = (_1456 * 2.0f) + -1.0f;
          float _1532 = sqrt((_1528 * _1528) + 1.0f);
          float _1533 = 1.0f / _1532;
          float _1536 = (_1532 * _1074) * (_1533 + _1072);
          float4 _1547 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1528) * _1536) + 0.5f), ((((_1485 * ((_1457 * 2.0f) + -1.0f)) * (((_1533 + -1.0f) * _1073) + 1.0f)) * _1536) + 0.5f)), 0.0f);
          float _1556 = (_1458 * 2.0f) + -1.0f;
          float _1560 = sqrt((_1556 * _1556) + 1.0f);
          float _1561 = 1.0f / _1560;
          float _1564 = (_1560 * _1074) * (_1561 + _1072);
          float4 _1575 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1556) * _1564) + 0.5f), ((((_1485 * ((_1459 * 2.0f) + -1.0f)) * (((_1561 + -1.0f) * _1073) + 1.0f)) * _1564) + 0.5f)), 0.0f);
          float _1584 = (_1460 * 2.0f) + -1.0f;
          float _1588 = sqrt((_1584 * _1584) + 1.0f);
          float _1589 = 1.0f / _1588;
          float _1592 = (_1588 * _1074) * (_1589 + _1072);
          float4 _1603 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1584) * _1592) + 0.5f), ((((_1485 * ((_1461 * 2.0f) + -1.0f)) * (((_1589 + -1.0f) * _1073) + 1.0f)) * _1592) + 0.5f)), 0.0f);
          float _1612 = (_1462 * 2.0f) + -1.0f;
          float _1616 = sqrt((_1612 * _1612) + 1.0f);
          float _1617 = 1.0f / _1616;
          float _1620 = (_1616 * _1074) * (_1617 + _1072);
          float4 _1631 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1612) * _1620) + 0.5f), ((((_1485 * ((_1463 * 2.0f) + -1.0f)) * (((_1617 + -1.0f) * _1073) + 1.0f)) * _1620) + 0.5f)), 0.0f);
          float _1640 = (_1464 * 2.0f) + -1.0f;
          float _1644 = sqrt((_1640 * _1640) + 1.0f);
          float _1645 = 1.0f / _1644;
          float _1648 = (_1644 * _1074) * (_1645 + _1072);
          float4 _1659 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1640) * _1648) + 0.5f), ((((_1485 * ((_1465 * 2.0f) + -1.0f)) * (((_1645 + -1.0f) * _1073) + 1.0f)) * _1648) + 0.5f)), 0.0f);
          float _1668 = (_1466 * 2.0f) + -1.0f;
          float _1672 = sqrt((_1668 * _1668) + 1.0f);
          float _1673 = 1.0f / _1672;
          float _1676 = (_1672 * _1074) * (_1673 + _1072);
          float4 _1687 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1668) * _1676) + 0.5f), ((((_1485 * ((_1467 * 2.0f) + -1.0f)) * (((_1673 + -1.0f) * _1073) + 1.0f)) * _1676) + 0.5f)), 0.0f);
          float _1696 = (_1468 * 2.0f) + -1.0f;
          float _1700 = sqrt((_1696 * _1696) + 1.0f);
          float _1701 = 1.0f / _1700;
          float _1704 = (_1700 * _1074) * (_1701 + _1072);
          float4 _1715 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1485 * _1696) * _1704) + 0.5f), ((((_1485 * ((_1469 * 2.0f) + -1.0f)) * (((_1701 + -1.0f) * _1073) + 1.0f)) * _1704) + 0.5f)), 0.0f);
          float _1722 = _1259 * ((((((((_1519.x + _1494.x) + _1547.x) + _1575.x) + _1603.x) + _1631.x) + _1659.x) + _1687.x) + _1715.x);
          float _1723 = _1260 * ((((((((_1519.y + _1494.y) + _1547.y) + _1575.y) + _1603.y) + _1631.y) + _1659.y) + _1687.y) + _1715.y);
          float _1724 = _1261 * ((((((((_1519.z + _1494.z) + _1547.z) + _1575.z) + _1603.z) + _1631.z) + _1659.z) + _1687.z) + _1715.z);
          float _1726 = max(max(_1722, _1723), _1724);
          if (isfinite(_1726)) {
            float _1732 = (tonemapRange * _1726) + 1.0f;
            _1737 = (_1722 / _1732);
            _1738 = (_1723 / _1732);
            _1739 = (_1724 / _1732);
          } else {
            _1737 = 1.0f;
            _1738 = 1.0f;
            _1739 = 1.0f;
          }
          _1839 = (_1737 + ((_1068 * 0.10000000149011612f) * cbRadialColor.x));
          _1840 = (_1738 + ((_1069 * 0.10000000149011612f) * cbRadialColor.y));
          _1841 = (_1739 + ((_1070 * 0.10000000149011612f) * cbRadialColor.z));
        } else {
          float4 _1751 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1451, _1453), 0.0f);
          float4 _1755 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1454, _1455), 0.0f);
          float4 _1762 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1456, _1457), 0.0f);
          float4 _1769 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1458, _1459), 0.0f);
          float4 _1776 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1460, _1461), 0.0f);
          float4 _1783 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1462, _1463), 0.0f);
          float4 _1790 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1464, _1465), 0.0f);
          float4 _1797 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1466, _1467), 0.0f);
          float4 _1804 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1468, _1469), 0.0f);
          float _1811 = _1259 * ((((((((_1755.x + _1751.x) + _1762.x) + _1769.x) + _1776.x) + _1783.x) + _1790.x) + _1797.x) + _1804.x);
          float _1812 = _1260 * ((((((((_1755.y + _1751.y) + _1762.y) + _1769.y) + _1776.y) + _1783.y) + _1790.y) + _1797.y) + _1804.y);
          float _1813 = _1261 * ((((((((_1755.z + _1751.z) + _1762.z) + _1769.z) + _1776.z) + _1783.z) + _1790.z) + _1797.z) + _1804.z);
          float _1815 = max(max(_1811, _1812), _1813);
          if (isfinite(_1815)) {
            float _1821 = (tonemapRange * _1815) + 1.0f;
            _1826 = (_1811 / _1821);
            _1827 = (_1812 / _1821);
            _1828 = (_1813 / _1821);
          } else {
            _1826 = 1.0f;
            _1827 = 1.0f;
            _1828 = 1.0f;
          }
          _1839 = (_1826 + ((_1068 * 0.10000000149011612f) * cbRadialColor.x));
          _1840 = (_1827 + ((_1069 * 0.10000000149011612f) * cbRadialColor.y));
          _1841 = (_1828 + ((_1070 * 0.10000000149011612f) * cbRadialColor.z));
        }
      }
      if (cbRadialMaskRate.x > 0.0f) {
        float _1850 = saturate((sqrt((_1116 * _1116) + (_1118 * _1118)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _1856 = (((_1850 * _1850) * cbRadialMaskRate.x) * (3.0f - (_1850 * 2.0f))) + cbRadialMaskRate.y;
        _1867 = ((_1856 * (_1839 - _1068)) + _1068);
        _1868 = ((_1856 * (_1840 - _1069)) + _1069);
        _1869 = ((_1856 * (_1841 - _1070)) + _1070);
      } else {
        _1867 = _1839;
        _1868 = _1840;
        _1869 = _1841;
      }
      _1880 = (lerp(_1068, _1867, _1107));
      _1881 = (lerp(_1069, _1868, _1107));
      _1882 = (lerp(_1070, _1869, _1107));
    } else {
      _1880 = _1068;
      _1881 = _1069;
      _1882 = _1070;
    }
  } else {
    _1880 = _1068;
    _1881 = _1069;
    _1882 = _1070;
  }
  if (!(((uint)(cPassEnabled) & 2) == 0)) {
    float _1899 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1901 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1905 = frac(frac(dot(float2(_1899, _1901), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    if (_1905 < fNoiseDensity) {
      int _1910 = (uint)(uint(_1901 * _1899)) ^ 12345391;
      uint _1911 = _1910 * 3635641;
      _1919 = (float((uint)((int)((((uint)(_1911) >> 26) | ((uint)(_1910 * 232681024))) ^ _1911))) * 2.3283064365386963e-10f);
    } else {
      _1919 = 0.0f;
    }
    float _1921 = frac(_1905 * 757.4846801757812f);
    if (_1921 < fNoiseDensity) {
      int _1925 = asint(_1921) ^ 12345391;
      uint _1926 = _1925 * 3635641;
      _1935 = ((float((uint)((int)((((uint)(_1926) >> 26) | ((uint)(_1925 * 232681024))) ^ _1926))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _1935 = 0.0f;
    }
    float _1937 = frac(_1921 * 757.4846801757812f);
    if (_1937 < fNoiseDensity) {
      int _1941 = asint(_1937) ^ 12345391;
      uint _1942 = _1941 * 3635641;
      _1951 = ((float((uint)((int)((((uint)(_1942) >> 26) | ((uint)(_1941 * 232681024))) ^ _1942))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _1951 = 0.0f;
    }
    float _1952 = _1919 * fNoisePower.x;
    float _1953 = _1951 * fNoisePower.y;
    float _1954 = _1935 * fNoisePower.y;
    float _1968 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1880), saturate(_1881), saturate(_1882)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
    _1979 = ((_1968 * (mad(_1954, 1.4019999504089355f, _1952) - _1880)) + _1880);
    _1980 = ((_1968 * (mad(_1954, -0.7139999866485596f, mad(_1953, -0.3440000116825104f, _1952)) - _1881)) + _1881);
    _1981 = ((_1968 * (mad(_1953, 1.7719999551773071f, _1952) - _1882)) + _1882);
  } else {
    _1979 = _1880;
    _1980 = _1881;
    _1981 = _1882;
  }
  if (!(((uint)(cPassEnabled) & 4) == 0)) {
    float _2006 = max(max(_1979, _1980), _1981);
    bool _2007 = (_2006 > 1.0f);
    if (_2007) {
      _2013 = (_1979 / _2006);
      _2014 = (_1980 / _2006);
      _2015 = (_1981 / _2006);
    } else {
      _2013 = _1979;
      _2014 = _1980;
      _2015 = _1981;
    }
    float _2016 = fTextureInverseSize * 0.5f;
    [branch]
    if (!(!(_2013 <= 0.0031308000907301903f))) {
      _2027 = (_2013 * 12.920000076293945f);
    } else {
      _2027 = (((pow(_2013, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_2014 <= 0.0031308000907301903f))) {
      _2038 = (_2014 * 12.920000076293945f);
    } else {
      _2038 = (((pow(_2014, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_2015 <= 0.0031308000907301903f))) {
      _2049 = (_2015 * 12.920000076293945f);
    } else {
      _2049 = (((pow(_2015, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    float _2050 = 1.0f - fTextureInverseSize;
    float _2054 = (_2027 * _2050) + _2016;
    float _2055 = (_2038 * _2050) + _2016;
    float _2056 = (_2049 * _2050) + _2016;
    float4 _2059 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2054, _2055, _2056), 0.0f);
    bool _2064 = (fTextureBlendRate2 > 0.0f);
    [branch]
    if (fTextureBlendRate > 0.0f) {
      float4 _2067 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2054, _2055, _2056), 0.0f);
      float _2077 = ((_2067.x - _2059.x) * fTextureBlendRate) + _2059.x;
      float _2078 = ((_2067.y - _2059.y) * fTextureBlendRate) + _2059.y;
      float _2079 = ((_2067.z - _2059.z) * fTextureBlendRate) + _2059.z;
      if (_2064) {
        [branch]
        if (!(!(_2077 <= 0.0031308000907301903f))) {
          _2091 = (_2077 * 12.920000076293945f);
        } else {
          _2091 = (((pow(_2077, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2078 <= 0.0031308000907301903f))) {
          _2102 = (_2078 * 12.920000076293945f);
        } else {
          _2102 = (((pow(_2078, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2079 <= 0.0031308000907301903f))) {
          _2113 = (_2079 * 12.920000076293945f);
        } else {
          _2113 = (((pow(_2079, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _2115 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2091, _2102, _2113), 0.0f);
        _2178 = (lerp(_2077, _2115.x, fTextureBlendRate2));
        _2179 = (lerp(_2078, _2115.y, fTextureBlendRate2));
        _2180 = (lerp(_2079, _2115.z, fTextureBlendRate2));
      } else {
        _2178 = _2077;
        _2179 = _2078;
        _2180 = _2079;
      }
    } else {
      if (_2064) {
        [branch]
        if (!(!(_2059.x <= 0.0031308000907301903f))) {
          _2140 = (_2059.x * 12.920000076293945f);
        } else {
          _2140 = (((pow(_2059.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2059.y <= 0.0031308000907301903f))) {
          _2151 = (_2059.y * 12.920000076293945f);
        } else {
          _2151 = (((pow(_2059.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_2059.z <= 0.0031308000907301903f))) {
          _2162 = (_2059.z * 12.920000076293945f);
        } else {
          _2162 = (((pow(_2059.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _2164 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2140, _2151, _2162), 0.0f);
        _2178 = (lerp(_2059.x, _2164.x, fTextureBlendRate2));
        _2179 = (lerp(_2059.y, _2164.y, fTextureBlendRate2));
        _2180 = (lerp(_2059.z, _2164.z, fTextureBlendRate2));
      } else {
        _2178 = _2059.x;
        _2179 = _2059.y;
        _2180 = _2059.z;
      }
    }
    float _2184 = mad(_2180, (fColorMatrix[2].x), mad(_2179, (fColorMatrix[1].x), (_2178 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
    float _2188 = mad(_2180, (fColorMatrix[2].y), mad(_2179, (fColorMatrix[1].y), (_2178 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
    float _2192 = mad(_2180, (fColorMatrix[2].z), mad(_2179, (fColorMatrix[1].z), (_2178 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
    if (_2007) {
      _2198 = (_2184 * _2006);
      _2199 = (_2188 * _2006);
      _2200 = (_2192 * _2006);
    } else {
      _2198 = _2184;
      _2199 = _2188;
      _2200 = _2192;
    }
  } else {
    _2198 = _1979;
    _2199 = _1980;
    _2200 = _1981;
  }
  if (!(((uint)(cPassEnabled) & 8) == 0)) {
    _2235 = saturate(((cvdR.x * _2198) + (cvdR.y * _2199)) + (cvdR.z * _2200));
    _2236 = saturate(((cvdG.x * _2198) + (cvdG.y * _2199)) + (cvdG.z * _2200));
    _2237 = saturate(((cvdB.x * _2198) + (cvdB.y * _2199)) + (cvdB.z * _2200));
  } else {
    _2235 = _2198;
    _2236 = _2199;
    _2237 = _2200;
  }
  if (!(((uint)(cPassEnabled) & 16) == 0)) {
    float _2252 = screenInverseSize.x * SV_Position.x;
    float _2253 = screenInverseSize.y * SV_Position.y;
    float4 _2256 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2252, _2253), 0.0f);
    float _2261 = _2256.x * ColorParam.x;
    float _2262 = _2256.y * ColorParam.y;
    float _2263 = _2256.z * ColorParam.z;
    float _2266 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2252, _2253), 0.0f);
    float _2271 = (_2256.w * ColorParam.w) * saturate((_2266.x * Levels_Rate) + Levels_Range);
    if (_2261 < 0.5f) {
      _2283 = ((_2235 * 2.0f) * _2261);
    } else {
      _2283 = (1.0f - (((1.0f - _2235) * 2.0f) * (1.0f - _2261)));
    }
    if (_2262 < 0.5f) {
      _2295 = ((_2236 * 2.0f) * _2262);
    } else {
      _2295 = (1.0f - (((1.0f - _2236) * 2.0f) * (1.0f - _2262)));
    }
    if (_2263 < 0.5f) {
      _2307 = ((_2237 * 2.0f) * _2263);
    } else {
      _2307 = (1.0f - (((1.0f - _2237) * 2.0f) * (1.0f - _2263)));
    }
    _2318 = (lerp(_2235, _2283, _2271));
    _2319 = (lerp(_2236, _2295, _2271));
    _2320 = (lerp(_2237, _2307, _2271));
  } else {
    _2318 = _2235;
    _2319 = _2236;
    _2320 = _2237;
  }
  SV_Target.x = _2318;
  SV_Target.y = _2319;
  SV_Target.z = _2320;

  SV_Target.rgb = Tonemap(untonemapped, renodx::tonemap::renodrt::NeutralSDR(SV_Target.rgb));

  SV_Target.w = 0.0f;
  return SV_Target;
}
