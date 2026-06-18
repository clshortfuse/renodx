#include "../common.hlsli"

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
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  uint sceneInfoAdditionalFlags : packoffset(c039.x);
};

cbuffer RangeCompressInfo : register(b1) {
  float rangeCompress : packoffset(c000.x);
  float rangeDecompress : packoffset(c000.y);
  float prevRangeCompress : packoffset(c000.z);
  float prevRangeDecompress : packoffset(c000.w);
  float rangeCompressForResource : packoffset(c001.x);
  float rangeDecompressForResource : packoffset(c001.y);
  float rangeCompressForCommon : packoffset(c001.z);
  float rangeDecompressForCommon : packoffset(c001.w);
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


SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  bool _30 = ((cPassEnabled & 1) == 0);
  bool _36;
  bool _42;
  float _187;
  float _188;
  float _209;
  float _331;
  float _332;
  float _340;
  float _341;
  float _661;
  float _662;
  float _683;
  float _805;
  float _806;
  float _814;
  float _815;
  float _943;
  float _944;
  float _967;
  float _1089;
  float _1090;
  float _1096;
  float _1097;
  float _1107;
  float _1108;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1115;
  float _1185;
  float _1740;
  float _1741;
  float _1742;
  float _1773;
  float _1774;
  float _1775;
  float _1786;
  float _1787;
  float _1788;
  float _1832;
  float _1848;
  float _1864;
  float _1892;
  float _1893;
  float _1894;
  float _1952;
  float _1973;
  float _1993;
  float _2001;
  float _2002;
  float _2003;
  float _2038;
  float _2048;
  float _2058;
  float _2084;
  float _2098;
  float _2112;
  float _2126;
  float _2135;
  float _2144;
  float _2169;
  float _2183;
  float _2197;
  float _2221;
  float _2231;
  float _2241;
  float _2266;
  float _2280;
  float _2294;
  float _2319;
  float _2329;
  float _2339;
  float _2364;
  float _2378;
  float _2392;
  float _2406;
  float _2407;
  float _2408;
  float _2422;
  float _2423;
  float _2424;
  float _2456;
  float _2457;
  float _2458;
  float _2501;
  float _2513;
  float _2525;
  float _2536;
  float _2537;
  float _2538;
  if (!_30) {
    _36 = (distortionType == 0);
  } else {
    _36 = false;
  }
  if (!_30) {
    _42 = (distortionType == 1);
  } else {
    _42 = false;
  }
  bool _44 = ((cPassEnabled & 64) != 0);
  if (_36) {
    float _61 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _62 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _63 = dot(float2(_61, _62), float2(_61, _62));
    float _65 = (_63 * fDistortionCoef) + 1.0f;
    float _66 = fCorrectCoef * _61;
    float _67 = _65 * _66;
    float _68 = fCorrectCoef * _62;
    float _69 = _65 * _68;
    float _70 = _67 + 0.5f;
    float _71 = _69 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_44) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _81 = HazeNoiseResult.Sample(BilinearWrap, float2(_70, _71));
            _340 = ((fHazeFilterScale * _81.x) + _70);
            _341 = ((fHazeFilterScale * _81.y) + _71);
          } else {
            bool _93 = ((fHazeFilterAttribute & 2) != 0);
            float _97 = tFilterTempMap1.Sample(BilinearWrap, float2(_70, _71));
            do {
              if (_93) {
                float _104 = ReadonlyDepth.SampleLevel(PointClamp, float2(_70, _71), 0.0f);
                float _112 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _70) + -1.0f;
                float _113 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _71);
                float _150 = 1.0f / (mad(_104.x, (viewProjInvMat[2].w), mad(_113, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _112))) + (viewProjInvMat[3].w));
                float _152 = _150 * (mad(_104.x, (viewProjInvMat[2].y), mad(_113, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _112))) + (viewProjInvMat[3].y));
                float _160 = (_150 * (mad(_104.x, (viewProjInvMat[2].x), mad(_113, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _112))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _161 = _152 - (transposeViewInvMat[1].w);
                float _162 = (_150 * (mad(_104.x, (viewProjInvMat[2].z), mad(_113, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _112))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _187 = saturate(max(((sqrt(((_161 * _161) + (_160 * _160)) + (_162 * _162)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_152 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _97.x);
                _188 = _104.x;
              } else {
                _187 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _97.x), _97.x);
                _188 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _202 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _209 = (1.0f - saturate(max((_202 * min(max((abs(_67) - fHazeFilterBorder), 0.0f), 1.0f)), (_202 * min(max((abs(_69) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _209 = 1.0f;
                }
                float _210 = _209 * _187;
                do {
                  if (!(_210 <= 9.999999747378752e-06f)) {
                    float _217 = -0.0f - _71;
                    float _240 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_217, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _70))) * fHazeFilterUVWOffset.w;
                    float _241 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_217, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _70))) * fHazeFilterUVWOffset.w;
                    float _242 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_217, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _70))) * fHazeFilterUVWOffset.w;
                    float _247 = tVolumeMap.Sample(BilinearWrap, float3((_240 + fHazeFilterUVWOffset.x), (_241 + fHazeFilterUVWOffset.y), (_242 + fHazeFilterUVWOffset.z)));
                    float _250 = _240 * 2.0f;
                    float _251 = _241 * 2.0f;
                    float _252 = _242 * 2.0f;
                    float _256 = tVolumeMap.Sample(BilinearWrap, float3((_250 + fHazeFilterUVWOffset.x), (_251 + fHazeFilterUVWOffset.y), (_252 + fHazeFilterUVWOffset.z)));
                    float _260 = _240 * 4.0f;
                    float _261 = _241 * 4.0f;
                    float _262 = _242 * 4.0f;
                    float _266 = tVolumeMap.Sample(BilinearWrap, float3((_260 + fHazeFilterUVWOffset.x), (_261 + fHazeFilterUVWOffset.y), (_262 + fHazeFilterUVWOffset.z)));
                    float _270 = _240 * 8.0f;
                    float _271 = _241 * 8.0f;
                    float _272 = _242 * 8.0f;
                    float _276 = tVolumeMap.Sample(BilinearWrap, float3((_270 + fHazeFilterUVWOffset.x), (_271 + fHazeFilterUVWOffset.y), (_272 + fHazeFilterUVWOffset.z)));
                    float _280 = fHazeFilterUVWOffset.x + 0.5f;
                    float _281 = fHazeFilterUVWOffset.y + 0.5f;
                    float _282 = fHazeFilterUVWOffset.z + 0.5f;
                    float _286 = tVolumeMap.Sample(BilinearWrap, float3((_240 + _280), (_241 + _281), (_242 + _282)));
                    float _292 = tVolumeMap.Sample(BilinearWrap, float3((_250 + _280), (_251 + _281), (_252 + _282)));
                    float _299 = tVolumeMap.Sample(BilinearWrap, float3((_260 + _280), (_261 + _281), (_262 + _282)));
                    float _306 = tVolumeMap.Sample(BilinearWrap, float3((_270 + _280), (_271 + _281), (_272 + _282)));
                    float _314 = ((((((_256.x * 0.25f) + (_247.x * 0.5f)) + (_266.x * 0.125f)) + (_276.x * 0.0625f)) * 2.0f) + -1.0f) * _210;
                    float _315 = ((((((_292.x * 0.25f) + (_286.x * 0.5f)) + (_299.x * 0.125f)) + (_306.x * 0.0625f)) * 2.0f) + -1.0f) * _210;
                    if (_93) {
                      float _324 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _314) + _70), ((fHazeFilterScale * _315) + _71)));
                      if (!((_324.x - _188) >= fHazeFilterDepthDiffBias)) {
                        _331 = _314;
                        _332 = _315;
                      } else {
                        _331 = 0.0f;
                        _332 = 0.0f;
                      }
                    } else {
                      _331 = _314;
                      _332 = _315;
                    }
                  } else {
                    _331 = 0.0f;
                    _332 = 0.0f;
                  }
                  _340 = ((fHazeFilterScale * _331) + _70);
                  _341 = ((fHazeFilterScale * _332) + _71);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _340 = _70;
          _341 = _71;
        }
        float4 _344 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_340, _341));
        _1107 = fDistortionCoef;
        _1108 = fCorrectCoef;
        _1109 = 0.0f;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = _344.x;
        _1114 = _344.y;
        _1115 = _344.z;
      } while (false);
    } else {
      float _364 = ((saturate((sqrt((_61 * _61) + (_62 * _62)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      float _365 = _364 + _63;
      float _367 = (_365 * fDistortionCoef) + 1.0f;
      float _370 = ((_365 + _364) * fDistortionCoef) + 1.0f;
      if (!(aberrationBlurEnable == 0)) {
        float _382 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        float _383 = _364 * 2.0f;
        float _387 = (((_382 * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _392 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_387 * _66) + 0.5f), ((_387 * _68) + 0.5f)));
        float _398 = ((((_382 + 0.125f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _403 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_398 * _66) + 0.5f), ((_398 * _68) + 0.5f)));
        float _410 = ((((_382 + 0.25f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _415 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_410 * _66) + 0.5f), ((_410 * _68) + 0.5f)));
        float _424 = ((((_382 + 0.375f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _429 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _66) + 0.5f), ((_424 * _68) + 0.5f)));
        float _438 = ((((_382 + 0.5f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _443 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_438 * _66) + 0.5f), ((_438 * _68) + 0.5f)));
        float _449 = ((((_382 + 0.625f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _454 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_449 * _66) + 0.5f), ((_449 * _68) + 0.5f)));
        float _462 = ((((_382 + 0.75f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_462 * _66) + 0.5f), ((_462 * _68) + 0.5f)));
        float _482 = ((((_382 + 0.875f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _487 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_482 * _66) + 0.5f), ((_482 * _68) + 0.5f)));
        float _494 = ((((_382 + 1.0f) * _383) + _63) * fDistortionCoef) + 1.0f;
        float4 _499 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_494 * _66) + 0.5f), ((_494 * _68) + 0.5f)));
        _1107 = fDistortionCoef;
        _1108 = fCorrectCoef;
        _1109 = 0.0f;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = ((((_403.x + _392.x) + (_415.x * 0.75f)) + (_429.x * 0.375f)) * 0.3199999928474426f);
        _1114 = (((((_454.y + _429.y) * 0.625f) + _443.y) + ((_467.y + _415.y) * 0.25f)) * 0.3636363744735718f);
        _1115 = (((((_467.z * 0.75f) + (_454.z * 0.375f)) + _487.z) + _499.z) * 0.3199999928474426f);
      } else {
        float4 _514 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_70, _71));
        float4 _516 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_367 * _66) + 0.5f), ((_367 * _68) + 0.5f)));
        float4 _518 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_370 * _66) + 0.5f), ((_370 * _68) + 0.5f)));
        _1107 = fDistortionCoef;
        _1108 = fCorrectCoef;
        _1109 = 0.0f;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = _514.x;
        _1114 = _516.y;
        _1115 = _518.z;
      }
    }
  } else {
    if (_42) {
      float _527 = screenInverseSize.x * 2.0f;
      float _529 = screenInverseSize.y * 2.0f;
      float _531 = (_527 * SV_Position.x) + -1.0f;
      float _535 = sqrt((_531 * _531) + 1.0f);
      float _536 = 1.0f / _535;
      float _544 = ((_535 * fOptimizedParam.z) * (_536 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      float _545 = _544 * _531;
      float _547 = (_544 * ((_529 * SV_Position.y) + -1.0f)) * (((_536 + -1.0f) * fOptimizedParam.y) + 1.0f);
      float _548 = _545 + 0.5f;
      float _549 = _547 + 0.5f;
      do {
        if (_44) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _557 = HazeNoiseResult.Sample(BilinearWrap, float2(_548, _549));
            _814 = ((fHazeFilterScale * _557.x) + _548);
            _815 = ((fHazeFilterScale * _557.y) + _549);
          } else {
            bool _569 = ((fHazeFilterAttribute & 2) != 0);
            float _573 = tFilterTempMap1.Sample(BilinearWrap, float2(_548, _549));
            do {
              if (_569) {
                float _580 = ReadonlyDepth.SampleLevel(PointClamp, float2(_548, _549), 0.0f);
                float _586 = ((_527 * screenSize.x) * _548) + -1.0f;
                float _587 = 1.0f - ((_529 * screenSize.y) * _549);
                float _624 = 1.0f / (mad(_580.x, (viewProjInvMat[2].w), mad(_587, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _586))) + (viewProjInvMat[3].w));
                float _626 = _624 * (mad(_580.x, (viewProjInvMat[2].y), mad(_587, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _586))) + (viewProjInvMat[3].y));
                float _634 = (_624 * (mad(_580.x, (viewProjInvMat[2].x), mad(_587, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _586))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _635 = _626 - (transposeViewInvMat[1].w);
                float _636 = (_624 * (mad(_580.x, (viewProjInvMat[2].z), mad(_587, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _586))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _661 = saturate(max(((sqrt(((_635 * _635) + (_634 * _634)) + (_636 * _636)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_626 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _573.x);
                _662 = _580.x;
              } else {
                _661 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _573.x), _573.x);
                _662 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _676 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _683 = (1.0f - saturate(max((_676 * min(max((abs(_545) - fHazeFilterBorder), 0.0f), 1.0f)), (_676 * min(max((abs(_547) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _683 = 1.0f;
                }
                float _684 = _683 * _661;
                do {
                  if (!(_684 <= 9.999999747378752e-06f)) {
                    float _691 = -0.0f - _549;
                    float _714 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_691, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _548))) * fHazeFilterUVWOffset.w;
                    float _715 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_691, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _548))) * fHazeFilterUVWOffset.w;
                    float _716 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_691, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _548))) * fHazeFilterUVWOffset.w;
                    float _721 = tVolumeMap.Sample(BilinearWrap, float3((_714 + fHazeFilterUVWOffset.x), (_715 + fHazeFilterUVWOffset.y), (_716 + fHazeFilterUVWOffset.z)));
                    float _724 = _714 * 2.0f;
                    float _725 = _715 * 2.0f;
                    float _726 = _716 * 2.0f;
                    float _730 = tVolumeMap.Sample(BilinearWrap, float3((_724 + fHazeFilterUVWOffset.x), (_725 + fHazeFilterUVWOffset.y), (_726 + fHazeFilterUVWOffset.z)));
                    float _734 = _714 * 4.0f;
                    float _735 = _715 * 4.0f;
                    float _736 = _716 * 4.0f;
                    float _740 = tVolumeMap.Sample(BilinearWrap, float3((_734 + fHazeFilterUVWOffset.x), (_735 + fHazeFilterUVWOffset.y), (_736 + fHazeFilterUVWOffset.z)));
                    float _744 = _714 * 8.0f;
                    float _745 = _715 * 8.0f;
                    float _746 = _716 * 8.0f;
                    float _750 = tVolumeMap.Sample(BilinearWrap, float3((_744 + fHazeFilterUVWOffset.x), (_745 + fHazeFilterUVWOffset.y), (_746 + fHazeFilterUVWOffset.z)));
                    float _754 = fHazeFilterUVWOffset.x + 0.5f;
                    float _755 = fHazeFilterUVWOffset.y + 0.5f;
                    float _756 = fHazeFilterUVWOffset.z + 0.5f;
                    float _760 = tVolumeMap.Sample(BilinearWrap, float3((_714 + _754), (_715 + _755), (_716 + _756)));
                    float _766 = tVolumeMap.Sample(BilinearWrap, float3((_724 + _754), (_725 + _755), (_726 + _756)));
                    float _773 = tVolumeMap.Sample(BilinearWrap, float3((_734 + _754), (_735 + _755), (_736 + _756)));
                    float _780 = tVolumeMap.Sample(BilinearWrap, float3((_744 + _754), (_745 + _755), (_746 + _756)));
                    float _788 = ((((((_730.x * 0.25f) + (_721.x * 0.5f)) + (_740.x * 0.125f)) + (_750.x * 0.0625f)) * 2.0f) + -1.0f) * _684;
                    float _789 = ((((((_766.x * 0.25f) + (_760.x * 0.5f)) + (_773.x * 0.125f)) + (_780.x * 0.0625f)) * 2.0f) + -1.0f) * _684;
                    if (_569) {
                      float _798 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _788) + _548), ((fHazeFilterScale * _789) + _549)));
                      if (!((_798.x - _662) >= fHazeFilterDepthDiffBias)) {
                        _805 = _788;
                        _806 = _789;
                      } else {
                        _805 = 0.0f;
                        _806 = 0.0f;
                      }
                    } else {
                      _805 = _788;
                      _806 = _789;
                    }
                  } else {
                    _805 = 0.0f;
                    _806 = 0.0f;
                  }
                  _814 = ((fHazeFilterScale * _805) + _548);
                  _815 = ((fHazeFilterScale * _806) + _549);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _814 = _548;
          _815 = _549;
        }
        float4 _818 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_814, _815));
        _1107 = 0.0f;
        _1108 = 1.0f;
        _1109 = fOptimizedParam.x;
        _1110 = fOptimizedParam.y;
        _1111 = fOptimizedParam.z;
        _1112 = fOptimizedParam.w;
        _1113 = _818.x;
        _1114 = _818.y;
        _1115 = _818.z;
      } while (false);
    } else {
      float _823 = screenInverseSize.x * SV_Position.x;
      float _824 = screenInverseSize.y * SV_Position.y;
      if (!_44) {
        float4 _828 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_823, _824));
        _1107 = 0.0f;
        _1108 = 1.0f;
        _1109 = 0.0f;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = _828.x;
        _1114 = _828.y;
        _1115 = _828.z;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _839 = HazeNoiseResult.Sample(BilinearWrap, float2(_823, _824));
            _1096 = (fHazeFilterScale * _839.x);
            _1097 = (fHazeFilterScale * _839.y);
          } else {
            bool _849 = ((fHazeFilterAttribute & 2) != 0);
            float _853 = tFilterTempMap1.Sample(BilinearWrap, float2(_823, _824));
            do {
              if (_849) {
                float _860 = ReadonlyDepth.SampleLevel(PointClamp, float2(_823, _824), 0.0f);
                float _868 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _823) + -1.0f;
                float _869 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _824);
                float _906 = 1.0f / (mad(_860.x, (viewProjInvMat[2].w), mad(_869, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _868))) + (viewProjInvMat[3].w));
                float _908 = _906 * (mad(_860.x, (viewProjInvMat[2].y), mad(_869, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _868))) + (viewProjInvMat[3].y));
                float _916 = (_906 * (mad(_860.x, (viewProjInvMat[2].x), mad(_869, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _868))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _917 = _908 - (transposeViewInvMat[1].w);
                float _918 = (_906 * (mad(_860.x, (viewProjInvMat[2].z), mad(_869, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _868))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _943 = saturate(max(((sqrt(((_917 * _917) + (_916 * _916)) + (_918 * _918)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_908 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _853.x);
                _944 = _860.x;
              } else {
                _943 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _853.x), _853.x);
                _944 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _960 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _967 = (1.0f - saturate(max((_960 * min(max((abs(_823 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_960 * min(max((abs(_824 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _967 = 1.0f;
                }
                float _968 = _967 * _943;
                do {
                  if (!(_968 <= 9.999999747378752e-06f)) {
                    float _975 = -0.0f - _824;
                    float _998 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_975, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _823))) * fHazeFilterUVWOffset.w;
                    float _999 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_975, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _823))) * fHazeFilterUVWOffset.w;
                    float _1000 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_975, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _823))) * fHazeFilterUVWOffset.w;
                    float _1005 = tVolumeMap.Sample(BilinearWrap, float3((_998 + fHazeFilterUVWOffset.x), (_999 + fHazeFilterUVWOffset.y), (_1000 + fHazeFilterUVWOffset.z)));
                    float _1008 = _998 * 2.0f;
                    float _1009 = _999 * 2.0f;
                    float _1010 = _1000 * 2.0f;
                    float _1014 = tVolumeMap.Sample(BilinearWrap, float3((_1008 + fHazeFilterUVWOffset.x), (_1009 + fHazeFilterUVWOffset.y), (_1010 + fHazeFilterUVWOffset.z)));
                    float _1018 = _998 * 4.0f;
                    float _1019 = _999 * 4.0f;
                    float _1020 = _1000 * 4.0f;
                    float _1024 = tVolumeMap.Sample(BilinearWrap, float3((_1018 + fHazeFilterUVWOffset.x), (_1019 + fHazeFilterUVWOffset.y), (_1020 + fHazeFilterUVWOffset.z)));
                    float _1028 = _998 * 8.0f;
                    float _1029 = _999 * 8.0f;
                    float _1030 = _1000 * 8.0f;
                    float _1034 = tVolumeMap.Sample(BilinearWrap, float3((_1028 + fHazeFilterUVWOffset.x), (_1029 + fHazeFilterUVWOffset.y), (_1030 + fHazeFilterUVWOffset.z)));
                    float _1038 = fHazeFilterUVWOffset.x + 0.5f;
                    float _1039 = fHazeFilterUVWOffset.y + 0.5f;
                    float _1040 = fHazeFilterUVWOffset.z + 0.5f;
                    float _1044 = tVolumeMap.Sample(BilinearWrap, float3((_998 + _1038), (_999 + _1039), (_1000 + _1040)));
                    float _1050 = tVolumeMap.Sample(BilinearWrap, float3((_1008 + _1038), (_1009 + _1039), (_1010 + _1040)));
                    float _1057 = tVolumeMap.Sample(BilinearWrap, float3((_1018 + _1038), (_1019 + _1039), (_1020 + _1040)));
                    float _1064 = tVolumeMap.Sample(BilinearWrap, float3((_1028 + _1038), (_1029 + _1039), (_1030 + _1040)));
                    float _1072 = ((((((_1014.x * 0.25f) + (_1005.x * 0.5f)) + (_1024.x * 0.125f)) + (_1034.x * 0.0625f)) * 2.0f) + -1.0f) * _968;
                    float _1073 = ((((((_1050.x * 0.25f) + (_1044.x * 0.5f)) + (_1057.x * 0.125f)) + (_1064.x * 0.0625f)) * 2.0f) + -1.0f) * _968;
                    if (_849) {
                      float _1082 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1072) + _823), ((fHazeFilterScale * _1073) + _824)));
                      if (!((_1082.x - _944) >= fHazeFilterDepthDiffBias)) {
                        _1089 = _1072;
                        _1090 = _1073;
                      } else {
                        _1089 = 0.0f;
                        _1090 = 0.0f;
                      }
                    } else {
                      _1089 = _1072;
                      _1090 = _1073;
                    }
                  } else {
                    _1089 = 0.0f;
                    _1090 = 0.0f;
                  }
                  _1096 = (fHazeFilterScale * _1089);
                  _1097 = (fHazeFilterScale * _1090);
                } while (false);
              } while (false);
            } while (false);
          }
          float4 _1102 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1096 + _823), (_1097 + _824)));
          _1107 = 0.0f;
          _1108 = 1.0f;
          _1109 = 0.0f;
          _1110 = 0.0f;
          _1111 = 0.0f;
          _1112 = 0.0f;
          _1113 = _1102.x;
          _1114 = _1102.y;
          _1115 = _1102.z;
        } while (false);
      }
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1138 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1142 = ComputeResultSRV[0].computeAlpha;
    float _1145 = ((1.0f - _1138) + (_1142 * _1138)) * cbRadialColor.w;
    if (!(_1145 == 0.0f)) {
      float _1148 = screenInverseSize.x * SV_Position.x;
      float _1149 = screenInverseSize.y * SV_Position.y;
      float _1151 = _1148 + (-0.5f - cbRadialScreenPos.x);
      float _1153 = _1149 + (-0.5f - cbRadialScreenPos.y);
      float _1156 = select((_1151 < 0.0f), (1.0f - _1148), _1148);
      float _1159 = select((_1153 < 0.0f), (1.0f - _1149), _1149);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1165 = rsqrt(dot(float2(_1151, _1153), float2(_1151, _1153))) * cbRadialSharpRange;
          uint _1172 = uint(abs(_1165 * _1153)) + uint(abs(_1165 * _1151));
          uint _1176 = ((_1172 ^ 61) ^ ((uint)(_1172) >> 16)) * 9;
          uint _1179 = (((uint)(_1176) >> 4) ^ _1176) * 668265261;
          _1185 = (float((uint)((int)(((uint)(_1179) >> 15) ^ _1179))) * 2.3283064365386963e-10f);
        } else {
          _1185 = 1.0f;
        }
        float _1189 = sqrt((_1151 * _1151) + (_1153 * _1153));
        float _1191 = 1.0f / max(1.0f, _1189);
        float _1192 = _1185 * _1156;
        float _1193 = cbRadialBlurPower * _1191;
        float _1194 = _1193 * -0.0011111111380159855f;
        float _1196 = _1185 * _1159;
        float _1200 = ((_1194 * _1192) + 1.0f) * _1151;
        float _1201 = ((_1194 * _1196) + 1.0f) * _1153;
        float _1203 = _1193 * -0.002222222276031971f;
        float _1208 = ((_1203 * _1192) + 1.0f) * _1151;
        float _1209 = ((_1203 * _1196) + 1.0f) * _1153;
        float _1210 = _1193 * -0.0033333334140479565f;
        float _1215 = ((_1210 * _1192) + 1.0f) * _1151;
        float _1216 = ((_1210 * _1196) + 1.0f) * _1153;
        float _1217 = _1193 * -0.004444444552063942f;
        float _1222 = ((_1217 * _1192) + 1.0f) * _1151;
        float _1223 = ((_1217 * _1196) + 1.0f) * _1153;
        float _1224 = _1193 * -0.0055555556900799274f;
        float _1229 = ((_1224 * _1192) + 1.0f) * _1151;
        float _1230 = ((_1224 * _1196) + 1.0f) * _1153;
        float _1231 = _1193 * -0.006666666828095913f;
        float _1236 = ((_1231 * _1192) + 1.0f) * _1151;
        float _1237 = ((_1231 * _1196) + 1.0f) * _1153;
        float _1238 = _1193 * -0.007777777966111898f;
        float _1243 = ((_1238 * _1192) + 1.0f) * _1151;
        float _1244 = ((_1238 * _1196) + 1.0f) * _1153;
        float _1245 = _1193 * -0.008888889104127884f;
        float _1250 = ((_1245 * _1192) + 1.0f) * _1151;
        float _1251 = ((_1245 * _1196) + 1.0f) * _1153;
        float _1254 = _1191 * ((cbRadialBlurPower * -0.009999999776482582f) * _1185);
        float _1259 = ((_1254 * _1156) + 1.0f) * _1151;
        float _1260 = ((_1254 * _1159) + 1.0f) * _1153;
        do {
          if (_36) {
            float _1262 = _1200 + cbRadialScreenPos.x;
            float _1263 = _1201 + cbRadialScreenPos.y;
            float _1267 = ((dot(float2(_1262, _1263), float2(_1262, _1263)) * _1107) + 1.0f) * _1108;
            float4 _1273 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1267 * _1262) + 0.5f), ((_1267 * _1263) + 0.5f)), 0.0f);
            float _1277 = _1208 + cbRadialScreenPos.x;
            float _1278 = _1209 + cbRadialScreenPos.y;
            float _1282 = ((dot(float2(_1277, _1278), float2(_1277, _1278)) * _1107) + 1.0f) * _1108;
            float4 _1287 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1282 * _1277) + 0.5f), ((_1282 * _1278) + 0.5f)), 0.0f);
            float _1294 = _1215 + cbRadialScreenPos.x;
            float _1295 = _1216 + cbRadialScreenPos.y;
            float _1299 = ((dot(float2(_1294, _1295), float2(_1294, _1295)) * _1107) + 1.0f) * _1108;
            float4 _1304 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1299 * _1294) + 0.5f), ((_1299 * _1295) + 0.5f)), 0.0f);
            float _1311 = _1222 + cbRadialScreenPos.x;
            float _1312 = _1223 + cbRadialScreenPos.y;
            float _1316 = ((dot(float2(_1311, _1312), float2(_1311, _1312)) * _1107) + 1.0f) * _1108;
            float4 _1321 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1316 * _1311) + 0.5f), ((_1316 * _1312) + 0.5f)), 0.0f);
            float _1328 = _1229 + cbRadialScreenPos.x;
            float _1329 = _1230 + cbRadialScreenPos.y;
            float _1333 = ((dot(float2(_1328, _1329), float2(_1328, _1329)) * _1107) + 1.0f) * _1108;
            float4 _1338 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1333 * _1328) + 0.5f), ((_1333 * _1329) + 0.5f)), 0.0f);
            float _1345 = _1236 + cbRadialScreenPos.x;
            float _1346 = _1237 + cbRadialScreenPos.y;
            float _1350 = ((dot(float2(_1345, _1346), float2(_1345, _1346)) * _1107) + 1.0f) * _1108;
            float4 _1355 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1350 * _1345) + 0.5f), ((_1350 * _1346) + 0.5f)), 0.0f);
            float _1362 = _1243 + cbRadialScreenPos.x;
            float _1363 = _1244 + cbRadialScreenPos.y;
            float _1367 = ((dot(float2(_1362, _1363), float2(_1362, _1363)) * _1107) + 1.0f) * _1108;
            float4 _1372 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1367 * _1362) + 0.5f), ((_1367 * _1363) + 0.5f)), 0.0f);
            float _1379 = _1250 + cbRadialScreenPos.x;
            float _1380 = _1251 + cbRadialScreenPos.y;
            float _1384 = ((dot(float2(_1379, _1380), float2(_1379, _1380)) * _1107) + 1.0f) * _1108;
            float4 _1389 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1384 * _1379) + 0.5f), ((_1384 * _1380) + 0.5f)), 0.0f);
            float _1396 = _1259 + cbRadialScreenPos.x;
            float _1397 = _1260 + cbRadialScreenPos.y;
            float _1401 = ((dot(float2(_1396, _1397), float2(_1396, _1397)) * _1107) + 1.0f) * _1108;
            float4 _1406 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1401 * _1396) + 0.5f), ((_1401 * _1397) + 0.5f)), 0.0f);
            _1740 = ((((((((_1287.x + _1273.x) + _1304.x) + _1321.x) + _1338.x) + _1355.x) + _1372.x) + _1389.x) + _1406.x);
            _1741 = ((((((((_1287.y + _1273.y) + _1304.y) + _1321.y) + _1338.y) + _1355.y) + _1372.y) + _1389.y) + _1406.y);
            _1742 = ((((((((_1287.z + _1273.z) + _1304.z) + _1321.z) + _1338.z) + _1355.z) + _1372.z) + _1389.z) + _1406.z);
          } else {
            float _1414 = cbRadialScreenPos.x + 0.5f;
            float _1415 = _1200 + _1414;
            float _1416 = cbRadialScreenPos.y + 0.5f;
            float _1417 = _1201 + _1416;
            float _1418 = _1208 + _1414;
            float _1419 = _1209 + _1416;
            float _1420 = _1215 + _1414;
            float _1421 = _1216 + _1416;
            float _1422 = _1222 + _1414;
            float _1423 = _1223 + _1416;
            float _1424 = _1229 + _1414;
            float _1425 = _1230 + _1416;
            float _1426 = _1236 + _1414;
            float _1427 = _1237 + _1416;
            float _1428 = _1243 + _1414;
            float _1429 = _1244 + _1416;
            float _1430 = _1250 + _1414;
            float _1431 = _1251 + _1416;
            float _1432 = _1259 + _1414;
            float _1433 = _1260 + _1416;
            if (_42) {
              float _1437 = (_1415 * 2.0f) + -1.0f;
              float _1441 = sqrt((_1437 * _1437) + 1.0f);
              float _1442 = 1.0f / _1441;
              float _1449 = _1112 * 0.5f;
              float _1450 = ((_1441 * _1111) * (_1442 + _1109)) * _1449;
              float4 _1457 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1450 * _1437) + 0.5f), (((_1450 * ((_1417 * 2.0f) + -1.0f)) * (((_1442 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1463 = (_1418 * 2.0f) + -1.0f;
              float _1467 = sqrt((_1463 * _1463) + 1.0f);
              float _1468 = 1.0f / _1467;
              float _1475 = ((_1467 * _1111) * (_1468 + _1109)) * _1449;
              float4 _1481 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1475 * _1463) + 0.5f), (((_1475 * ((_1419 * 2.0f) + -1.0f)) * (((_1468 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1490 = (_1420 * 2.0f) + -1.0f;
              float _1494 = sqrt((_1490 * _1490) + 1.0f);
              float _1495 = 1.0f / _1494;
              float _1502 = ((_1494 * _1111) * (_1495 + _1109)) * _1449;
              float4 _1508 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1502 * _1490) + 0.5f), (((_1502 * ((_1421 * 2.0f) + -1.0f)) * (((_1495 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1517 = (_1422 * 2.0f) + -1.0f;
              float _1521 = sqrt((_1517 * _1517) + 1.0f);
              float _1522 = 1.0f / _1521;
              float _1529 = ((_1521 * _1111) * (_1522 + _1109)) * _1449;
              float4 _1535 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1529 * _1517) + 0.5f), (((_1529 * ((_1423 * 2.0f) + -1.0f)) * (((_1522 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1544 = (_1424 * 2.0f) + -1.0f;
              float _1548 = sqrt((_1544 * _1544) + 1.0f);
              float _1549 = 1.0f / _1548;
              float _1556 = ((_1548 * _1111) * (_1549 + _1109)) * _1449;
              float4 _1562 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1556 * _1544) + 0.5f), (((_1556 * ((_1425 * 2.0f) + -1.0f)) * (((_1549 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1571 = (_1426 * 2.0f) + -1.0f;
              float _1575 = sqrt((_1571 * _1571) + 1.0f);
              float _1576 = 1.0f / _1575;
              float _1583 = ((_1575 * _1111) * (_1576 + _1109)) * _1449;
              float4 _1589 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1583 * _1571) + 0.5f), (((_1583 * ((_1427 * 2.0f) + -1.0f)) * (((_1576 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1598 = (_1428 * 2.0f) + -1.0f;
              float _1602 = sqrt((_1598 * _1598) + 1.0f);
              float _1603 = 1.0f / _1602;
              float _1610 = ((_1602 * _1111) * (_1603 + _1109)) * _1449;
              float4 _1616 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1610 * _1598) + 0.5f), (((_1610 * ((_1429 * 2.0f) + -1.0f)) * (((_1603 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1625 = (_1430 * 2.0f) + -1.0f;
              float _1629 = sqrt((_1625 * _1625) + 1.0f);
              float _1630 = 1.0f / _1629;
              float _1637 = ((_1629 * _1111) * (_1630 + _1109)) * _1449;
              float4 _1643 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1637 * _1625) + 0.5f), (((_1637 * ((_1431 * 2.0f) + -1.0f)) * (((_1630 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              float _1652 = (_1432 * 2.0f) + -1.0f;
              float _1656 = sqrt((_1652 * _1652) + 1.0f);
              float _1657 = 1.0f / _1656;
              float _1664 = ((_1656 * _1111) * (_1657 + _1109)) * _1449;
              float4 _1670 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1664 * _1652) + 0.5f), (((_1664 * ((_1433 * 2.0f) + -1.0f)) * (((_1657 + -1.0f) * _1110) + 1.0f)) + 0.5f)), 0.0f);
              _1740 = ((((((((_1481.x + _1457.x) + _1508.x) + _1535.x) + _1562.x) + _1589.x) + _1616.x) + _1643.x) + _1670.x);
              _1741 = ((((((((_1481.y + _1457.y) + _1508.y) + _1535.y) + _1562.y) + _1589.y) + _1616.y) + _1643.y) + _1670.y);
              _1742 = ((((((((_1481.z + _1457.z) + _1508.z) + _1535.z) + _1562.z) + _1589.z) + _1616.z) + _1643.z) + _1670.z);
            } else {
              float4 _1679 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1415, _1417), 0.0f);
              float4 _1683 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1418, _1419), 0.0f);
              float4 _1690 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1420, _1421), 0.0f);
              float4 _1697 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1422, _1423), 0.0f);
              float4 _1704 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1424, _1425), 0.0f);
              float4 _1711 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1426, _1427), 0.0f);
              float4 _1718 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1428, _1429), 0.0f);
              float4 _1725 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1430, _1431), 0.0f);
              float4 _1732 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1432, _1433), 0.0f);
              _1740 = ((((((((_1683.x + _1679.x) + _1690.x) + _1697.x) + _1704.x) + _1711.x) + _1718.x) + _1725.x) + _1732.x);
              _1741 = ((((((((_1683.y + _1679.y) + _1690.y) + _1697.y) + _1704.y) + _1711.y) + _1718.y) + _1725.y) + _1732.y);
              _1742 = ((((((((_1683.z + _1679.z) + _1690.z) + _1697.z) + _1704.z) + _1711.z) + _1718.z) + _1725.z) + _1732.z);
            }
          }
          float _1749 = ((_1113 + _1740) * 0.10000000149011612f) * cbRadialColor.x;
          float _1750 = ((_1114 + _1741) * 0.10000000149011612f) * cbRadialColor.y;
          float _1751 = ((_1115 + _1742) * 0.10000000149011612f) * cbRadialColor.z;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1756 = saturate((_1189 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1762 = (((_1756 * _1756) * cbRadialMaskRate.x) * (3.0f - (_1756 * 2.0f))) + cbRadialMaskRate.y;
              _1773 = ((_1762 * (_1749 - _1113)) + _1113);
              _1774 = ((_1762 * (_1750 - _1114)) + _1114);
              _1775 = ((_1762 * (_1751 - _1115)) + _1115);
            } else {
              _1773 = _1749;
              _1774 = _1750;
              _1775 = _1751;
            }
            _1786 = (lerp(_1113, _1773, _1145));
            _1787 = (lerp(_1114, _1774, _1145));
            _1788 = (lerp(_1115, _1775, _1145));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1786 = _1113;
      _1787 = _1114;
      _1788 = _1115;
    }
  } else {
    _1786 = _1113;
    _1787 = _1114;
    _1788 = _1115;
  }
  float _1791 = rangeDecompress * _1786;
  float _1792 = rangeDecompress * _1787;
  float _1793 = rangeDecompress * _1788;
  if (!((cPassEnabled & 2) == 0)) {
    float _1810 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1812 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1818 = frac(frac((_1812 * 0.005837149918079376f) + (_1810 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1818 < fNoiseDensity) {
        int _1823 = (uint)(uint(_1812 * _1810)) ^ 12345391;
        uint _1824 = _1823 * 3635641;
        _1832 = (float((uint)((int)((((uint)(_1824) >> 26) | ((uint)(_1823 * 232681024))) ^ _1824))) * 2.3283064365386963e-10f);
      } else {
        _1832 = 0.0f;
      }
      float _1834 = frac(_1818 * 757.4846801757812f);
      do {
        if (_1834 < fNoiseDensity) {
          int _1838 = asint(_1834) ^ 12345391;
          uint _1839 = _1838 * 3635641;
          _1848 = ((float((uint)((int)((((uint)(_1839) >> 26) | ((uint)(_1838 * 232681024))) ^ _1839))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1848 = 0.0f;
        }
        float _1850 = frac(_1834 * 757.4846801757812f);
        do {
          if (_1850 < fNoiseDensity) {
            int _1854 = asint(_1850) ^ 12345391;
            uint _1855 = _1854 * 3635641;
            _1864 = ((float((uint)((int)((((uint)(_1855) >> 26) | ((uint)(_1854 * 232681024))) ^ _1855))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1864 = 0.0f;
          }
          float _1865 = _1832 * CUSTOM_NOISE * fNoisePower.x;
          float _1866 = _1864 * CUSTOM_NOISE * fNoisePower.y;
          float _1867 = _1848 * CUSTOM_NOISE * fNoisePower.y;
          float _1881 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1791), saturate(_1792), saturate(_1793)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1892 = ((_1881 * (mad(_1867, 1.4019999504089355f, _1865) - _1791)) + _1791);
          _1893 = ((_1881 * (mad(_1867, -0.7139999866485596f, mad(_1866, -0.3440000116825104f, _1865)) - _1792)) + _1792);
          _1894 = ((_1881 * (mad(_1866, 1.7719999551773071f, _1865) - _1793)) + _1793);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1892 = _1791;
    _1893 = _1792;
    _1894 = _1793;
  }
  float _1909 = mad(_1894, (fOCIOTransformMatrix[2].x), mad(_1893, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1892)));
  float _1912 = mad(_1894, (fOCIOTransformMatrix[2].y), mad(_1893, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1892)));
  float _1915 = mad(_1894, (fOCIOTransformMatrix[2].z), mad(_1893, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1892)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1921 = max(max(_1909, _1912), _1915);
    if (!(_1921 == 0.0f)) {
      float _1927 = abs(_1921);
      float _1928 = (_1921 - _1909) / _1927;
      float _1929 = (_1921 - _1912) / _1927;
      float _1930 = (_1921 - _1915) / _1927;
      do {
        if (!(!(_1928 >= cbControlRGCParam.CyanThreshold))) {
          float _1940 = _1928 - cbControlRGCParam.CyanThreshold;
          _1952 = ((_1940 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1940) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1952 = _1928;
        }
        do {
          if (!(!(_1929 >= cbControlRGCParam.MagentaThreshold))) {
            float _1961 = _1929 - cbControlRGCParam.MagentaThreshold;
            _1973 = ((_1961 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1961) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1973 = _1929;
          }
          do {
            if (!(!(_1930 >= cbControlRGCParam.YellowThreshold))) {
              float _1981 = _1930 - cbControlRGCParam.YellowThreshold;
              _1993 = ((_1981 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1981) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1993 = _1930;
            }
            _2001 = (_1921 - (_1952 * _1927));
            _2002 = (_1921 - (_1973 * _1927));
            _2003 = (_1921 - (_1993 * _1927));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2001 = _1909;
      _2002 = _1912;
      _2003 = _1915;
    }
  } else {
    _2001 = _1909;
    _2002 = _1912;
    _2003 = _1915;
  }
  if (!((cPassEnabled & 4) == 0)) {
    bool _2029 = !(_2001 <= 0.0078125f);
    do {
      if (!_2029) {
        _2038 = ((_2001 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2038 = ((log2(_2001) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _2039 = !(_2002 <= 0.0078125f);
      do {
        if (!_2039) {
          _2048 = ((_2002 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2048 = ((log2(_2002) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _2049 = !(_2003 <= 0.0078125f);
        do {
          if (!_2049) {
            _2058 = ((_2003 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2058 = ((log2(_2003) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _2067 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2038 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2048 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2058 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2067.x < 0.155251145362854f) {
              _2084 = ((_2067.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_2067.x >= 0.155251145362854f) && (bool)(_2067.x < 1.4679962396621704f)) {
                _2084 = exp2((_2067.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2084 = 65504.0f;
              }
            }
            do {
              if (_2067.y < 0.155251145362854f) {
                _2098 = ((_2067.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_2067.y >= 0.155251145362854f) && (bool)(_2067.y < 1.4679962396621704f)) {
                  _2098 = exp2((_2067.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2098 = 65504.0f;
                }
              }
              do {
                if (_2067.z < 0.155251145362854f) {
                  _2112 = ((_2067.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_2067.z >= 0.155251145362854f) && (bool)(_2067.z < 1.4679962396621704f)) {
                    _2112 = exp2((_2067.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2112 = 65504.0f;
                  }
                }
                float _2113 = max(_2084, 0.0f);
                float _2114 = max(_2098, 0.0f);
                float _2115 = max(_2112, 0.0f);
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!_2029) {
                        _2126 = ((_2001 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2126 = ((log2(_2001) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_2039) {
                          _2135 = ((_2002 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2135 = ((log2(_2002) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_2049) {
                            _2144 = ((_2003 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2144 = ((log2(_2003) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          float4 _2152 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2126 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2135 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2144 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2152.x < 0.155251145362854f) {
                              _2169 = ((_2152.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_2152.x >= 0.155251145362854f) && (bool)(_2152.x < 1.4679962396621704f)) {
                                _2169 = exp2((_2152.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2169 = 65504.0f;
                              }
                            }
                            do {
                              if (_2152.y < 0.155251145362854f) {
                                _2183 = ((_2152.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_2152.y >= 0.155251145362854f) && (bool)(_2152.y < 1.4679962396621704f)) {
                                  _2183 = exp2((_2152.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2183 = 65504.0f;
                                }
                              }
                              do {
                                if (_2152.z < 0.155251145362854f) {
                                  _2197 = ((_2152.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_2152.z >= 0.155251145362854f) && (bool)(_2152.z < 1.4679962396621704f)) {
                                    _2197 = exp2((_2152.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2197 = 65504.0f;
                                  }
                                }
                                float _2207 = ((max(_2169, 0.0f) - _2113) * fTextureBlendRate) + _2113;
                                float _2208 = ((max(_2183, 0.0f) - _2114) * fTextureBlendRate) + _2114;
                                float _2209 = ((max(_2197, 0.0f) - _2115) * fTextureBlendRate) + _2115;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2207 <= 0.0078125f))) {
                                      _2221 = ((_2207 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2221 = ((log2(_2207) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2208 <= 0.0078125f))) {
                                        _2231 = ((_2208 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2231 = ((log2(_2208) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2209 <= 0.0078125f))) {
                                          _2241 = ((_2209 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2241 = ((log2(_2209) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        float4 _2249 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2221 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2231 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2241 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2249.x < 0.155251145362854f) {
                                            _2266 = ((_2249.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((bool)(_2249.x >= 0.155251145362854f) && (bool)(_2249.x < 1.4679962396621704f)) {
                                              _2266 = exp2((_2249.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2266 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2249.y < 0.155251145362854f) {
                                              _2280 = ((_2249.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((bool)(_2249.y >= 0.155251145362854f) && (bool)(_2249.y < 1.4679962396621704f)) {
                                                _2280 = exp2((_2249.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2280 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2249.z < 0.155251145362854f) {
                                                _2294 = ((_2249.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((bool)(_2249.z >= 0.155251145362854f) && (bool)(_2249.z < 1.4679962396621704f)) {
                                                  _2294 = exp2((_2249.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2294 = 65504.0f;
                                                }
                                              }
                                              _2406 = (((max(_2266, 0.0f) - _2207) * fTextureBlendRate2) + _2207);
                                              _2407 = (((max(_2280, 0.0f) - _2208) * fTextureBlendRate2) + _2208);
                                              _2408 = (((max(_2294, 0.0f) - _2209) * fTextureBlendRate2) + _2209);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2406 = _2207;
                                  _2407 = _2208;
                                  _2408 = _2209;
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
                        if (!(!(_2113 <= 0.0078125f))) {
                          _2319 = ((_2113 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2319 = ((log2(_2113) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2114 <= 0.0078125f))) {
                            _2329 = ((_2114 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2329 = ((log2(_2114) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2115 <= 0.0078125f))) {
                              _2339 = ((_2115 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2339 = ((log2(_2115) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _2347 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2319 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2329 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2339 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2347.x < 0.155251145362854f) {
                                _2364 = ((_2347.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_2347.x >= 0.155251145362854f) && (bool)(_2347.x < 1.4679962396621704f)) {
                                  _2364 = exp2((_2347.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2364 = 65504.0f;
                                }
                              }
                              do {
                                if (_2347.y < 0.155251145362854f) {
                                  _2378 = ((_2347.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_2347.y >= 0.155251145362854f) && (bool)(_2347.y < 1.4679962396621704f)) {
                                    _2378 = exp2((_2347.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2378 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2347.z < 0.155251145362854f) {
                                    _2392 = ((_2347.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((bool)(_2347.z >= 0.155251145362854f) && (bool)(_2347.z < 1.4679962396621704f)) {
                                      _2392 = exp2((_2347.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2392 = 65504.0f;
                                    }
                                  }
                                  _2406 = (((max(_2364, 0.0f) - _2113) * fTextureBlendRate2) + _2113);
                                  _2407 = (((max(_2378, 0.0f) - _2114) * fTextureBlendRate2) + _2114);
                                  _2408 = (((max(_2392, 0.0f) - _2115) * fTextureBlendRate2) + _2115);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2406 = _2113;
                      _2407 = _2114;
                      _2408 = _2115;
                    }
                  }
                  _2422 = (mad(_2408, (fColorMatrix[2].x), mad(_2407, (fColorMatrix[1].x), (_2406 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2423 = (mad(_2408, (fColorMatrix[2].y), mad(_2407, (fColorMatrix[1].y), (_2406 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2424 = (mad(_2408, (fColorMatrix[2].z), mad(_2407, (fColorMatrix[1].z), (_2406 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2422 = _2001;
    _2423 = _2002;
    _2424 = _2003;
  }
  if (!((cPassEnabled & 8) == 0)) {
    _2456 = (((cvdR.x * _2422) + (cvdR.y * _2423)) + (cvdR.z * _2424));
    _2457 = (((cvdG.x * _2422) + (cvdG.y * _2423)) + (cvdG.z * _2424));
    _2458 = (((cvdB.x * _2422) + (cvdB.y * _2423)) + (cvdB.z * _2424));
  } else {
    _2456 = _2422;
    _2457 = _2423;
    _2458 = _2424;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2470 = screenInverseSize.x * SV_Position.x;
    float _2471 = screenInverseSize.y * SV_Position.y;
    float4 _2474 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2470, _2471), 0.0f);
    float _2479 = _2474.x * ColorParam.x;
    float _2480 = _2474.y * ColorParam.y;
    float _2481 = _2474.z * ColorParam.z;
    float _2484 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2470, _2471), 0.0f);
    float _2489 = (_2474.w * ColorParam.w) * saturate((_2484.x * Levels_Rate) + Levels_Range);
    do {
      if (_2479 < 0.5f) {
        _2501 = ((_2456 * 2.0f) * _2479);
      } else {
        _2501 = (1.0f - (((1.0f - _2456) * 2.0f) * (1.0f - _2479)));
      }
      do {
        if (_2480 < 0.5f) {
          _2513 = ((_2457 * 2.0f) * _2480);
        } else {
          _2513 = (1.0f - (((1.0f - _2457) * 2.0f) * (1.0f - _2480)));
        }
        do {
          if (_2481 < 0.5f) {
            _2525 = ((_2458 * 2.0f) * _2481);
          } else {
            _2525 = (1.0f - (((1.0f - _2458) * 2.0f) * (1.0f - _2481)));
          }
          _2536 = (lerp(_2456, _2501, _2489));
          _2537 = (lerp(_2457, _2513, _2489));
          _2538 = (lerp(_2458, _2525, _2489));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2536 = _2456;
    _2537 = _2457;
    _2538 = _2458;
  }
  SV_Target.x = _2536;
  SV_Target.y = _2537;
  SV_Target.z = _2538;
  SV_Target.w = 0.0f;
  return SV_Target;
}
