#include "./PostProcess.hlsli"

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
};


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
  float SceneInfo_Reserve2 : packoffset(c039.x);
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

cbuffer CBControl : register(b3) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  RGCParam cbControlRGCParam : packoffset(c005.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float4 _24;
  float _30;
  float _31;
  float _32;
  float _47;
  float _50;
  float _53;
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
  float _258;
  float _267;
  float _276;
  float _301;
  float _315;
  float _329;
  float _350;
  float _360;
  float _370;
  float _395;
  float _409;
  float _423;
  float _445;
  float _455;
  float _465;
  float _490;
  float _504;
  float _518;
  float _529;
  float _530;
  float _531;
  float _59;
  float _65;
  float _66;
  float _67;
  float _68;
  float _78;
  float _99;
  float _119;
  bool _164;
  bool _174;
  bool _184;
  float4 _202;
  float4 _284;
  float _336;
  float _337;
  float _338;
  float4 _378;
  float4 _473;
  _24 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  _30 = rangeDecompress * _24.x;
  _31 = rangeDecompress * _24.y;
  _32 = rangeDecompress * _24.z;
  _47 = mad(_32, (fOCIOTransformMatrix[2].x), mad(_31, (fOCIOTransformMatrix[1].x), (_30 * (fOCIOTransformMatrix[0].x))));
  _50 = mad(_32, (fOCIOTransformMatrix[2].y), mad(_31, (fOCIOTransformMatrix[1].y), (_30 * (fOCIOTransformMatrix[0].y))));
  _53 = mad(_32, (fOCIOTransformMatrix[2].z), mad(_31, (fOCIOTransformMatrix[1].z), (_30 * (fOCIOTransformMatrix[0].z))));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _59 = max(max(_47, _50), _53);
    if (!(_59 == 0.0f)) {
      _65 = abs(_59);
      _66 = (_59 - _47) / _65;
      _67 = (_59 - _50) / _65;
      _68 = (_59 - _53) / _65;
      do {
        _90 = _66;
        if (!(!(_66 >= cbControlRGCParam.CyanThreshold))) {
          _78 = _66 - cbControlRGCParam.CyanThreshold;
          _90 = ((_78 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _78) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _111 = _67;
          if (!(!(_67 >= cbControlRGCParam.MagentaThreshold))) {
            _99 = _67 - cbControlRGCParam.MagentaThreshold;
            _111 = ((_99 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _99) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _131 = _68;
            if (!(!(_68 >= cbControlRGCParam.YellowThreshold))) {
              _119 = _68 - cbControlRGCParam.YellowThreshold;
              _131 = ((_119 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _119) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
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
#if 1
  ApplyColorCorrectTexturePass(
      true,
      _139, _140, _141,
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
      _529, _530, _531);
  SV_Target.x = _529;
  SV_Target.y = _530;
  SV_Target.z = _531;
#else
  _164 = !(_139 <= 0.0078125f);
  if (!(_164)) {
    _173 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _173 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _174 = !(_140 <= 0.0078125f);
  if (!(_174)) {
    _183 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _183 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _184 = !(_141 <= 0.0078125f);
  if (!(_184)) {
    _193 = ((_141 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _193 = ((log2(_141) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _202 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_173 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_183 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_193 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_202.x < 0.155251145362854f) {
    _219 = ((_202.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_202.x >= 0.155251145362854f) && (_202.x < 1.4679962396621704f)) {
      _219 = exp2((_202.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _219 = 65504.0f;
    }
  }
  if (_202.y < 0.155251145362854f) {
    _233 = ((_202.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_202.y >= 0.155251145362854f) && (_202.y < 1.4679962396621704f)) {
      _233 = exp2((_202.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _233 = 65504.0f;
    }
  }
  if (_202.z < 0.155251145362854f) {
    _247 = ((_202.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_202.z >= 0.155251145362854f) && (_202.z < 1.4679962396621704f)) {
      _247 = exp2((_202.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _247 = 65504.0f;
    }
  }
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!(_164)) {
        _258 = ((_139 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _258 = ((log2(_139) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!(_174)) {
          _267 = ((_140 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _267 = ((log2(_140) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(_184)) {
            _276 = ((_141 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _276 = ((log2(_141) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _284 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_258 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_267 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_276 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_284.x < 0.155251145362854f) {
              _301 = ((_284.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_284.x >= 0.155251145362854f) && (_284.x < 1.4679962396621704f)) {
                _301 = exp2((_284.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _301 = 65504.0f;
              }
            }
            do {
              if (_284.y < 0.155251145362854f) {
                _315 = ((_284.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_284.y >= 0.155251145362854f) && (_284.y < 1.4679962396621704f)) {
                  _315 = exp2((_284.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _315 = 65504.0f;
                }
              }
              do {
                if (_284.z < 0.155251145362854f) {
                  _329 = ((_284.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_284.z >= 0.155251145362854f) && (_284.z < 1.4679962396621704f)) {
                    _329 = exp2((_284.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _329 = 65504.0f;
                  }
                }
                _336 = ((_301 - _219) * fTextureBlendRate) + _219;
                _337 = ((_315 - _233) * fTextureBlendRate) + _233;
                _338 = ((_329 - _247) * fTextureBlendRate) + _247;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_336 <= 0.0078125f))) {
                      _350 = ((_336 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _350 = ((log2(_336) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_337 <= 0.0078125f))) {
                        _360 = ((_337 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _360 = ((log2(_337) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_338 <= 0.0078125f))) {
                          _370 = ((_338 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _370 = ((log2(_338) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        _378 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_350 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_360 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_370 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_378.x < 0.155251145362854f) {
                            _395 = ((_378.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((_378.x >= 0.155251145362854f) && (_378.x < 1.4679962396621704f)) {
                              _395 = exp2((_378.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _395 = 65504.0f;
                            }
                          }
                          do {
                            if (_378.y < 0.155251145362854f) {
                              _409 = ((_378.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_378.y >= 0.155251145362854f) && (_378.y < 1.4679962396621704f)) {
                                _409 = exp2((_378.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _409 = 65504.0f;
                              }
                            }
                            do {
                              if (_378.z < 0.155251145362854f) {
                                _423 = ((_378.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_378.z >= 0.155251145362854f) && (_378.z < 1.4679962396621704f)) {
                                  _423 = exp2((_378.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _423 = 65504.0f;
                                }
                              }
                              _529 = (lerp(_336, _395, fTextureBlendRate2));
                              _530 = (lerp(_337, _409, fTextureBlendRate2));
                              _531 = (lerp(_338, _423, fTextureBlendRate2));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _529 = _336;
                  _530 = _337;
                  _531 = _338;
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
        if (!(!(_219 <= 0.0078125f))) {
          _445 = ((_219 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _445 = ((log2(_219) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_233 <= 0.0078125f))) {
            _455 = ((_233 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _455 = ((log2(_233) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_247 <= 0.0078125f))) {
              _465 = ((_247 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _465 = ((log2(_247) + 9.720000267028809f) * 0.05707762390375137f);
            }
            _473 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_445 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_455 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_465 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_473.x < 0.155251145362854f) {
                _490 = ((_473.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_473.x >= 0.155251145362854f) && (_473.x < 1.4679962396621704f)) {
                  _490 = exp2((_473.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _490 = 65504.0f;
                }
              }
              do {
                if (_473.y < 0.155251145362854f) {
                  _504 = ((_473.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_473.y >= 0.155251145362854f) && (_473.y < 1.4679962396621704f)) {
                    _504 = exp2((_473.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _504 = 65504.0f;
                  }
                }
                do {
                  if (_473.z < 0.155251145362854f) {
                    _518 = ((_473.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((_473.z >= 0.155251145362854f) && (_473.z < 1.4679962396621704f)) {
                      _518 = exp2((_473.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _518 = 65504.0f;
                    }
                  }
                  _529 = (lerp(_219, _490, fTextureBlendRate2));
                  _530 = (lerp(_233, _504, fTextureBlendRate2));
                  _531 = (lerp(_247, _518, fTextureBlendRate2));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _529 = _219;
      _530 = _233;
      _531 = _247;
    }
  }
  SV_Target.x = (mad(_531, (fColorMatrix[2].x), mad(_530, (fColorMatrix[1].x), (_529 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
  SV_Target.y = (mad(_531, (fColorMatrix[2].y), mad(_530, (fColorMatrix[1].y), (_529 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
  SV_Target.z = (mad(_531, (fColorMatrix[2].z), mad(_530, (fColorMatrix[1].z), (_529 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
#endif
  SV_Target.w = 0.0f;
  return SV_Target;
}