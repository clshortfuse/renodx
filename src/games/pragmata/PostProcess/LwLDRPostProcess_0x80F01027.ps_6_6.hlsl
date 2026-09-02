#include "../common.hlsli"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct RadialBlurComputeResult {
  float computeAlpha;
};
StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

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
  float4 _25 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _43 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
  float _47 = ComputeResultSRV[0].computeAlpha;
  float _50 = ((1.0f - _43) + (_47 * _43)) * cbRadialColor.w;
  float _247;
  float _248;
  float _249;
  float _260;
  float _261;
  float _262;
  float _325;
  float _346;
  float _366;
  float _374;
  float _375;
  float _376;
  float _408;
  float _418;
  float _428;
  float _454;
  float _468;
  float _482;
  float _496;
  float _505;
  float _514;
  float _539;
  float _553;
  float _567;
  float _591;
  float _601;
  float _611;
  float _636;
  float _650;
  float _664;
  float _689;
  float _699;
  float _709;
  float _734;
  float _748;
  float _762;
  float _776;
  float _777;
  float _778;
  if (!(_50 == 0.0f)) {
    float _60 = screenInverseSize.x * SV_Position.x;
    float _61 = screenInverseSize.y * SV_Position.y;
    float _63 = _60 + (-0.5f - cbRadialScreenPos.x);
    float _65 = _61 + (-0.5f - cbRadialScreenPos.y);
    float _75 = sqrt((_63 * _63) + (_65 * _65));
    float _77 = 1.0f / max(1.0f, _75);
    float _78 = -0.0f - cbRadialBlurPower;
    float _80 = (select((_63 < 0.0f), (1.0f - _60), _60) * _77) * _78;
    float _83 = (select((_65 < 0.0f), (1.0f - _61), _61) * _77) * _78;
    float _89 = cbRadialScreenPos.x + 0.5f;
    float _91 = cbRadialScreenPos.y + 0.5f;
    float4 _93 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.0011111111380159855f) + 1.0f) * _63) + _89), ((((_83 * 0.0011111111380159855f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _105 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.002222222276031971f) + 1.0f) * _63) + _89), ((((_83 * 0.002222222276031971f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _117 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.0033333334140479565f) + 1.0f) * _63) + _89), ((((_83 * 0.0033333334140479565f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _129 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.004444444552063942f) + 1.0f) * _63) + _89), ((((_83 * 0.004444444552063942f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _141 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.0055555556900799274f) + 1.0f) * _63) + _89), ((((_83 * 0.0055555556900799274f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _153 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.006666666828095913f) + 1.0f) * _63) + _89), ((((_83 * 0.006666666828095913f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _165 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.007777777966111898f) + 1.0f) * _63) + _89), ((((_83 * 0.007777777966111898f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _177 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.008888889104127884f) + 1.0f) * _63) + _89), ((((_83 * 0.008888889104127884f) + 1.0f) * _65) + _91)), 0.0f);
    float4 _189 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_80 * 0.009999999776482582f) + 1.0f) * _63) + _89), ((((_83 * 0.009999999776482582f) + 1.0f) * _65) + _91)), 0.0f);
    float _221 = (cbRadialColor.x * 0.10000000149011612f) * (((((((((_93.x + _25.x) + _105.x) + _117.x) + _129.x) + _141.x) + _153.x) + _165.x) + _177.x) + _189.x);
    float _223 = (cbRadialColor.y * 0.10000000149011612f) * (((((((((_93.y + _25.y) + _105.y) + _117.y) + _129.y) + _141.y) + _153.y) + _165.y) + _177.y) + _189.y);
    float _225 = (cbRadialColor.z * 0.10000000149011612f) * (((((((((_93.z + _25.z) + _105.z) + _117.z) + _129.z) + _141.z) + _153.z) + _165.z) + _177.z) + _189.z);
    do {
      if (cbRadialMaskRate.x > 0.0f) {
        float _230 = saturate((_75 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _236 = (((_230 * _230) * cbRadialMaskRate.x) * (3.0f - (_230 * 2.0f))) + cbRadialMaskRate.y;
        _247 = ((_236 * (_221 - _25.x)) + _25.x);
        _248 = ((_236 * (_223 - _25.y)) + _25.y);
        _249 = ((_236 * (_225 - _25.z)) + _25.z);
      } else {
        _247 = _221;
        _248 = _223;
        _249 = _225;
      }
      _260 = (lerp(_25.x, _247, _50));
      _261 = (lerp(_25.y, _248, _50));
      _262 = (lerp(_25.z, _249, _50));
    } while (false);
  } else {
    _260 = _25.x;
    _261 = _25.y;
    _262 = _25.z;
  }
  float _265 = rangeDecompress * _260;
  float _266 = rangeDecompress * _261;
  float _267 = rangeDecompress * _262;
  float _282 = mad(_267, (fOCIOTransformMatrix[2].x), mad(_266, (fOCIOTransformMatrix[1].x), (_265 * (fOCIOTransformMatrix[0].x))));
  float _285 = mad(_267, (fOCIOTransformMatrix[2].y), mad(_266, (fOCIOTransformMatrix[1].y), (_265 * (fOCIOTransformMatrix[0].y))));
  float _288 = mad(_267, (fOCIOTransformMatrix[2].z), mad(_266, (fOCIOTransformMatrix[1].z), (_265 * (fOCIOTransformMatrix[0].z))));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _294 = max(max(_282, _285), _288);
    if (!(_294 == 0.0f)) {
      float _300 = abs(_294);
      float _301 = (_294 - _282) / _300;
      float _302 = (_294 - _285) / _300;
      float _303 = (_294 - _288) / _300;
      do {
        if (!(!(_301 >= cbControlRGCParam.CyanThreshold))) {
          float _313 = _301 - cbControlRGCParam.CyanThreshold;
          _325 = ((_313 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _313) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _325 = _301;
        }
        do {
          if (!(!(_302 >= cbControlRGCParam.MagentaThreshold))) {
            float _334 = _302 - cbControlRGCParam.MagentaThreshold;
            _346 = ((_334 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _334) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _346 = _302;
          }
          do {
            if (!(!(_303 >= cbControlRGCParam.YellowThreshold))) {
              float _354 = _303 - cbControlRGCParam.YellowThreshold;
              _366 = ((_354 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _354) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _366 = _303;
            }
            _374 = (_294 - (_325 * _300));
            _375 = (_294 - (_346 * _300));
            _376 = (_294 - (_366 * _300));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _374 = _282;
      _375 = _285;
      _376 = _288;
    }
  } else {
    _374 = _282;
    _375 = _285;
    _376 = _288;
  }
  bool _399 = !(_374 <= 0.0078125f);
  if (!_399) {
    _408 = ((_374 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _408 = ((log2(_374) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _409 = !(_375 <= 0.0078125f);
  if (!_409) {
    _418 = ((_375 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _418 = ((log2(_375) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _419 = !(_376 <= 0.0078125f);
  if (!_419) {
    _428 = ((_376 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _428 = ((log2(_376) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _437 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_408 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_418 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_428 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_437.x < 0.155251145362854f) {
    _454 = ((_437.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_437.x >= 0.155251145362854f) && (bool)(_437.x < 1.4679962396621704f)) {
      _454 = exp2((_437.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _454 = 65504.0f;
    }
  }
  if (_437.y < 0.155251145362854f) {
    _468 = ((_437.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_437.y >= 0.155251145362854f) && (bool)(_437.y < 1.4679962396621704f)) {
      _468 = exp2((_437.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _468 = 65504.0f;
    }
  }
  if (_437.z < 0.155251145362854f) {
    _482 = ((_437.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_437.z >= 0.155251145362854f) && (bool)(_437.z < 1.4679962396621704f)) {
      _482 = exp2((_437.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _482 = 65504.0f;
    }
  }
  float _483 = max(_454, 0.0f);
  float _484 = max(_468, 0.0f);
  float _485 = max(_482, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_399) {
        _496 = ((_374 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _496 = ((log2(_374) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_409) {
          _505 = ((_375 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _505 = ((log2(_375) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_419) {
            _514 = ((_376 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _514 = ((log2(_376) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _522 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_496 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_505 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_514 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_522.x < 0.155251145362854f) {
              _539 = ((_522.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_522.x >= 0.155251145362854f) && (bool)(_522.x < 1.4679962396621704f)) {
                _539 = exp2((_522.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _539 = 65504.0f;
              }
            }
            do {
              if (_522.y < 0.155251145362854f) {
                _553 = ((_522.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_522.y >= 0.155251145362854f) && (bool)(_522.y < 1.4679962396621704f)) {
                  _553 = exp2((_522.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _553 = 65504.0f;
                }
              }
              do {
                if (_522.z < 0.155251145362854f) {
                  _567 = ((_522.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_522.z >= 0.155251145362854f) && (bool)(_522.z < 1.4679962396621704f)) {
                    _567 = exp2((_522.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _567 = 65504.0f;
                  }
                }
                float _577 = ((max(_539, 0.0f) - _483) * fTextureBlendRate) + _483;
                float _578 = ((max(_553, 0.0f) - _484) * fTextureBlendRate) + _484;
                float _579 = ((max(_567, 0.0f) - _485) * fTextureBlendRate) + _485;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_577 <= 0.0078125f))) {
                      _591 = ((_577 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _591 = ((log2(_577) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_578 <= 0.0078125f))) {
                        _601 = ((_578 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _601 = ((log2(_578) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_579 <= 0.0078125f))) {
                          _611 = ((_579 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _611 = ((log2(_579) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _619 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_591 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_601 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_611 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_619.x < 0.155251145362854f) {
                            _636 = ((_619.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_619.x >= 0.155251145362854f) && (bool)(_619.x < 1.4679962396621704f)) {
                              _636 = exp2((_619.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _636 = 65504.0f;
                            }
                          }
                          do {
                            if (_619.y < 0.155251145362854f) {
                              _650 = ((_619.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_619.y >= 0.155251145362854f) && (bool)(_619.y < 1.4679962396621704f)) {
                                _650 = exp2((_619.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _650 = 65504.0f;
                              }
                            }
                            do {
                              if (_619.z < 0.155251145362854f) {
                                _664 = ((_619.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_619.z >= 0.155251145362854f) && (bool)(_619.z < 1.4679962396621704f)) {
                                  _664 = exp2((_619.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _664 = 65504.0f;
                                }
                              }
                              _776 = (((max(_636, 0.0f) - _577) * fTextureBlendRate2) + _577);
                              _777 = (((max(_650, 0.0f) - _578) * fTextureBlendRate2) + _578);
                              _778 = (((max(_664, 0.0f) - _579) * fTextureBlendRate2) + _579);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _776 = _577;
                  _777 = _578;
                  _778 = _579;
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
        if (!(!(_483 <= 0.0078125f))) {
          _689 = ((_483 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _689 = ((log2(_483) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_484 <= 0.0078125f))) {
            _699 = ((_484 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _699 = ((log2(_484) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_485 <= 0.0078125f))) {
              _709 = ((_485 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _709 = ((log2(_485) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _717 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_689 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_699 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_709 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_717.x < 0.155251145362854f) {
                _734 = ((_717.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_717.x >= 0.155251145362854f) && (bool)(_717.x < 1.4679962396621704f)) {
                  _734 = exp2((_717.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _734 = 65504.0f;
                }
              }
              do {
                if (_717.y < 0.155251145362854f) {
                  _748 = ((_717.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_717.y >= 0.155251145362854f) && (bool)(_717.y < 1.4679962396621704f)) {
                    _748 = exp2((_717.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _748 = 65504.0f;
                  }
                }
                do {
                  if (_717.z < 0.155251145362854f) {
                    _762 = ((_717.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_717.z >= 0.155251145362854f) && (bool)(_717.z < 1.4679962396621704f)) {
                      _762 = exp2((_717.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _762 = 65504.0f;
                    }
                  }
                  _776 = (((max(_734, 0.0f) - _483) * fTextureBlendRate2) + _483);
                  _777 = (((max(_748, 0.0f) - _484) * fTextureBlendRate2) + _484);
                  _778 = (((max(_762, 0.0f) - _485) * fTextureBlendRate2) + _485);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _776 = _483;
      _777 = _484;
      _778 = _485;
    }
  }
  SV_Target.x = (mad(_778, (fColorMatrix[2].x), mad(_777, (fColorMatrix[1].x), (_776 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
  SV_Target.y = (mad(_778, (fColorMatrix[2].y), mad(_777, (fColorMatrix[1].y), (_776 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
  SV_Target.z = (mad(_778, (fColorMatrix[2].z), mad(_777, (fColorMatrix[1].z), (_776 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
  SV_Target.w = 0.0f;
  return SV_Target;
}
