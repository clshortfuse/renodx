#include "./postprocess.hlsl"

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float2 SceneInfo_Reserve2 : packoffset(c038.z);
};

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b2) {
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

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

/*
This shader IS USED WITH LOCAL EXPOSURE STUFF IN CERTAIN SCENARIOS

REF pp mod findings:
Both disabled: flat exposure with no luminance shaders
Local exposure only: flat exposure with flat luminance shaders
Both enabled: local exposure with blurred luminance shaders
 */

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  bool _37 = ((cPassEnabled & 1) == 0);
  bool _43;
  bool _49;
  float _98;
  float _243;
  float _244;
  float _266;
  float _386;
  float _387;
  float _395;
  float _396;
  float _727;
  float _728;
  float _750;
  float _870;
  float _871;
  float _879;
  float _880;
  float _1011;
  float _1012;
  float _1036;
  float _1156;
  float _1157;
  float _1163;
  float _1164;
  float _1174;
  float _1175;
  float _1176;
  float _1181;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  float _1264;
  float _1867;
  float _1868;
  float _1869;
  float _1907;
  float _1908;
  float _1909;
  float _1920;
  float _1921;
  float _1922;
  float _1980;
  float _2001;
  float _2021;
  float _2029;
  float _2030;
  float _2031;
  float _2068;
  float _2084;
  float _2100;
  float _2128;
  float _2129;
  float _2130;
  float _2165;
  float _2175;
  float _2185;
  float _2211;
  float _2225;
  float _2239;
  float _2250;
  float _2259;
  float _2268;
  float _2293;
  float _2307;
  float _2321;
  float _2342;
  float _2352;
  float _2362;
  float _2387;
  float _2401;
  float _2415;
  float _2437;
  float _2447;
  float _2457;
  float _2482;
  float _2496;
  float _2510;
  float _2521;
  float _2522;
  float _2523;
  float _2537;
  float _2538;
  float _2539;
  float _2583;
  float _2584;
  float _2585;
  float _2631;
  float _2643;
  float _2655;
  float _2666;
  float _2667;
  float _2668;
  float _2684;
  float _2693;
  float _2702;
  float _2773;
  float _2774;
  float _2775;
  if (!_37) {
    _43 = (distortionType == 0);
  } else {
    _43 = false;
  }
  if (!_37) {
    _49 = (distortionType == 1);
  } else {
    _49 = false;
  }
  bool _51 = ((cPassEnabled & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    float _59 = Kerare.x / Kerare.w;
    float _60 = Kerare.y / Kerare.w;
    float _61 = Kerare.z / Kerare.w;
    float _65 = abs(rsqrt(dot(float3(_59, _60, _61), float3(_59, _60, _61))) * _61);
    float _70 = _65 * _65;
    _98 = ((_70 * _70) * (1.0f - saturate((kerare_scale * _65) + kerare_offset)));
  } else {
    float _81 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _83 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _85 = sqrt(dot(float2(_83, _81), float2(_83, _81)));
    float _93 = (_85 * _85) + 1.0f;
    _98 = ((1.0f / (_93 * _93)) * (1.0f - saturate((kerare_scale * (1.0f / (_85 + 1.0f))) + kerare_offset)));
  }
  float _100 = saturate(_98 + kerare_brightness);

  CustomVignette(_100);

  float _101 = _100 * Exposure;

  // This should be 1 if 0x4905680A is loaded, since that one handles exposure
  float custom_flat_exposure = 1.f;

  // We check if 0x4905680A has loaded
  if (CUSTOM_EXPOSURE_SHADER_DRAW == 0.f) {
    // In case of vanilla
    custom_flat_exposure = 1.f * NormalizeExposure();
    if (CUSTOM_EXPOSURE_TYPE >= 1.f) {
      custom_flat_exposure = FlatExposure();
    }
  }

  // Lens distortion
  if (_43) {
    float _118 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _119 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _120 = dot(float2(_118, _119), float2(_118, _119));
    float _123 = ((_120 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _124 = _123 * _118;
    float _125 = _123 * _119;
    float _126 = _124 + 0.5f;
    float _127 = _125 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _137 = HazeNoiseResult.Sample(BilinearWrap, float2(_126, _127));
            _395 = ((fHazeFilterScale * _137.x) + _126);
            _396 = ((fHazeFilterScale * _137.y) + _127);
          } else {
            bool _149 = ((fHazeFilterAttribute & 2) != 0);
            float _153 = tFilterTempMap1.Sample(BilinearWrap, float2(_126, _127));
            do {
              if (_149) {
                float _160 = ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f);
                float _168 = (((_126 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
                float _169 = 1.0f - (((_127 * 2.0f) * screenSize.y) * screenInverseSize.y);
                float _206 = 1.0f / (mad(_160.x, (viewProjInvMat[2].w), mad(_169, (viewProjInvMat[1].w), (_168 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
                float _208 = _206 * (mad(_160.x, (viewProjInvMat[2].y), mad(_169, (viewProjInvMat[1].y), (_168 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
                float _216 = (_206 * (mad(_160.x, (viewProjInvMat[2].x), mad(_169, (viewProjInvMat[1].x), (_168 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _217 = _208 - (transposeViewInvMat[1].w);
                float _218 = (_206 * (mad(_160.x, (viewProjInvMat[2].z), mad(_169, (viewProjInvMat[1].z), (_168 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _243 = saturate(_153.x * max(((sqrt(((_217 * _217) + (_216 * _216)) + (_218 * _218)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_208 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
                _244 = _160.x;
              } else {
                _243 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _153.x), _153.x);
                _244 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _256 = 0.5f / fHazeFilterBorder;
                  _266 = (1.0f - saturate(max(((_256 * min(max((abs(_124) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_256 * min(max((abs(_125) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
                } else {
                  _266 = 1.0f;
                }
                float _267 = _266 * _243;
                do {
                  if (!(_267 <= 9.999999747378752e-06f)) {
                    float _274 = -0.0f - _127;
                    float _297 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_274, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _126)));
                    float _298 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_274, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _126)));
                    float _299 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_274, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _126)));
                    float _305 = tVolumeMap.Sample(BilinearWrap, float3((_297 + fHazeFilterUVWOffset.x), (_298 + fHazeFilterUVWOffset.y), (_299 + fHazeFilterUVWOffset.z)));
                    float _308 = _297 * 2.0f;
                    float _309 = _298 * 2.0f;
                    float _310 = _299 * 2.0f;
                    float _314 = tVolumeMap.Sample(BilinearWrap, float3((_308 + fHazeFilterUVWOffset.x), (_309 + fHazeFilterUVWOffset.y), (_310 + fHazeFilterUVWOffset.z)));
                    float _318 = _297 * 4.0f;
                    float _319 = _298 * 4.0f;
                    float _320 = _299 * 4.0f;
                    float _324 = tVolumeMap.Sample(BilinearWrap, float3((_318 + fHazeFilterUVWOffset.x), (_319 + fHazeFilterUVWOffset.y), (_320 + fHazeFilterUVWOffset.z)));
                    float _328 = _297 * 8.0f;
                    float _329 = _298 * 8.0f;
                    float _330 = _299 * 8.0f;
                    float _334 = tVolumeMap.Sample(BilinearWrap, float3((_328 + fHazeFilterUVWOffset.x), (_329 + fHazeFilterUVWOffset.y), (_330 + fHazeFilterUVWOffset.z)));
                    float _338 = fHazeFilterUVWOffset.x + 0.5f;
                    float _339 = fHazeFilterUVWOffset.y + 0.5f;
                    float _340 = fHazeFilterUVWOffset.z + 0.5f;
                    float _344 = tVolumeMap.Sample(BilinearWrap, float3((_297 + _338), (_298 + _339), (_299 + _340)));
                    float _350 = tVolumeMap.Sample(BilinearWrap, float3((_308 + _338), (_309 + _339), (_310 + _340)));
                    float _357 = tVolumeMap.Sample(BilinearWrap, float3((_318 + _338), (_319 + _339), (_320 + _340)));
                    float _364 = tVolumeMap.Sample(BilinearWrap, float3((_328 + _338), (_329 + _339), (_330 + _340)));
                    float _372 = ((((((_314.x * 0.25f) + (_305.x * 0.5f)) + (_324.x * 0.125f)) + (_334.x * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    float _373 = ((((((_350.x * 0.25f) + (_344.x * 0.5f)) + (_357.x * 0.125f)) + (_364.x * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    if (_149) {
                      float _378 = ReadonlyDepth.Sample(BilinearWrap, float2((_372 + _126), (_373 + _127)));
                      if (!((_378.x - _244) >= fHazeFilterDepthDiffBias)) {
                        _386 = _372;
                        _387 = _373;
                      } else {
                        _386 = 0.0f;
                        _387 = 0.0f;
                      }
                    } else {
                      _386 = _372;
                      _387 = _373;
                    }
                  } else {
                    _386 = 0.0f;
                    _387 = 0.0f;
                  }
                  _395 = ((fHazeFilterScale * _386) + _126);
                  _396 = ((fHazeFilterScale * _387) + _127);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _395 = _126;
          _396 = _127;
        }

        _395 = lerp(_126, _395, CUSTOM_ABERRATION);
        _396 = lerp(_127, _396, CUSTOM_ABERRATION);

        float4 _399 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_395, _396));

        _399.xyz *= custom_flat_exposure;

        _1181 = (_399.x * _101);
        _1182 = (_399.y * _101);
        _1183 = (_399.z * _101);
        _1184 = fDistortionCoef;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = fCorrectCoef;
      } while (false);
    } else {
      float _422 = ((saturate((sqrt((_118 * _118) + (_119 * _119)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      float _424 = _118 * fCorrectCoef;
      float _425 = _119 * fCorrectCoef;
      if (!(aberrationBlurEnable == 0)) {
        float _434 = (fBlurNoisePower * 0.125f) * frac(frac(dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
        float _435 = _422 * 2.0f;
        float _439 = (((_435 * _434) + _120) * fDistortionCoef) + 1.0f;
        float4 _444 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _439) + 0.5f), ((_425 * _439) + 0.5f)));
        float _450 = (((_435 * (_434 + 0.125f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _455 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _450) + 0.5f), ((_425 * _450) + 0.5f)));
        float _462 = (((_435 * (_434 + 0.25f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _462) + 0.5f), ((_425 * _462) + 0.5f)));
        float _476 = (((_435 * (_434 + 0.375f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _481 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _476) + 0.5f), ((_425 * _476) + 0.5f)));
        float _490 = (((_435 * (_434 + 0.5f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _495 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _490) + 0.5f), ((_425 * _490) + 0.5f)));
        float _501 = (((_435 * (_434 + 0.625f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _506 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _501) + 0.5f), ((_425 * _501) + 0.5f)));
        float _514 = (((_435 * (_434 + 0.75f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _519 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _514) + 0.5f), ((_425 * _514) + 0.5f)));
        float _534 = (((_435 * (_434 + 0.875f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _539 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _534) + 0.5f), ((_425 * _534) + 0.5f)));
        float _546 = (((_435 * (_434 + 1.0f)) + _120) * fDistortionCoef) + 1.0f;
        float4 _551 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _546) + 0.5f), ((_425 * _546) + 0.5f)));
        float _554 = _101 * 0.3199999928474426f;
        _1181 = (_554 * (((_455.x + _444.x) + (_467.x * 0.75f)) + (_481.x * 0.375f)));
        _1182 = ((_101 * 0.3636363744735718f) * ((((_506.y + _481.y) * 0.625f) + _495.y) + ((_519.y + _467.y) * 0.25f)));
        _1183 = (_554 * ((((_519.z * 0.75f) + (_506.z * 0.375f)) + _539.z) + _551.z));
        _1184 = fDistortionCoef;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = fCorrectCoef;
      } else {
        float _560 = _422 + _120;
        float _562 = (_560 * fDistortionCoef) + 1.0f;
        float _569 = ((_560 + _422) * fDistortionCoef) + 1.0f;
        float4 _574 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_126, _127));
        float4 _577 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _562) + 0.5f), ((_425 * _562) + 0.5f)));
        float4 _580 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _569) + 0.5f), ((_425 * _569) + 0.5f)));
        _1181 = (_574.x * _101);
        _1182 = (_577.y * _101);
        _1183 = (_580.z * _101);
        _1184 = fDistortionCoef;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = fCorrectCoef;
      }
    }
  } else {
    // Here
    // _49 is distortion type
    // We still hazing
    if (_49) {
      float _594 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _598 = sqrt((_594 * _594) + 1.0f);
      float _599 = 1.0f / _598;
      // Controls lens distortion
      float _602 = (_598 * fOptimizedParam.z) * (_599 + fOptimizedParam.x);
      float _606 = fOptimizedParam.w * 0.5f;
      float _608 = (_606 * _594) * _602;
      float _611 = ((_606 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_599 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _602;
      float _612 = _608 + 0.5f;
      float _613 = _611 + 0.5f;
      do {
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _621 = HazeNoiseResult.Sample(BilinearWrap, float2(_612, _613));
            _879 = ((fHazeFilterScale * _621.x) + _612);
            _880 = ((fHazeFilterScale * _621.y) + _613);
          } else {
            bool _633 = ((fHazeFilterAttribute & 2) != 0);
            float _637 = tFilterTempMap1.Sample(BilinearWrap, float2(_612, _613));
            do {
              if (_633) {
                float _644 = ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f);
                float _652 = (((_612 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
                float _653 = 1.0f - (((_613 * 2.0f) * screenSize.y) * screenInverseSize.y);
                float _690 = 1.0f / (mad(_644.x, (viewProjInvMat[2].w), mad(_653, (viewProjInvMat[1].w), (_652 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
                float _692 = _690 * (mad(_644.x, (viewProjInvMat[2].y), mad(_653, (viewProjInvMat[1].y), (_652 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
                float _700 = (_690 * (mad(_644.x, (viewProjInvMat[2].x), mad(_653, (viewProjInvMat[1].x), (_652 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _701 = _692 - (transposeViewInvMat[1].w);
                float _702 = (_690 * (mad(_644.x, (viewProjInvMat[2].z), mad(_653, (viewProjInvMat[1].z), (_652 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _727 = saturate(_637.x * max(((sqrt(((_701 * _701) + (_700 * _700)) + (_702 * _702)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_692 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
                _728 = _644.x;
              } else {
                _727 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _637.x), _637.x);
                _728 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _740 = 0.5f / fHazeFilterBorder;
                  _750 = (1.0f - saturate(max(((_740 * min(max((abs(_608) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_740 * min(max((abs(_611) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
                } else {
                  _750 = 1.0f;
                }
                float _751 = _750 * _727;
                do {
                  if (!(_751 <= 9.999999747378752e-06f)) {
                    float _758 = -0.0f - _613;
                    float _781 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_758, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _612)));
                    float _782 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_758, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _612)));
                    float _783 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_758, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _612)));
                    float _789 = tVolumeMap.Sample(BilinearWrap, float3((_781 + fHazeFilterUVWOffset.x), (_782 + fHazeFilterUVWOffset.y), (_783 + fHazeFilterUVWOffset.z)));
                    float _792 = _781 * 2.0f;
                    float _793 = _782 * 2.0f;
                    float _794 = _783 * 2.0f;
                    float _798 = tVolumeMap.Sample(BilinearWrap, float3((_792 + fHazeFilterUVWOffset.x), (_793 + fHazeFilterUVWOffset.y), (_794 + fHazeFilterUVWOffset.z)));
                    float _802 = _781 * 4.0f;
                    float _803 = _782 * 4.0f;
                    float _804 = _783 * 4.0f;
                    float _808 = tVolumeMap.Sample(BilinearWrap, float3((_802 + fHazeFilterUVWOffset.x), (_803 + fHazeFilterUVWOffset.y), (_804 + fHazeFilterUVWOffset.z)));
                    float _812 = _781 * 8.0f;
                    float _813 = _782 * 8.0f;
                    float _814 = _783 * 8.0f;
                    float _818 = tVolumeMap.Sample(BilinearWrap, float3((_812 + fHazeFilterUVWOffset.x), (_813 + fHazeFilterUVWOffset.y), (_814 + fHazeFilterUVWOffset.z)));
                    float _822 = fHazeFilterUVWOffset.x + 0.5f;
                    float _823 = fHazeFilterUVWOffset.y + 0.5f;
                    float _824 = fHazeFilterUVWOffset.z + 0.5f;
                    float _828 = tVolumeMap.Sample(BilinearWrap, float3((_781 + _822), (_782 + _823), (_783 + _824)));
                    float _834 = tVolumeMap.Sample(BilinearWrap, float3((_792 + _822), (_793 + _823), (_794 + _824)));
                    float _841 = tVolumeMap.Sample(BilinearWrap, float3((_802 + _822), (_803 + _823), (_804 + _824)));
                    float _848 = tVolumeMap.Sample(BilinearWrap, float3((_812 + _822), (_813 + _823), (_814 + _824)));
                    float _856 = ((((((_798.x * 0.25f) + (_789.x * 0.5f)) + (_808.x * 0.125f)) + (_818.x * 0.0625f)) * 2.0f) + -1.0f) * _751;
                    float _857 = ((((((_834.x * 0.25f) + (_828.x * 0.5f)) + (_841.x * 0.125f)) + (_848.x * 0.0625f)) * 2.0f) + -1.0f) * _751;
                    if (_633) {
                      float _862 = ReadonlyDepth.Sample(BilinearWrap, float2((_856 + _612), (_857 + _613)));
                      if (!((_862.x - _728) >= fHazeFilterDepthDiffBias)) {
                        _870 = _856;
                        _871 = _857;
                      } else {
                        _870 = 0.0f;
                        _871 = 0.0f;
                      }
                    } else {
                      _870 = _856;
                      _871 = _857;
                    }
                  } else {
                    _870 = 0.0f;
                    _871 = 0.0f;
                  }
                  _879 = ((fHazeFilterScale * _870) + _612);
                  _880 = ((fHazeFilterScale * _871) + _613);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _879 = _612;
          _880 = _613;
        }
        // Here
        // RE_POSTPROCESS_Color is adjusted by 0x4905680A
        float4 _883 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_879, _880));

        _883.xyz *= custom_flat_exposure;
        // This section in flat FOR SURE
        _1181 = (_883.x * _101);
        _1182 = (_883.y * _101);
        _1183 = (_883.z * _101);
        _1184 = 0.0f;
        _1185 = fOptimizedParam.x;
        _1186 = fOptimizedParam.y;
        _1187 = fOptimizedParam.z;
        _1188 = fOptimizedParam.w;
        _1189 = 1.0f;
      } while (false);
    } else {
      float _891 = screenInverseSize.x * SV_Position.x;
      float _892 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_51) {
          float4 _896 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_891, _892));

          _896.xyz *= custom_flat_exposure;

          _1174 = _896.x;
          _1175 = _896.y;
          _1176 = _896.z;
        } else {
          do {
            if (!(fHazeFilterReductionResolution == 0)) {
              float2 _907 = HazeNoiseResult.Sample(BilinearWrap, float2(_891, _892));
              _1163 = (fHazeFilterScale * _907.x);
              _1164 = (fHazeFilterScale * _907.y);
            } else {
              bool _917 = ((fHazeFilterAttribute & 2) != 0);
              float _921 = tFilterTempMap1.Sample(BilinearWrap, float2(_891, _892));
              do {
                if (_917) {
                  float _928 = ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f);
                  float _936 = (((_891 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
                  float _937 = 1.0f - (((_892 * 2.0f) * screenSize.y) * screenInverseSize.y);
                  float _974 = 1.0f / (mad(_928.x, (viewProjInvMat[2].w), mad(_937, (viewProjInvMat[1].w), (_936 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
                  float _976 = _974 * (mad(_928.x, (viewProjInvMat[2].y), mad(_937, (viewProjInvMat[1].y), (_936 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
                  float _984 = (_974 * (mad(_928.x, (viewProjInvMat[2].x), mad(_937, (viewProjInvMat[1].x), (_936 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                  float _985 = _976 - (transposeViewInvMat[1].w);
                  float _986 = (_974 * (mad(_928.x, (viewProjInvMat[2].z), mad(_937, (viewProjInvMat[1].z), (_936 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                  _1011 = saturate(_921.x * max(((sqrt(((_985 * _985) + (_984 * _984)) + (_986 * _986)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_976 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
                  _1012 = _928.x;
                } else {
                  _1011 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _921.x), _921.x);
                  _1012 = 0.0f;
                }
                do {
                  if (!((fHazeFilterAttribute & 4) == 0)) {
                    float _1026 = 0.5f / fHazeFilterBorder;
                    _1036 = (1.0f - saturate(max(((_1026 * min(max((abs(_891 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1026 * min(max((abs(_892 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
                  } else {
                    _1036 = 1.0f;
                  }
                  float _1037 = _1036 * _1011;
                  do {
                    if (!(_1037 <= 9.999999747378752e-06f)) {
                      float _1044 = -0.0f - _892;
                      float _1067 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1044, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _891)));
                      float _1068 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1044, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _891)));
                      float _1069 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1044, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _891)));
                      float _1075 = tVolumeMap.Sample(BilinearWrap, float3((_1067 + fHazeFilterUVWOffset.x), (_1068 + fHazeFilterUVWOffset.y), (_1069 + fHazeFilterUVWOffset.z)));
                      float _1078 = _1067 * 2.0f;
                      float _1079 = _1068 * 2.0f;
                      float _1080 = _1069 * 2.0f;
                      float _1084 = tVolumeMap.Sample(BilinearWrap, float3((_1078 + fHazeFilterUVWOffset.x), (_1079 + fHazeFilterUVWOffset.y), (_1080 + fHazeFilterUVWOffset.z)));
                      float _1088 = _1067 * 4.0f;
                      float _1089 = _1068 * 4.0f;
                      float _1090 = _1069 * 4.0f;
                      float _1094 = tVolumeMap.Sample(BilinearWrap, float3((_1088 + fHazeFilterUVWOffset.x), (_1089 + fHazeFilterUVWOffset.y), (_1090 + fHazeFilterUVWOffset.z)));
                      float _1098 = _1067 * 8.0f;
                      float _1099 = _1068 * 8.0f;
                      float _1100 = _1069 * 8.0f;
                      float _1104 = tVolumeMap.Sample(BilinearWrap, float3((_1098 + fHazeFilterUVWOffset.x), (_1099 + fHazeFilterUVWOffset.y), (_1100 + fHazeFilterUVWOffset.z)));
                      float _1108 = fHazeFilterUVWOffset.x + 0.5f;
                      float _1109 = fHazeFilterUVWOffset.y + 0.5f;
                      float _1110 = fHazeFilterUVWOffset.z + 0.5f;
                      float _1114 = tVolumeMap.Sample(BilinearWrap, float3((_1067 + _1108), (_1068 + _1109), (_1069 + _1110)));
                      float _1120 = tVolumeMap.Sample(BilinearWrap, float3((_1078 + _1108), (_1079 + _1109), (_1080 + _1110)));
                      float _1127 = tVolumeMap.Sample(BilinearWrap, float3((_1088 + _1108), (_1089 + _1109), (_1090 + _1110)));
                      float _1134 = tVolumeMap.Sample(BilinearWrap, float3((_1098 + _1108), (_1099 + _1109), (_1100 + _1110)));
                      float _1142 = ((((((_1084.x * 0.25f) + (_1075.x * 0.5f)) + (_1094.x * 0.125f)) + (_1104.x * 0.0625f)) * 2.0f) + -1.0f) * _1037;
                      float _1143 = ((((((_1120.x * 0.25f) + (_1114.x * 0.5f)) + (_1127.x * 0.125f)) + (_1134.x * 0.0625f)) * 2.0f) + -1.0f) * _1037;
                      if (_917) {
                        float _1148 = ReadonlyDepth.Sample(BilinearWrap, float2((_1142 + _891), (_1143 + _892)));
                        if (!((_1148.x - _1012) >= fHazeFilterDepthDiffBias)) {
                          _1156 = _1142;
                          _1157 = _1143;
                        } else {
                          _1156 = 0.0f;
                          _1157 = 0.0f;
                        }
                      } else {
                        _1156 = _1142;
                        _1157 = _1143;
                      }
                    } else {
                      _1156 = 0.0f;
                      _1157 = 0.0f;
                    }
                    _1163 = (fHazeFilterScale * _1156);
                    _1164 = (fHazeFilterScale * _1157);
                  } while (false);
                } while (false);
              } while (false);
            }
            float4 _1169 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1163 + _891), (_1164 + _892)));

            _1169.xyz *= custom_flat_exposure;

            _1174 = _1169.x;
            _1175 = _1169.y;
            _1176 = _1169.z;
          } while (false);
        }
        _1181 = (_1174 * _101);
        _1182 = (_1175 * _101);
        _1183 = (_1176 * _101);
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1210 = _100 * Exposure;
    float _1213 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1217 = ComputeResultSRV[0].computeAlpha;
    float _1220 = ((1.0f - _1213) + (_1217 * _1213)) * cbRadialColor.w;
    if (!(_1220 == 0.0f)) {
      float _1226 = screenInverseSize.x * SV_Position.x;
      float _1227 = screenInverseSize.y * SV_Position.y;
      float _1229 = (-0.5f - cbRadialScreenPos.x) + _1226;
      float _1231 = (-0.5f - cbRadialScreenPos.y) + _1227;
      float _1234 = select((_1229 < 0.0f), (1.0f - _1226), _1226);
      float _1237 = select((_1231 < 0.0f), (1.0f - _1227), _1227);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1242 = rsqrt(dot(float2(_1229, _1231), float2(_1229, _1231)));
          uint _1251 = uint(abs((_1231 * cbRadialSharpRange) * _1242)) + uint(abs((_1229 * cbRadialSharpRange) * _1242));
          uint _1255 = ((_1251 ^ 61) ^ ((uint)(_1251) >> 16)) * 9;
          uint _1258 = (((uint)(_1255) >> 4) ^ _1255) * 668265261;
          _1264 = (float((uint)((int)(((uint)(_1258) >> 15) ^ _1258))) * 2.3283064365386963e-10f);
        } else {
          _1264 = 1.0f;
        }
        float _1270 = 1.0f / max(1.0f, sqrt((_1229 * _1229) + (_1231 * _1231)));
        float _1271 = cbRadialBlurPower * -0.0011111111380159855f;
        float _1280 = ((((_1271 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1281 = ((((_1271 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1283 = cbRadialBlurPower * -0.002222222276031971f;
        float _1292 = ((((_1283 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1293 = ((((_1283 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1294 = cbRadialBlurPower * -0.0033333334140479565f;
        float _1303 = ((((_1294 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1304 = ((((_1294 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1305 = cbRadialBlurPower * -0.004444444552063942f;
        float _1314 = ((((_1305 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1315 = ((((_1305 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1316 = cbRadialBlurPower * -0.0055555556900799274f;
        float _1325 = ((((_1316 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1326 = ((((_1316 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1327 = cbRadialBlurPower * -0.006666666828095913f;
        float _1336 = ((((_1327 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1337 = ((((_1327 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1338 = cbRadialBlurPower * -0.007777777966111898f;
        float _1347 = ((((_1338 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1348 = ((((_1338 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1349 = cbRadialBlurPower * -0.008888889104127884f;
        float _1358 = ((((_1349 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1359 = ((((_1349 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1360 = cbRadialBlurPower * -0.009999999776482582f;
        float _1369 = ((((_1360 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1370 = ((((_1360 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        do {
          if (_43) {
            float _1372 = _1280 + cbRadialScreenPos.x;
            float _1373 = _1281 + cbRadialScreenPos.y;
            float _1377 = ((dot(float2(_1372, _1373), float2(_1372, _1373)) * _1184) + 1.0f) * _1189;
            float4 _1383 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1377 * _1372) + 0.5f), ((_1377 * _1373) + 0.5f)), 0.0f);
            float _1387 = _1292 + cbRadialScreenPos.x;
            float _1388 = _1293 + cbRadialScreenPos.y;
            float _1391 = (dot(float2(_1387, _1388), float2(_1387, _1388)) * _1184) + 1.0f;
            float4 _1398 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1387 * _1189) * _1391) + 0.5f), (((_1388 * _1189) * _1391) + 0.5f)), 0.0f);
            float _1405 = _1303 + cbRadialScreenPos.x;
            float _1406 = _1304 + cbRadialScreenPos.y;
            float _1409 = (dot(float2(_1405, _1406), float2(_1405, _1406)) * _1184) + 1.0f;
            float4 _1416 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1405 * _1189) * _1409) + 0.5f), (((_1406 * _1189) * _1409) + 0.5f)), 0.0f);
            float _1423 = _1314 + cbRadialScreenPos.x;
            float _1424 = _1315 + cbRadialScreenPos.y;
            float _1427 = (dot(float2(_1423, _1424), float2(_1423, _1424)) * _1184) + 1.0f;
            float4 _1434 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1423 * _1189) * _1427) + 0.5f), (((_1424 * _1189) * _1427) + 0.5f)), 0.0f);
            float _1441 = _1325 + cbRadialScreenPos.x;
            float _1442 = _1326 + cbRadialScreenPos.y;
            float _1445 = (dot(float2(_1441, _1442), float2(_1441, _1442)) * _1184) + 1.0f;
            float4 _1452 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1441 * _1189) * _1445) + 0.5f), (((_1442 * _1189) * _1445) + 0.5f)), 0.0f);
            float _1459 = _1336 + cbRadialScreenPos.x;
            float _1460 = _1337 + cbRadialScreenPos.y;
            float _1463 = (dot(float2(_1459, _1460), float2(_1459, _1460)) * _1184) + 1.0f;
            float4 _1470 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1459 * _1189) * _1463) + 0.5f), (((_1460 * _1189) * _1463) + 0.5f)), 0.0f);
            float _1477 = _1347 + cbRadialScreenPos.x;
            float _1478 = _1348 + cbRadialScreenPos.y;
            float _1481 = (dot(float2(_1477, _1478), float2(_1477, _1478)) * _1184) + 1.0f;
            float4 _1488 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1477 * _1189) * _1481) + 0.5f), (((_1478 * _1189) * _1481) + 0.5f)), 0.0f);
            float _1495 = _1358 + cbRadialScreenPos.x;
            float _1496 = _1359 + cbRadialScreenPos.y;
            float _1499 = (dot(float2(_1495, _1496), float2(_1495, _1496)) * _1184) + 1.0f;
            float4 _1506 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1495 * _1189) * _1499) + 0.5f), (((_1496 * _1189) * _1499) + 0.5f)), 0.0f);
            float _1513 = _1369 + cbRadialScreenPos.x;
            float _1514 = _1370 + cbRadialScreenPos.y;
            float _1517 = (dot(float2(_1513, _1514), float2(_1513, _1514)) * _1184) + 1.0f;
            float4 _1524 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1513 * _1189) * _1517) + 0.5f), (((_1514 * _1189) * _1517) + 0.5f)), 0.0f);
            _1867 = ((((((((_1398.x + _1383.x) + _1416.x) + _1434.x) + _1452.x) + _1470.x) + _1488.x) + _1506.x) + _1524.x);
            _1868 = ((((((((_1398.y + _1383.y) + _1416.y) + _1434.y) + _1452.y) + _1470.y) + _1488.y) + _1506.y) + _1524.y);
            _1869 = ((((((((_1398.z + _1383.z) + _1416.z) + _1434.z) + _1452.z) + _1470.z) + _1488.z) + _1506.z) + _1524.z);
          } else {
            float _1532 = cbRadialScreenPos.x + 0.5f;
            float _1533 = _1532 + _1280;
            float _1534 = cbRadialScreenPos.y + 0.5f;
            float _1535 = _1534 + _1281;
            float _1536 = _1532 + _1292;
            float _1537 = _1534 + _1293;
            float _1538 = _1532 + _1303;
            float _1539 = _1534 + _1304;
            float _1540 = _1532 + _1314;
            float _1541 = _1534 + _1315;
            float _1542 = _1532 + _1325;
            float _1543 = _1534 + _1326;
            float _1544 = _1532 + _1336;
            float _1545 = _1534 + _1337;
            float _1546 = _1532 + _1347;
            float _1547 = _1534 + _1348;
            float _1548 = _1532 + _1358;
            float _1549 = _1534 + _1359;
            float _1550 = _1532 + _1369;
            float _1551 = _1534 + _1370;
            if (_49) {
              float _1555 = (_1533 * 2.0f) + -1.0f;
              float _1559 = sqrt((_1555 * _1555) + 1.0f);
              float _1560 = 1.0f / _1559;
              float _1563 = (_1559 * _1187) * (_1560 + _1185);
              float _1567 = _1188 * 0.5f;
              float4 _1576 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1563) * _1555) + 0.5f), ((((_1567 * (((_1560 + -1.0f) * _1186) + 1.0f)) * _1563) * ((_1535 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
              float _1582 = (_1536 * 2.0f) + -1.0f;
              float _1586 = sqrt((_1582 * _1582) + 1.0f);
              float _1587 = 1.0f / _1586;
              float _1590 = (_1586 * _1187) * (_1587 + _1185);
              float4 _1601 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1582) * _1590) + 0.5f), ((((_1567 * ((_1537 * 2.0f) + -1.0f)) * (((_1587 + -1.0f) * _1186) + 1.0f)) * _1590) + 0.5f)), 0.0f);
              float _1610 = (_1538 * 2.0f) + -1.0f;
              float _1614 = sqrt((_1610 * _1610) + 1.0f);
              float _1615 = 1.0f / _1614;
              float _1618 = (_1614 * _1187) * (_1615 + _1185);
              float4 _1629 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1610) * _1618) + 0.5f), ((((_1567 * ((_1539 * 2.0f) + -1.0f)) * (((_1615 + -1.0f) * _1186) + 1.0f)) * _1618) + 0.5f)), 0.0f);
              float _1638 = (_1540 * 2.0f) + -1.0f;
              float _1642 = sqrt((_1638 * _1638) + 1.0f);
              float _1643 = 1.0f / _1642;
              float _1646 = (_1642 * _1187) * (_1643 + _1185);
              float4 _1657 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1638) * _1646) + 0.5f), ((((_1567 * ((_1541 * 2.0f) + -1.0f)) * (((_1643 + -1.0f) * _1186) + 1.0f)) * _1646) + 0.5f)), 0.0f);
              float _1666 = (_1542 * 2.0f) + -1.0f;
              float _1670 = sqrt((_1666 * _1666) + 1.0f);
              float _1671 = 1.0f / _1670;
              float _1674 = (_1670 * _1187) * (_1671 + _1185);
              float4 _1685 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1666) * _1674) + 0.5f), ((((_1567 * ((_1543 * 2.0f) + -1.0f)) * (((_1671 + -1.0f) * _1186) + 1.0f)) * _1674) + 0.5f)), 0.0f);
              float _1694 = (_1544 * 2.0f) + -1.0f;
              float _1698 = sqrt((_1694 * _1694) + 1.0f);
              float _1699 = 1.0f / _1698;
              float _1702 = (_1698 * _1187) * (_1699 + _1185);
              float4 _1713 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1694) * _1702) + 0.5f), ((((_1567 * ((_1545 * 2.0f) + -1.0f)) * (((_1699 + -1.0f) * _1186) + 1.0f)) * _1702) + 0.5f)), 0.0f);
              float _1722 = (_1546 * 2.0f) + -1.0f;
              float _1726 = sqrt((_1722 * _1722) + 1.0f);
              float _1727 = 1.0f / _1726;
              float _1730 = (_1726 * _1187) * (_1727 + _1185);
              float4 _1741 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1722) * _1730) + 0.5f), ((((_1567 * ((_1547 * 2.0f) + -1.0f)) * (((_1727 + -1.0f) * _1186) + 1.0f)) * _1730) + 0.5f)), 0.0f);
              float _1750 = (_1548 * 2.0f) + -1.0f;
              float _1754 = sqrt((_1750 * _1750) + 1.0f);
              float _1755 = 1.0f / _1754;
              float _1758 = (_1754 * _1187) * (_1755 + _1185);
              float4 _1769 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1750) * _1758) + 0.5f), ((((_1567 * ((_1549 * 2.0f) + -1.0f)) * (((_1755 + -1.0f) * _1186) + 1.0f)) * _1758) + 0.5f)), 0.0f);
              float _1778 = (_1550 * 2.0f) + -1.0f;
              float _1782 = sqrt((_1778 * _1778) + 1.0f);
              float _1783 = 1.0f / _1782;
              float _1786 = (_1782 * _1187) * (_1783 + _1185);
              float4 _1797 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1778) * _1786) + 0.5f), ((((_1567 * ((_1551 * 2.0f) + -1.0f)) * (((_1783 + -1.0f) * _1186) + 1.0f)) * _1786) + 0.5f)), 0.0f);
              _1867 = ((((((((_1601.x + _1576.x) + _1629.x) + _1657.x) + _1685.x) + _1713.x) + _1741.x) + _1769.x) + _1797.x);
              _1868 = ((((((((_1601.y + _1576.y) + _1629.y) + _1657.y) + _1685.y) + _1713.y) + _1741.y) + _1769.y) + _1797.y);
              _1869 = ((((((((_1601.z + _1576.z) + _1629.z) + _1657.z) + _1685.z) + _1713.z) + _1741.z) + _1769.z) + _1797.z);
            } else {
              float4 _1806 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1533, _1535), 0.0f);
              float4 _1810 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1536, _1537), 0.0f);
              float4 _1817 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1538, _1539), 0.0f);
              float4 _1824 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1540, _1541), 0.0f);
              float4 _1831 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1542, _1543), 0.0f);
              float4 _1838 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1544, _1545), 0.0f);
              float4 _1845 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1546, _1547), 0.0f);
              float4 _1852 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1548, _1549), 0.0f);
              float4 _1859 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1550, _1551), 0.0f);
              _1867 = ((((((((_1810.x + _1806.x) + _1817.x) + _1824.x) + _1831.x) + _1838.x) + _1845.x) + _1852.x) + _1859.x);
              _1868 = ((((((((_1810.y + _1806.y) + _1817.y) + _1824.y) + _1831.y) + _1838.y) + _1845.y) + _1852.y) + _1859.y);
              _1869 = ((((((((_1810.z + _1806.z) + _1817.z) + _1824.z) + _1831.z) + _1838.z) + _1845.z) + _1852.z) + _1859.z);
            }
          }
          float _1879 = (((_1869 * _1210) + _1183) * 0.10000000149011612f) * cbRadialColor.z;
          float _1880 = (((_1868 * _1210) + _1182) * 0.10000000149011612f) * cbRadialColor.y;
          float _1881 = (((_1867 * _1210) + _1181) * 0.10000000149011612f) * cbRadialColor.x;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1890 = saturate((sqrt((_1229 * _1229) + (_1231 * _1231)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1896 = (((_1890 * _1890) * cbRadialMaskRate.x) * (3.0f - (_1890 * 2.0f))) + cbRadialMaskRate.y;
              _1907 = ((_1896 * (_1881 - _1181)) + _1181);
              _1908 = ((_1896 * (_1880 - _1182)) + _1182);
              _1909 = ((_1896 * (_1879 - _1183)) + _1183);
            } else {
              _1907 = _1881;
              _1908 = _1880;
              _1909 = _1879;
            }
            _1920 = (lerp(_1181, _1907, _1220));
            _1921 = (lerp(_1182, _1908, _1220));
            _1922 = (lerp(_1183, _1909, _1220));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1920 = _1181;
      _1921 = _1182;
      _1922 = _1183;
    }
  } else {
    _1920 = _1181;
    _1921 = _1182;
    _1922 = _1183;
  }
  float _1937 = mad(_1922, (fOCIOTransformMatrix[2].x), mad(_1921, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1920)));
  float _1940 = mad(_1922, (fOCIOTransformMatrix[2].y), mad(_1921, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1920)));
  float _1943 = mad(_1922, (fOCIOTransformMatrix[2].z), mad(_1921, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1920)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1949 = max(max(_1937, _1940), _1943);
    if (!(_1949 == 0.0f)) {
      float _1955 = abs(_1949);
      float _1956 = (_1949 - _1937) / _1955;
      float _1957 = (_1949 - _1940) / _1955;
      float _1958 = (_1949 - _1943) / _1955;
      do {
        if (!(!(_1956 >= cbControlRGCParam.CyanThreshold))) {
          float _1968 = _1956 - cbControlRGCParam.CyanThreshold;
          _1980 = ((_1968 / exp2(log2(exp2(log2(_1968 * cbControlRGCParam.InvCyanSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1980 = _1956;
        }
        do {
          if (!(!(_1957 >= cbControlRGCParam.MagentaThreshold))) {
            float _1989 = _1957 - cbControlRGCParam.MagentaThreshold;
            _2001 = ((_1989 / exp2(log2(exp2(log2(_1989 * cbControlRGCParam.InvMagentaSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _2001 = _1957;
          }
          do {
            if (!(!(_1958 >= cbControlRGCParam.YellowThreshold))) {
              float _2009 = _1958 - cbControlRGCParam.YellowThreshold;
              _2021 = ((_2009 / exp2(log2(exp2(log2(_2009 * cbControlRGCParam.InvYellowSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _2021 = _1958;
            }
            _2029 = (_1949 - (_1955 * _1980));
            _2030 = (_1949 - (_1955 * _2001));
            _2031 = (_1949 - (_1955 * _2021));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2029 = _1937;
      _2030 = _1940;
      _2031 = _1943;
    }
  } else {
    _2029 = _1937;
    _2030 = _1940;
    _2031 = _1943;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _2048 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _2050 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _2054 = frac(frac(dot(float2(_2048, _2050), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2054 < fNoiseDensity) {
        int _2059 = (uint)(uint(_2050 * _2048)) ^ 12345391;
        uint _2060 = _2059 * 3635641;
        _2068 = (float((uint)((int)((((uint)(_2060) >> 26) | ((uint)(_2059 * 232681024))) ^ _2060))) * 2.3283064365386963e-10f);
      } else {
        _2068 = 0.0f;
      }
      float _2070 = frac(_2054 * 757.4846801757812f);
      do {
        if (_2070 < fNoiseDensity) {
          int _2074 = asint(_2070) ^ 12345391;
          uint _2075 = _2074 * 3635641;
          _2084 = ((float((uint)((int)((((uint)(_2075) >> 26) | ((uint)(_2074 * 232681024))) ^ _2075))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2084 = 0.0f;
        }
        float _2086 = frac(_2070 * 757.4846801757812f);
        do {
          if (_2086 < fNoiseDensity) {
            int _2090 = asint(_2086) ^ 12345391;
            uint _2091 = _2090 * 3635641;
            _2100 = ((float((uint)((int)((((uint)(_2091) >> 26) | ((uint)(_2090 * 232681024))) ^ _2091))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2100 = 0.0f;
          }
          float _2101 = _2068 * fNoisePower.x;
          float _2102 = _2100 * fNoisePower.y;
          float _2103 = _2084 * fNoisePower.y;
          float _2117 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2029), saturate(_2030), saturate(_2031)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2128 = ((_2117 * (mad(_2103, 1.4019999504089355f, _2101) - _2029)) + _2029);
          _2129 = ((_2117 * (mad(_2103, -0.7139999866485596f, mad(_2102, -0.3440000116825104f, _2101)) - _2030)) + _2030);
          _2130 = ((_2117 * (mad(_2102, 1.7719999551773071f, _2101) - _2031)) + _2031);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2128 = _2029;
    _2129 = _2030;
    _2130 = _2031;
  }
  if (!((cPassEnabled & 4) == 0)) {
    bool _2156 = !(_2128 <= 0.0078125f);
    do {
      if (!_2156) {
        _2165 = ((_2128 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2165 = ((log2(_2128) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _2166 = !(_2129 <= 0.0078125f);
      do {
        if (!_2166) {
          _2175 = ((_2129 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2175 = ((log2(_2129) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _2176 = !(_2130 <= 0.0078125f);
        do {
          if (!_2176) {
            _2185 = ((_2130 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2185 = ((log2(_2130) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _2194 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2165 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2175 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2185 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2194.x < 0.155251145362854f) {
              _2211 = ((_2194.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_2194.x >= 0.155251145362854f) && (bool)(_2194.x < 1.4679962396621704f)) {
                _2211 = exp2((_2194.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2211 = 65504.0f;
              }
            }
            do {
              if (_2194.y < 0.155251145362854f) {
                _2225 = ((_2194.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_2194.y >= 0.155251145362854f) && (bool)(_2194.y < 1.4679962396621704f)) {
                  _2225 = exp2((_2194.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2225 = 65504.0f;
                }
              }
              do {
                if (_2194.z < 0.155251145362854f) {
                  _2239 = ((_2194.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_2194.z >= 0.155251145362854f) && (bool)(_2194.z < 1.4679962396621704f)) {
                    _2239 = exp2((_2194.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2239 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!_2156) {
                        _2250 = ((_2128 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2250 = ((log2(_2128) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_2166) {
                          _2259 = ((_2129 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2259 = ((log2(_2129) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_2176) {
                            _2268 = ((_2130 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2268 = ((log2(_2130) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          float4 _2276 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2250 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2259 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2268 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2276.x < 0.155251145362854f) {
                              _2293 = ((_2276.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_2276.x >= 0.155251145362854f) && (bool)(_2276.x < 1.4679962396621704f)) {
                                _2293 = exp2((_2276.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2293 = 65504.0f;
                              }
                            }
                            do {
                              if (_2276.y < 0.155251145362854f) {
                                _2307 = ((_2276.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_2276.y >= 0.155251145362854f) && (bool)(_2276.y < 1.4679962396621704f)) {
                                  _2307 = exp2((_2276.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2307 = 65504.0f;
                                }
                              }
                              do {
                                if (_2276.z < 0.155251145362854f) {
                                  _2321 = ((_2276.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_2276.z >= 0.155251145362854f) && (bool)(_2276.z < 1.4679962396621704f)) {
                                    _2321 = exp2((_2276.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2321 = 65504.0f;
                                  }
                                }
                                float _2328 = ((_2293 - _2211) * fTextureBlendRate) + _2211;
                                float _2329 = ((_2307 - _2225) * fTextureBlendRate) + _2225;
                                float _2330 = ((_2321 - _2239) * fTextureBlendRate) + _2239;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2328 <= 0.0078125f))) {
                                      _2342 = ((_2328 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2342 = ((log2(_2328) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2329 <= 0.0078125f))) {
                                        _2352 = ((_2329 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2352 = ((log2(_2329) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2330 <= 0.0078125f))) {
                                          _2362 = ((_2330 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2362 = ((log2(_2330) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        float4 _2370 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2342 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2352 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2362 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2370.x < 0.155251145362854f) {
                                            _2387 = ((_2370.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((bool)(_2370.x >= 0.155251145362854f) && (bool)(_2370.x < 1.4679962396621704f)) {
                                              _2387 = exp2((_2370.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2387 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2370.y < 0.155251145362854f) {
                                              _2401 = ((_2370.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((bool)(_2370.y >= 0.155251145362854f) && (bool)(_2370.y < 1.4679962396621704f)) {
                                                _2401 = exp2((_2370.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2401 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2370.z < 0.155251145362854f) {
                                                _2415 = ((_2370.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((bool)(_2370.z >= 0.155251145362854f) && (bool)(_2370.z < 1.4679962396621704f)) {
                                                  _2415 = exp2((_2370.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2415 = 65504.0f;
                                                }
                                              }
                                              _2521 = (lerp(_2328, _2387, fTextureBlendRate2));
                                              _2522 = (lerp(_2329, _2401, fTextureBlendRate2));
                                              _2523 = (lerp(_2330, _2415, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2521 = _2328;
                                  _2522 = _2329;
                                  _2523 = _2330;
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
                        if (!(!(_2211 <= 0.0078125f))) {
                          _2437 = ((_2211 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2437 = ((log2(_2211) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2225 <= 0.0078125f))) {
                            _2447 = ((_2225 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2447 = ((log2(_2225) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2239 <= 0.0078125f))) {
                              _2457 = ((_2239 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2457 = ((log2(_2239) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _2465 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2437 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2447 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2457 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2465.x < 0.155251145362854f) {
                                _2482 = ((_2465.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_2465.x >= 0.155251145362854f) && (bool)(_2465.x < 1.4679962396621704f)) {
                                  _2482 = exp2((_2465.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2482 = 65504.0f;
                                }
                              }
                              do {
                                if (_2465.y < 0.155251145362854f) {
                                  _2496 = ((_2465.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_2465.y >= 0.155251145362854f) && (bool)(_2465.y < 1.4679962396621704f)) {
                                    _2496 = exp2((_2465.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2496 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2465.z < 0.155251145362854f) {
                                    _2510 = ((_2465.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((bool)(_2465.z >= 0.155251145362854f) && (bool)(_2465.z < 1.4679962396621704f)) {
                                      _2510 = exp2((_2465.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2510 = 65504.0f;
                                    }
                                  }
                                  _2521 = (lerp(_2211, _2482, fTextureBlendRate2));
                                  _2522 = (lerp(_2225, _2496, fTextureBlendRate2));
                                  _2523 = (lerp(_2239, _2510, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2521 = _2211;
                      _2522 = _2225;
                      _2523 = _2239;
                    }
                  }
                  _2537 = (mad(_2523, (fColorMatrix[2].x), mad(_2522, (fColorMatrix[1].x), (_2521 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2538 = (mad(_2523, (fColorMatrix[2].y), mad(_2522, (fColorMatrix[1].y), (_2521 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2539 = (mad(_2523, (fColorMatrix[2].z), mad(_2522, (fColorMatrix[1].z), (_2521 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));

                  float3 new_color = CustomLUTColor(float3(_2128, _2129, _2130), float3(_2537, _2538, _2539));
                  _2537 = new_color.r;
                  _2538 = new_color.g;
                  _2539 = new_color.b;

                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2537 = _2128;
    _2538 = _2129;
    _2539 = _2130;
  }
  float _2540 = min(_2537, 65000.0f);
  float _2541 = min(_2538, 65000.0f);
  float _2542 = min(_2539, 65000.0f);
  bool _2545 = isfinite(max(max(_2540, _2541), _2542));
  float _2546 = select(_2545, _2540, 1.0f);
  float _2547 = select(_2545, _2541, 1.0f);
  float _2548 = select(_2545, _2542, 1.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2583 = saturate(((cvdR.x * _2546) + (cvdR.y * _2547)) + (cvdR.z * _2548));
    _2584 = saturate(((cvdG.x * _2546) + (cvdG.y * _2547)) + (cvdG.z * _2548));
    _2585 = saturate(((cvdB.x * _2546) + (cvdB.y * _2547)) + (cvdB.z * _2548));
  } else {
    _2583 = _2546;
    _2584 = _2547;
    _2585 = _2548;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2600 = screenInverseSize.x * SV_Position.x;
    float _2601 = screenInverseSize.y * SV_Position.y;
    float4 _2604 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2600, _2601), 0.0f);
    float _2609 = _2604.x * ColorParam.x;
    float _2610 = _2604.y * ColorParam.y;
    float _2611 = _2604.z * ColorParam.z;
    float _2614 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2600, _2601), 0.0f);
    float _2619 = (_2604.w * ColorParam.w) * saturate((_2614.x * Levels_Rate) + Levels_Range);
    do {
      if (_2609 < 0.5f) {
        _2631 = ((_2583 * 2.0f) * _2609);
      } else {
        _2631 = (1.0f - (((1.0f - _2583) * 2.0f) * (1.0f - _2609)));
      }
      do {
        if (_2610 < 0.5f) {
          _2643 = ((_2584 * 2.0f) * _2610);
        } else {
          _2643 = (1.0f - (((1.0f - _2584) * 2.0f) * (1.0f - _2610)));
        }
        do {
          if (_2611 < 0.5f) {
            _2655 = ((_2585 * 2.0f) * _2611);
          } else {
            _2655 = (1.0f - (((1.0f - _2585) * 2.0f) * (1.0f - _2611)));
          }
          _2666 = (lerp(_2583, _2631, _2619));
          _2667 = (lerp(_2584, _2643, _2619));
          _2668 = (lerp(_2585, _2655, _2619));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2666 = _2583;
    _2667 = _2584;
    _2668 = _2585;
  }

  // Original SDR Tonemapper
  if (tonemapParam_isHDRMode == 0.0f && ProcessSDRVanilla()) {
    float _2676 = invLinearBegin * _2666;
    do {
      if (!(_2666 >= linearBegin)) {
        _2684 = ((_2676 * _2676) * (3.0f - (_2676 * 2.0f)));
      } else {
        _2684 = 1.0f;
      }
      float _2685 = invLinearBegin * _2667;
      do {
        if (!(_2667 >= linearBegin)) {
          _2693 = ((_2685 * _2685) * (3.0f - (_2685 * 2.0f)));
        } else {
          _2693 = 1.0f;
        }
        float _2694 = invLinearBegin * _2668;
        do {
          if (!(_2668 >= linearBegin)) {
            _2702 = ((_2694 * _2694) * (3.0f - (_2694 * 2.0f)));
          } else {
            _2702 = 1.0f;
          }
          float _2711 = select((_2666 < linearStart), 0.0f, 1.0f);
          float _2712 = select((_2667 < linearStart), 0.0f, 1.0f);
          float _2713 = select((_2668 < linearStart), 0.0f, 1.0f);
          _2773 = (((((contrast * _2666) + madLinearStartContrastFactor) * (_2684 - _2711)) + (((pow(_2676, toe)) * (1.0f - _2684)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2666) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2711));
          _2774 = (((((contrast * _2667) + madLinearStartContrastFactor) * (_2693 - _2712)) + (((pow(_2685, toe)) * (1.0f - _2693)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2667) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2712));
          _2775 = (((((contrast * _2668) + madLinearStartContrastFactor) * (_2702 - _2713)) + (((pow(_2694, toe)) * (1.0f - _2702)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2668) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2713));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2773 = _2666;
    _2774 = _2667;
    _2775 = _2668;
  }
  SV_Target.x = _2773;
  SV_Target.y = _2774;
  SV_Target.z = _2775;
  SV_Target.w = 0.0f;
  return SV_Target;
}
