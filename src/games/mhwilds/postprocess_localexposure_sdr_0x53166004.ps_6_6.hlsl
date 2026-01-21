#define USE_CBUFFER_SLOT_B4

#include "./postprocess.hlsl"
#include "./tonemapper.hlsl"



Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Buffer<uint4> WhitePtSrv : register(t1);

Texture3D<float2> BilateralLuminanceSRV : register(t2);

Texture2D<float> BlurredLogLumSRV : register(t3);

Texture3D<float4> tTextureMap0 : register(t4);

Texture3D<float4> tTextureMap1 : register(t5);

Texture3D<float4> tTextureMap2 : register(t6);

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

cbuffer Tonemap : register(b2) {
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
  int LEBlurredLogDownsampleMip : packoffset(c005.y);
  int2 LELuminanceTextureSize : packoffset(c005.z);
};

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer LDRPostProcessParam : register(b5) {
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

cbuffer CBControl : register(b6) {
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

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _77;
  float _103;
  float _218;
  float _239;
  float _259;
  float _267;
  float _268;
  float _269;
  float _301;
  float _311;
  float _321;
  float _347;
  float _361;
  float _375;
  float _386;
  float _395;
  float _404;
  float _429;
  float _443;
  float _457;
  float _478;
  float _488;
  float _498;
  float _523;
  float _537;
  float _551;
  float _573;
  float _583;
  float _593;
  float _618;
  float _632;
  float _646;
  float _657;
  float _658;
  float _659;
  float _696;
  float _705;
  float _714;
  float _785;
  float _786;
  float _787;
  [branch]
  if (film_aspect == 0.0f) {
    float _38 = Kerare.x / Kerare.w;
    float _39 = Kerare.y / Kerare.w;
    float _40 = Kerare.z / Kerare.w;
    float _44 = abs(rsqrt(dot(float3(_38, _39, _40), float3(_38, _39, _40))) * _40);
    float _49 = _44 * _44;
    _77 = ((_49 * _49) * (1.0f - saturate((kerare_scale * _44) + kerare_offset)));
  } else {
    float _60 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _62 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _64 = sqrt(dot(float2(_62, _60), float2(_62, _60)));
    float _72 = (_64 * _64) + 1.0f;
    _77 = ((1.0f / (_72 * _72)) * (1.0f - saturate((kerare_scale * (1.0f / (_64 + 1.0f))) + kerare_offset)));
  }

  float _80 = saturate(_77 + kerare_brightness);
  CustomVignette(_80);
  _80 *= Exposure;

  float _84 = screenInverseSize.x * SV_Position.x;
  float _85 = screenInverseSize.y * SV_Position.y;
  float4 _88 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_84, _85));
  if (!(useAutoExposure == 0)) {
    int4 _99 = asint(WhitePtSrv[16 / 4]);
    _103 = asfloat(_99.x);
  } else {
    _103 = 1.0f;
  }
  float _104 = _103 * exposureAdjustment;
  float _115 = log2(dot(float3(((_104 * _88.x) * rangeDecompress), ((_104 * _88.y) * rangeDecompress), ((_104 * _88.z) * rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
  float2 _124 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_84, _85, ((((LEBilateralGridScale * _115) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
  float _129 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_84, _85), 0.0f);
  float _132 = select((_124.y < 0.0010000000474974513f), _129.x, (_124.x / _124.y));
  float _138 = (LEPreExposureLog + _132) + ((_129.x - _132) * 0.6000000238418579f);
  float _139 = LEPreExposureLog + _115;
  float _142 = _138 - LEMiddleGreyLog;
  float _154 = exp2((((select((_142 > 0.0f), LEHighlightContrast, LEShadowContrast) * _142) - _139) + LEMiddleGreyLog) + (LEDetailStrength * (_139 - _138)));

  _154 = PickExposure(_154);
  
  float _156 = (_88.x * _80) * _154;
  float _158 = (_88.y * _80) * _154;
  float _160 = (_88.z * _80) * _154;
  float _175 = mad(_160, (fOCIOTransformMatrix[2].x), mad(_158, (fOCIOTransformMatrix[1].x), (_156 * (fOCIOTransformMatrix[0].x))));
  float _178 = mad(_160, (fOCIOTransformMatrix[2].y), mad(_158, (fOCIOTransformMatrix[1].y), (_156 * (fOCIOTransformMatrix[0].y))));
  float _181 = mad(_160, (fOCIOTransformMatrix[2].z), mad(_158, (fOCIOTransformMatrix[1].z), (_156 * (fOCIOTransformMatrix[0].z))));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _187 = max(max(_175, _178), _181);
    if (!(_187 == 0.0f)) {
      float _193 = abs(_187);
      float _194 = (_187 - _175) / _193;
      float _195 = (_187 - _178) / _193;
      float _196 = (_187 - _181) / _193;
      do {
        if (!(!(_194 >= cbControlRGCParam.CyanThreshold))) {
          float _206 = _194 - cbControlRGCParam.CyanThreshold;
          _218 = ((_206 / exp2(log2(exp2(log2(_206 * cbControlRGCParam.InvCyanSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _218 = _194;
        }
        do {
          if (!(!(_195 >= cbControlRGCParam.MagentaThreshold))) {
            float _227 = _195 - cbControlRGCParam.MagentaThreshold;
            _239 = ((_227 / exp2(log2(exp2(log2(_227 * cbControlRGCParam.InvMagentaSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _239 = _195;
          }
          do {
            if (!(!(_196 >= cbControlRGCParam.YellowThreshold))) {
              float _247 = _196 - cbControlRGCParam.YellowThreshold;
              _259 = ((_247 / exp2(log2(exp2(log2(_247 * cbControlRGCParam.InvYellowSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _259 = _196;
            }
            _267 = (_187 - (_193 * _218));
            _268 = (_187 - (_193 * _239));
            _269 = (_187 - (_193 * _259));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _267 = _175;
      _268 = _178;
      _269 = _181;
    }
  } else {
    _267 = _175;
    _268 = _178;
    _269 = _181;
  }
  bool _292 = !(_267 <= 0.0078125f);
  if (!_292) {
    _301 = ((_267 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _301 = ((log2(_267) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _302 = !(_268 <= 0.0078125f);
  if (!_302) {
    _311 = ((_268 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _311 = ((log2(_268) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _312 = !(_269 <= 0.0078125f);
  if (!_312) {
    _321 = ((_269 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _321 = ((log2(_269) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _330 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_301 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_311 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_321 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_330.x < 0.155251145362854f) {
    _347 = ((_330.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_330.x >= 0.155251145362854f) && (bool)(_330.x < 1.4679962396621704f)) {
      _347 = exp2((_330.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _347 = 65504.0f;
    }
  }
  if (_330.y < 0.155251145362854f) {
    _361 = ((_330.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_330.y >= 0.155251145362854f) && (bool)(_330.y < 1.4679962396621704f)) {
      _361 = exp2((_330.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _361 = 65504.0f;
    }
  }
  if (_330.z < 0.155251145362854f) {
    _375 = ((_330.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_330.z >= 0.155251145362854f) && (bool)(_330.z < 1.4679962396621704f)) {
      _375 = exp2((_330.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _375 = 65504.0f;
    }
  }
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_292) {
        _386 = ((_267 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _386 = ((log2(_267) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_302) {
          _395 = ((_268 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _395 = ((log2(_268) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_312) {
            _404 = ((_269 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _404 = ((log2(_269) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _412 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_386 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_395 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_404 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_412.x < 0.155251145362854f) {
              _429 = ((_412.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_412.x >= 0.155251145362854f) && (bool)(_412.x < 1.4679962396621704f)) {
                _429 = exp2((_412.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _429 = 65504.0f;
              }
            }
            do {
              if (_412.y < 0.155251145362854f) {
                _443 = ((_412.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_412.y >= 0.155251145362854f) && (bool)(_412.y < 1.4679962396621704f)) {
                  _443 = exp2((_412.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _443 = 65504.0f;
                }
              }
              do {
                if (_412.z < 0.155251145362854f) {
                  _457 = ((_412.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_412.z >= 0.155251145362854f) && (bool)(_412.z < 1.4679962396621704f)) {
                    _457 = exp2((_412.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _457 = 65504.0f;
                  }
                }
                float _464 = ((_429 - _347) * fTextureBlendRate) + _347;
                float _465 = ((_443 - _361) * fTextureBlendRate) + _361;
                float _466 = ((_457 - _375) * fTextureBlendRate) + _375;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_464 <= 0.0078125f))) {
                      _478 = ((_464 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _478 = ((log2(_464) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_465 <= 0.0078125f))) {
                        _488 = ((_465 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _488 = ((log2(_465) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_466 <= 0.0078125f))) {
                          _498 = ((_466 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _498 = ((log2(_466) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _506 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_478 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_488 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_498 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_506.x < 0.155251145362854f) {
                            _523 = ((_506.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_506.x >= 0.155251145362854f) && (bool)(_506.x < 1.4679962396621704f)) {
                              _523 = exp2((_506.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _523 = 65504.0f;
                            }
                          }
                          do {
                            if (_506.y < 0.155251145362854f) {
                              _537 = ((_506.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_506.y >= 0.155251145362854f) && (bool)(_506.y < 1.4679962396621704f)) {
                                _537 = exp2((_506.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _537 = 65504.0f;
                              }
                            }
                            do {
                              if (_506.z < 0.155251145362854f) {
                                _551 = ((_506.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_506.z >= 0.155251145362854f) && (bool)(_506.z < 1.4679962396621704f)) {
                                  _551 = exp2((_506.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _551 = 65504.0f;
                                }
                              }
                              _657 = (lerp(_464, _523, fTextureBlendRate2));
                              _658 = (lerp(_465, _537, fTextureBlendRate2));
                              _659 = (lerp(_466, _551, fTextureBlendRate2));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _657 = _464;
                  _658 = _465;
                  _659 = _466;
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
        if (!(!(_347 <= 0.0078125f))) {
          _573 = ((_347 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _573 = ((log2(_347) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_361 <= 0.0078125f))) {
            _583 = ((_361 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _583 = ((log2(_361) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_375 <= 0.0078125f))) {
              _593 = ((_375 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _593 = ((log2(_375) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _601 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_573 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_583 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_593 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_601.x < 0.155251145362854f) {
                _618 = ((_601.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_601.x >= 0.155251145362854f) && (bool)(_601.x < 1.4679962396621704f)) {
                  _618 = exp2((_601.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _618 = 65504.0f;
                }
              }
              do {
                if (_601.y < 0.155251145362854f) {
                  _632 = ((_601.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_601.y >= 0.155251145362854f) && (bool)(_601.y < 1.4679962396621704f)) {
                    _632 = exp2((_601.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _632 = 65504.0f;
                  }
                }
                do {
                  if (_601.z < 0.155251145362854f) {
                    _646 = ((_601.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_601.z >= 0.155251145362854f) && (bool)(_601.z < 1.4679962396621704f)) {
                      _646 = exp2((_601.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _646 = 65504.0f;
                    }
                  }
                  _657 = (lerp(_347, _618, fTextureBlendRate2));
                  _658 = (lerp(_361, _632, fTextureBlendRate2));
                  _659 = (lerp(_375, _646, fTextureBlendRate2));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _657 = _347;
      _658 = _361;
      _659 = _375;
    }
  }
  float _672 = min((mad(_659, (fColorMatrix[2].x), mad(_658, (fColorMatrix[1].x), (_657 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x)), 65000.0f);
  float _673 = min((mad(_659, (fColorMatrix[2].y), mad(_658, (fColorMatrix[1].y), (_657 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y)), 65000.0f);
  float _674 = min((mad(_659, (fColorMatrix[2].z), mad(_658, (fColorMatrix[1].z), (_657 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z)), 65000.0f);

  float3 new_color = CustomLUTColor(float3(_267, _268, _269), float3(_672, _673, _674));
  _672 = new_color.r;
  _673 = new_color.g;
  _674 = new_color.b;

  bool _677 = isfinite(max(max(_672, _673), _674));
  float _678 = select(_677, _672, 1.0f);
  float _679 = select(_677, _673, 1.0f);
  float _680 = select(_677, _674, 1.0f);
  // if (tonemapParam_isHDRMode == 0.0f && ProcessSDRVanilla()) {
  //   float _688 = invLinearBegin * _678;
  //   do {
  //     if (!(_678 >= linearBegin)) {
  //       _696 = ((_688 * _688) * (3.0f - (_688 * 2.0f)));
  //     } else {
  //       _696 = 1.0f;
  //     }
  //     float _697 = invLinearBegin * _679;
  //     do {
  //       if (!(_679 >= linearBegin)) {
  //         _705 = ((_697 * _697) * (3.0f - (_697 * 2.0f)));
  //       } else {
  //         _705 = 1.0f;
  //       }
  //       float _706 = invLinearBegin * _680;
  //       do {
  //         if (!(_680 >= linearBegin)) {
  //           _714 = ((_706 * _706) * (3.0f - (_706 * 2.0f)));
  //         } else {
  //           _714 = 1.0f;
  //         }
  //         float _723 = select((_678 < linearStart), 0.0f, 1.0f);
  //         float _724 = select((_679 < linearStart), 0.0f, 1.0f);
  //         float _725 = select((_680 < linearStart), 0.0f, 1.0f);
  //         _785 = (((((contrast * _678) + madLinearStartContrastFactor) * (_696 - _723)) + (((pow(_688, toe)) * (1.0f - _696)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _678) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _723));
  //         _786 = (((((contrast * _679) + madLinearStartContrastFactor) * (_705 - _724)) + (((pow(_697, toe)) * (1.0f - _705)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _679) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _724));
  //         _787 = (((((contrast * _680) + madLinearStartContrastFactor) * (_714 - _725)) + (((pow(_706, toe)) * (1.0f - _714)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _680) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _725));
  //       } while (false);
  //     } while (false);
  //   } while (false);
  // } else {
  //   _785 = _678;
  //   _786 = _679;
  //   _787 = _680;
  // }
  // SV_Target.x = _785;
  // SV_Target.y = _786;
  // SV_Target.z = _787;

  SV_Target.xyz = CustomTonemap(float3(_678, _679, _680));

  SV_Target.w = 0.0f;
  return SV_Target;
}
