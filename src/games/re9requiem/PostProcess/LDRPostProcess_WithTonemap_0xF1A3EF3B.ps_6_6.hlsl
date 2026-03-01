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

cbuffer LDRPostProcessParam : register(b1) {
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

cbuffer CBControl : register(b2) {
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
  bool _29 = ((cPassEnabled & 1) == 0);
  bool _35;
  bool _41;
  float _186;
  float _187;
  float _208;
  float _330;
  float _331;
  float _339;
  float _340;
  float _660;
  float _661;
  float _682;
  float _804;
  float _805;
  float _813;
  float _814;
  float _942;
  float _943;
  float _966;
  float _1088;
  float _1089;
  float _1095;
  float _1096;
  float _1106;
  float _1107;
  float _1108;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1187;
  float _1742;
  float _1743;
  float _1744;
  float _1778;
  float _1779;
  float _1780;
  float _1791;
  float _1792;
  float _1793;
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
  float _2213;
  float _2214;
  float _2215;
  float _2229;
  float _2230;
  float _2231;
  float _2266;
  float _2267;
  float _2268;
  float _2311;
  float _2323;
  float _2335;
  float _2346;
  float _2347;
  float _2348;
  if (!_29) {
    _35 = (distortionType == 0);
  } else {
    _35 = false;
  }
  if (!_29) {
    _41 = (distortionType == 1);
  } else {
    _41 = false;
  }
  bool _43 = ((cPassEnabled & 64) != 0);
  if (_35) {
    float _60 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _61 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _62 = dot(float2(_60, _61), float2(_60, _61));
    float _64 = (_62 * fDistortionCoef) + 1.0f;
    float _65 = fCorrectCoef * _60;
    float _66 = _64 * _65;
    float _67 = fCorrectCoef * _61;
    float _68 = _64 * _67;
    float _69 = _66 + 0.5f;
    float _70 = _68 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_43) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _80 = HazeNoiseResult.Sample(BilinearWrap, float2(_69, _70));
            _339 = ((fHazeFilterScale * _80.x) + _69);
            _340 = ((fHazeFilterScale * _80.y) + _70);
          } else {
            bool _92 = ((fHazeFilterAttribute & 2) != 0);
            float _96 = tFilterTempMap1.Sample(BilinearWrap, float2(_69, _70));
            do {
              if (_92) {
                float _103 = ReadonlyDepth.SampleLevel(PointClamp, float2(_69, _70), 0.0f);
                float _111 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _69) + -1.0f;
                float _112 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _70);
                float _149 = 1.0f / (mad(_103.x, (viewProjInvMat[2].w), mad(_112, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _111))) + (viewProjInvMat[3].w));
                float _151 = _149 * (mad(_103.x, (viewProjInvMat[2].y), mad(_112, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _111))) + (viewProjInvMat[3].y));
                float _159 = (_149 * (mad(_103.x, (viewProjInvMat[2].x), mad(_112, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _111))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _160 = _151 - (transposeViewInvMat[1].w);
                float _161 = (_149 * (mad(_103.x, (viewProjInvMat[2].z), mad(_112, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _111))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _186 = saturate(max(((sqrt(((_160 * _160) + (_159 * _159)) + (_161 * _161)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_151 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _96.x);
                _187 = _103.x;
              } else {
                _186 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _96.x), _96.x);
                _187 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _201 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _208 = (1.0f - saturate(max((_201 * min(max((abs(_66) - fHazeFilterBorder), 0.0f), 1.0f)), (_201 * min(max((abs(_68) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _208 = 1.0f;
                }
                float _209 = _208 * _186;
                do {
                  if (!(_209 <= 9.999999747378752e-06f)) {
                    float _216 = -0.0f - _70;
                    float _239 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_216, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _69))) * fHazeFilterUVWOffset.w;
                    float _240 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_216, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _69))) * fHazeFilterUVWOffset.w;
                    float _241 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_216, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _69))) * fHazeFilterUVWOffset.w;
                    float _246 = tVolumeMap.Sample(BilinearWrap, float3((_239 + fHazeFilterUVWOffset.x), (_240 + fHazeFilterUVWOffset.y), (_241 + fHazeFilterUVWOffset.z)));
                    float _249 = _239 * 2.0f;
                    float _250 = _240 * 2.0f;
                    float _251 = _241 * 2.0f;
                    float _255 = tVolumeMap.Sample(BilinearWrap, float3((_249 + fHazeFilterUVWOffset.x), (_250 + fHazeFilterUVWOffset.y), (_251 + fHazeFilterUVWOffset.z)));
                    float _259 = _239 * 4.0f;
                    float _260 = _240 * 4.0f;
                    float _261 = _241 * 4.0f;
                    float _265 = tVolumeMap.Sample(BilinearWrap, float3((_259 + fHazeFilterUVWOffset.x), (_260 + fHazeFilterUVWOffset.y), (_261 + fHazeFilterUVWOffset.z)));
                    float _269 = _239 * 8.0f;
                    float _270 = _240 * 8.0f;
                    float _271 = _241 * 8.0f;
                    float _275 = tVolumeMap.Sample(BilinearWrap, float3((_269 + fHazeFilterUVWOffset.x), (_270 + fHazeFilterUVWOffset.y), (_271 + fHazeFilterUVWOffset.z)));
                    float _279 = fHazeFilterUVWOffset.x + 0.5f;
                    float _280 = fHazeFilterUVWOffset.y + 0.5f;
                    float _281 = fHazeFilterUVWOffset.z + 0.5f;
                    float _285 = tVolumeMap.Sample(BilinearWrap, float3((_239 + _279), (_240 + _280), (_241 + _281)));
                    float _291 = tVolumeMap.Sample(BilinearWrap, float3((_249 + _279), (_250 + _280), (_251 + _281)));
                    float _298 = tVolumeMap.Sample(BilinearWrap, float3((_259 + _279), (_260 + _280), (_261 + _281)));
                    float _305 = tVolumeMap.Sample(BilinearWrap, float3((_269 + _279), (_270 + _280), (_271 + _281)));
                    float _313 = ((((((_255.x * 0.25f) + (_246.x * 0.5f)) + (_265.x * 0.125f)) + (_275.x * 0.0625f)) * 2.0f) + -1.0f) * _209;
                    float _314 = ((((((_291.x * 0.25f) + (_285.x * 0.5f)) + (_298.x * 0.125f)) + (_305.x * 0.0625f)) * 2.0f) + -1.0f) * _209;
                    if (_92) {
                      float _323 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _313) + _69), ((fHazeFilterScale * _314) + _70)));
                      if (!((_323.x - _187) >= fHazeFilterDepthDiffBias)) {
                        _330 = _313;
                        _331 = _314;
                      } else {
                        _330 = 0.0f;
                        _331 = 0.0f;
                      }
                    } else {
                      _330 = _313;
                      _331 = _314;
                    }
                  } else {
                    _330 = 0.0f;
                    _331 = 0.0f;
                  }
                  _339 = ((fHazeFilterScale * _330) + _69);
                  _340 = ((fHazeFilterScale * _331) + _70);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _339 = _69;
          _340 = _70;
        }
        float4 _343 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_339, _340));
        _1106 = _343.x;
        _1107 = _343.y;
        _1108 = _343.z;
        _1109 = fDistortionCoef;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = fCorrectCoef;
      } while (false);
    } else {
      float _363 = ((saturate((sqrt((_60 * _60) + (_61 * _61)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        float _375 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        float _376 = _363 * 2.0f;
        float _380 = (((_375 * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _385 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_380 * _65) + 0.5f), ((_380 * _67) + 0.5f)));
        float _391 = ((((_375 + 0.125f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _396 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_391 * _65) + 0.5f), ((_391 * _67) + 0.5f)));
        float _403 = ((((_375 + 0.25f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _408 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_403 * _65) + 0.5f), ((_403 * _67) + 0.5f)));
        float _417 = ((((_375 + 0.375f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _422 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_417 * _65) + 0.5f), ((_417 * _67) + 0.5f)));
        float _431 = ((((_375 + 0.5f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _436 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_431 * _65) + 0.5f), ((_431 * _67) + 0.5f)));
        float _442 = ((((_375 + 0.625f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _447 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_442 * _65) + 0.5f), ((_442 * _67) + 0.5f)));
        float _455 = ((((_375 + 0.75f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _460 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_455 * _65) + 0.5f), ((_455 * _67) + 0.5f)));
        float _475 = ((((_375 + 0.875f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _480 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_475 * _65) + 0.5f), ((_475 * _67) + 0.5f)));
        float _487 = ((((_375 + 1.0f) * _376) + _62) * fDistortionCoef) + 1.0f;
        float4 _492 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_487 * _65) + 0.5f), ((_487 * _67) + 0.5f)));
        _1106 = ((((_396.x + _385.x) + (_408.x * 0.75f)) + (_422.x * 0.375f)) * 0.3199999928474426f);
        _1107 = (((((_447.y + _422.y) * 0.625f) + _436.y) + ((_460.y + _408.y) * 0.25f)) * 0.3636363744735718f);
        _1108 = (((((_460.z * 0.75f) + (_447.z * 0.375f)) + _480.z) + _492.z) * 0.3199999928474426f);
        _1109 = fDistortionCoef;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = fCorrectCoef;
      } else {
        float _499 = _363 + _62;
        float _501 = (_499 * fDistortionCoef) + 1.0f;
        float _508 = ((_499 + _363) * fDistortionCoef) + 1.0f;
        float4 _513 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_69, _70));
        float4 _515 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_501 * _65) + 0.5f), ((_501 * _67) + 0.5f)));
        float4 _517 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_508 * _65) + 0.5f), ((_508 * _67) + 0.5f)));
        _1106 = _513.x;
        _1107 = _515.y;
        _1108 = _517.z;
        _1109 = fDistortionCoef;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = fCorrectCoef;
      }
    }
  } else {
    if (_41) {
      float _526 = screenInverseSize.x * 2.0f;
      float _528 = screenInverseSize.y * 2.0f;
      float _530 = (_526 * SV_Position.x) + -1.0f;
      float _534 = sqrt((_530 * _530) + 1.0f);
      float _535 = 1.0f / _534;
      float _543 = ((_534 * fOptimizedParam.z) * (_535 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      float _544 = _543 * _530;
      float _546 = (_543 * ((_528 * SV_Position.y) + -1.0f)) * (((_535 + -1.0f) * fOptimizedParam.y) + 1.0f);
      float _547 = _544 + 0.5f;
      float _548 = _546 + 0.5f;
      do {
        if (_43) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _556 = HazeNoiseResult.Sample(BilinearWrap, float2(_547, _548));
            _813 = ((fHazeFilterScale * _556.x) + _547);
            _814 = ((fHazeFilterScale * _556.y) + _548);
          } else {
            bool _568 = ((fHazeFilterAttribute & 2) != 0);
            float _572 = tFilterTempMap1.Sample(BilinearWrap, float2(_547, _548));
            do {
              if (_568) {
                float _579 = ReadonlyDepth.SampleLevel(PointClamp, float2(_547, _548), 0.0f);
                float _585 = ((_526 * screenSize.x) * _547) + -1.0f;
                float _586 = 1.0f - ((_528 * screenSize.y) * _548);
                float _623 = 1.0f / (mad(_579.x, (viewProjInvMat[2].w), mad(_586, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _585))) + (viewProjInvMat[3].w));
                float _625 = _623 * (mad(_579.x, (viewProjInvMat[2].y), mad(_586, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _585))) + (viewProjInvMat[3].y));
                float _633 = (_623 * (mad(_579.x, (viewProjInvMat[2].x), mad(_586, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _585))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _634 = _625 - (transposeViewInvMat[1].w);
                float _635 = (_623 * (mad(_579.x, (viewProjInvMat[2].z), mad(_586, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _585))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _660 = saturate(max(((sqrt(((_634 * _634) + (_633 * _633)) + (_635 * _635)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_625 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _572.x);
                _661 = _579.x;
              } else {
                _660 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _572.x), _572.x);
                _661 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _675 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _682 = (1.0f - saturate(max((_675 * min(max((abs(_544) - fHazeFilterBorder), 0.0f), 1.0f)), (_675 * min(max((abs(_546) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _682 = 1.0f;
                }
                float _683 = _682 * _660;
                do {
                  if (!(_683 <= 9.999999747378752e-06f)) {
                    float _690 = -0.0f - _548;
                    float _713 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_690, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _547))) * fHazeFilterUVWOffset.w;
                    float _714 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_690, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _547))) * fHazeFilterUVWOffset.w;
                    float _715 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_690, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _547))) * fHazeFilterUVWOffset.w;
                    float _720 = tVolumeMap.Sample(BilinearWrap, float3((_713 + fHazeFilterUVWOffset.x), (_714 + fHazeFilterUVWOffset.y), (_715 + fHazeFilterUVWOffset.z)));
                    float _723 = _713 * 2.0f;
                    float _724 = _714 * 2.0f;
                    float _725 = _715 * 2.0f;
                    float _729 = tVolumeMap.Sample(BilinearWrap, float3((_723 + fHazeFilterUVWOffset.x), (_724 + fHazeFilterUVWOffset.y), (_725 + fHazeFilterUVWOffset.z)));
                    float _733 = _713 * 4.0f;
                    float _734 = _714 * 4.0f;
                    float _735 = _715 * 4.0f;
                    float _739 = tVolumeMap.Sample(BilinearWrap, float3((_733 + fHazeFilterUVWOffset.x), (_734 + fHazeFilterUVWOffset.y), (_735 + fHazeFilterUVWOffset.z)));
                    float _743 = _713 * 8.0f;
                    float _744 = _714 * 8.0f;
                    float _745 = _715 * 8.0f;
                    float _749 = tVolumeMap.Sample(BilinearWrap, float3((_743 + fHazeFilterUVWOffset.x), (_744 + fHazeFilterUVWOffset.y), (_745 + fHazeFilterUVWOffset.z)));
                    float _753 = fHazeFilterUVWOffset.x + 0.5f;
                    float _754 = fHazeFilterUVWOffset.y + 0.5f;
                    float _755 = fHazeFilterUVWOffset.z + 0.5f;
                    float _759 = tVolumeMap.Sample(BilinearWrap, float3((_713 + _753), (_714 + _754), (_715 + _755)));
                    float _765 = tVolumeMap.Sample(BilinearWrap, float3((_723 + _753), (_724 + _754), (_725 + _755)));
                    float _772 = tVolumeMap.Sample(BilinearWrap, float3((_733 + _753), (_734 + _754), (_735 + _755)));
                    float _779 = tVolumeMap.Sample(BilinearWrap, float3((_743 + _753), (_744 + _754), (_745 + _755)));
                    float _787 = ((((((_729.x * 0.25f) + (_720.x * 0.5f)) + (_739.x * 0.125f)) + (_749.x * 0.0625f)) * 2.0f) + -1.0f) * _683;
                    float _788 = ((((((_765.x * 0.25f) + (_759.x * 0.5f)) + (_772.x * 0.125f)) + (_779.x * 0.0625f)) * 2.0f) + -1.0f) * _683;
                    if (_568) {
                      float _797 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _787) + _547), ((fHazeFilterScale * _788) + _548)));
                      if (!((_797.x - _661) >= fHazeFilterDepthDiffBias)) {
                        _804 = _787;
                        _805 = _788;
                      } else {
                        _804 = 0.0f;
                        _805 = 0.0f;
                      }
                    } else {
                      _804 = _787;
                      _805 = _788;
                    }
                  } else {
                    _804 = 0.0f;
                    _805 = 0.0f;
                  }
                  _813 = ((fHazeFilterScale * _804) + _547);
                  _814 = ((fHazeFilterScale * _805) + _548);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _813 = _547;
          _814 = _548;
        }
        float4 _817 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_813, _814));
        _1106 = _817.x;
        _1107 = _817.y;
        _1108 = _817.z;
        _1109 = 0.0f;
        _1110 = fOptimizedParam.x;
        _1111 = fOptimizedParam.y;
        _1112 = fOptimizedParam.z;
        _1113 = fOptimizedParam.w;
        _1114 = 1.0f;
      } while (false);
    } else {
      float _822 = screenInverseSize.x * SV_Position.x;
      float _823 = screenInverseSize.y * SV_Position.y;
      if (!_43) {
        float4 _827 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_822, _823));
        _1106 = _827.x;
        _1107 = _827.y;
        _1108 = _827.z;
        _1109 = 0.0f;
        _1110 = 0.0f;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 1.0f;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _838 = HazeNoiseResult.Sample(BilinearWrap, float2(_822, _823));
            _1095 = (fHazeFilterScale * _838.x);
            _1096 = (fHazeFilterScale * _838.y);
          } else {
            bool _848 = ((fHazeFilterAttribute & 2) != 0);
            float _852 = tFilterTempMap1.Sample(BilinearWrap, float2(_822, _823));
            do {
              if (_848) {
                float _859 = ReadonlyDepth.SampleLevel(PointClamp, float2(_822, _823), 0.0f);
                float _867 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _822) + -1.0f;
                float _868 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _823);
                float _905 = 1.0f / (mad(_859.x, (viewProjInvMat[2].w), mad(_868, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _867))) + (viewProjInvMat[3].w));
                float _907 = _905 * (mad(_859.x, (viewProjInvMat[2].y), mad(_868, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _867))) + (viewProjInvMat[3].y));
                float _915 = (_905 * (mad(_859.x, (viewProjInvMat[2].x), mad(_868, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _867))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _916 = _907 - (transposeViewInvMat[1].w);
                float _917 = (_905 * (mad(_859.x, (viewProjInvMat[2].z), mad(_868, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _867))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _942 = saturate(max(((sqrt(((_916 * _916) + (_915 * _915)) + (_917 * _917)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_907 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _852.x);
                _943 = _859.x;
              } else {
                _942 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _852.x), _852.x);
                _943 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _959 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _966 = (1.0f - saturate(max((_959 * min(max((abs(_822 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_959 * min(max((abs(_823 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _966 = 1.0f;
                }
                float _967 = _966 * _942;
                do {
                  if (!(_967 <= 9.999999747378752e-06f)) {
                    float _974 = -0.0f - _823;
                    float _997 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_974, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _822))) * fHazeFilterUVWOffset.w;
                    float _998 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_974, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _822))) * fHazeFilterUVWOffset.w;
                    float _999 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_974, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _822))) * fHazeFilterUVWOffset.w;
                    float _1004 = tVolumeMap.Sample(BilinearWrap, float3((_997 + fHazeFilterUVWOffset.x), (_998 + fHazeFilterUVWOffset.y), (_999 + fHazeFilterUVWOffset.z)));
                    float _1007 = _997 * 2.0f;
                    float _1008 = _998 * 2.0f;
                    float _1009 = _999 * 2.0f;
                    float _1013 = tVolumeMap.Sample(BilinearWrap, float3((_1007 + fHazeFilterUVWOffset.x), (_1008 + fHazeFilterUVWOffset.y), (_1009 + fHazeFilterUVWOffset.z)));
                    float _1017 = _997 * 4.0f;
                    float _1018 = _998 * 4.0f;
                    float _1019 = _999 * 4.0f;
                    float _1023 = tVolumeMap.Sample(BilinearWrap, float3((_1017 + fHazeFilterUVWOffset.x), (_1018 + fHazeFilterUVWOffset.y), (_1019 + fHazeFilterUVWOffset.z)));
                    float _1027 = _997 * 8.0f;
                    float _1028 = _998 * 8.0f;
                    float _1029 = _999 * 8.0f;
                    float _1033 = tVolumeMap.Sample(BilinearWrap, float3((_1027 + fHazeFilterUVWOffset.x), (_1028 + fHazeFilterUVWOffset.y), (_1029 + fHazeFilterUVWOffset.z)));
                    float _1037 = fHazeFilterUVWOffset.x + 0.5f;
                    float _1038 = fHazeFilterUVWOffset.y + 0.5f;
                    float _1039 = fHazeFilterUVWOffset.z + 0.5f;
                    float _1043 = tVolumeMap.Sample(BilinearWrap, float3((_997 + _1037), (_998 + _1038), (_999 + _1039)));
                    float _1049 = tVolumeMap.Sample(BilinearWrap, float3((_1007 + _1037), (_1008 + _1038), (_1009 + _1039)));
                    float _1056 = tVolumeMap.Sample(BilinearWrap, float3((_1017 + _1037), (_1018 + _1038), (_1019 + _1039)));
                    float _1063 = tVolumeMap.Sample(BilinearWrap, float3((_1027 + _1037), (_1028 + _1038), (_1029 + _1039)));
                    float _1071 = ((((((_1013.x * 0.25f) + (_1004.x * 0.5f)) + (_1023.x * 0.125f)) + (_1033.x * 0.0625f)) * 2.0f) + -1.0f) * _967;
                    float _1072 = ((((((_1049.x * 0.25f) + (_1043.x * 0.5f)) + (_1056.x * 0.125f)) + (_1063.x * 0.0625f)) * 2.0f) + -1.0f) * _967;
                    if (_848) {
                      float _1081 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1071) + _822), ((fHazeFilterScale * _1072) + _823)));
                      if (!((_1081.x - _943) >= fHazeFilterDepthDiffBias)) {
                        _1088 = _1071;
                        _1089 = _1072;
                      } else {
                        _1088 = 0.0f;
                        _1089 = 0.0f;
                      }
                    } else {
                      _1088 = _1071;
                      _1089 = _1072;
                    }
                  } else {
                    _1088 = 0.0f;
                    _1089 = 0.0f;
                  }
                  _1095 = (fHazeFilterScale * _1088);
                  _1096 = (fHazeFilterScale * _1089);
                } while (false);
              } while (false);
            } while (false);
          }
          float4 _1101 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1095 + _822), (_1096 + _823)));
          _1106 = _1101.x;
          _1107 = _1101.y;
          _1108 = _1101.z;
          _1109 = 0.0f;
          _1110 = 0.0f;
          _1111 = 0.0f;
          _1112 = 0.0f;
          _1113 = 0.0f;
          _1114 = 1.0f;
        } while (false);
      }
    }
  }
  float _1115 = Exposure * _1108;
  float _1116 = Exposure * _1107;
  float _1117 = Exposure * _1106;
  if (!((cPassEnabled & 32) == 0)) {
    float _1140 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1144 = ComputeResultSRV[0].computeAlpha;
    float _1147 = ((1.0f - _1140) + (_1144 * _1140)) * cbRadialColor.w;
    if (!(_1147 == 0.0f)) {
      float _1150 = screenInverseSize.x * SV_Position.x;
      float _1151 = screenInverseSize.y * SV_Position.y;
      float _1153 = _1150 + (-0.5f - cbRadialScreenPos.x);
      float _1155 = _1151 + (-0.5f - cbRadialScreenPos.y);
      float _1158 = select((_1153 < 0.0f), (1.0f - _1150), _1150);
      float _1161 = select((_1155 < 0.0f), (1.0f - _1151), _1151);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1167 = rsqrt(dot(float2(_1153, _1155), float2(_1153, _1155))) * cbRadialSharpRange;
          uint _1174 = uint(abs(_1167 * _1155)) + uint(abs(_1167 * _1153));
          uint _1178 = ((_1174 ^ 61) ^ ((uint)(_1174) >> 16)) * 9;
          uint _1181 = (((uint)(_1178) >> 4) ^ _1178) * 668265261;
          _1187 = (float((uint)((int)(((uint)(_1181) >> 15) ^ _1181))) * 2.3283064365386963e-10f);
        } else {
          _1187 = 1.0f;
        }
        float _1191 = sqrt((_1153 * _1153) + (_1155 * _1155));
        float _1193 = 1.0f / max(1.0f, _1191);
        float _1194 = _1187 * _1158;
        float _1195 = cbRadialBlurPower * _1193;
        float _1196 = _1195 * -0.0011111111380159855f;
        float _1198 = _1187 * _1161;
        float _1202 = ((_1196 * _1194) + 1.0f) * _1153;
        float _1203 = ((_1196 * _1198) + 1.0f) * _1155;
        float _1205 = _1195 * -0.002222222276031971f;
        float _1210 = ((_1205 * _1194) + 1.0f) * _1153;
        float _1211 = ((_1205 * _1198) + 1.0f) * _1155;
        float _1212 = _1195 * -0.0033333334140479565f;
        float _1217 = ((_1212 * _1194) + 1.0f) * _1153;
        float _1218 = ((_1212 * _1198) + 1.0f) * _1155;
        float _1219 = _1195 * -0.004444444552063942f;
        float _1224 = ((_1219 * _1194) + 1.0f) * _1153;
        float _1225 = ((_1219 * _1198) + 1.0f) * _1155;
        float _1226 = _1195 * -0.0055555556900799274f;
        float _1231 = ((_1226 * _1194) + 1.0f) * _1153;
        float _1232 = ((_1226 * _1198) + 1.0f) * _1155;
        float _1233 = _1195 * -0.006666666828095913f;
        float _1238 = ((_1233 * _1194) + 1.0f) * _1153;
        float _1239 = ((_1233 * _1198) + 1.0f) * _1155;
        float _1240 = _1195 * -0.007777777966111898f;
        float _1245 = ((_1240 * _1194) + 1.0f) * _1153;
        float _1246 = ((_1240 * _1198) + 1.0f) * _1155;
        float _1247 = _1195 * -0.008888889104127884f;
        float _1252 = ((_1247 * _1194) + 1.0f) * _1153;
        float _1253 = ((_1247 * _1198) + 1.0f) * _1155;
        float _1256 = _1193 * ((cbRadialBlurPower * -0.009999999776482582f) * _1187);
        float _1261 = ((_1256 * _1158) + 1.0f) * _1153;
        float _1262 = ((_1256 * _1161) + 1.0f) * _1155;
        do {
          if (_35) {
            float _1264 = _1202 + cbRadialScreenPos.x;
            float _1265 = _1203 + cbRadialScreenPos.y;
            float _1269 = ((dot(float2(_1264, _1265), float2(_1264, _1265)) * _1109) + 1.0f) * _1114;
            float4 _1275 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1269 * _1264) + 0.5f), ((_1269 * _1265) + 0.5f)), 0.0f);
            float _1279 = _1210 + cbRadialScreenPos.x;
            float _1280 = _1211 + cbRadialScreenPos.y;
            float _1284 = ((dot(float2(_1279, _1280), float2(_1279, _1280)) * _1109) + 1.0f) * _1114;
            float4 _1289 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1284 * _1279) + 0.5f), ((_1284 * _1280) + 0.5f)), 0.0f);
            float _1296 = _1217 + cbRadialScreenPos.x;
            float _1297 = _1218 + cbRadialScreenPos.y;
            float _1301 = ((dot(float2(_1296, _1297), float2(_1296, _1297)) * _1109) + 1.0f) * _1114;
            float4 _1306 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1301 * _1296) + 0.5f), ((_1301 * _1297) + 0.5f)), 0.0f);
            float _1313 = _1224 + cbRadialScreenPos.x;
            float _1314 = _1225 + cbRadialScreenPos.y;
            float _1318 = ((dot(float2(_1313, _1314), float2(_1313, _1314)) * _1109) + 1.0f) * _1114;
            float4 _1323 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1318 * _1313) + 0.5f), ((_1318 * _1314) + 0.5f)), 0.0f);
            float _1330 = _1231 + cbRadialScreenPos.x;
            float _1331 = _1232 + cbRadialScreenPos.y;
            float _1335 = ((dot(float2(_1330, _1331), float2(_1330, _1331)) * _1109) + 1.0f) * _1114;
            float4 _1340 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1335 * _1330) + 0.5f), ((_1335 * _1331) + 0.5f)), 0.0f);
            float _1347 = _1238 + cbRadialScreenPos.x;
            float _1348 = _1239 + cbRadialScreenPos.y;
            float _1352 = ((dot(float2(_1347, _1348), float2(_1347, _1348)) * _1109) + 1.0f) * _1114;
            float4 _1357 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1352 * _1347) + 0.5f), ((_1352 * _1348) + 0.5f)), 0.0f);
            float _1364 = _1245 + cbRadialScreenPos.x;
            float _1365 = _1246 + cbRadialScreenPos.y;
            float _1369 = ((dot(float2(_1364, _1365), float2(_1364, _1365)) * _1109) + 1.0f) * _1114;
            float4 _1374 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1369 * _1364) + 0.5f), ((_1369 * _1365) + 0.5f)), 0.0f);
            float _1381 = _1252 + cbRadialScreenPos.x;
            float _1382 = _1253 + cbRadialScreenPos.y;
            float _1386 = ((dot(float2(_1381, _1382), float2(_1381, _1382)) * _1109) + 1.0f) * _1114;
            float4 _1391 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1386 * _1381) + 0.5f), ((_1386 * _1382) + 0.5f)), 0.0f);
            float _1398 = _1261 + cbRadialScreenPos.x;
            float _1399 = _1262 + cbRadialScreenPos.y;
            float _1403 = ((dot(float2(_1398, _1399), float2(_1398, _1399)) * _1109) + 1.0f) * _1114;
            float4 _1408 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1403 * _1398) + 0.5f), ((_1403 * _1399) + 0.5f)), 0.0f);
            _1742 = ((((((((_1289.x + _1275.x) + _1306.x) + _1323.x) + _1340.x) + _1357.x) + _1374.x) + _1391.x) + _1408.x);
            _1743 = ((((((((_1289.y + _1275.y) + _1306.y) + _1323.y) + _1340.y) + _1357.y) + _1374.y) + _1391.y) + _1408.y);
            _1744 = ((((((((_1289.z + _1275.z) + _1306.z) + _1323.z) + _1340.z) + _1357.z) + _1374.z) + _1391.z) + _1408.z);
          } else {
            float _1416 = cbRadialScreenPos.x + 0.5f;
            float _1417 = _1202 + _1416;
            float _1418 = cbRadialScreenPos.y + 0.5f;
            float _1419 = _1203 + _1418;
            float _1420 = _1210 + _1416;
            float _1421 = _1211 + _1418;
            float _1422 = _1217 + _1416;
            float _1423 = _1218 + _1418;
            float _1424 = _1224 + _1416;
            float _1425 = _1225 + _1418;
            float _1426 = _1231 + _1416;
            float _1427 = _1232 + _1418;
            float _1428 = _1238 + _1416;
            float _1429 = _1239 + _1418;
            float _1430 = _1245 + _1416;
            float _1431 = _1246 + _1418;
            float _1432 = _1252 + _1416;
            float _1433 = _1253 + _1418;
            float _1434 = _1261 + _1416;
            float _1435 = _1262 + _1418;
            if (_41) {
              float _1439 = (_1417 * 2.0f) + -1.0f;
              float _1443 = sqrt((_1439 * _1439) + 1.0f);
              float _1444 = 1.0f / _1443;
              float _1451 = _1113 * 0.5f;
              float _1452 = ((_1443 * _1112) * (_1444 + _1110)) * _1451;
              float4 _1459 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1452 * _1439) + 0.5f), (((_1452 * ((_1419 * 2.0f) + -1.0f)) * (((_1444 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1465 = (_1420 * 2.0f) + -1.0f;
              float _1469 = sqrt((_1465 * _1465) + 1.0f);
              float _1470 = 1.0f / _1469;
              float _1477 = ((_1469 * _1112) * (_1470 + _1110)) * _1451;
              float4 _1483 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1477 * _1465) + 0.5f), (((_1477 * ((_1421 * 2.0f) + -1.0f)) * (((_1470 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1492 = (_1422 * 2.0f) + -1.0f;
              float _1496 = sqrt((_1492 * _1492) + 1.0f);
              float _1497 = 1.0f / _1496;
              float _1504 = ((_1496 * _1112) * (_1497 + _1110)) * _1451;
              float4 _1510 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1504 * _1492) + 0.5f), (((_1504 * ((_1423 * 2.0f) + -1.0f)) * (((_1497 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1519 = (_1424 * 2.0f) + -1.0f;
              float _1523 = sqrt((_1519 * _1519) + 1.0f);
              float _1524 = 1.0f / _1523;
              float _1531 = ((_1523 * _1112) * (_1524 + _1110)) * _1451;
              float4 _1537 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1531 * _1519) + 0.5f), (((_1531 * ((_1425 * 2.0f) + -1.0f)) * (((_1524 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1546 = (_1426 * 2.0f) + -1.0f;
              float _1550 = sqrt((_1546 * _1546) + 1.0f);
              float _1551 = 1.0f / _1550;
              float _1558 = ((_1550 * _1112) * (_1551 + _1110)) * _1451;
              float4 _1564 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1558 * _1546) + 0.5f), (((_1558 * ((_1427 * 2.0f) + -1.0f)) * (((_1551 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1573 = (_1428 * 2.0f) + -1.0f;
              float _1577 = sqrt((_1573 * _1573) + 1.0f);
              float _1578 = 1.0f / _1577;
              float _1585 = ((_1577 * _1112) * (_1578 + _1110)) * _1451;
              float4 _1591 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1585 * _1573) + 0.5f), (((_1585 * ((_1429 * 2.0f) + -1.0f)) * (((_1578 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1600 = (_1430 * 2.0f) + -1.0f;
              float _1604 = sqrt((_1600 * _1600) + 1.0f);
              float _1605 = 1.0f / _1604;
              float _1612 = ((_1604 * _1112) * (_1605 + _1110)) * _1451;
              float4 _1618 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1612 * _1600) + 0.5f), (((_1612 * ((_1431 * 2.0f) + -1.0f)) * (((_1605 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1627 = (_1432 * 2.0f) + -1.0f;
              float _1631 = sqrt((_1627 * _1627) + 1.0f);
              float _1632 = 1.0f / _1631;
              float _1639 = ((_1631 * _1112) * (_1632 + _1110)) * _1451;
              float4 _1645 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1639 * _1627) + 0.5f), (((_1639 * ((_1433 * 2.0f) + -1.0f)) * (((_1632 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              float _1654 = (_1434 * 2.0f) + -1.0f;
              float _1658 = sqrt((_1654 * _1654) + 1.0f);
              float _1659 = 1.0f / _1658;
              float _1666 = ((_1658 * _1112) * (_1659 + _1110)) * _1451;
              float4 _1672 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1666 * _1654) + 0.5f), (((_1666 * ((_1435 * 2.0f) + -1.0f)) * (((_1659 + -1.0f) * _1111) + 1.0f)) + 0.5f)), 0.0f);
              _1742 = ((((((((_1483.x + _1459.x) + _1510.x) + _1537.x) + _1564.x) + _1591.x) + _1618.x) + _1645.x) + _1672.x);
              _1743 = ((((((((_1483.y + _1459.y) + _1510.y) + _1537.y) + _1564.y) + _1591.y) + _1618.y) + _1645.y) + _1672.y);
              _1744 = ((((((((_1483.z + _1459.z) + _1510.z) + _1537.z) + _1564.z) + _1591.z) + _1618.z) + _1645.z) + _1672.z);
            } else {
              float4 _1681 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1417, _1419), 0.0f);
              float4 _1685 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1420, _1421), 0.0f);
              float4 _1692 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1422, _1423), 0.0f);
              float4 _1699 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1424, _1425), 0.0f);
              float4 _1706 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1426, _1427), 0.0f);
              float4 _1713 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1428, _1429), 0.0f);
              float4 _1720 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1430, _1431), 0.0f);
              float4 _1727 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1432, _1433), 0.0f);
              float4 _1734 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1434, _1435), 0.0f);
              _1742 = ((((((((_1685.x + _1681.x) + _1692.x) + _1699.x) + _1706.x) + _1713.x) + _1720.x) + _1727.x) + _1734.x);
              _1743 = ((((((((_1685.y + _1681.y) + _1692.y) + _1699.y) + _1706.y) + _1713.y) + _1720.y) + _1727.y) + _1734.y);
              _1744 = ((((((((_1685.z + _1681.z) + _1692.z) + _1699.z) + _1706.z) + _1713.z) + _1720.z) + _1727.z) + _1734.z);
            }
          }
          float _1754 = (cbRadialColor.z * (Exposure * (_1108 + _1744))) * 0.10000000149011612f;
          float _1755 = (cbRadialColor.y * (Exposure * (_1107 + _1743))) * 0.10000000149011612f;
          float _1756 = (cbRadialColor.x * (Exposure * (_1106 + _1742))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1761 = saturate((_1191 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1767 = (((_1761 * _1761) * cbRadialMaskRate.x) * (3.0f - (_1761 * 2.0f))) + cbRadialMaskRate.y;
              _1778 = ((_1767 * (_1756 - _1117)) + _1117);
              _1779 = ((_1767 * (_1755 - _1116)) + _1116);
              _1780 = ((_1767 * (_1754 - _1115)) + _1115);
            } else {
              _1778 = _1756;
              _1779 = _1755;
              _1780 = _1754;
            }
            _1791 = (lerp(_1117, _1778, _1147));
            _1792 = (lerp(_1116, _1779, _1147));
            _1793 = (lerp(_1115, _1780, _1147));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1791 = _1117;
      _1792 = _1116;
      _1793 = _1115;
    }
  } else {
    _1791 = _1117;
    _1792 = _1116;
    _1793 = _1115;
  }
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
          float _1865 = _1832 * fNoisePower.x * CUSTOM_NOISE;
          float _1866 = _1864 * fNoisePower.y * CUSTOM_NOISE;
          float _1867 = _1848 * fNoisePower.y * CUSTOM_NOISE;
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
  #if 1
    ApplyColorCorrectTexturePass(
        true,
        cPassEnabled,
        _2001,
        _2002,
        _2003,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _2229,
        _2230,
        _2231);
  #else
  if (!((cPassEnabled & 4) == 0)) {
    float _2053 = (((log2(select((_2001 < 3.0517578125e-05f), ((_2001 * 0.5f) + 1.52587890625e-05f), _2001)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2054 = (((log2(select((_2002 < 3.0517578125e-05f), ((_2002 * 0.5f) + 1.52587890625e-05f), _2002)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2055 = (((log2(select((_2003 < 3.0517578125e-05f), ((_2003 * 0.5f) + 1.52587890625e-05f), _2003)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _2058 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2053, _2054, _2055), 0.0f);
    float _2071 = max(exp2((_2058.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2072 = max(exp2((_2058.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2073 = max(exp2((_2058.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _2075 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _2078 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2053, _2054, _2055), 0.0f);
        float _2100 = ((max(exp2((_2078.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2071) * fTextureBlendRate) + _2071;
        float _2101 = ((max(exp2((_2078.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2072) * fTextureBlendRate) + _2072;
        float _2102 = ((max(exp2((_2078.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2073) * fTextureBlendRate) + _2073;
        if (_2075) {
          float4 _2132 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2100 < 3.0517578125e-05f), ((_2100 * 0.5f) + 1.52587890625e-05f), _2100)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2101 < 3.0517578125e-05f), ((_2101 * 0.5f) + 1.52587890625e-05f), _2101)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2102 < 3.0517578125e-05f), ((_2102 * 0.5f) + 1.52587890625e-05f), _2102)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2213 = (((max(exp2((_2132.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2100) * fTextureBlendRate2) + _2100);
          _2214 = (((max(exp2((_2132.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2101) * fTextureBlendRate2) + _2101);
          _2215 = (((max(exp2((_2132.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2102) * fTextureBlendRate2) + _2102);
        } else {
          _2213 = _2100;
          _2214 = _2101;
          _2215 = _2102;
        }
      } else {
        if (_2075) {
          float4 _2187 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2071 < 3.0517578125e-05f), ((_2071 * 0.5f) + 1.52587890625e-05f), _2071)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2072 < 3.0517578125e-05f), ((_2072 * 0.5f) + 1.52587890625e-05f), _2072)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2073 < 3.0517578125e-05f), ((_2073 * 0.5f) + 1.52587890625e-05f), _2073)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2213 = (((max(exp2((_2187.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2071) * fTextureBlendRate2) + _2071);
          _2214 = (((max(exp2((_2187.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2072) * fTextureBlendRate2) + _2072);
          _2215 = (((max(exp2((_2187.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2073) * fTextureBlendRate2) + _2073);
        } else {
          _2213 = _2071;
          _2214 = _2072;
          _2215 = _2073;
        }
      }
      _2229 = (mad(_2215, (fColorMatrix[2].x), mad(_2214, (fColorMatrix[1].x), (_2213 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _2230 = (mad(_2215, (fColorMatrix[2].y), mad(_2214, (fColorMatrix[1].y), (_2213 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _2231 = (mad(_2215, (fColorMatrix[2].z), mad(_2214, (fColorMatrix[1].z), (_2213 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _2229 = _2001;
    _2230 = _2002;
    _2231 = _2003;
  }
  #endif
  float _2232 = min(_2229, 65000.0f);
  float _2233 = min(_2230, 65000.0f);
  float _2234 = min(_2231, 65000.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2266 = (((cvdR.x * _2232) + (cvdR.y * _2233)) + (cvdR.z * _2234));
    _2267 = (((cvdG.x * _2232) + (cvdG.y * _2233)) + (cvdG.z * _2234));
    _2268 = (((cvdB.x * _2232) + (cvdB.y * _2233)) + (cvdB.z * _2234));
  } else {
    _2266 = _2232;
    _2267 = _2233;
    _2268 = _2234;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2280 = screenInverseSize.x * SV_Position.x;
    float _2281 = screenInverseSize.y * SV_Position.y;
    float4 _2284 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2280, _2281), 0.0f);
    float _2289 = _2284.x * ColorParam.x;
    float _2290 = _2284.y * ColorParam.y;
    float _2291 = _2284.z * ColorParam.z;
    float _2294 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2280, _2281), 0.0f);
    float _2299 = (_2284.w * ColorParam.w) * saturate((_2294.x * Levels_Rate) + Levels_Range);
    do {
      if (_2289 < 0.5f) {
        _2311 = ((_2266 * 2.0f) * _2289);
      } else {
        _2311 = (1.0f - (((1.0f - _2266) * 2.0f) * (1.0f - _2289)));
      }
      do {
        if (_2290 < 0.5f) {
          _2323 = ((_2267 * 2.0f) * _2290);
        } else {
          _2323 = (1.0f - (((1.0f - _2267) * 2.0f) * (1.0f - _2290)));
        }
        do {
          if (_2291 < 0.5f) {
            _2335 = ((_2268 * 2.0f) * _2291);
          } else {
            _2335 = (1.0f - (((1.0f - _2268) * 2.0f) * (1.0f - _2291)));
          }
          _2346 = (lerp(_2266, _2311, _2299));
          _2347 = (lerp(_2267, _2323, _2299));
          _2348 = (lerp(_2268, _2335, _2299));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2346 = _2266;
    _2347 = _2267;
    _2348 = _2268;
  }
  SV_Target.x = _2346;
  SV_Target.y = _2347;
  SV_Target.z = _2348;
  SV_Target.w = 0.0f;
  return SV_Target;
}
