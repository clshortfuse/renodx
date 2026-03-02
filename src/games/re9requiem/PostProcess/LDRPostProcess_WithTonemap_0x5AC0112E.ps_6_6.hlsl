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
  float _244;
  float _245;
  float _266;
  float _388;
  float _389;
  float _397;
  float _398;
  float _726;
  float _727;
  float _748;
  float _870;
  float _871;
  float _879;
  float _880;
  float _1011;
  float _1012;
  float _1035;
  float _1157;
  float _1158;
  float _1164;
  float _1165;
  float _1175;
  float _1176;
  float _1177;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  float _1190;
  float _1260;
  float _1815;
  float _1816;
  float _1817;
  float _1851;
  float _1852;
  float _1853;
  float _1864;
  float _1865;
  float _1866;
  float _1905;
  float _1921;
  float _1937;
  float _1965;
  float _1966;
  float _1967;
  float _2025;
  float _2046;
  float _2066;
  float _2074;
  float _2075;
  float _2076;
  float _2286;
  float _2287;
  float _2288;
  float _2302;
  float _2303;
  float _2304;
  float _2339;
  float _2340;
  float _2341;
  float _2384;
  float _2396;
  float _2408;
  float _2419;
  float _2420;
  float _2421;
  float _2482;
  float _2515;
  float _2526;
  float _2537;
  float _2538;
  float _2539;
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
    _98 = ((_70 * _70) * (1.0f - saturate((_65 * kerare_scale) + kerare_offset)));
  } else {
    float _81 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _83 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _85 = sqrt(dot(float2(_83, _81), float2(_83, _81)));
    float _93 = (_85 * _85) + 1.0f;
    _98 = ((1.0f / (_93 * _93)) * (1.0f - saturate(((1.0f / (_85 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _101 = saturate(_98 + kerare_brightness) * Exposure;
  if (_43) {
    float _118 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _119 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _120 = dot(float2(_118, _119), float2(_118, _119));
    float _122 = (_120 * fDistortionCoef) + 1.0f;
    float _123 = fCorrectCoef * _118;
    float _124 = _122 * _123;
    float _125 = fCorrectCoef * _119;
    float _126 = _122 * _125;
    float _127 = _124 + 0.5f;
    float _128 = _126 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _138 = HazeNoiseResult.Sample(BilinearWrap, float2(_127, _128));
            _397 = ((fHazeFilterScale * _138.x) + _127);
            _398 = ((fHazeFilterScale * _138.y) + _128);
          } else {
            bool _150 = ((fHazeFilterAttribute & 2) != 0);
            float _154 = tFilterTempMap1.Sample(BilinearWrap, float2(_127, _128));
            do {
              if (_150) {
                float _161 = ReadonlyDepth.SampleLevel(PointClamp, float2(_127, _128), 0.0f);
                float _169 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _127) + -1.0f;
                float _170 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _128);
                float _207 = 1.0f / (mad(_161.x, (viewProjInvMat[2].w), mad(_170, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _169))) + (viewProjInvMat[3].w));
                float _209 = _207 * (mad(_161.x, (viewProjInvMat[2].y), mad(_170, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _169))) + (viewProjInvMat[3].y));
                float _217 = (_207 * (mad(_161.x, (viewProjInvMat[2].x), mad(_170, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _169))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _218 = _209 - (transposeViewInvMat[1].w);
                float _219 = (_207 * (mad(_161.x, (viewProjInvMat[2].z), mad(_170, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _169))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _244 = saturate(max(((sqrt(((_218 * _218) + (_217 * _217)) + (_219 * _219)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_209 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _154.x);
                _245 = _161.x;
              } else {
                _244 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _154.x), _154.x);
                _245 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _259 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _266 = (1.0f - saturate(max((_259 * min(max((abs(_124) - fHazeFilterBorder), 0.0f), 1.0f)), (_259 * min(max((abs(_126) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _266 = 1.0f;
                }
                float _267 = _266 * _244;
                do {
                  if (!(_267 <= 9.999999747378752e-06f)) {
                    float _274 = -0.0f - _128;
                    float _297 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_274, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _127))) * fHazeFilterUVWOffset.w;
                    float _298 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_274, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _127))) * fHazeFilterUVWOffset.w;
                    float _299 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_274, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _127))) * fHazeFilterUVWOffset.w;
                    float _304 = tVolumeMap.Sample(BilinearWrap, float3((_297 + fHazeFilterUVWOffset.x), (_298 + fHazeFilterUVWOffset.y), (_299 + fHazeFilterUVWOffset.z)));
                    float _307 = _297 * 2.0f;
                    float _308 = _298 * 2.0f;
                    float _309 = _299 * 2.0f;
                    float _313 = tVolumeMap.Sample(BilinearWrap, float3((_307 + fHazeFilterUVWOffset.x), (_308 + fHazeFilterUVWOffset.y), (_309 + fHazeFilterUVWOffset.z)));
                    float _317 = _297 * 4.0f;
                    float _318 = _298 * 4.0f;
                    float _319 = _299 * 4.0f;
                    float _323 = tVolumeMap.Sample(BilinearWrap, float3((_317 + fHazeFilterUVWOffset.x), (_318 + fHazeFilterUVWOffset.y), (_319 + fHazeFilterUVWOffset.z)));
                    float _327 = _297 * 8.0f;
                    float _328 = _298 * 8.0f;
                    float _329 = _299 * 8.0f;
                    float _333 = tVolumeMap.Sample(BilinearWrap, float3((_327 + fHazeFilterUVWOffset.x), (_328 + fHazeFilterUVWOffset.y), (_329 + fHazeFilterUVWOffset.z)));
                    float _337 = fHazeFilterUVWOffset.x + 0.5f;
                    float _338 = fHazeFilterUVWOffset.y + 0.5f;
                    float _339 = fHazeFilterUVWOffset.z + 0.5f;
                    float _343 = tVolumeMap.Sample(BilinearWrap, float3((_297 + _337), (_298 + _338), (_299 + _339)));
                    float _349 = tVolumeMap.Sample(BilinearWrap, float3((_307 + _337), (_308 + _338), (_309 + _339)));
                    float _356 = tVolumeMap.Sample(BilinearWrap, float3((_317 + _337), (_318 + _338), (_319 + _339)));
                    float _363 = tVolumeMap.Sample(BilinearWrap, float3((_327 + _337), (_328 + _338), (_329 + _339)));
                    float _371 = ((((((_313.x * 0.25f) + (_304.x * 0.5f)) + (_323.x * 0.125f)) + (_333.x * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    float _372 = ((((((_349.x * 0.25f) + (_343.x * 0.5f)) + (_356.x * 0.125f)) + (_363.x * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    if (_150) {
                      float _381 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _371) + _127), ((fHazeFilterScale * _372) + _128)));
                      if (!((_381.x - _245) >= fHazeFilterDepthDiffBias)) {
                        _388 = _371;
                        _389 = _372;
                      } else {
                        _388 = 0.0f;
                        _389 = 0.0f;
                      }
                    } else {
                      _388 = _371;
                      _389 = _372;
                    }
                  } else {
                    _388 = 0.0f;
                    _389 = 0.0f;
                  }
                  _397 = ((fHazeFilterScale * _388) + _127);
                  _398 = ((fHazeFilterScale * _389) + _128);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _397 = _127;
          _398 = _128;
        }
        float4 _401 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_397, _398));
        _1182 = (_401.x * _101);
        _1183 = (_401.y * _101);
        _1184 = (_401.z * _101);
        _1185 = fDistortionCoef;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 0.0f;
        _1190 = fCorrectCoef;
      } while (false);
    } else {
      float _424 = ((saturate((sqrt((_118 * _118) + (_119 * _119)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        float _436 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        float _437 = _424 * 2.0f;
        float _441 = (((_436 * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _446 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_441 * _123) + 0.5f), ((_441 * _125) + 0.5f)));
        float _452 = ((((_436 + 0.125f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _457 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_452 * _123) + 0.5f), ((_452 * _125) + 0.5f)));
        float _464 = ((((_436 + 0.25f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _469 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_464 * _123) + 0.5f), ((_464 * _125) + 0.5f)));
        float _478 = ((((_436 + 0.375f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _483 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_478 * _123) + 0.5f), ((_478 * _125) + 0.5f)));
        float _492 = ((((_436 + 0.5f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _497 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_492 * _123) + 0.5f), ((_492 * _125) + 0.5f)));
        float _503 = ((((_436 + 0.625f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _508 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_503 * _123) + 0.5f), ((_503 * _125) + 0.5f)));
        float _516 = ((((_436 + 0.75f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _521 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_516 * _123) + 0.5f), ((_516 * _125) + 0.5f)));
        float _536 = ((((_436 + 0.875f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _541 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_536 * _123) + 0.5f), ((_536 * _125) + 0.5f)));
        float _548 = ((((_436 + 1.0f) * _437) + _120) * fDistortionCoef) + 1.0f;
        float4 _553 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_548 * _123) + 0.5f), ((_548 * _125) + 0.5f)));
        float _556 = _101 * 0.3199999928474426f;
        _1182 = ((((_457.x + _446.x) + (_469.x * 0.75f)) + (_483.x * 0.375f)) * _556);
        _1183 = ((_101 * 0.3636363744735718f) * ((((_508.y + _483.y) * 0.625f) + _497.y) + ((_521.y + _469.y) * 0.25f)));
        _1184 = (((((_521.z * 0.75f) + (_508.z * 0.375f)) + _541.z) + _553.z) * _556);
        _1185 = fDistortionCoef;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 0.0f;
        _1190 = fCorrectCoef;
      } else {
        float _562 = _424 + _120;
        float _564 = (_562 * fDistortionCoef) + 1.0f;
        float _571 = ((_562 + _424) * fDistortionCoef) + 1.0f;
        float4 _576 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_127, _128));
        float4 _579 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_564 * _123) + 0.5f), ((_564 * _125) + 0.5f)));
        float4 _582 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_571 * _123) + 0.5f), ((_571 * _125) + 0.5f)));
        _1182 = (_576.x * _101);
        _1183 = (_579.y * _101);
        _1184 = (_582.z * _101);
        _1185 = fDistortionCoef;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 0.0f;
        _1190 = fCorrectCoef;
      }
    }
  } else {
    if (_49) {
      float _592 = screenInverseSize.x * 2.0f;
      float _594 = screenInverseSize.y * 2.0f;
      float _596 = (_592 * SV_Position.x) + -1.0f;
      float _600 = sqrt((_596 * _596) + 1.0f);
      float _601 = 1.0f / _600;
      float _609 = ((_600 * fOptimizedParam.z) * (_601 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      float _610 = _609 * _596;
      float _612 = (_609 * ((_594 * SV_Position.y) + -1.0f)) * (((_601 + -1.0f) * fOptimizedParam.y) + 1.0f);
      float _613 = _610 + 0.5f;
      float _614 = _612 + 0.5f;
      do {
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            float2 _622 = HazeNoiseResult.Sample(BilinearWrap, float2(_613, _614));
            _879 = ((fHazeFilterScale * _622.x) + _613);
            _880 = ((fHazeFilterScale * _622.y) + _614);
          } else {
            bool _634 = ((fHazeFilterAttribute & 2) != 0);
            float _638 = tFilterTempMap1.Sample(BilinearWrap, float2(_613, _614));
            do {
              if (_634) {
                float _645 = ReadonlyDepth.SampleLevel(PointClamp, float2(_613, _614), 0.0f);
                float _651 = ((_592 * screenSize.x) * _613) + -1.0f;
                float _652 = 1.0f - ((_594 * screenSize.y) * _614);
                float _689 = 1.0f / (mad(_645.x, (viewProjInvMat[2].w), mad(_652, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _651))) + (viewProjInvMat[3].w));
                float _691 = _689 * (mad(_645.x, (viewProjInvMat[2].y), mad(_652, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _651))) + (viewProjInvMat[3].y));
                float _699 = (_689 * (mad(_645.x, (viewProjInvMat[2].x), mad(_652, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _651))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _700 = _691 - (transposeViewInvMat[1].w);
                float _701 = (_689 * (mad(_645.x, (viewProjInvMat[2].z), mad(_652, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _651))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _726 = saturate(max(((sqrt(((_700 * _700) + (_699 * _699)) + (_701 * _701)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_691 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _638.x);
                _727 = _645.x;
              } else {
                _726 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _638.x), _638.x);
                _727 = 0.0f;
              }
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _741 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _748 = (1.0f - saturate(max((_741 * min(max((abs(_610) - fHazeFilterBorder), 0.0f), 1.0f)), (_741 * min(max((abs(_612) - fHazeFilterBorder), 0.0f), 1.0f)))));
                } else {
                  _748 = 1.0f;
                }
                float _749 = _748 * _726;
                do {
                  if (!(_749 <= 9.999999747378752e-06f)) {
                    float _756 = -0.0f - _614;
                    float _779 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_756, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _613))) * fHazeFilterUVWOffset.w;
                    float _780 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_756, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _613))) * fHazeFilterUVWOffset.w;
                    float _781 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_756, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _613))) * fHazeFilterUVWOffset.w;
                    float _786 = tVolumeMap.Sample(BilinearWrap, float3((_779 + fHazeFilterUVWOffset.x), (_780 + fHazeFilterUVWOffset.y), (_781 + fHazeFilterUVWOffset.z)));
                    float _789 = _779 * 2.0f;
                    float _790 = _780 * 2.0f;
                    float _791 = _781 * 2.0f;
                    float _795 = tVolumeMap.Sample(BilinearWrap, float3((_789 + fHazeFilterUVWOffset.x), (_790 + fHazeFilterUVWOffset.y), (_791 + fHazeFilterUVWOffset.z)));
                    float _799 = _779 * 4.0f;
                    float _800 = _780 * 4.0f;
                    float _801 = _781 * 4.0f;
                    float _805 = tVolumeMap.Sample(BilinearWrap, float3((_799 + fHazeFilterUVWOffset.x), (_800 + fHazeFilterUVWOffset.y), (_801 + fHazeFilterUVWOffset.z)));
                    float _809 = _779 * 8.0f;
                    float _810 = _780 * 8.0f;
                    float _811 = _781 * 8.0f;
                    float _815 = tVolumeMap.Sample(BilinearWrap, float3((_809 + fHazeFilterUVWOffset.x), (_810 + fHazeFilterUVWOffset.y), (_811 + fHazeFilterUVWOffset.z)));
                    float _819 = fHazeFilterUVWOffset.x + 0.5f;
                    float _820 = fHazeFilterUVWOffset.y + 0.5f;
                    float _821 = fHazeFilterUVWOffset.z + 0.5f;
                    float _825 = tVolumeMap.Sample(BilinearWrap, float3((_779 + _819), (_780 + _820), (_781 + _821)));
                    float _831 = tVolumeMap.Sample(BilinearWrap, float3((_789 + _819), (_790 + _820), (_791 + _821)));
                    float _838 = tVolumeMap.Sample(BilinearWrap, float3((_799 + _819), (_800 + _820), (_801 + _821)));
                    float _845 = tVolumeMap.Sample(BilinearWrap, float3((_809 + _819), (_810 + _820), (_811 + _821)));
                    float _853 = ((((((_795.x * 0.25f) + (_786.x * 0.5f)) + (_805.x * 0.125f)) + (_815.x * 0.0625f)) * 2.0f) + -1.0f) * _749;
                    float _854 = ((((((_831.x * 0.25f) + (_825.x * 0.5f)) + (_838.x * 0.125f)) + (_845.x * 0.0625f)) * 2.0f) + -1.0f) * _749;
                    if (_634) {
                      float _863 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _853) + _613), ((fHazeFilterScale * _854) + _614)));
                      if (!((_863.x - _727) >= fHazeFilterDepthDiffBias)) {
                        _870 = _853;
                        _871 = _854;
                      } else {
                        _870 = 0.0f;
                        _871 = 0.0f;
                      }
                    } else {
                      _870 = _853;
                      _871 = _854;
                    }
                  } else {
                    _870 = 0.0f;
                    _871 = 0.0f;
                  }
                  _879 = ((fHazeFilterScale * _870) + _613);
                  _880 = ((fHazeFilterScale * _871) + _614);
                } while (false);
              } while (false);
            } while (false);
          }
        } else {
          _879 = _613;
          _880 = _614;
        }
        float4 _883 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_879, _880));
        _1182 = (_883.x * _101);
        _1183 = (_883.y * _101);
        _1184 = (_883.z * _101);
        _1185 = 0.0f;
        _1186 = fOptimizedParam.x;
        _1187 = fOptimizedParam.y;
        _1188 = fOptimizedParam.z;
        _1189 = fOptimizedParam.w;
        _1190 = 1.0f;
      } while (false);
    } else {
      float _891 = screenInverseSize.x * SV_Position.x;
      float _892 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_51) {
          float4 _896 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_891, _892));
          _1175 = _896.x;
          _1176 = _896.y;
          _1177 = _896.z;
        } else {
          do {
            if (!(fHazeFilterReductionResolution == 0)) {
              float2 _907 = HazeNoiseResult.Sample(BilinearWrap, float2(_891, _892));
              _1164 = (fHazeFilterScale * _907.x);
              _1165 = (fHazeFilterScale * _907.y);
            } else {
              bool _917 = ((fHazeFilterAttribute & 2) != 0);
              float _921 = tFilterTempMap1.Sample(BilinearWrap, float2(_891, _892));
              do {
                if (_917) {
                  float _928 = ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f);
                  float _936 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _891) + -1.0f;
                  float _937 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _892);
                  float _974 = 1.0f / (mad(_928.x, (viewProjInvMat[2].w), mad(_937, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _936))) + (viewProjInvMat[3].w));
                  float _976 = _974 * (mad(_928.x, (viewProjInvMat[2].y), mad(_937, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _936))) + (viewProjInvMat[3].y));
                  float _984 = (_974 * (mad(_928.x, (viewProjInvMat[2].x), mad(_937, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _936))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                  float _985 = _976 - (transposeViewInvMat[1].w);
                  float _986 = (_974 * (mad(_928.x, (viewProjInvMat[2].z), mad(_937, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _936))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                  _1011 = saturate(max(((sqrt(((_985 * _985) + (_984 * _984)) + (_986 * _986)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_976 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _921.x);
                  _1012 = _928.x;
                } else {
                  _1011 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _921.x), _921.x);
                  _1012 = 0.0f;
                }
                do {
                  if (!((fHazeFilterAttribute & 4) == 0)) {
                    float _1028 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                    _1035 = (1.0f - saturate(max((_1028 * min(max((abs(_891 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_1028 * min(max((abs(_892 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                  } else {
                    _1035 = 1.0f;
                  }
                  float _1036 = _1035 * _1011;
                  do {
                    if (!(_1036 <= 9.999999747378752e-06f)) {
                      float _1043 = -0.0f - _892;
                      float _1066 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_1043, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _891))) * fHazeFilterUVWOffset.w;
                      float _1067 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_1043, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _891))) * fHazeFilterUVWOffset.w;
                      float _1068 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_1043, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _891))) * fHazeFilterUVWOffset.w;
                      float _1073 = tVolumeMap.Sample(BilinearWrap, float3((_1066 + fHazeFilterUVWOffset.x), (_1067 + fHazeFilterUVWOffset.y), (_1068 + fHazeFilterUVWOffset.z)));
                      float _1076 = _1066 * 2.0f;
                      float _1077 = _1067 * 2.0f;
                      float _1078 = _1068 * 2.0f;
                      float _1082 = tVolumeMap.Sample(BilinearWrap, float3((_1076 + fHazeFilterUVWOffset.x), (_1077 + fHazeFilterUVWOffset.y), (_1078 + fHazeFilterUVWOffset.z)));
                      float _1086 = _1066 * 4.0f;
                      float _1087 = _1067 * 4.0f;
                      float _1088 = _1068 * 4.0f;
                      float _1092 = tVolumeMap.Sample(BilinearWrap, float3((_1086 + fHazeFilterUVWOffset.x), (_1087 + fHazeFilterUVWOffset.y), (_1088 + fHazeFilterUVWOffset.z)));
                      float _1096 = _1066 * 8.0f;
                      float _1097 = _1067 * 8.0f;
                      float _1098 = _1068 * 8.0f;
                      float _1102 = tVolumeMap.Sample(BilinearWrap, float3((_1096 + fHazeFilterUVWOffset.x), (_1097 + fHazeFilterUVWOffset.y), (_1098 + fHazeFilterUVWOffset.z)));
                      float _1106 = fHazeFilterUVWOffset.x + 0.5f;
                      float _1107 = fHazeFilterUVWOffset.y + 0.5f;
                      float _1108 = fHazeFilterUVWOffset.z + 0.5f;
                      float _1112 = tVolumeMap.Sample(BilinearWrap, float3((_1066 + _1106), (_1067 + _1107), (_1068 + _1108)));
                      float _1118 = tVolumeMap.Sample(BilinearWrap, float3((_1076 + _1106), (_1077 + _1107), (_1078 + _1108)));
                      float _1125 = tVolumeMap.Sample(BilinearWrap, float3((_1086 + _1106), (_1087 + _1107), (_1088 + _1108)));
                      float _1132 = tVolumeMap.Sample(BilinearWrap, float3((_1096 + _1106), (_1097 + _1107), (_1098 + _1108)));
                      float _1140 = ((((((_1082.x * 0.25f) + (_1073.x * 0.5f)) + (_1092.x * 0.125f)) + (_1102.x * 0.0625f)) * 2.0f) + -1.0f) * _1036;
                      float _1141 = ((((((_1118.x * 0.25f) + (_1112.x * 0.5f)) + (_1125.x * 0.125f)) + (_1132.x * 0.0625f)) * 2.0f) + -1.0f) * _1036;
                      if (_917) {
                        float _1150 = ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1140) + _891), ((fHazeFilterScale * _1141) + _892)));
                        if (!((_1150.x - _1012) >= fHazeFilterDepthDiffBias)) {
                          _1157 = _1140;
                          _1158 = _1141;
                        } else {
                          _1157 = 0.0f;
                          _1158 = 0.0f;
                        }
                      } else {
                        _1157 = _1140;
                        _1158 = _1141;
                      }
                    } else {
                      _1157 = 0.0f;
                      _1158 = 0.0f;
                    }
                    _1164 = (fHazeFilterScale * _1157);
                    _1165 = (fHazeFilterScale * _1158);
                  } while (false);
                } while (false);
              } while (false);
            }
            float4 _1170 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1164 + _891), (_1165 + _892)));
            _1175 = _1170.x;
            _1176 = _1170.y;
            _1177 = _1170.z;
          } while (false);
        }
        _1182 = (_1175 * _101);
        _1183 = (_1176 * _101);
        _1184 = (_1177 * _101);
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 0.0f;
        _1190 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1213 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1217 = ComputeResultSRV[0].computeAlpha;
    float _1220 = ((1.0f - _1213) + (_1217 * _1213)) * cbRadialColor.w;
    if (!(_1220 == 0.0f)) {
      float _1223 = screenInverseSize.x * SV_Position.x;
      float _1224 = screenInverseSize.y * SV_Position.y;
      float _1226 = _1223 + (-0.5f - cbRadialScreenPos.x);
      float _1228 = _1224 + (-0.5f - cbRadialScreenPos.y);
      float _1231 = select((_1226 < 0.0f), (1.0f - _1223), _1223);
      float _1234 = select((_1228 < 0.0f), (1.0f - _1224), _1224);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1240 = rsqrt(dot(float2(_1226, _1228), float2(_1226, _1228))) * cbRadialSharpRange;
          uint _1247 = uint(abs(_1240 * _1228)) + uint(abs(_1240 * _1226));
          uint _1251 = ((_1247 ^ 61) ^ ((uint)(_1247) >> 16)) * 9;
          uint _1254 = (((uint)(_1251) >> 4) ^ _1251) * 668265261;
          _1260 = (float((uint)((int)(((uint)(_1254) >> 15) ^ _1254))) * 2.3283064365386963e-10f);
        } else {
          _1260 = 1.0f;
        }
        float _1264 = sqrt((_1226 * _1226) + (_1228 * _1228));
        float _1266 = 1.0f / max(1.0f, _1264);
        float _1267 = _1260 * _1231;
        float _1268 = cbRadialBlurPower * _1266;
        float _1269 = _1268 * -0.0011111111380159855f;
        float _1271 = _1260 * _1234;
        float _1275 = ((_1269 * _1267) + 1.0f) * _1226;
        float _1276 = ((_1269 * _1271) + 1.0f) * _1228;
        float _1278 = _1268 * -0.002222222276031971f;
        float _1283 = ((_1278 * _1267) + 1.0f) * _1226;
        float _1284 = ((_1278 * _1271) + 1.0f) * _1228;
        float _1285 = _1268 * -0.0033333334140479565f;
        float _1290 = ((_1285 * _1267) + 1.0f) * _1226;
        float _1291 = ((_1285 * _1271) + 1.0f) * _1228;
        float _1292 = _1268 * -0.004444444552063942f;
        float _1297 = ((_1292 * _1267) + 1.0f) * _1226;
        float _1298 = ((_1292 * _1271) + 1.0f) * _1228;
        float _1299 = _1268 * -0.0055555556900799274f;
        float _1304 = ((_1299 * _1267) + 1.0f) * _1226;
        float _1305 = ((_1299 * _1271) + 1.0f) * _1228;
        float _1306 = _1268 * -0.006666666828095913f;
        float _1311 = ((_1306 * _1267) + 1.0f) * _1226;
        float _1312 = ((_1306 * _1271) + 1.0f) * _1228;
        float _1313 = _1268 * -0.007777777966111898f;
        float _1318 = ((_1313 * _1267) + 1.0f) * _1226;
        float _1319 = ((_1313 * _1271) + 1.0f) * _1228;
        float _1320 = _1268 * -0.008888889104127884f;
        float _1325 = ((_1320 * _1267) + 1.0f) * _1226;
        float _1326 = ((_1320 * _1271) + 1.0f) * _1228;
        float _1329 = _1266 * ((cbRadialBlurPower * -0.009999999776482582f) * _1260);
        float _1334 = ((_1329 * _1231) + 1.0f) * _1226;
        float _1335 = ((_1329 * _1234) + 1.0f) * _1228;
        do {
          if (_43) {
            float _1337 = _1275 + cbRadialScreenPos.x;
            float _1338 = _1276 + cbRadialScreenPos.y;
            float _1342 = ((dot(float2(_1337, _1338), float2(_1337, _1338)) * _1185) + 1.0f) * _1190;
            float4 _1348 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1342 * _1337) + 0.5f), ((_1342 * _1338) + 0.5f)), 0.0f);
            float _1352 = _1283 + cbRadialScreenPos.x;
            float _1353 = _1284 + cbRadialScreenPos.y;
            float _1357 = ((dot(float2(_1352, _1353), float2(_1352, _1353)) * _1185) + 1.0f) * _1190;
            float4 _1362 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1357 * _1352) + 0.5f), ((_1357 * _1353) + 0.5f)), 0.0f);
            float _1369 = _1290 + cbRadialScreenPos.x;
            float _1370 = _1291 + cbRadialScreenPos.y;
            float _1374 = ((dot(float2(_1369, _1370), float2(_1369, _1370)) * _1185) + 1.0f) * _1190;
            float4 _1379 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1374 * _1369) + 0.5f), ((_1374 * _1370) + 0.5f)), 0.0f);
            float _1386 = _1297 + cbRadialScreenPos.x;
            float _1387 = _1298 + cbRadialScreenPos.y;
            float _1391 = ((dot(float2(_1386, _1387), float2(_1386, _1387)) * _1185) + 1.0f) * _1190;
            float4 _1396 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1391 * _1386) + 0.5f), ((_1391 * _1387) + 0.5f)), 0.0f);
            float _1403 = _1304 + cbRadialScreenPos.x;
            float _1404 = _1305 + cbRadialScreenPos.y;
            float _1408 = ((dot(float2(_1403, _1404), float2(_1403, _1404)) * _1185) + 1.0f) * _1190;
            float4 _1413 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1408 * _1403) + 0.5f), ((_1408 * _1404) + 0.5f)), 0.0f);
            float _1420 = _1311 + cbRadialScreenPos.x;
            float _1421 = _1312 + cbRadialScreenPos.y;
            float _1425 = ((dot(float2(_1420, _1421), float2(_1420, _1421)) * _1185) + 1.0f) * _1190;
            float4 _1430 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1425 * _1420) + 0.5f), ((_1425 * _1421) + 0.5f)), 0.0f);
            float _1437 = _1318 + cbRadialScreenPos.x;
            float _1438 = _1319 + cbRadialScreenPos.y;
            float _1442 = ((dot(float2(_1437, _1438), float2(_1437, _1438)) * _1185) + 1.0f) * _1190;
            float4 _1447 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1442 * _1437) + 0.5f), ((_1442 * _1438) + 0.5f)), 0.0f);
            float _1454 = _1325 + cbRadialScreenPos.x;
            float _1455 = _1326 + cbRadialScreenPos.y;
            float _1459 = ((dot(float2(_1454, _1455), float2(_1454, _1455)) * _1185) + 1.0f) * _1190;
            float4 _1464 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1459 * _1454) + 0.5f), ((_1459 * _1455) + 0.5f)), 0.0f);
            float _1471 = _1334 + cbRadialScreenPos.x;
            float _1472 = _1335 + cbRadialScreenPos.y;
            float _1476 = ((dot(float2(_1471, _1472), float2(_1471, _1472)) * _1185) + 1.0f) * _1190;
            float4 _1481 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1476 * _1471) + 0.5f), ((_1476 * _1472) + 0.5f)), 0.0f);
            _1815 = ((((((((_1362.x + _1348.x) + _1379.x) + _1396.x) + _1413.x) + _1430.x) + _1447.x) + _1464.x) + _1481.x);
            _1816 = ((((((((_1362.y + _1348.y) + _1379.y) + _1396.y) + _1413.y) + _1430.y) + _1447.y) + _1464.y) + _1481.y);
            _1817 = ((((((((_1362.z + _1348.z) + _1379.z) + _1396.z) + _1413.z) + _1430.z) + _1447.z) + _1464.z) + _1481.z);
          } else {
            float _1489 = cbRadialScreenPos.x + 0.5f;
            float _1490 = _1275 + _1489;
            float _1491 = cbRadialScreenPos.y + 0.5f;
            float _1492 = _1276 + _1491;
            float _1493 = _1283 + _1489;
            float _1494 = _1284 + _1491;
            float _1495 = _1290 + _1489;
            float _1496 = _1291 + _1491;
            float _1497 = _1297 + _1489;
            float _1498 = _1298 + _1491;
            float _1499 = _1304 + _1489;
            float _1500 = _1305 + _1491;
            float _1501 = _1311 + _1489;
            float _1502 = _1312 + _1491;
            float _1503 = _1318 + _1489;
            float _1504 = _1319 + _1491;
            float _1505 = _1325 + _1489;
            float _1506 = _1326 + _1491;
            float _1507 = _1334 + _1489;
            float _1508 = _1335 + _1491;
            if (_49) {
              float _1512 = (_1490 * 2.0f) + -1.0f;
              float _1516 = sqrt((_1512 * _1512) + 1.0f);
              float _1517 = 1.0f / _1516;
              float _1524 = _1189 * 0.5f;
              float _1525 = ((_1516 * _1188) * (_1517 + _1186)) * _1524;
              float4 _1532 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1525 * _1512) + 0.5f), (((_1525 * ((_1492 * 2.0f) + -1.0f)) * (((_1517 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1538 = (_1493 * 2.0f) + -1.0f;
              float _1542 = sqrt((_1538 * _1538) + 1.0f);
              float _1543 = 1.0f / _1542;
              float _1550 = ((_1542 * _1188) * (_1543 + _1186)) * _1524;
              float4 _1556 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1550 * _1538) + 0.5f), (((_1550 * ((_1494 * 2.0f) + -1.0f)) * (((_1543 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1565 = (_1495 * 2.0f) + -1.0f;
              float _1569 = sqrt((_1565 * _1565) + 1.0f);
              float _1570 = 1.0f / _1569;
              float _1577 = ((_1569 * _1188) * (_1570 + _1186)) * _1524;
              float4 _1583 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1577 * _1565) + 0.5f), (((_1577 * ((_1496 * 2.0f) + -1.0f)) * (((_1570 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1592 = (_1497 * 2.0f) + -1.0f;
              float _1596 = sqrt((_1592 * _1592) + 1.0f);
              float _1597 = 1.0f / _1596;
              float _1604 = ((_1596 * _1188) * (_1597 + _1186)) * _1524;
              float4 _1610 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1604 * _1592) + 0.5f), (((_1604 * ((_1498 * 2.0f) + -1.0f)) * (((_1597 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1619 = (_1499 * 2.0f) + -1.0f;
              float _1623 = sqrt((_1619 * _1619) + 1.0f);
              float _1624 = 1.0f / _1623;
              float _1631 = ((_1623 * _1188) * (_1624 + _1186)) * _1524;
              float4 _1637 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1631 * _1619) + 0.5f), (((_1631 * ((_1500 * 2.0f) + -1.0f)) * (((_1624 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1646 = (_1501 * 2.0f) + -1.0f;
              float _1650 = sqrt((_1646 * _1646) + 1.0f);
              float _1651 = 1.0f / _1650;
              float _1658 = ((_1650 * _1188) * (_1651 + _1186)) * _1524;
              float4 _1664 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1658 * _1646) + 0.5f), (((_1658 * ((_1502 * 2.0f) + -1.0f)) * (((_1651 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1673 = (_1503 * 2.0f) + -1.0f;
              float _1677 = sqrt((_1673 * _1673) + 1.0f);
              float _1678 = 1.0f / _1677;
              float _1685 = ((_1677 * _1188) * (_1678 + _1186)) * _1524;
              float4 _1691 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1685 * _1673) + 0.5f), (((_1685 * ((_1504 * 2.0f) + -1.0f)) * (((_1678 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1700 = (_1505 * 2.0f) + -1.0f;
              float _1704 = sqrt((_1700 * _1700) + 1.0f);
              float _1705 = 1.0f / _1704;
              float _1712 = ((_1704 * _1188) * (_1705 + _1186)) * _1524;
              float4 _1718 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1712 * _1700) + 0.5f), (((_1712 * ((_1506 * 2.0f) + -1.0f)) * (((_1705 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              float _1727 = (_1507 * 2.0f) + -1.0f;
              float _1731 = sqrt((_1727 * _1727) + 1.0f);
              float _1732 = 1.0f / _1731;
              float _1739 = ((_1731 * _1188) * (_1732 + _1186)) * _1524;
              float4 _1745 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1739 * _1727) + 0.5f), (((_1739 * ((_1508 * 2.0f) + -1.0f)) * (((_1732 + -1.0f) * _1187) + 1.0f)) + 0.5f)), 0.0f);
              _1815 = ((((((((_1556.x + _1532.x) + _1583.x) + _1610.x) + _1637.x) + _1664.x) + _1691.x) + _1718.x) + _1745.x);
              _1816 = ((((((((_1556.y + _1532.y) + _1583.y) + _1610.y) + _1637.y) + _1664.y) + _1691.y) + _1718.y) + _1745.y);
              _1817 = ((((((((_1556.z + _1532.z) + _1583.z) + _1610.z) + _1637.z) + _1664.z) + _1691.z) + _1718.z) + _1745.z);
            } else {
              float4 _1754 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1490, _1492), 0.0f);
              float4 _1758 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1493, _1494), 0.0f);
              float4 _1765 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1495, _1496), 0.0f);
              float4 _1772 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1497, _1498), 0.0f);
              float4 _1779 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1499, _1500), 0.0f);
              float4 _1786 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1501, _1502), 0.0f);
              float4 _1793 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1503, _1504), 0.0f);
              float4 _1800 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1505, _1506), 0.0f);
              float4 _1807 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1507, _1508), 0.0f);
              _1815 = ((((((((_1758.x + _1754.x) + _1765.x) + _1772.x) + _1779.x) + _1786.x) + _1793.x) + _1800.x) + _1807.x);
              _1816 = ((((((((_1758.y + _1754.y) + _1765.y) + _1772.y) + _1779.y) + _1786.y) + _1793.y) + _1800.y) + _1807.y);
              _1817 = ((((((((_1758.z + _1754.z) + _1765.z) + _1772.z) + _1779.z) + _1786.z) + _1793.z) + _1800.z) + _1807.z);
            }
          }
          float _1827 = (cbRadialColor.z * (_1184 + (_101 * _1817))) * 0.10000000149011612f;
          float _1828 = (cbRadialColor.y * (_1183 + (_101 * _1816))) * 0.10000000149011612f;
          float _1829 = (cbRadialColor.x * (_1182 + (_101 * _1815))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1834 = saturate((_1264 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1840 = (((_1834 * _1834) * cbRadialMaskRate.x) * (3.0f - (_1834 * 2.0f))) + cbRadialMaskRate.y;
              _1851 = ((_1840 * (_1829 - _1182)) + _1182);
              _1852 = ((_1840 * (_1828 - _1183)) + _1183);
              _1853 = ((_1840 * (_1827 - _1184)) + _1184);
            } else {
              _1851 = _1829;
              _1852 = _1828;
              _1853 = _1827;
            }
            _1864 = (lerp(_1182, _1851, _1220));
            _1865 = (lerp(_1183, _1852, _1220));
            _1866 = (lerp(_1184, _1853, _1220));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1864 = _1182;
      _1865 = _1183;
      _1866 = _1184;
    }
  } else {
    _1864 = _1182;
    _1865 = _1183;
    _1866 = _1184;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1883 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1885 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1891 = frac(frac((_1885 * 0.005837149918079376f) + (_1883 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1891 < fNoiseDensity) {
        int _1896 = (uint)(uint(_1885 * _1883)) ^ 12345391;
        uint _1897 = _1896 * 3635641;
        _1905 = (float((uint)((int)((((uint)(_1897) >> 26) | ((uint)(_1896 * 232681024))) ^ _1897))) * 2.3283064365386963e-10f);
      } else {
        _1905 = 0.0f;
      }
      float _1907 = frac(_1891 * 757.4846801757812f);
      do {
        if (_1907 < fNoiseDensity) {
          int _1911 = asint(_1907) ^ 12345391;
          uint _1912 = _1911 * 3635641;
          _1921 = ((float((uint)((int)((((uint)(_1912) >> 26) | ((uint)(_1911 * 232681024))) ^ _1912))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1921 = 0.0f;
        }
        float _1923 = frac(_1907 * 757.4846801757812f);
        do {
          if (_1923 < fNoiseDensity) {
            int _1927 = asint(_1923) ^ 12345391;
            uint _1928 = _1927 * 3635641;
            _1937 = ((float((uint)((int)((((uint)(_1928) >> 26) | ((uint)(_1927 * 232681024))) ^ _1928))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1937 = 0.0f;
          }
          float _1938 = _1905 * fNoisePower.x * CUSTOM_NOISE;
          float _1939 = _1937 * fNoisePower.y * CUSTOM_NOISE;
          float _1940 = _1921 * fNoisePower.y * CUSTOM_NOISE;
          float _1954 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1864), saturate(_1865), saturate(_1866)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1965 = ((_1954 * (mad(_1940, 1.4019999504089355f, _1938) - _1864)) + _1864);
          _1966 = ((_1954 * (mad(_1940, -0.7139999866485596f, mad(_1939, -0.3440000116825104f, _1938)) - _1865)) + _1865);
          _1967 = ((_1954 * (mad(_1939, 1.7719999551773071f, _1938) - _1866)) + _1866);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1965 = _1864;
    _1966 = _1865;
    _1967 = _1866;
  }
  float _1982 = mad(_1967, (fOCIOTransformMatrix[2].x), mad(_1966, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1965)));
  float _1985 = mad(_1967, (fOCIOTransformMatrix[2].y), mad(_1966, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1965)));
  float _1988 = mad(_1967, (fOCIOTransformMatrix[2].z), mad(_1966, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1965)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1994 = max(max(_1982, _1985), _1988);
    if (!(_1994 == 0.0f)) {
      float _2000 = abs(_1994);
      float _2001 = (_1994 - _1982) / _2000;
      float _2002 = (_1994 - _1985) / _2000;
      float _2003 = (_1994 - _1988) / _2000;
      do {
        if (!(!(_2001 >= cbControlRGCParam.CyanThreshold))) {
          float _2013 = _2001 - cbControlRGCParam.CyanThreshold;
          _2025 = ((_2013 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _2013) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _2025 = _2001;
        }
        do {
          if (!(!(_2002 >= cbControlRGCParam.MagentaThreshold))) {
            float _2034 = _2002 - cbControlRGCParam.MagentaThreshold;
            _2046 = ((_2034 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _2034) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _2046 = _2002;
          }
          do {
            if (!(!(_2003 >= cbControlRGCParam.YellowThreshold))) {
              float _2054 = _2003 - cbControlRGCParam.YellowThreshold;
              _2066 = ((_2054 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _2054) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _2066 = _2003;
            }
            _2074 = (_1994 - (_2025 * _2000));
            _2075 = (_1994 - (_2046 * _2000));
            _2076 = (_1994 - (_2066 * _2000));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2074 = _1982;
      _2075 = _1985;
      _2076 = _1988;
    }
  } else {
    _2074 = _1982;
    _2075 = _1985;
    _2076 = _1988;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        true,
        cPassEnabled,
        _2074,
        _2075,
        _2076,
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
        _2302,
        _2303,
        _2304);
  #else
  if (!((cPassEnabled & 4) == 0)) {
    float _2126 = (((log2(select((_2074 < 3.0517578125e-05f), ((_2074 * 0.5f) + 1.52587890625e-05f), _2074)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2127 = (((log2(select((_2075 < 3.0517578125e-05f), ((_2075 * 0.5f) + 1.52587890625e-05f), _2075)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _2128 = (((log2(select((_2076 < 3.0517578125e-05f), ((_2076 * 0.5f) + 1.52587890625e-05f), _2076)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _2131 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2126, _2127, _2128), 0.0f);
    float _2144 = max(exp2((_2131.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2145 = max(exp2((_2131.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _2146 = max(exp2((_2131.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _2148 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _2151 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2126, _2127, _2128), 0.0f);
        float _2173 = ((max(exp2((_2151.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2144) * fTextureBlendRate) + _2144;
        float _2174 = ((max(exp2((_2151.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2145) * fTextureBlendRate) + _2145;
        float _2175 = ((max(exp2((_2151.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2146) * fTextureBlendRate) + _2146;
        if (_2148) {
          float4 _2205 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2173 < 3.0517578125e-05f), ((_2173 * 0.5f) + 1.52587890625e-05f), _2173)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2174 < 3.0517578125e-05f), ((_2174 * 0.5f) + 1.52587890625e-05f), _2174)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2175 < 3.0517578125e-05f), ((_2175 * 0.5f) + 1.52587890625e-05f), _2175)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2286 = (((max(exp2((_2205.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2173) * fTextureBlendRate2) + _2173);
          _2287 = (((max(exp2((_2205.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2174) * fTextureBlendRate2) + _2174);
          _2288 = (((max(exp2((_2205.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2175) * fTextureBlendRate2) + _2175);
        } else {
          _2286 = _2173;
          _2287 = _2174;
          _2288 = _2175;
        }
      } else {
        if (_2148) {
          float4 _2260 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_2144 < 3.0517578125e-05f), ((_2144 * 0.5f) + 1.52587890625e-05f), _2144)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2145 < 3.0517578125e-05f), ((_2145 * 0.5f) + 1.52587890625e-05f), _2145)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_2146 < 3.0517578125e-05f), ((_2146 * 0.5f) + 1.52587890625e-05f), _2146)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2286 = (((max(exp2((_2260.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2144) * fTextureBlendRate2) + _2144);
          _2287 = (((max(exp2((_2260.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2145) * fTextureBlendRate2) + _2145);
          _2288 = (((max(exp2((_2260.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _2146) * fTextureBlendRate2) + _2146);
        } else {
          _2286 = _2144;
          _2287 = _2145;
          _2288 = _2146;
        }
      }
      _2302 = (mad(_2288, (fColorMatrix[2].x), mad(_2287, (fColorMatrix[1].x), (_2286 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _2303 = (mad(_2288, (fColorMatrix[2].y), mad(_2287, (fColorMatrix[1].y), (_2286 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _2304 = (mad(_2288, (fColorMatrix[2].z), mad(_2287, (fColorMatrix[1].z), (_2286 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _2302 = _2074;
    _2303 = _2075;
    _2304 = _2076;
  }
  #endif
  float _2305 = min(_2302, 65000.0f);
  float _2306 = min(_2303, 65000.0f);
  float _2307 = min(_2304, 65000.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2339 = (((cvdR.x * _2305) + (cvdR.y * _2306)) + (cvdR.z * _2307));
    _2340 = (((cvdG.x * _2305) + (cvdG.y * _2306)) + (cvdG.z * _2307));
    _2341 = (((cvdB.x * _2305) + (cvdB.y * _2306)) + (cvdB.z * _2307));
  } else {
    _2339 = _2305;
    _2340 = _2306;
    _2341 = _2307;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2353 = screenInverseSize.x * SV_Position.x;
    float _2354 = screenInverseSize.y * SV_Position.y;
    float4 _2357 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2353, _2354), 0.0f);
    float _2362 = _2357.x * ColorParam.x;
    float _2363 = _2357.y * ColorParam.y;
    float _2364 = _2357.z * ColorParam.z;
    float _2367 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2353, _2354), 0.0f);
    float _2372 = (_2357.w * ColorParam.w) * saturate((_2367.x * Levels_Rate) + Levels_Range);
    do {
      if (_2362 < 0.5f) {
        _2384 = ((_2339 * 2.0f) * _2362);
      } else {
        _2384 = (1.0f - (((1.0f - _2339) * 2.0f) * (1.0f - _2362)));
      }
      do {
        if (_2363 < 0.5f) {
          _2396 = ((_2340 * 2.0f) * _2363);
        } else {
          _2396 = (1.0f - (((1.0f - _2340) * 2.0f) * (1.0f - _2363)));
        }
        do {
          if (_2364 < 0.5f) {
            _2408 = ((_2341 * 2.0f) * _2364);
          } else {
            _2408 = (1.0f - (((1.0f - _2341) * 2.0f) * (1.0f - _2364)));
          }
          _2419 = (lerp(_2339, _2384, _2372));
          _2420 = (lerp(_2340, _2396, _2372));
          _2421 = (lerp(_2341, _2408, _2372));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2419 = _2339;
    _2420 = _2340;
    _2421 = _2341;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _2461 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _2421, mad((RGBToXYZViaCrosstalkMatrix[0].y), _2420, ((RGBToXYZViaCrosstalkMatrix[0].x) * _2419)));
      float _2464 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _2421, mad((RGBToXYZViaCrosstalkMatrix[1].y), _2420, ((RGBToXYZViaCrosstalkMatrix[1].x) * _2419)));
      float _2469 = (_2464 + _2461) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _2421, mad((RGBToXYZViaCrosstalkMatrix[2].y), _2420, ((RGBToXYZViaCrosstalkMatrix[2].x) * _2419)));
      float _2470 = _2461 / _2469;
      float _2471 = _2464 / _2469;
      do {
        if (_2464 < curve_HDRip) {
          _2482 = (_2464 * exposureScale);
        } else {
          _2482 = ((log2((_2464 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _2484 = (_2470 / _2471) * _2482;
        float _2488 = (((1.0f - _2470) - _2471) / _2471) * _2482;
        _2537 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _2488, mad((XYZToRGBViaCrosstalkMatrix[0].y), _2482, (_2484 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _2538 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _2488, mad((XYZToRGBViaCrosstalkMatrix[1].y), _2482, (_2484 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _2539 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _2488, mad((XYZToRGBViaCrosstalkMatrix[2].y), _2482, (_2484 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_2419 < curve_HDRip) {
          _2515 = (exposureScale * _2419);
        } else {
          _2515 = ((log2((_2419 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_2420 < curve_HDRip) {
            _2526 = (exposureScale * _2420);
          } else {
            _2526 = ((log2((_2420 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_2421 < curve_HDRip) {
            _2537 = _2515;
            _2538 = _2526;
            _2539 = (exposureScale * _2421);
          } else {
            _2537 = _2515;
            _2538 = _2526;
            _2539 = ((log2((_2421 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _2537 = _2419;
    _2538 = _2420;
    _2539 = _2421;
  }
  SV_Target.x = _2537;
  SV_Target.y = _2538;
  SV_Target.z = _2539;
  SV_Target.w = 0.0f;
  return SV_Target;
}
