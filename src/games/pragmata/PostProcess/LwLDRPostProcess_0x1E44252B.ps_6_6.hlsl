#define TONEMAP_PARAM_REGISTER b2
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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

// cbuffer TonemapParam : register(b2) {
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
  } cbControlRGCParam: packoffset(c005.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float _70;
  float _145;
  float _166;
  float _186;
  float _194;
  float _195;
  float _196;
  float _228;
  float _238;
  float _248;
  float _274;
  float _288;
  float _302;
  float _316;
  float _325;
  float _334;
  float _359;
  float _373;
  float _387;
  float _411;
  float _421;
  float _431;
  float _456;
  float _470;
  float _484;
  float _509;
  float _519;
  float _529;
  float _554;
  float _568;
  float _582;
  float _596;
  float _597;
  float _598;
  float _635;
  float _644;
  float _653;
  float _724;
  float _725;
  float _726;
  [branch]
  if (film_aspect == 0.0f) {
    float _31 = Kerare.x / Kerare.w;
    float _32 = Kerare.y / Kerare.w;
    float _33 = Kerare.z / Kerare.w;
    float _37 = abs(rsqrt(dot(float3(_31, _32, _33), float3(_31, _32, _33))) * _33);
    float _42 = _37 * _37;
    _70 = ((_42 * _42) * (1.0f - saturate((_37 * kerare_scale) + kerare_offset)));
  } else {
    float _53 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _55 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _57 = sqrt(dot(float2(_55, _53), float2(_55, _53)));
    float _65 = (_57 * _57) + 1.0f;
    _70 = ((1.0f / (_65 * _65)) * (1.0f - saturate(((1.0f / (_57 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _73 = saturate(_70 + kerare_brightness) * Exposure;
  float4 _81 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _85 = _81.x * _73;
  float _86 = _81.y * _73;
  float _87 = _81.z * _73;
  float _102 = mad(_87, (fOCIOTransformMatrix[2].x), mad(_86, (fOCIOTransformMatrix[1].x), (_85 * (fOCIOTransformMatrix[0].x))));
  float _105 = mad(_87, (fOCIOTransformMatrix[2].y), mad(_86, (fOCIOTransformMatrix[1].y), (_85 * (fOCIOTransformMatrix[0].y))));
  float _108 = mad(_87, (fOCIOTransformMatrix[2].z), mad(_86, (fOCIOTransformMatrix[1].z), (_85 * (fOCIOTransformMatrix[0].z))));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _114 = max(max(_102, _105), _108);
    if (!(_114 == 0.0f)) {
      float _120 = abs(_114);
      float _121 = (_114 - _102) / _120;
      float _122 = (_114 - _105) / _120;
      float _123 = (_114 - _108) / _120;
      do {
        if (!(!(_121 >= cbControlRGCParam.CyanThreshold))) {
          float _133 = _121 - cbControlRGCParam.CyanThreshold;
          _145 = ((_133 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _133) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _145 = _121;
        }
        do {
          if (!(!(_122 >= cbControlRGCParam.MagentaThreshold))) {
            float _154 = _122 - cbControlRGCParam.MagentaThreshold;
            _166 = ((_154 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _154) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _166 = _122;
          }
          do {
            if (!(!(_123 >= cbControlRGCParam.YellowThreshold))) {
              float _174 = _123 - cbControlRGCParam.YellowThreshold;
              _186 = ((_174 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _174) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _186 = _123;
            }
            _194 = (_114 - (_145 * _120));
            _195 = (_114 - (_166 * _120));
            _196 = (_114 - (_186 * _120));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _194 = _102;
      _195 = _105;
      _196 = _108;
    }
  } else {
    _194 = _102;
    _195 = _105;
    _196 = _108;
  }
  bool _219 = !(_194 <= 0.0078125f);
  if (!_219) {
    _228 = ((_194 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _228 = ((log2(_194) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _229 = !(_195 <= 0.0078125f);
  if (!_229) {
    _238 = ((_195 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _238 = ((log2(_195) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _239 = !(_196 <= 0.0078125f);
  if (!_239) {
    _248 = ((_196 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _248 = ((log2(_196) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _257 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_228 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_238 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_248 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_257.x < 0.155251145362854f) {
    _274 = ((_257.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_257.x >= 0.155251145362854f) && (bool)(_257.x < 1.4679962396621704f)) {
      _274 = exp2((_257.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _274 = 65504.0f;
    }
  }
  if (_257.y < 0.155251145362854f) {
    _288 = ((_257.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_257.y >= 0.155251145362854f) && (bool)(_257.y < 1.4679962396621704f)) {
      _288 = exp2((_257.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _288 = 65504.0f;
    }
  }
  if (_257.z < 0.155251145362854f) {
    _302 = ((_257.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_257.z >= 0.155251145362854f) && (bool)(_257.z < 1.4679962396621704f)) {
      _302 = exp2((_257.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _302 = 65504.0f;
    }
  }
  float _303 = max(_274, 0.0f);
  float _304 = max(_288, 0.0f);
  float _305 = max(_302, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_219) {
        _316 = ((_194 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _316 = ((log2(_194) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_229) {
          _325 = ((_195 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _325 = ((log2(_195) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_239) {
            _334 = ((_196 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _334 = ((log2(_196) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _342 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_316 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_325 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_334 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_342.x < 0.155251145362854f) {
              _359 = ((_342.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_342.x >= 0.155251145362854f) && (bool)(_342.x < 1.4679962396621704f)) {
                _359 = exp2((_342.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _359 = 65504.0f;
              }
            }
            do {
              if (_342.y < 0.155251145362854f) {
                _373 = ((_342.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_342.y >= 0.155251145362854f) && (bool)(_342.y < 1.4679962396621704f)) {
                  _373 = exp2((_342.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _373 = 65504.0f;
                }
              }
              do {
                if (_342.z < 0.155251145362854f) {
                  _387 = ((_342.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_342.z >= 0.155251145362854f) && (bool)(_342.z < 1.4679962396621704f)) {
                    _387 = exp2((_342.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _387 = 65504.0f;
                  }
                }
                float _397 = ((max(_359, 0.0f) - _303) * fTextureBlendRate) + _303;
                float _398 = ((max(_373, 0.0f) - _304) * fTextureBlendRate) + _304;
                float _399 = ((max(_387, 0.0f) - _305) * fTextureBlendRate) + _305;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_397 <= 0.0078125f))) {
                      _411 = ((_397 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _411 = ((log2(_397) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_398 <= 0.0078125f))) {
                        _421 = ((_398 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _421 = ((log2(_398) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_399 <= 0.0078125f))) {
                          _431 = ((_399 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _431 = ((log2(_399) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _439 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_411 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_421 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_431 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_439.x < 0.155251145362854f) {
                            _456 = ((_439.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_439.x >= 0.155251145362854f) && (bool)(_439.x < 1.4679962396621704f)) {
                              _456 = exp2((_439.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _456 = 65504.0f;
                            }
                          }
                          do {
                            if (_439.y < 0.155251145362854f) {
                              _470 = ((_439.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_439.y >= 0.155251145362854f) && (bool)(_439.y < 1.4679962396621704f)) {
                                _470 = exp2((_439.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _470 = 65504.0f;
                              }
                            }
                            do {
                              if (_439.z < 0.155251145362854f) {
                                _484 = ((_439.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_439.z >= 0.155251145362854f) && (bool)(_439.z < 1.4679962396621704f)) {
                                  _484 = exp2((_439.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _484 = 65504.0f;
                                }
                              }
                              _596 = (((max(_456, 0.0f) - _397) * fTextureBlendRate2) + _397);
                              _597 = (((max(_470, 0.0f) - _398) * fTextureBlendRate2) + _398);
                              _598 = (((max(_484, 0.0f) - _399) * fTextureBlendRate2) + _399);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _596 = _397;
                  _597 = _398;
                  _598 = _399;
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
        if (!(!(_303 <= 0.0078125f))) {
          _509 = ((_303 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _509 = ((log2(_303) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_304 <= 0.0078125f))) {
            _519 = ((_304 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _519 = ((log2(_304) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_305 <= 0.0078125f))) {
              _529 = ((_305 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _529 = ((log2(_305) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _537 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_509 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_519 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_529 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_537.x < 0.155251145362854f) {
                _554 = ((_537.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_537.x >= 0.155251145362854f) && (bool)(_537.x < 1.4679962396621704f)) {
                  _554 = exp2((_537.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _554 = 65504.0f;
                }
              }
              do {
                if (_537.y < 0.155251145362854f) {
                  _568 = ((_537.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_537.y >= 0.155251145362854f) && (bool)(_537.y < 1.4679962396621704f)) {
                    _568 = exp2((_537.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _568 = 65504.0f;
                  }
                }
                do {
                  if (_537.z < 0.155251145362854f) {
                    _582 = ((_537.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_537.z >= 0.155251145362854f) && (bool)(_537.z < 1.4679962396621704f)) {
                      _582 = exp2((_537.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _582 = 65504.0f;
                    }
                  }
                  _596 = (((max(_554, 0.0f) - _303) * fTextureBlendRate2) + _303);
                  _597 = (((max(_568, 0.0f) - _304) * fTextureBlendRate2) + _304);
                  _598 = (((max(_582, 0.0f) - _305) * fTextureBlendRate2) + _305);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _596 = _303;
      _597 = _304;
      _598 = _305;
    }
  }
  float _611 = min((mad(_598, (fColorMatrix[2].x), mad(_597, (fColorMatrix[1].x), (_596 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x)), 65000.0f);
  float _612 = min((mad(_598, (fColorMatrix[2].y), mad(_597, (fColorMatrix[1].y), (_596 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y)), 65000.0f);
  float _613 = min((mad(_598, (fColorMatrix[2].z), mad(_597, (fColorMatrix[1].z), (_596 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z)), 65000.0f);
  bool _616 = isfinite(max(max(_611, _612), _613));
  float _617 = select(_616, _611, 1.0f);
  float _618 = select(_616, _612, 1.0f);
  float _619 = select(_616, _613, 1.0f);
  if (tonemapParam_isHDRMode == 0.0f) {
    float _627 = invLinearBegin * _617;
    do {
      if (!(_617 >= linearBegin)) {
        _635 = ((_627 * _627) * (3.0f - (_627 * 2.0f)));
      } else {
        _635 = 1.0f;
      }
      float _636 = invLinearBegin * _618;
      do {
        if (!(_618 >= linearBegin)) {
          _644 = ((_636 * _636) * (3.0f - (_636 * 2.0f)));
        } else {
          _644 = 1.0f;
        }
        float _645 = invLinearBegin * _619;
        do {
          if (!(_619 >= linearBegin)) {
            _653 = ((_645 * _645) * (3.0f - (_645 * 2.0f)));
          } else {
            _653 = 1.0f;
          }
          float _662 = select((_617 < linearStart), 0.0f, 1.0f);
          float _663 = select((_618 < linearStart), 0.0f, 1.0f);
          float _664 = select((_619 < linearStart), 0.0f, 1.0f);
          _724 = (((((1.0f - _635) * linearBegin) * (pow(_627, toe))) + ((_635 - _662) * ((contrast * _617) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _617) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _662));
          _725 = (((((1.0f - _644) * linearBegin) * (pow(_636, toe))) + ((_644 - _663) * ((contrast * _618) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _618) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _663));
          _726 = (((((1.0f - _653) * linearBegin) * (pow(_645, toe))) + ((_653 - _664) * ((contrast * _619) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _619) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _664));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _724 = _617;
    _725 = _618;
    _726 = _619;
  }
  SV_Target.x = _724;
  SV_Target.y = _725;
  SV_Target.z = _726;
  SV_Target.w = 0.0f;
  return SV_Target;
}

