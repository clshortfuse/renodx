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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
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
  bool _35 = ((cPassEnabled & 1) == 0);
  bool _41;
  bool _47;
  float _96;
  float _242;
  float _243;
  float _264;
  float _386;
  float _387;
  float _395;
  float _396;
  float _724;
  float _725;
  float _746;
  float _868;
  float _869;
  float _877;
  float _878;
  float _1009;
  float _1010;
  float _1033;
  float _1155;
  float _1156;
  float _1162;
  float _1163;
  float _1173;
  float _1174;
  float _1175;
  float _1180;
  float _1181;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1186;
  float _1187;
  float _1188;
  float _1258;
  float _1813;
  float _1814;
  float _1815;
  float _1849;
  float _1850;
  float _1851;
  float _1862;
  float _1863;
  float _1864;
  float _1903;
  float _1919;
  float _1935;
  float _1963;
  float _1964;
  float _1965;
  float _2023;
  float _2044;
  float _2064;
  float _2072;
  float _2073;
  float _2074;
  float _2284;
  float _2285;
  float _2286;
  float _2300;
  float _2301;
  float _2302;
  float _2337;
  float _2338;
  float _2339;
  float _2382;
  float _2394;
  float _2406;
  float _2417;
  float _2418;
  float _2419;
  if (!_35) {
    _41 = (distortionType == 0);
  } else {
    _41 = false;
  }
  if (!_35) {
    _47 = (distortionType == 1);
  } else {
    _47 = false;
  }
  bool _49 = ((cPassEnabled & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    float _57 = Kerare.x / Kerare.w;
    float _58 = Kerare.y / Kerare.w;
    float _59 = Kerare.z / Kerare.w;
    float _63 = abs(rsqrt(dot(float3(_57, _58, _59), float3(_57, _58, _59))) * _59);
    float _68 = _63 * _63;
    _96 = ((_68 * _68) * (1.0f - saturate((_63 * kerare_scale) + kerare_offset)));
  } else {
    float _79 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _81 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _83 = sqrt(dot(float2(_81, _79), float2(_81, _79)));
    float _91 = (_83 * _83) + 1.0f;
    _96 = ((1.0f / (_91 * _91)) * (1.0f - saturate(((1.0f / (_83 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _99 = saturate(_96 + kerare_brightness) * Exposure;
  if (_41) {
    float _116 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _117 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _118 = dot(float2(_116, _117), float2(_116, _117));
    float _120 = (_118 * fDistortionCoef) + 1.0f;
    float _121 = fCorrectCoef * _116;
    float _122 = _120 * _121;
    float _123 = fCorrectCoef * _117;
    float _124 = _120 * _123;
    float _125 = _122 + 0.5f;
    float _126 = _124 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_49) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _136 = HazeNoiseResult.Sample(BilinearWrap, float2(_125, _126));
            _395 = ((fHazeFilterScale * _136.x) + _125);
            _396 = ((fHazeFilterScale * _136.y) + _126);
          } else {
            bool _148 = ((fHazeFilterAttribute & 2) != 0);
            float _152 = tFilterTempMap1.Sample(BilinearWrap, float2(_125, _126));
            do {
              if (_148) {
                float _159 = ReadonlyDepth.SampleLevel(PointClamp, float2(_125, _126), 0.0f);
                float _167 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _125) + -1.0f;
                float _168 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _126);
                float _205 = 1.0f / (mad(_159.x, (viewProjInvMat[2].w), mad(_168, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _167))) + (viewProjInvMat[3].w));
                float _207 = _205 * (mad(_159.x, (viewProjInvMat[2].y), mad(_168, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _167))) + (viewProjInvMat[3].y));
                float _215 = (_205 * (mad(_159.x, (viewProjInvMat[2].x), mad(_168, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _167))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _216 = _207 - (transposeViewInvMat[1].w);
                float _217 = (_205 * (mad(_159.x, (viewProjInvMat[2].z), mad(_168, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _167))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _242 = saturate(max(((sqrt(((_216 * _216) + (_215 * _215)) + (_217 * _217)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_207 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _152.x);
                _243 = _159.x;
              } else {
                _242 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _152.x), _152.x);
                _243 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _257 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _264 = (1.0f - saturate(max((_257 * min(max((abs(_122) - fHazeFilterBorder), 0.0f), 1.0f)), (_257 * min(max((abs(_124) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _264 = 1.0f;
                }
                float _265 = _264 * _242;
                do {
                  if (!(_265 <= 9.999999747378752e-06f)) {
                    float _272 = -0.0f - _126;
                    float _295 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_272, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _125))) * fHazeFilterUVWOffset.w;
                    float _296 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_272, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _125))) * fHazeFilterUVWOffset.w;
                    float _297 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_272, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _125))) * fHazeFilterUVWOffset.w;
                    float _302 = tVolumeMap.Sample(BilinearWrap, float3((_295 + fHazeFilterUVWOffset.x), (_296 + fHazeFilterUVWOffset.y), (_297 + fHazeFilterUVWOffset.z)));
                    float _305 = _295 * 2.0f;
                    float _306 = _296 * 2.0f;
                    float _307 = _297 * 2.0f;
                    float _311 = tVolumeMap.Sample(BilinearWrap, float3((_305 + fHazeFilterUVWOffset.x), (_306 + fHazeFilterUVWOffset.y), (_307 + fHazeFilterUVWOffset.z)));
                    float _315 = _295 * 4.0f;
                    float _316 = _296 * 4.0f;
                    float _317 = _297 * 4.0f;
                    float _321 = tVolumeMap.Sample(BilinearWrap, float3((_315 + fHazeFilterUVWOffset.x), (_316 + fHazeFilterUVWOffset.y), (_317 + fHazeFilterUVWOffset.z)));
                    float _325 = _295 * 8.0f;
                    float _326 = _296 * 8.0f;
                    float _327 = _297 * 8.0f;
                    float _331 = tVolumeMap.Sample(BilinearWrap, float3((_325 + fHazeFilterUVWOffset.x), (_326 + fHazeFilterUVWOffset.y), (_327 + fHazeFilterUVWOffset.z)));
                    float _335 = fHazeFilterUVWOffset.x + 0.5f;
                    float _336 = fHazeFilterUVWOffset.y + 0.5f;
                    float _337 = fHazeFilterUVWOffset.z + 0.5f;
                    float _341 = tVolumeMap.Sample(BilinearWrap, float3((_295 + _335), (_296 + _336), (_297 + _337)));
                    float _347 = tVolumeMap.Sample(BilinearWrap, float3((_305 + _335), (_306 + _336), (_307 + _337)));
                    float _354 = tVolumeMap.Sample(BilinearWrap, float3((_315 + _335), (_316 + _336), (_317 + _337)));
                    float _361 = tVolumeMap.Sample(BilinearWrap, float3((_325 + _335), (_326 + _336), (_327 + _337)));
                    float _369 = ((((((_311.x * 0.25f) + (_302.x * 0.5f)) + (_321.x * 0.125f)) + (_331.x * 0.0625f)) * 2.0f) + -1.0f) * _265;
                    float _370 = ((((((_347.x * 0.25f) + (_341.x * 0.5f)) + (_354.x * 0.125f)) + (_361.x * 0.0625f)) * 2.0f) + -1.0f) * _265;
                    if (_148) {
                      float _379 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _369) + _125), ((fHazeFilterScale * _370) + _126)));
                      if (!((_379.x - _243) >= fHazeFilterDepthDiffBias)) {
                        _386 = _369;
                        _387 = _370;
                      } else {
                        _386 = 0.0f;
                        _387 = 0.0f;
                      }
                    } else {
                      _386 = _369;
                      _387 = _370;
                    }
                  } else {
                    _386 = 0.0f;
                    _387 = 0.0f;
                  }
                  _395 = ((fHazeFilterScale * _386) + _125);
                  _396 = ((fHazeFilterScale * _387) + _126);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _395 = _125;
          _396 = _126;
        }
        float4 _399 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_395, _396));
        _1180 = (_399.x * _99);
        _1181 = (_399.y * _99);
        _1182 = (_399.z * _99);
        _1183 = fDistortionCoef;
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = fCorrectCoef;
      } while (false);
    } else {
      float _422 = ((saturate((sqrt((_116 * _116) + (_117 * _117)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        float _434 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        float _435 = _422 * 2.0f;
        float _439 = (((_434 * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _444 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_439 * _121) + 0.5f), ((_439 * _123) + 0.5f)));
        float _450 = ((((_434 + 0.125f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _455 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_450 * _121) + 0.5f), ((_450 * _123) + 0.5f)));
        float _462 = ((((_434 + 0.25f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_462 * _121) + 0.5f), ((_462 * _123) + 0.5f)));
        float _476 = ((((_434 + 0.375f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _481 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_476 * _121) + 0.5f), ((_476 * _123) + 0.5f)));
        float _490 = ((((_434 + 0.5f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _495 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_490 * _121) + 0.5f), ((_490 * _123) + 0.5f)));
        float _501 = ((((_434 + 0.625f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _506 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_501 * _121) + 0.5f), ((_501 * _123) + 0.5f)));
        float _514 = ((((_434 + 0.75f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _519 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_514 * _121) + 0.5f), ((_514 * _123) + 0.5f)));
        float _534 = ((((_434 + 0.875f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _539 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_534 * _121) + 0.5f), ((_534 * _123) + 0.5f)));
        float _546 = ((((_434 + 1.0f) * _435) + _118) * fDistortionCoef) + 1.0f;
        float4 _551 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_546 * _121) + 0.5f), ((_546 * _123) + 0.5f)));
        float _554 = _99 * 0.3199999928474426f;
        _1180 = ((((_455.x + _444.x) + (_467.x * 0.75f)) + (_481.x * 0.375f)) * _554);
        _1181 = ((_99 * 0.3636363744735718f) * ((((_506.y + _481.y) * 0.625f) + _495.y) + ((_519.y + _467.y) * 0.25f)));
        _1182 = (((((_519.z * 0.75f) + (_506.z * 0.375f)) + _539.z) + _551.z) * _554);
        _1183 = fDistortionCoef;
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = fCorrectCoef;
      } else {
        float _560 = _422 + _118;
        float _562 = (_560 * fDistortionCoef) + 1.0f;
        float _569 = ((_560 + _422) * fDistortionCoef) + 1.0f;
        float4 _574 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_125, _126));
        float4 _577 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_562 * _121) + 0.5f), ((_562 * _123) + 0.5f)));
        float4 _580 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_569 * _121) + 0.5f), ((_569 * _123) + 0.5f)));
        _1180 = (_574.x * _99);
        _1181 = (_577.y * _99);
        _1182 = (_580.z * _99);
        _1183 = fDistortionCoef;
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = fCorrectCoef;
      }
    }
  } else {
    if (_47) {
      float _590 = screenInverseSize.x * 2.0f;
      float _592 = screenInverseSize.y * 2.0f;
      float _594 = (_590 * SV_Position.x) + -1.0f;
      float _598 = sqrt((_594 * _594) + 1.0f);
      float _599 = 1.0f / _598;
      float _607 = ((_598 * fOptimizedParam.z) * (_599 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      float _608 = _607 * _594;
      float _610 = (_607 * ((_592 * SV_Position.y) + -1.0f)) * (((_599 + -1.0f) * fOptimizedParam.y) + 1.0f);
      float _611 = _608 + 0.5f;
      float _612 = _610 + 0.5f;
      do {
        if (_49) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _620 = HazeNoiseResult.Sample(BilinearWrap, float2(_611, _612));
            _877 = ((fHazeFilterScale * _620.x) + _611);
            _878 = ((fHazeFilterScale * _620.y) + _612);
          } else {
            bool _632 = ((fHazeFilterAttribute & 2) != 0);
            float _636 = tFilterTempMap1.Sample(BilinearWrap, float2(_611, _612));
            do {
              if (_632) {
                float _643 = ReadonlyDepth.SampleLevel(PointClamp, float2(_611, _612), 0.0f);
                float _649 = ((_590 * screenSize.x) * _611) + -1.0f;
                float _650 = 1.0f - ((_592 * screenSize.y) * _612);
                float _687 = 1.0f / (mad(_643.x, (viewProjInvMat[2].w), mad(_650, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _649))) + (viewProjInvMat[3].w));
                float _689 = _687 * (mad(_643.x, (viewProjInvMat[2].y), mad(_650, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _649))) + (viewProjInvMat[3].y));
                float _697 = (_687 * (mad(_643.x, (viewProjInvMat[2].x), mad(_650, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _649))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _698 = _689 - (transposeViewInvMat[1].w);
                float _699 = (_687 * (mad(_643.x, (viewProjInvMat[2].z), mad(_650, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _649))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _724 = saturate(max(((sqrt(((_698 * _698) + (_697 * _697)) + (_699 * _699)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_689 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _636.x);
                _725 = _643.x;
              } else {
                _724 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _636.x), _636.x);
                _725 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _739 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _746 = (1.0f - saturate(max((_739 * min(max((abs(_608) - fHazeFilterBorder), 0.0f), 1.0f)), (_739 * min(max((abs(_610) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _746 = 1.0f;
                }
                float _747 = _746 * _724;
                do {
                  if (!(_747 <= 9.999999747378752e-06f)) {
                    float _754 = -0.0f - _612;
                    float _777 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_754, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _611))) * fHazeFilterUVWOffset.w;
                    float _778 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_754, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _611))) * fHazeFilterUVWOffset.w;
                    float _779 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_754, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _611))) * fHazeFilterUVWOffset.w;
                    float _784 = tVolumeMap.Sample(BilinearWrap, float3((_777 + fHazeFilterUVWOffset.x), (_778 + fHazeFilterUVWOffset.y), (_779 + fHazeFilterUVWOffset.z)));
                    float _787 = _777 * 2.0f;
                    float _788 = _778 * 2.0f;
                    float _789 = _779 * 2.0f;
                    float _793 = tVolumeMap.Sample(BilinearWrap, float3((_787 + fHazeFilterUVWOffset.x), (_788 + fHazeFilterUVWOffset.y), (_789 + fHazeFilterUVWOffset.z)));
                    float _797 = _777 * 4.0f;
                    float _798 = _778 * 4.0f;
                    float _799 = _779 * 4.0f;
                    float _803 = tVolumeMap.Sample(BilinearWrap, float3((_797 + fHazeFilterUVWOffset.x), (_798 + fHazeFilterUVWOffset.y), (_799 + fHazeFilterUVWOffset.z)));
                    float _807 = _777 * 8.0f;
                    float _808 = _778 * 8.0f;
                    float _809 = _779 * 8.0f;
                    float _813 = tVolumeMap.Sample(BilinearWrap, float3((_807 + fHazeFilterUVWOffset.x), (_808 + fHazeFilterUVWOffset.y), (_809 + fHazeFilterUVWOffset.z)));
                    float _817 = fHazeFilterUVWOffset.x + 0.5f;
                    float _818 = fHazeFilterUVWOffset.y + 0.5f;
                    float _819 = fHazeFilterUVWOffset.z + 0.5f;
                    float _823 = tVolumeMap.Sample(BilinearWrap, float3((_777 + _817), (_778 + _818), (_779 + _819)));
                    float _829 = tVolumeMap.Sample(BilinearWrap, float3((_787 + _817), (_788 + _818), (_789 + _819)));
                    float _836 = tVolumeMap.Sample(BilinearWrap, float3((_797 + _817), (_798 + _818), (_799 + _819)));
                    float _843 = tVolumeMap.Sample(BilinearWrap, float3((_807 + _817), (_808 + _818), (_809 + _819)));
                    float _851 = ((((((_793.x * 0.25f) + (_784.x * 0.5f)) + (_803.x * 0.125f)) + (_813.x * 0.0625f)) * 2.0f) + -1.0f) * _747;
                    float _852 = ((((((_829.x * 0.25f) + (_823.x * 0.5f)) + (_836.x * 0.125f)) + (_843.x * 0.0625f)) * 2.0f) + -1.0f) * _747;
                    if (_632) {
                      float _861 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _851) + _611), ((fHazeFilterScale * _852) + _612)));
                      if (!((_861.x - _725) >= fHazeFilterDepthDiffBias)) {
                        _868 = _851;
                        _869 = _852;
                      } else {
                        _868 = 0.0f;
                        _869 = 0.0f;
                      }
                    } else {
                      _868 = _851;
                      _869 = _852;
                    }
                  } else {
                    _868 = 0.0f;
                    _869 = 0.0f;
                  }
                  _877 = ((fHazeFilterScale * _868) + _611);
                  _878 = ((fHazeFilterScale * _869) + _612);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _877 = _611;
          _878 = _612;
        }
        float4 _881 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_877, _878));
        _1180 = (_881.x * _99);
        _1181 = (_881.y * _99);
        _1182 = (_881.z * _99);
        _1183 = 0.0f;
        _1184 = fOptimizedParam.x;
        _1185 = fOptimizedParam.y;
        _1186 = fOptimizedParam.z;
        _1187 = fOptimizedParam.w;
        _1188 = 1.0f;
      } while (false);
    } else {
      float _889 = screenInverseSize.x * SV_Position.x;
      float _890 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_49) {
          float4 _894 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_889, _890));
          _1173 = _894.x;
          _1174 = _894.y;
          _1175 = _894.z;
        } else {
          do {
            if (!(fHazeFilterReductionResolution == 0)) {
              float2 _905 = HazeNoiseResult.Sample(BilinearWrap, float2(_889, _890));
              _1162 = (fHazeFilterScale * _905.x);
              _1163 = (fHazeFilterScale * _905.y);
            } else {
              bool _915 = ((fHazeFilterAttribute & 2) != 0);
              float _919 = tFilterTempMap1.Sample(BilinearWrap, float2(_889, _890));
              do {
                if (_915) {
                  float _926 = ReadonlyDepth.SampleLevel(PointClamp, float2(_889, _890), 0.0f);
                  float _934 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _889) + -1.0f;
                  float _935 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _890);
                  float _972 = 1.0f / (mad(_926.x, (viewProjInvMat[2].w), mad(_935, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _934))) + (viewProjInvMat[3].w));
                  float _974 = _972 * (mad(_926.x, (viewProjInvMat[2].y), mad(_935, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _934))) + (viewProjInvMat[3].y));
                  float _982 = (_972 * (mad(_926.x, (viewProjInvMat[2].x), mad(_935, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _934))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                  float _983 = _974 - (transposeViewInvMat[1].w);
                  float _984 = (_972 * (mad(_926.x, (viewProjInvMat[2].z), mad(_935, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _934))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                  _1009 = saturate(max(((sqrt(((_983 * _983) + (_982 * _982)) + (_984 * _984)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_974 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _919.x);
                  _1010 = _926.x;
                } else {
                  _1009 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _919.x), _919.x);
                  _1010 = 0.0f;
                }
                do {
                  if (!((fHazeFilterAttribute & 4) == 0)) {
                    float _1026 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                    _1033 = (1.0f - saturate(max((_1026 * min(max((abs(_889 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_1026 * min(max((abs(_890 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                  } else {
                    _1033 = 1.0f;
                  }
                  float _1034 = _1033 * _1009;
                  do {
                    if (!(_1034 <= 9.999999747378752e-06f)) {
                      float _1041 = -0.0f - _890;
                      float _1064 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_1041, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _889))) * fHazeFilterUVWOffset.w;
                      float _1065 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_1041, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _889))) * fHazeFilterUVWOffset.w;
                      float _1066 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_1041, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _889))) * fHazeFilterUVWOffset.w;
                      float _1071 = tVolumeMap.Sample(BilinearWrap, float3((_1064 + fHazeFilterUVWOffset.x), (_1065 + fHazeFilterUVWOffset.y), (_1066 + fHazeFilterUVWOffset.z)));
                      float _1074 = _1064 * 2.0f;
                      float _1075 = _1065 * 2.0f;
                      float _1076 = _1066 * 2.0f;
                      float _1080 = tVolumeMap.Sample(BilinearWrap, float3((_1074 + fHazeFilterUVWOffset.x), (_1075 + fHazeFilterUVWOffset.y), (_1076 + fHazeFilterUVWOffset.z)));
                      float _1084 = _1064 * 4.0f;
                      float _1085 = _1065 * 4.0f;
                      float _1086 = _1066 * 4.0f;
                      float _1090 = tVolumeMap.Sample(BilinearWrap, float3((_1084 + fHazeFilterUVWOffset.x), (_1085 + fHazeFilterUVWOffset.y), (_1086 + fHazeFilterUVWOffset.z)));
                      float _1094 = _1064 * 8.0f;
                      float _1095 = _1065 * 8.0f;
                      float _1096 = _1066 * 8.0f;
                      float _1100 = tVolumeMap.Sample(BilinearWrap, float3((_1094 + fHazeFilterUVWOffset.x), (_1095 + fHazeFilterUVWOffset.y), (_1096 + fHazeFilterUVWOffset.z)));
                      float _1104 = fHazeFilterUVWOffset.x + 0.5f;
                      float _1105 = fHazeFilterUVWOffset.y + 0.5f;
                      float _1106 = fHazeFilterUVWOffset.z + 0.5f;
                      float _1110 = tVolumeMap.Sample(BilinearWrap, float3((_1064 + _1104), (_1065 + _1105), (_1066 + _1106)));
                      float _1116 = tVolumeMap.Sample(BilinearWrap, float3((_1074 + _1104), (_1075 + _1105), (_1076 + _1106)));
                      float _1123 = tVolumeMap.Sample(BilinearWrap, float3((_1084 + _1104), (_1085 + _1105), (_1086 + _1106)));
                      float _1130 = tVolumeMap.Sample(BilinearWrap, float3((_1094 + _1104), (_1095 + _1105), (_1096 + _1106)));
                      float _1138 = ((((((_1080.x * 0.25f) + (_1071.x * 0.5f)) + (_1090.x * 0.125f)) + (_1100.x * 0.0625f)) * 2.0f) + -1.0f) * _1034;
                      float _1139 = ((((((_1116.x * 0.25f) + (_1110.x * 0.5f)) + (_1123.x * 0.125f)) + (_1130.x * 0.0625f)) * 2.0f) + -1.0f) * _1034;
                      if (_915) {
                        float _1148 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1138) + _889), ((fHazeFilterScale * _1139) + _890)));
                        if (!((_1148.x - _1010) >= fHazeFilterDepthDiffBias)) {
                          _1155 = _1138;
                          _1156 = _1139;
                        } else {
                          _1155 = 0.0f;
                          _1156 = 0.0f;
                        }
                      } else {
                        _1155 = _1138;
                        _1156 = _1139;
                      }
                    } else {
                      _1155 = 0.0f;
                      _1156 = 0.0f;
                    }
                    _1162 = (fHazeFilterScale * _1155);
                    _1163 = (fHazeFilterScale * _1156);
                  } while (false);
                } while (false);
              } while (false);
            }
            float4 _1168 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1162 + _889), (_1163 + _890)));
            _1173 = _1168.x;
            _1174 = _1168.y;
            _1175 = _1168.z;
          } while (false);
        }
        _1180 = (_1173 * _99);
        _1181 = (_1174 * _99);
        _1182 = (_1175 * _99);
        _1183 = 0.0f;
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1211 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1215 = ComputeResultSRV[0].computeAlpha;
    float _1218 = ((1.0f - _1211) + (_1215 * _1211)) * cbRadialColor.w;
    if (!(_1218 == 0.0f)) {
      float _1221 = screenInverseSize.x * SV_Position.x;
      float _1222 = screenInverseSize.y * SV_Position.y;
      float _1224 = _1221 + (-0.5f - cbRadialScreenPos.x);
      float _1226 = _1222 + (-0.5f - cbRadialScreenPos.y);
      float _1229 = select((_1224 < 0.0f), (1.0f - _1221), _1221);
      float _1232 = select((_1226 < 0.0f), (1.0f - _1222), _1222);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1238 = rsqrt(dot(float2(_1224, _1226), float2(_1224, _1226))) * cbRadialSharpRange;
          uint _1245 = uint(abs(_1238 * _1226)) + uint(abs(_1238 * _1224));
          uint _1249 = ((_1245 ^ 61) ^ ((uint)(_1245) >> 16)) * 9;
          uint _1252 = (((uint)(_1249) >> 4) ^ _1249) * 668265261;
          _1258 = (float((uint)((int)(((uint)(_1252) >> 15) ^ _1252))) * 2.3283064365386963e-10f);
        } else {
          _1258 = 1.0f;
        }
        float _1262 = sqrt((_1224 * _1224) + (_1226 * _1226));
        float _1264 = 1.0f / max(1.0f, _1262);
        float _1265 = _1258 * _1229;
        float _1266 = cbRadialBlurPower * _1264;
        float _1267 = _1266 * -0.0011111111380159855f;
        float _1269 = _1258 * _1232;
        float _1273 = ((_1267 * _1265) + 1.0f) * _1224;
        float _1274 = ((_1267 * _1269) + 1.0f) * _1226;
        float _1276 = _1266 * -0.002222222276031971f;
        float _1281 = ((_1276 * _1265) + 1.0f) * _1224;
        float _1282 = ((_1276 * _1269) + 1.0f) * _1226;
        float _1283 = _1266 * -0.0033333334140479565f;
        float _1288 = ((_1283 * _1265) + 1.0f) * _1224;
        float _1289 = ((_1283 * _1269) + 1.0f) * _1226;
        float _1290 = _1266 * -0.004444444552063942f;
        float _1295 = ((_1290 * _1265) + 1.0f) * _1224;
        float _1296 = ((_1290 * _1269) + 1.0f) * _1226;
        float _1297 = _1266 * -0.0055555556900799274f;
        float _1302 = ((_1297 * _1265) + 1.0f) * _1224;
        float _1303 = ((_1297 * _1269) + 1.0f) * _1226;
        float _1304 = _1266 * -0.006666666828095913f;
        float _1309 = ((_1304 * _1265) + 1.0f) * _1224;
        float _1310 = ((_1304 * _1269) + 1.0f) * _1226;
        float _1311 = _1266 * -0.007777777966111898f;
        float _1316 = ((_1311 * _1265) + 1.0f) * _1224;
        float _1317 = ((_1311 * _1269) + 1.0f) * _1226;
        float _1318 = _1266 * -0.008888889104127884f;
        float _1323 = ((_1318 * _1265) + 1.0f) * _1224;
        float _1324 = ((_1318 * _1269) + 1.0f) * _1226;
        float _1327 = _1264 * ((cbRadialBlurPower * -0.009999999776482582f) * _1258);
        float _1332 = ((_1327 * _1229) + 1.0f) * _1224;
        float _1333 = ((_1327 * _1232) + 1.0f) * _1226;
        do {
          if (_41) {
            float _1335 = _1273 + cbRadialScreenPos.x;
            float _1336 = _1274 + cbRadialScreenPos.y;
            float _1340 = ((dot(float2(_1335, _1336), float2(_1335, _1336)) * _1183) + 1.0f) * _1188;
            float4 _1346 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1340 * _1335) + 0.5f), ((_1340 * _1336) + 0.5f)), 0.0f);
            float _1350 = _1281 + cbRadialScreenPos.x;
            float _1351 = _1282 + cbRadialScreenPos.y;
            float _1355 = ((dot(float2(_1350, _1351), float2(_1350, _1351)) * _1183) + 1.0f) * _1188;
            float4 _1360 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1355 * _1350) + 0.5f), ((_1355 * _1351) + 0.5f)), 0.0f);
            float _1367 = _1288 + cbRadialScreenPos.x;
            float _1368 = _1289 + cbRadialScreenPos.y;
            float _1372 = ((dot(float2(_1367, _1368), float2(_1367, _1368)) * _1183) + 1.0f) * _1188;
            float4 _1377 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1372 * _1367) + 0.5f), ((_1372 * _1368) + 0.5f)), 0.0f);
            float _1384 = _1295 + cbRadialScreenPos.x;
            float _1385 = _1296 + cbRadialScreenPos.y;
            float _1389 = ((dot(float2(_1384, _1385), float2(_1384, _1385)) * _1183) + 1.0f) * _1188;
            float4 _1394 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1389 * _1384) + 0.5f), ((_1389 * _1385) + 0.5f)), 0.0f);
            float _1401 = _1302 + cbRadialScreenPos.x;
            float _1402 = _1303 + cbRadialScreenPos.y;
            float _1406 = ((dot(float2(_1401, _1402), float2(_1401, _1402)) * _1183) + 1.0f) * _1188;
            float4 _1411 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1406 * _1401) + 0.5f), ((_1406 * _1402) + 0.5f)), 0.0f);
            float _1418 = _1309 + cbRadialScreenPos.x;
            float _1419 = _1310 + cbRadialScreenPos.y;
            float _1423 = ((dot(float2(_1418, _1419), float2(_1418, _1419)) * _1183) + 1.0f) * _1188;
            float4 _1428 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1423 * _1418) + 0.5f), ((_1423 * _1419) + 0.5f)), 0.0f);
            float _1435 = _1316 + cbRadialScreenPos.x;
            float _1436 = _1317 + cbRadialScreenPos.y;
            float _1440 = ((dot(float2(_1435, _1436), float2(_1435, _1436)) * _1183) + 1.0f) * _1188;
            float4 _1445 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1440 * _1435) + 0.5f), ((_1440 * _1436) + 0.5f)), 0.0f);
            float _1452 = _1323 + cbRadialScreenPos.x;
            float _1453 = _1324 + cbRadialScreenPos.y;
            float _1457 = ((dot(float2(_1452, _1453), float2(_1452, _1453)) * _1183) + 1.0f) * _1188;
            float4 _1462 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1457 * _1452) + 0.5f), ((_1457 * _1453) + 0.5f)), 0.0f);
            float _1469 = _1332 + cbRadialScreenPos.x;
            float _1470 = _1333 + cbRadialScreenPos.y;
            float _1474 = ((dot(float2(_1469, _1470), float2(_1469, _1470)) * _1183) + 1.0f) * _1188;
            float4 _1479 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1474 * _1469) + 0.5f), ((_1474 * _1470) + 0.5f)), 0.0f);
            _1813 = ((((((((_1360.x + _1346.x) + _1377.x) + _1394.x) + _1411.x) + _1428.x) + _1445.x) + _1462.x) + _1479.x);
            _1814 = ((((((((_1360.y + _1346.y) + _1377.y) + _1394.y) + _1411.y) + _1428.y) + _1445.y) + _1462.y) + _1479.y);
            _1815 = ((((((((_1360.z + _1346.z) + _1377.z) + _1394.z) + _1411.z) + _1428.z) + _1445.z) + _1462.z) + _1479.z);
          } else {
            float _1487 = cbRadialScreenPos.x + 0.5f;
            float _1488 = _1273 + _1487;
            float _1489 = cbRadialScreenPos.y + 0.5f;
            float _1490 = _1274 + _1489;
            float _1491 = _1281 + _1487;
            float _1492 = _1282 + _1489;
            float _1493 = _1288 + _1487;
            float _1494 = _1289 + _1489;
            float _1495 = _1295 + _1487;
            float _1496 = _1296 + _1489;
            float _1497 = _1302 + _1487;
            float _1498 = _1303 + _1489;
            float _1499 = _1309 + _1487;
            float _1500 = _1310 + _1489;
            float _1501 = _1316 + _1487;
            float _1502 = _1317 + _1489;
            float _1503 = _1323 + _1487;
            float _1504 = _1324 + _1489;
            float _1505 = _1332 + _1487;
            float _1506 = _1333 + _1489;
            if (_47) {
              float _1510 = (_1488 * 2.0f) + -1.0f;
              float _1514 = sqrt((_1510 * _1510) + 1.0f);
              float _1515 = 1.0f / _1514;
              float _1522 = _1187 * 0.5f;
              float _1523 = ((_1514 * _1186) * (_1515 + _1184)) * _1522;
              float4 _1530 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1523 * _1510) + 0.5f), (((_1523 * ((_1490 * 2.0f) + -1.0f)) * (((_1515 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1536 = (_1491 * 2.0f) + -1.0f;
              float _1540 = sqrt((_1536 * _1536) + 1.0f);
              float _1541 = 1.0f / _1540;
              float _1548 = ((_1540 * _1186) * (_1541 + _1184)) * _1522;
              float4 _1554 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1548 * _1536) + 0.5f), (((_1548 * ((_1492 * 2.0f) + -1.0f)) * (((_1541 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1563 = (_1493 * 2.0f) + -1.0f;
              float _1567 = sqrt((_1563 * _1563) + 1.0f);
              float _1568 = 1.0f / _1567;
              float _1575 = ((_1567 * _1186) * (_1568 + _1184)) * _1522;
              float4 _1581 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1575 * _1563) + 0.5f), (((_1575 * ((_1494 * 2.0f) + -1.0f)) * (((_1568 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1590 = (_1495 * 2.0f) + -1.0f;
              float _1594 = sqrt((_1590 * _1590) + 1.0f);
              float _1595 = 1.0f / _1594;
              float _1602 = ((_1594 * _1186) * (_1595 + _1184)) * _1522;
              float4 _1608 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1602 * _1590) + 0.5f), (((_1602 * ((_1496 * 2.0f) + -1.0f)) * (((_1595 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1617 = (_1497 * 2.0f) + -1.0f;
              float _1621 = sqrt((_1617 * _1617) + 1.0f);
              float _1622 = 1.0f / _1621;
              float _1629 = ((_1621 * _1186) * (_1622 + _1184)) * _1522;
              float4 _1635 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1629 * _1617) + 0.5f), (((_1629 * ((_1498 * 2.0f) + -1.0f)) * (((_1622 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1644 = (_1499 * 2.0f) + -1.0f;
              float _1648 = sqrt((_1644 * _1644) + 1.0f);
              float _1649 = 1.0f / _1648;
              float _1656 = ((_1648 * _1186) * (_1649 + _1184)) * _1522;
              float4 _1662 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1656 * _1644) + 0.5f), (((_1656 * ((_1500 * 2.0f) + -1.0f)) * (((_1649 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1671 = (_1501 * 2.0f) + -1.0f;
              float _1675 = sqrt((_1671 * _1671) + 1.0f);
              float _1676 = 1.0f / _1675;
              float _1683 = ((_1675 * _1186) * (_1676 + _1184)) * _1522;
              float4 _1689 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1683 * _1671) + 0.5f), (((_1683 * ((_1502 * 2.0f) + -1.0f)) * (((_1676 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1698 = (_1503 * 2.0f) + -1.0f;
              float _1702 = sqrt((_1698 * _1698) + 1.0f);
              float _1703 = 1.0f / _1702;
              float _1710 = ((_1702 * _1186) * (_1703 + _1184)) * _1522;
              float4 _1716 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1710 * _1698) + 0.5f), (((_1710 * ((_1504 * 2.0f) + -1.0f)) * (((_1703 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              float _1725 = (_1505 * 2.0f) + -1.0f;
              float _1729 = sqrt((_1725 * _1725) + 1.0f);
              float _1730 = 1.0f / _1729;
              float _1737 = ((_1729 * _1186) * (_1730 + _1184)) * _1522;
              float4 _1743 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1737 * _1725) + 0.5f), (((_1737 * ((_1506 * 2.0f) + -1.0f)) * (((_1730 + -1.0f) * _1185) + 1.0f)) + 0.5f)), 0.0f);
              _1813 = ((((((((_1554.x + _1530.x) + _1581.x) + _1608.x) + _1635.x) + _1662.x) + _1689.x) + _1716.x) + _1743.x);
              _1814 = ((((((((_1554.y + _1530.y) + _1581.y) + _1608.y) + _1635.y) + _1662.y) + _1689.y) + _1716.y) + _1743.y);
              _1815 = ((((((((_1554.z + _1530.z) + _1581.z) + _1608.z) + _1635.z) + _1662.z) + _1689.z) + _1716.z) + _1743.z);
            } else {
              float4 _1752 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1488, _1490), 0.0f);
              float4 _1756 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1491, _1492), 0.0f);
              float4 _1763 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1493, _1494), 0.0f);
              float4 _1770 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1495, _1496), 0.0f);
              float4 _1777 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1497, _1498), 0.0f);
              float4 _1784 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1499, _1500), 0.0f);
              float4 _1791 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1501, _1502), 0.0f);
              float4 _1798 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1503, _1504), 0.0f);
              float4 _1805 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1505, _1506), 0.0f);
              _1813 = ((((((((_1756.x + _1752.x) + _1763.x) + _1770.x) + _1777.x) + _1784.x) + _1791.x) + _1798.x) + _1805.x);
              _1814 = ((((((((_1756.y + _1752.y) + _1763.y) + _1770.y) + _1777.y) + _1784.y) + _1791.y) + _1798.y) + _1805.y);
              _1815 = ((((((((_1756.z + _1752.z) + _1763.z) + _1770.z) + _1777.z) + _1784.z) + _1791.z) + _1798.z) + _1805.z);
            }
          }
          float _1825 = (cbRadialColor.z * (_1182 + (_99 * _1815))) * 0.10000000149011612f;
          float _1826 = (cbRadialColor.y * (_1181 + (_99 * _1814))) * 0.10000000149011612f;
          float _1827 = (cbRadialColor.x * (_1180 + (_99 * _1813))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1832 = saturate((_1262 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1838 = (((_1832 * _1832) * cbRadialMaskRate.x) * (3.0f - (_1832 * 2.0f))) + cbRadialMaskRate.y;
              _1849 = ((_1838 * (_1827 - _1180)) + _1180);
              _1850 = ((_1838 * (_1826 - _1181)) + _1181);
              _1851 = ((_1838 * (_1825 - _1182)) + _1182);
            } else {
              _1849 = _1827;
              _1850 = _1826;
              _1851 = _1825;
            }
            _1862 = (lerp(_1180, _1849, _1218));
            _1863 = (lerp(_1181, _1850, _1218));
            _1864 = (lerp(_1182, _1851, _1218));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1862 = _1180;
      _1863 = _1181;
      _1864 = _1182;
    }
  } else {
    _1862 = _1180;
    _1863 = _1181;
    _1864 = _1182;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1881 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1883 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1889 = frac(frac((_1883 * 0.005837149918079376f) + (_1881 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1889 < fNoiseDensity) {
        int _1894 = (uint)(uint(_1883 * _1881)) ^ 12345391;
        uint _1895 = _1894 * 3635641;
        _1903 = (float((uint)((int)((((uint)(_1895) >> 26) | ((uint)(_1894 * 232681024))) ^ _1895))) * 2.3283064365386963e-10f);
      } else {
        _1903 = 0.0f;
      }
      float _1905 = frac(_1889 * 757.4846801757812f);
      do {
        if (_1905 < fNoiseDensity) {
          int _1909 = asint(_1905) ^ 12345391;
          uint _1910 = _1909 * 3635641;
          _1919 = ((float((uint)((int)((((uint)(_1910) >> 26) | ((uint)(_1909 * 232681024))) ^ _1910))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1919 = 0.0f;
        }
        float _1921 = frac(_1905 * 757.4846801757812f);
        do {
          if (_1921 < fNoiseDensity) {
            int _1925 = asint(_1921) ^ 12345391;
            uint _1926 = _1925 * 3635641;
            _1935 = ((float((uint)((int)((((uint)(_1926) >> 26) | ((uint)(_1925 * 232681024))) ^ _1926))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1935 = 0.0f;
          }
          float _1936 = _1903 * fNoisePower.x * CUSTOM_NOISE;
          float _1937 = _1935 * fNoisePower.y * CUSTOM_NOISE;
          float _1938 = _1919 * fNoisePower.y * CUSTOM_NOISE;
          float _1952 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1862), saturate(_1863), saturate(_1864)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1963 = ((_1952 * (mad(_1938, 1.4019999504089355f, _1936) - _1862)) + _1862);
          _1964 = ((_1952 * (mad(_1938, -0.7139999866485596f, mad(_1937, -0.3440000116825104f, _1936)) - _1863)) + _1863);
          _1965 = ((_1952 * (mad(_1937, 1.7719999551773071f, _1936) - _1864)) + _1864);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1963 = _1862;
    _1964 = _1863;
    _1965 = _1864;
  }
  float _1980 = mad(_1965, (fOCIOTransformMatrix[2].x), mad(_1964, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1963)));
  float _1983 = mad(_1965, (fOCIOTransformMatrix[2].y), mad(_1964, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1963)));
  float _1986 = mad(_1965, (fOCIOTransformMatrix[2].z), mad(_1964, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1963)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1992 = max(max(_1980, _1983), _1986);
    if (!(_1992 == 0.0f)) {
      float _1998 = abs(_1992);
      float _1999 = (_1992 - _1980) / _1998;
      float _2000 = (_1992 - _1983) / _1998;
      float _2001 = (_1992 - _1986) / _1998;
      do {
        if (!(!(_1999 >= cbControlRGCParam.CyanThreshold))) {
          float _2011 = _1999 - cbControlRGCParam.CyanThreshold;
          _2023 = ((_2011 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _2011) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _2023 = _1999;
        }
        do {
          if (!(!(_2000 >= cbControlRGCParam.MagentaThreshold))) {
            float _2032 = _2000 - cbControlRGCParam.MagentaThreshold;
            _2044 = ((_2032 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _2032) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _2044 = _2000;
          }
          do {
            if (!(!(_2001 >= cbControlRGCParam.YellowThreshold))) {
              float _2052 = _2001 - cbControlRGCParam.YellowThreshold;
              _2064 = ((_2052 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _2052) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _2064 = _2001;
            }
            _2072 = (_1992 - (_2023 * _1998));
            _2073 = (_1992 - (_2044 * _1998));
            _2074 = (_1992 - (_2064 * _1998));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2072 = _1980;
      _2073 = _1983;
      _2074 = _1986;
    }
  } else {
    _2072 = _1980;
    _2073 = _1983;
    _2074 = _1986;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        true,
        cPassEnabled,
        _2072,
        _2073,
        _2074,
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
        _2300,
        _2301,
        _2302);
  #else
  if (!((cPassEnabled & 4) == 0)) {
    float _2124 = (((log2(select((_2072 < 3.0517578125e-05f), ((_2072 * 0.5f) + 1.52587890625e-05f), _2072)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2125 = (((log2(select((_2073 < 3.0517578125e-05f), ((_2073 * 0.5f) + 1.52587890625e-05f), _2073)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2126 = (((log2(select((_2074 < 3.0517578125e-05f), ((_2074 * 0.5f) + 1.52587890625e-05f), _2074)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _2129 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2124, _2125, _2126), 0.0f);
    float _2142 = max(exp2((_2129.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2143 = max(exp2((_2129.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2144 = max(exp2((_2129.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _2146 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _2149 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2124, _2125, _2126), 0.0f);
        float _2171 = ((max(exp2((_2149.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2142) * fTextureBlendRate) + _2142;
        float _2172 = ((max(exp2((_2149.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2143) * fTextureBlendRate) + _2143;
        float _2173 = ((max(exp2((_2149.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2144) * fTextureBlendRate) + _2144;
        if (_2146) {
          float4 _2203 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2171 < 3.0517578125e-05f), ((_2171 * 0.5f) + 1.52587890625e-05f), _2171)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2172 < 3.0517578125e-05f), ((_2172 * 0.5f) + 1.52587890625e-05f), _2172)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2173 < 3.0517578125e-05f), ((_2173 * 0.5f) + 1.52587890625e-05f), _2173)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2284 = (((max(exp2((_2203.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2171) * fTextureBlendRate2) + _2171);
          _2285 = (((max(exp2((_2203.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2172) * fTextureBlendRate2) + _2172);
          _2286 = (((max(exp2((_2203.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2173) * fTextureBlendRate2) + _2173);
        } else {
          _2284 = _2171;
          _2285 = _2172;
          _2286 = _2173;
        }
      } else {
        if (_2146) {
          float4 _2258 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2142 < 3.0517578125e-05f), ((_2142 * 0.5f) + 1.52587890625e-05f), _2142)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2143 < 3.0517578125e-05f), ((_2143 * 0.5f) + 1.52587890625e-05f), _2143)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2144 < 3.0517578125e-05f), ((_2144 * 0.5f) + 1.52587890625e-05f), _2144)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2284 = (((max(exp2((_2258.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2142) * fTextureBlendRate2) + _2142);
          _2285 = (((max(exp2((_2258.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2143) * fTextureBlendRate2) + _2143);
          _2286 = (((max(exp2((_2258.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2144) * fTextureBlendRate2) + _2144);
        } else {
          _2284 = _2142;
          _2285 = _2143;
          _2286 = _2144;
        }
      }
      _2300 = (mad(_2286, (fColorMatrix[2].x), mad(_2285, (fColorMatrix[1].x), (_2284 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _2301 = (mad(_2286, (fColorMatrix[2].y), mad(_2285, (fColorMatrix[1].y), (_2284 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _2302 = (mad(_2286, (fColorMatrix[2].z), mad(_2285, (fColorMatrix[1].z), (_2284 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _2300 = _2072;
    _2301 = _2073;
    _2302 = _2074;
  }
  #endif
  float _2303 = min(_2300, 65000.0f);
  float _2304 = min(_2301, 65000.0f);
  float _2305 = min(_2302, 65000.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2337 = (((cvdR.x * _2303) + (cvdR.y * _2304)) + (cvdR.z * _2305));
    _2338 = (((cvdG.x * _2303) + (cvdG.y * _2304)) + (cvdG.z * _2305));
    _2339 = (((cvdB.x * _2303) + (cvdB.y * _2304)) + (cvdB.z * _2305));
  } else {
    _2337 = _2303;
    _2338 = _2304;
    _2339 = _2305;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2351 = screenInverseSize.x * SV_Position.x;
    float _2352 = screenInverseSize.y * SV_Position.y;
    float4 _2355 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2351, _2352), 0.0f);
    float _2360 = _2355.x * ColorParam.x;
    float _2361 = _2355.y * ColorParam.y;
    float _2362 = _2355.z * ColorParam.z;
    float _2365 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2351, _2352), 0.0f);
    float _2370 = (_2355.w * ColorParam.w) * saturate((_2365.x * Levels_Rate) + Levels_Range);
    do {
      if (_2360 < 0.5f) {
        _2382 = ((_2337 * 2.0f) * _2360);
      } else {
        _2382 = (1.0f - (((1.0f - _2337) * 2.0f) * (1.0f - _2360)));
      }
      do {
        if (_2361 < 0.5f) {
          _2394 = ((_2338 * 2.0f) * _2361);
        } else {
          _2394 = (1.0f - (((1.0f - _2338) * 2.0f) * (1.0f - _2361)));
        }
        do {
          if (_2362 < 0.5f) {
            _2406 = ((_2339 * 2.0f) * _2362);
          } else {
            _2406 = (1.0f - (((1.0f - _2339) * 2.0f) * (1.0f - _2362)));
          }
          _2417 = (lerp(_2337, _2382, _2370));
          _2418 = (lerp(_2338, _2394, _2370));
          _2419 = (lerp(_2339, _2406, _2370));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2417 = _2337;
    _2418 = _2338;
    _2419 = _2339;
  }
  SV_Target.x = _2417;
  SV_Target.y = _2418;
  SV_Target.z = _2419;
  SV_Target.w = 0.0f;
  return SV_Target;
}
