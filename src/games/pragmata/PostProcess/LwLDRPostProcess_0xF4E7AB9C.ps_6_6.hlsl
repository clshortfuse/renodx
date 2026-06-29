#define TONEMAP_PARAM_REGISTER b1
#include "./PostProcess.hlsli"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Texture3D<float4> tTextureMap0 : register(t1);

Texture3D<float4> tTextureMap1 : register(t2);

Texture3D<float4> tTextureMap2 : register(t3);

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

// cbuffer TonemapParam : register(b1) {
//   float contrast : packoffset(c000.x);
//   float linearBegin : packoffset(c000.y);
//   float linearLength : packoffset(c000.z);
//   float toe : packoffset(c000.w);
//   float maxNit : packoffset(c001.x);
//   float linearStart : packoffset(c001.y);
//   float displayMaxNitSubContrastFactor : packoffset(c001.z);
//   float contrastFactor : packoffset(c001.w);
//   float mulLinearStartContrastFactor : packoffset(c002.x);
//   float invLinearBegin : packoffset(c002.y);
//   float madLinearStartContrastFactor : packoffset(c002.z);
//   float tonemapParam_isHDRMode : packoffset(c002.w);
//   float useDynamicRangeConversion : packoffset(c003.x);
//   float useHuePreserve : packoffset(c003.y);
//   float exposureScale : packoffset(c003.z);
//   float kneeStartNit : packoffset(c003.w);
//   float knee : packoffset(c004.x);
//   float curve_HDRip : packoffset(c004.y);
//   float curve_k2 : packoffset(c004.z);
//   float curve_k4 : packoffset(c004.w);
//   row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
//   row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
//   float tonemapGraphScale : packoffset(c013.x);
//   float offsetEVCurveStart : packoffset(c013.y);
//   float offsetEVCurveRange : packoffset(c013.z);
// };

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


SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float4 _25 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _29 = _25.x * Exposure;
  float _30 = _25.y * Exposure;
  float _31 = _25.z * Exposure;
  float _46 = mad(_31, (fOCIOTransformMatrix[2].x), mad(_30, (fOCIOTransformMatrix[1].x), (_29 * (fOCIOTransformMatrix[0].x))));
  float _49 = mad(_31, (fOCIOTransformMatrix[2].y), mad(_30, (fOCIOTransformMatrix[1].y), (_29 * (fOCIOTransformMatrix[0].y))));
  float _52 = mad(_31, (fOCIOTransformMatrix[2].z), mad(_30, (fOCIOTransformMatrix[1].z), (_29 * (fOCIOTransformMatrix[0].z))));
  float _89;
  float _110;
  float _130;
  float _138;
  float _139;
  float _140;
  float _172;
  float _182;
  float _192;
  float _218;
  float _232;
  float _246;
  float _260;
  float _269;
  float _278;
  float _303;
  float _317;
  float _331;
  float _355;
  float _365;
  float _375;
  float _400;
  float _414;
  float _428;
  float _453;
  float _463;
  float _473;
  float _498;
  float _512;
  float _526;
  float _540;
  float _541;
  float _542;
  float _579;
  float _588;
  float _597;
  float _668;
  float _669;
  float _670;
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _58 = max(max(_46, _49), _52);
    if (!(_58 == 0.0f)) {
      float _64 = abs(_58);
      float _65 = (_58 - _46) / _64;
      float _66 = (_58 - _49) / _64;
      float _67 = (_58 - _52) / _64;
      do {
        if (!(!(_65 >= cbControlRGCParam.CyanThreshold))) {
          float _77 = _65 - cbControlRGCParam.CyanThreshold;
          _89 = ((_77 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _77) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _89 = _65;
        }
        do {
          if (!(!(_66 >= cbControlRGCParam.MagentaThreshold))) {
            float _98 = _66 - cbControlRGCParam.MagentaThreshold;
            _110 = ((_98 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _98) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _110 = _66;
          }
          do {
            if (!(!(_67 >= cbControlRGCParam.YellowThreshold))) {
              float _118 = _67 - cbControlRGCParam.YellowThreshold;
              _130 = ((_118 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _118) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _130 = _67;
            }
            _138 = (_58 - (_89 * _64));
            _139 = (_58 - (_110 * _64));
            _140 = (_58 - (_130 * _64));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _138 = _46;
      _139 = _49;
      _140 = _52;
    }
  } else {
    _138 = _46;
    _139 = _49;
    _140 = _52;
  }
  bool _163 = !(_138 <= 0.0078125f);
  if (!_163) {
    _172 = ((_138 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _172 = ((log2(_138) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _173 = !(_139 <= 0.0078125f);
  if (!_173) {
    _182 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _182 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _183 = !(_140 <= 0.0078125f);
  if (!_183) {
    _192 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _192 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _201 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_172 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_182 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_192 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_201.x < 0.155251145362854f) {
    _218 = ((_201.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_201.x >= 0.155251145362854f) && (bool)(_201.x < 1.4679962396621704f)) {
      _218 = exp2((_201.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _218 = 65504.0f;
    }
  }
  if (_201.y < 0.155251145362854f) {
    _232 = ((_201.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_201.y >= 0.155251145362854f) && (bool)(_201.y < 1.4679962396621704f)) {
      _232 = exp2((_201.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _232 = 65504.0f;
    }
  }
  if (_201.z < 0.155251145362854f) {
    _246 = ((_201.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_201.z >= 0.155251145362854f) && (bool)(_201.z < 1.4679962396621704f)) {
      _246 = exp2((_201.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _246 = 65504.0f;
    }
  }
  float _247 = max(_218, 0.0f);
  float _248 = max(_232, 0.0f);
  float _249 = max(_246, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_163) {
        _260 = ((_138 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _260 = ((log2(_138) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_173) {
          _269 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _269 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_183) {
            _278 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _278 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _286 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_260 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_269 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_278 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_286.x < 0.155251145362854f) {
              _303 = ((_286.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_286.x >= 0.155251145362854f) && (bool)(_286.x < 1.4679962396621704f)) {
                _303 = exp2((_286.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _303 = 65504.0f;
              }
            }
            do {
              if (_286.y < 0.155251145362854f) {
                _317 = ((_286.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_286.y >= 0.155251145362854f) && (bool)(_286.y < 1.4679962396621704f)) {
                  _317 = exp2((_286.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _317 = 65504.0f;
                }
              }
              do {
                if (_286.z < 0.155251145362854f) {
                  _331 = ((_286.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_286.z >= 0.155251145362854f) && (bool)(_286.z < 1.4679962396621704f)) {
                    _331 = exp2((_286.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _331 = 65504.0f;
                  }
                }
                float _341 = ((max(_303, 0.0f) - _247) * fTextureBlendRate) + _247;
                float _342 = ((max(_317, 0.0f) - _248) * fTextureBlendRate) + _248;
                float _343 = ((max(_331, 0.0f) - _249) * fTextureBlendRate) + _249;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_341 <= 0.0078125f))) {
                      _355 = ((_341 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _355 = ((log2(_341) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_342 <= 0.0078125f))) {
                        _365 = ((_342 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _365 = ((log2(_342) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_343 <= 0.0078125f))) {
                          _375 = ((_343 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _375 = ((log2(_343) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _383 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_355 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_365 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_375 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_383.x < 0.155251145362854f) {
                            _400 = ((_383.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_383.x >= 0.155251145362854f) && (bool)(_383.x < 1.4679962396621704f)) {
                              _400 = exp2((_383.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _400 = 65504.0f;
                            }
                          }
                          do {
                            if (_383.y < 0.155251145362854f) {
                              _414 = ((_383.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_383.y >= 0.155251145362854f) && (bool)(_383.y < 1.4679962396621704f)) {
                                _414 = exp2((_383.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _414 = 65504.0f;
                              }
                            }
                            do {
                              if (_383.z < 0.155251145362854f) {
                                _428 = ((_383.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_383.z >= 0.155251145362854f) && (bool)(_383.z < 1.4679962396621704f)) {
                                  _428 = exp2((_383.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _428 = 65504.0f;
                                }
                              }
                              _540 = (((max(_400, 0.0f) - _341) * fTextureBlendRate2) + _341);
                              _541 = (((max(_414, 0.0f) - _342) * fTextureBlendRate2) + _342);
                              _542 = (((max(_428, 0.0f) - _343) * fTextureBlendRate2) + _343);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _540 = _341;
                  _541 = _342;
                  _542 = _343;
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
        if (!(!(_247 <= 0.0078125f))) {
          _453 = ((_247 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _453 = ((log2(_247) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_248 <= 0.0078125f))) {
            _463 = ((_248 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _463 = ((log2(_248) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_249 <= 0.0078125f))) {
              _473 = ((_249 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _473 = ((log2(_249) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _481 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_453 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_463 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_473 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_481.x < 0.155251145362854f) {
                _498 = ((_481.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_481.x >= 0.155251145362854f) && (bool)(_481.x < 1.4679962396621704f)) {
                  _498 = exp2((_481.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _498 = 65504.0f;
                }
              }
              do {
                if (_481.y < 0.155251145362854f) {
                  _512 = ((_481.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_481.y >= 0.155251145362854f) && (bool)(_481.y < 1.4679962396621704f)) {
                    _512 = exp2((_481.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _512 = 65504.0f;
                  }
                }
                do {
                  if (_481.z < 0.155251145362854f) {
                    _526 = ((_481.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_481.z >= 0.155251145362854f) && (bool)(_481.z < 1.4679962396621704f)) {
                      _526 = exp2((_481.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _526 = 65504.0f;
                    }
                  }
                  _540 = (((max(_498, 0.0f) - _247) * fTextureBlendRate2) + _247);
                  _541 = (((max(_512, 0.0f) - _248) * fTextureBlendRate2) + _248);
                  _542 = (((max(_526, 0.0f) - _249) * fTextureBlendRate2) + _249);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _540 = _247;
      _541 = _248;
      _542 = _249;
    }
  }
  float _555 = min((mad(_542, (fColorMatrix[2].x), mad(_541, (fColorMatrix[1].x), (_540 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x)), 65000.0f);
  float _556 = min((mad(_542, (fColorMatrix[2].y), mad(_541, (fColorMatrix[1].y), (_540 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y)), 65000.0f);
  float _557 = min((mad(_542, (fColorMatrix[2].z), mad(_541, (fColorMatrix[1].z), (_540 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z)), 65000.0f);
  bool _560 = isfinite(max(max(_555, _556), _557));
  float _561 = select(_560, _555, 1.0f);
  float _562 = select(_560, _556, 1.0f);
  float _563 = select(_560, _557, 1.0f);
  if (tonemapParam_isHDRMode == 0.0f) {
    float _571 = invLinearBegin * _561;
    do {
      if (!(_561 >= linearBegin)) {
        _579 = ((_571 * _571) * (3.0f - (_571 * 2.0f)));
      } else {
        _579 = 1.0f;
      }
      float _580 = invLinearBegin * _562;
      do {
        if (!(_562 >= linearBegin)) {
          _588 = ((_580 * _580) * (3.0f - (_580 * 2.0f)));
        } else {
          _588 = 1.0f;
        }
        float _589 = invLinearBegin * _563;
        do {
          if (!(_563 >= linearBegin)) {
            _597 = ((_589 * _589) * (3.0f - (_589 * 2.0f)));
          } else {
            _597 = 1.0f;
          }
          float _606 = select((_561 < linearStart), 0.0f, 1.0f);
          float _607 = select((_562 < linearStart), 0.0f, 1.0f);
          float _608 = select((_563 < linearStart), 0.0f, 1.0f);
          _668 = (((((1.0f - _579) * linearBegin) * (pow(_571, toe))) + ((_579 - _606) * ((contrast * _561) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _561) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _606));
          _669 = (((((1.0f - _588) * linearBegin) * (pow(_580, toe))) + ((_588 - _607) * ((contrast * _562) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _562) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _607));
          _670 = (((((1.0f - _597) * linearBegin) * (pow(_589, toe))) + ((_597 - _608) * ((contrast * _563) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _563) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _608));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _668 = _561;
    _669 = _562;
    _670 = _563;
  }
  SV_Target.x = _668;
  SV_Target.y = _669;
  SV_Target.z = _670;
  SV_Target.w = 0.0f;
  return SV_Target;
}

