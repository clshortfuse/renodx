#define TONEMAP_PARAM_REGISTER b1
#include "./PostProcess.hlsli"

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
  float4 _26 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _30 = _26.x * Exposure;
  float _31 = _26.y * Exposure;
  float _32 = _26.z * Exposure;
  float _47 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
  float _51 = ComputeResultSRV[0].computeAlpha;
  float _54 = ((1.0f - _47) + (_51 * _47)) * cbRadialColor.w;
  float _282;
  float _283;
  float _284;
  float _295;
  float _296;
  float _297;
  float _355;
  float _376;
  float _396;
  float _404;
  float _405;
  float _406;
  float _438;
  float _448;
  float _458;
  float _484;
  float _498;
  float _512;
  float _526;
  float _535;
  float _544;
  float _569;
  float _583;
  float _597;
  float _621;
  float _631;
  float _641;
  float _666;
  float _680;
  float _694;
  float _719;
  float _729;
  float _739;
  float _764;
  float _778;
  float _792;
  float _806;
  float _807;
  float _808;
  float _845;
  float _854;
  float _863;
  float _934;
  float _935;
  float _936;
  if (!(_54 == 0.0f)) {
    float _65 = screenInverseSize.x * SV_Position.x;
    float _66 = screenInverseSize.y * SV_Position.y;
    float _68 = _65 + (-0.5f - cbRadialScreenPos.x);
    float _70 = _66 + (-0.5f - cbRadialScreenPos.y);
    float _73 = select((_68 < 0.0f), (1.0f - _65), _65);
    float _76 = select((_70 < 0.0f), (1.0f - _66), _66);
    float _79 = rsqrt(dot(float2(_68, _70), float2(_68, _70))) * cbRadialSharpRange;
    uint _86 = uint(abs(_79 * _70)) + uint(abs(_79 * _68));
    uint _90 = ((_86 ^ 61) ^ ((uint)(_86) >> 16)) * 9;
    uint _93 = (((uint)(_90) >> 4) ^ _90) * 668265261;
    float _97 = float((uint)((int)(((uint)(_93) >> 15) ^ _93))) * 2.3283064365386963e-10f;
    float _101 = sqrt((_68 * _68) + (_70 * _70));
    float _103 = 1.0f / max(1.0f, _101);
    float _105 = cbRadialBlurPower * (_97 * _103);
    float _106 = _105 * -0.0011111111380159855f;
    float _113 = cbRadialScreenPos.x + 0.5f;
    float _115 = cbRadialScreenPos.y + 0.5f;
    float4 _117 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_106 * _73) + 1.0f) * _68) + _113), ((((_106 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _121 = _105 * -0.002222222276031971f;
    float4 _130 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_121 * _73) + 1.0f) * _68) + _113), ((((_121 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _134 = _105 * -0.0033333334140479565f;
    float4 _143 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_134 * _73) + 1.0f) * _68) + _113), ((((_134 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _147 = _105 * -0.004444444552063942f;
    float4 _156 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_147 * _73) + 1.0f) * _68) + _113), ((((_147 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _160 = _105 * -0.0055555556900799274f;
    float4 _169 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_160 * _73) + 1.0f) * _68) + _113), ((((_160 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _173 = _105 * -0.006666666828095913f;
    float4 _182 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_173 * _73) + 1.0f) * _68) + _113), ((((_173 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _186 = _105 * -0.007777777966111898f;
    float4 _195 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_186 * _73) + 1.0f) * _68) + _113), ((((_186 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _199 = _105 * -0.008888889104127884f;
    float4 _208 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_199 * _73) + 1.0f) * _68) + _113), ((((_199 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _214 = _97 * ((cbRadialBlurPower * -0.009999999776482582f) * _103);
    float4 _223 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_214 * _73) + 1.0f) * _68) + _113), ((((_214 * _76) + 1.0f) * _70) + _115)), 0.0f);
    float _236 = Exposure * 0.10000000149011612f;
    float _238 = (_236 * cbRadialColor.x) * (((((((((_117.x + _26.x) + _130.x) + _143.x) + _156.x) + _169.x) + _182.x) + _195.x) + _208.x) + _223.x);
    float _249 = (_236 * cbRadialColor.y) * (((((((((_117.y + _26.y) + _130.y) + _143.y) + _156.y) + _169.y) + _182.y) + _195.y) + _208.y) + _223.y);
    float _260 = (_236 * cbRadialColor.z) * (((((((((_117.z + _26.z) + _130.z) + _143.z) + _156.z) + _169.z) + _182.z) + _195.z) + _208.z) + _223.z);
    do {
      if (cbRadialMaskRate.x > 0.0f) {
        float _265 = saturate((_101 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _271 = (((_265 * _265) * cbRadialMaskRate.x) * (3.0f - (_265 * 2.0f))) + cbRadialMaskRate.y;
        _282 = ((_271 * (_238 - _30)) + _30);
        _283 = ((_271 * (_249 - _31)) + _31);
        _284 = ((_271 * (_260 - _32)) + _32);
      } else {
        _282 = _238;
        _283 = _249;
        _284 = _260;
      }
      _295 = (lerp(_30, _282, _54));
      _296 = (lerp(_31, _283, _54));
      _297 = (lerp(_32, _284, _54));
    } while (false);
  } else {
    _295 = _30;
    _296 = _31;
    _297 = _32;
  }
  float _312 = mad(_297, (fOCIOTransformMatrix[2].x), mad(_296, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _295)));
  float _315 = mad(_297, (fOCIOTransformMatrix[2].y), mad(_296, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _295)));
  float _318 = mad(_297, (fOCIOTransformMatrix[2].z), mad(_296, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _295)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _324 = max(max(_312, _315), _318);
    if (!(_324 == 0.0f)) {
      float _330 = abs(_324);
      float _331 = (_324 - _312) / _330;
      float _332 = (_324 - _315) / _330;
      float _333 = (_324 - _318) / _330;
      do {
        if (!(!(_331 >= cbControlRGCParam.CyanThreshold))) {
          float _343 = _331 - cbControlRGCParam.CyanThreshold;
          _355 = ((_343 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _343) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _355 = _331;
        }
        do {
          if (!(!(_332 >= cbControlRGCParam.MagentaThreshold))) {
            float _364 = _332 - cbControlRGCParam.MagentaThreshold;
            _376 = ((_364 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _364) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _376 = _332;
          }
          do {
            if (!(!(_333 >= cbControlRGCParam.YellowThreshold))) {
              float _384 = _333 - cbControlRGCParam.YellowThreshold;
              _396 = ((_384 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _384) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _396 = _333;
            }
            _404 = (_324 - (_355 * _330));
            _405 = (_324 - (_376 * _330));
            _406 = (_324 - (_396 * _330));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _404 = _312;
      _405 = _315;
      _406 = _318;
    }
  } else {
    _404 = _312;
    _405 = _315;
    _406 = _318;
  }
  bool _429 = !(_404 <= 0.0078125f);
  if (!_429) {
    _438 = ((_404 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _438 = ((log2(_404) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _439 = !(_405 <= 0.0078125f);
  if (!_439) {
    _448 = ((_405 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _448 = ((log2(_405) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _449 = !(_406 <= 0.0078125f);
  if (!_449) {
    _458 = ((_406 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _458 = ((log2(_406) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _467 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_438 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_448 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_458 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_467.x < 0.155251145362854f) {
    _484 = ((_467.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_467.x >= 0.155251145362854f) && (bool)(_467.x < 1.4679962396621704f)) {
      _484 = exp2((_467.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _484 = 65504.0f;
    }
  }
  if (_467.y < 0.155251145362854f) {
    _498 = ((_467.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_467.y >= 0.155251145362854f) && (bool)(_467.y < 1.4679962396621704f)) {
      _498 = exp2((_467.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _498 = 65504.0f;
    }
  }
  if (_467.z < 0.155251145362854f) {
    _512 = ((_467.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((bool)(_467.z >= 0.155251145362854f) && (bool)(_467.z < 1.4679962396621704f)) {
      _512 = exp2((_467.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _512 = 65504.0f;
    }
  }
  float _513 = max(_484, 0.0f);
  float _514 = max(_498, 0.0f);
  float _515 = max(_512, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!_429) {
        _526 = ((_404 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _526 = ((log2(_404) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_439) {
          _535 = ((_405 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _535 = ((log2(_405) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_449) {
            _544 = ((_406 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _544 = ((log2(_406) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _552 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_526 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_535 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_544 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_552.x < 0.155251145362854f) {
              _569 = ((_552.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_552.x >= 0.155251145362854f) && (bool)(_552.x < 1.4679962396621704f)) {
                _569 = exp2((_552.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _569 = 65504.0f;
              }
            }
            do {
              if (_552.y < 0.155251145362854f) {
                _583 = ((_552.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_552.y >= 0.155251145362854f) && (bool)(_552.y < 1.4679962396621704f)) {
                  _583 = exp2((_552.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _583 = 65504.0f;
                }
              }
              do {
                if (_552.z < 0.155251145362854f) {
                  _597 = ((_552.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_552.z >= 0.155251145362854f) && (bool)(_552.z < 1.4679962396621704f)) {
                    _597 = exp2((_552.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _597 = 65504.0f;
                  }
                }
                float _607 = ((max(_569, 0.0f) - _513) * fTextureBlendRate) + _513;
                float _608 = ((max(_583, 0.0f) - _514) * fTextureBlendRate) + _514;
                float _609 = ((max(_597, 0.0f) - _515) * fTextureBlendRate) + _515;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_607 <= 0.0078125f))) {
                      _621 = ((_607 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _621 = ((log2(_607) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_608 <= 0.0078125f))) {
                        _631 = ((_608 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _631 = ((log2(_608) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_609 <= 0.0078125f))) {
                          _641 = ((_609 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _641 = ((log2(_609) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _649 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_621 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_631 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_641 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_649.x < 0.155251145362854f) {
                            _666 = ((_649.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((bool)(_649.x >= 0.155251145362854f) && (bool)(_649.x < 1.4679962396621704f)) {
                              _666 = exp2((_649.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _666 = 65504.0f;
                            }
                          }
                          do {
                            if (_649.y < 0.155251145362854f) {
                              _680 = ((_649.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_649.y >= 0.155251145362854f) && (bool)(_649.y < 1.4679962396621704f)) {
                                _680 = exp2((_649.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _680 = 65504.0f;
                              }
                            }
                            do {
                              if (_649.z < 0.155251145362854f) {
                                _694 = ((_649.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_649.z >= 0.155251145362854f) && (bool)(_649.z < 1.4679962396621704f)) {
                                  _694 = exp2((_649.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _694 = 65504.0f;
                                }
                              }
                              _806 = (((max(_666, 0.0f) - _607) * fTextureBlendRate2) + _607);
                              _807 = (((max(_680, 0.0f) - _608) * fTextureBlendRate2) + _608);
                              _808 = (((max(_694, 0.0f) - _609) * fTextureBlendRate2) + _609);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _806 = _607;
                  _807 = _608;
                  _808 = _609;
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
        if (!(!(_513 <= 0.0078125f))) {
          _719 = ((_513 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _719 = ((log2(_513) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_514 <= 0.0078125f))) {
            _729 = ((_514 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _729 = ((log2(_514) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_515 <= 0.0078125f))) {
              _739 = ((_515 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _739 = ((log2(_515) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _747 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_719 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_729 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_739 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_747.x < 0.155251145362854f) {
                _764 = ((_747.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_747.x >= 0.155251145362854f) && (bool)(_747.x < 1.4679962396621704f)) {
                  _764 = exp2((_747.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _764 = 65504.0f;
                }
              }
              do {
                if (_747.y < 0.155251145362854f) {
                  _778 = ((_747.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_747.y >= 0.155251145362854f) && (bool)(_747.y < 1.4679962396621704f)) {
                    _778 = exp2((_747.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _778 = 65504.0f;
                  }
                }
                do {
                  if (_747.z < 0.155251145362854f) {
                    _792 = ((_747.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((bool)(_747.z >= 0.155251145362854f) && (bool)(_747.z < 1.4679962396621704f)) {
                      _792 = exp2((_747.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _792 = 65504.0f;
                    }
                  }
                  _806 = (((max(_764, 0.0f) - _513) * fTextureBlendRate2) + _513);
                  _807 = (((max(_778, 0.0f) - _514) * fTextureBlendRate2) + _514);
                  _808 = (((max(_792, 0.0f) - _515) * fTextureBlendRate2) + _515);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _806 = _513;
      _807 = _514;
      _808 = _515;
    }
  }
  float _821 = min((mad(_808, (fColorMatrix[2].x), mad(_807, (fColorMatrix[1].x), (_806 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x)), 65000.0f);
  float _822 = min((mad(_808, (fColorMatrix[2].y), mad(_807, (fColorMatrix[1].y), (_806 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y)), 65000.0f);
  float _823 = min((mad(_808, (fColorMatrix[2].z), mad(_807, (fColorMatrix[1].z), (_806 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z)), 65000.0f);
  bool _826 = isfinite(max(max(_821, _822), _823));
  float _827 = select(_826, _821, 1.0f);
  float _828 = select(_826, _822, 1.0f);
  float _829 = select(_826, _823, 1.0f);
  if (tonemapParam_isHDRMode == 0.0f) {
    float _837 = invLinearBegin * _827;
    do {
      if (!(_827 >= linearBegin)) {
        _845 = ((_837 * _837) * (3.0f - (_837 * 2.0f)));
      } else {
        _845 = 1.0f;
      }
      float _846 = invLinearBegin * _828;
      do {
        if (!(_828 >= linearBegin)) {
          _854 = ((_846 * _846) * (3.0f - (_846 * 2.0f)));
        } else {
          _854 = 1.0f;
        }
        float _855 = invLinearBegin * _829;
        do {
          if (!(_829 >= linearBegin)) {
            _863 = ((_855 * _855) * (3.0f - (_855 * 2.0f)));
          } else {
            _863 = 1.0f;
          }
          float _872 = select((_827 < linearStart), 0.0f, 1.0f);
          float _873 = select((_828 < linearStart), 0.0f, 1.0f);
          float _874 = select((_829 < linearStart), 0.0f, 1.0f);
          _934 = (((((1.0f - _845) * linearBegin) * (pow(_837, toe))) + ((_845 - _872) * ((contrast * _827) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _827) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _872));
          _935 = (((((1.0f - _854) * linearBegin) * (pow(_846, toe))) + ((_854 - _873) * ((contrast * _828) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _828) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _873));
          _936 = (((((1.0f - _863) * linearBegin) * (pow(_855, toe))) + ((_863 - _874) * ((contrast * _829) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _829) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _874));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _934 = _827;
    _935 = _828;
    _936 = _829;
  }
  SV_Target.x = _934;
  SV_Target.y = _935;
  SV_Target.z = _936;
  SV_Target.w = 0.0f;
  return SV_Target;
}

