#include "../common.hlsli"

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


SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float4 _24 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _30 = rangeDecompress * _24.x;
  float _31 = rangeDecompress * _24.y;
  float _32 = rangeDecompress * _24.z;
  float _47 = mad(_32, (fOCIOTransformMatrix[2].x), mad(_31, (fOCIOTransformMatrix[1].x), (_30 * (fOCIOTransformMatrix[0].x))));
  float _50 = mad(_32, (fOCIOTransformMatrix[2].y), mad(_31, (fOCIOTransformMatrix[1].y), (_30 * (fOCIOTransformMatrix[0].y))));
  float _53 = mad(_32, (fOCIOTransformMatrix[2].z), mad(_31, (fOCIOTransformMatrix[1].z), (_30 * (fOCIOTransformMatrix[0].z))));
  float _90;
  float _111;
  float _131;
  float _139;
  float _140;
  float _141;
  float _173;
  float _183;
  float _193;
  float _219;
  float _233;
  float _247;
  float _261;
  float _270;
  float _279;
  float _304;
  float _318;
  float _332;
  float _356;
  float _366;
  float _376;
  float _401;
  float _415;
  float _429;
  float _454;
  float _464;
  float _474;
  float _499;
  float _513;
  float _527;
  float _541;
  float _542;
  float _543;
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _59 = max(max(_47, _50), _53);
    if (!(_59 == 0.0f)) {
      float _65 = abs(_59);
      float _66 = (_59 - _47) / _65;
      float _67 = (_59 - _50) / _65;
      float _68 = (_59 - _53) / _65;
      do {
        if (!(!(_66 >= cbControlRGCParam.CyanThreshold))) {
          float _78 = _66 - cbControlRGCParam.CyanThreshold;
          _90 = ((_78 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _78) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _90 = _66;
        }
        do {
          if (!(!(_67 >= cbControlRGCParam.MagentaThreshold))) {
            float _99 = _67 - cbControlRGCParam.MagentaThreshold;
            _111 = ((_99 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _99) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _111 = _67;
          }
          do {
            if (!(!(_68 >= cbControlRGCParam.YellowThreshold))) {
              float _119 = _68 - cbControlRGCParam.YellowThreshold;
              _131 = ((_119 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _119) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _131 = _68;
            }
            _139 = (_59 - (_90 * _65));
            _140 = (_59 - (_111 * _65));
            _141 = (_59 - (_131 * _65));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _139 = _47;
      _140 = _50;
      _141 = _53;
    }
  } else {
    _139 = _47;
    _140 = _50;
    _141 = _53;
  }
  bool _164 = !(_139 <= 0.0078125f);
  if (!_164) {
    _173 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _173 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _174 = !(_140 <= 0.0078125f);
  if (!_174) {
    _183 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _183 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _184 = !(_141 <= 0.0078125f);
  if (!_184) {
    _193 = ((_141 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _193 = ((log2(_141) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _202 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_173 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_183 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_193 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_202.x < 0.155251145362854f) {
    _219 = ((_202.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_202.x >= 0.155251145362854f) && (bool)(_202.x < 1.4679962396621704f)) {
      _219 = exp2((_202.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _219 = 65504.0f;
    }
  }
  if (_202.y < 0.155251145362854f) {
    _233 = ((_202.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_202.y >= 0.155251145362854f) && (bool)(_202.y < 1.4679962396621704f)) {
      _233 = exp2((_202.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _233 = 65504.0f;
    }
  }
  if (_202.z < 0.155251145362854f) {
    _247 = ((_202.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_202.z >= 0.155251145362854f) && (bool)(_202.z < 1.4679962396621704f)) {
      _247 = exp2((_202.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _247 = 65504.0f;
    }
  }
  float _248 = max(_219, 0.0f);
  float _249 = max(_233, 0.0f);
  float _250 = max(_247, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_164) {
        _261 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _261 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_174) {
          _270 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _270 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_184) {
            _279 = ((_141 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _279 = ((log2(_141) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _287 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_261 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_270 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_279 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_287.x < 0.155251145362854f) {
              _304 = ((_287.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_287.x >= 0.155251145362854f) && (bool)(_287.x < 1.4679962396621704f)) {
                _304 = exp2((_287.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _304 = 65504.0f;
              }
            }
            do {
              if (_287.y < 0.155251145362854f) {
                _318 = ((_287.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_287.y >= 0.155251145362854f) && (bool)(_287.y < 1.4679962396621704f)) {
                  _318 = exp2((_287.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _318 = 65504.0f;
                }
              }
              do {
                if (_287.z < 0.155251145362854f) {
                  _332 = ((_287.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_287.z >= 0.155251145362854f) && (bool)(_287.z < 1.4679962396621704f)) {
                    _332 = exp2((_287.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _332 = 65504.0f;
                  }
                }
                float _342 = ((max(_304, 0.0f) - _248) * fTextureBlendRate) + _248;
                float _343 = ((max(_318, 0.0f) - _249) * fTextureBlendRate) + _249;
                float _344 = ((max(_332, 0.0f) - _250) * fTextureBlendRate) + _250;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_342 <= 0.0078125f))) {
                      _356 = ((_342 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _356 = ((log2(_342) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_343 <= 0.0078125f))) {
                        _366 = ((_343 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _366 = ((log2(_343) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_344 <= 0.0078125f))) {
                          _376 = ((_344 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _376 = ((log2(_344) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _384 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_356 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_366 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_376 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_384.x < 0.155251145362854f) {
                            _401 = ((_384.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_384.x >= 0.155251145362854f) && (bool)(_384.x < 1.4679962396621704f)) {
                              _401 = exp2((_384.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _401 = 65504.0f;
                            }
                          }
                          do {
                            if (_384.y < 0.155251145362854f) {
                              _415 = ((_384.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_384.y >= 0.155251145362854f) && (bool)(_384.y < 1.4679962396621704f)) {
                                _415 = exp2((_384.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _415 = 65504.0f;
                              }
                            }
                            do {
                              if (_384.z < 0.155251145362854f) {
                                _429 = ((_384.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_384.z >= 0.155251145362854f) && (bool)(_384.z < 1.4679962396621704f)) {
                                  _429 = exp2((_384.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _429 = 65504.0f;
                                }
                              }
                              _541 = (((max(_401, 0.0f) - _342) * fTextureBlendRate2) + _342);
                              _542 = (((max(_415, 0.0f) - _343) * fTextureBlendRate2) + _343);
                              _543 = (((max(_429, 0.0f) - _344) * fTextureBlendRate2) + _344);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _541 = _342;
                  _542 = _343;
                  _543 = _344;
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
        if (!(!(_248 <= 0.0078125f))) {
          _454 = ((_248 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _454 = ((log2(_248) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_249 <= 0.0078125f))) {
            _464 = ((_249 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _464 = ((log2(_249) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_250 <= 0.0078125f))) {
              _474 = ((_250 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _474 = ((log2(_250) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _482 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_454 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_464 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_474 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_482.x < 0.155251145362854f) {
                _499 = ((_482.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_482.x >= 0.155251145362854f) && (bool)(_482.x < 1.4679962396621704f)) {
                  _499 = exp2((_482.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _499 = 65504.0f;
                }
              }
              do {
                if (_482.y < 0.155251145362854f) {
                  _513 = ((_482.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_482.y >= 0.155251145362854f) && (bool)(_482.y < 1.4679962396621704f)) {
                    _513 = exp2((_482.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _513 = 65504.0f;
                  }
                }
                do {
                  if (_482.z < 0.155251145362854f) {
                    _527 = ((_482.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_482.z >= 0.155251145362854f) && (bool)(_482.z < 1.4679962396621704f)) {
                      _527 = exp2((_482.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _527 = 65504.0f;
                    }
                  }
                  _541 = (((max(_499, 0.0f) - _248) * fTextureBlendRate2) + _248);
                  _542 = (((max(_513, 0.0f) - _249) * fTextureBlendRate2) + _249);
                  _543 = (((max(_527, 0.0f) - _250) * fTextureBlendRate2) + _250);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _541 = _248;
      _542 = _249;
      _543 = _250;
    }
  }
  SV_Target.x = (mad(_543, (fColorMatrix[2].x), mad(_542, (fColorMatrix[1].x), (_541 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
  SV_Target.y = (mad(_543, (fColorMatrix[2].y), mad(_542, (fColorMatrix[1].y), (_541 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
  SV_Target.z = (mad(_543, (fColorMatrix[2].z), mad(_542, (fColorMatrix[1].z), (_541 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
  SV_Target.w = 0.0f;
  return SV_Target;
}
