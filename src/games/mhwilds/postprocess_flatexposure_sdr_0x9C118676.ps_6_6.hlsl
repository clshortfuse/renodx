#define USE_FLATEXPOSURE_SDR

#include "./postprocess.hlsl"

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

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
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
  float _313;
  float _322;
  float _331;
  float _356;
  float _370;
  float _384;
  float _405;
  float _415;
  float _425;
  float _450;
  float _464;
  float _478;
  float _500;
  float _510;
  float _520;
  float _545;
  float _559;
  float _573;
  float _584;
  float _585;
  float _586;
  float _626;
  float _635;
  float _644;
  float _715;
  float _716;
  float _717;
  [branch]
  if (film_aspect == 0.0f) {
    float _31 = Kerare.x / Kerare.w;
    float _32 = Kerare.y / Kerare.w;
    float _33 = Kerare.z / Kerare.w;
    float _37 = abs(rsqrt(dot(float3(_31, _32, _33), float3(_31, _32, _33))) * _33);
    float _42 = _37 * _37;
    _70 = ((_42 * _42) * (1.0f - saturate((kerare_scale * _37) + kerare_offset)));
  } else {
    float _53 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _55 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _57 = sqrt(dot(float2(_55, _53), float2(_55, _53)));
    float _65 = (_57 * _57) + 1.0f;
    _70 = ((1.0f / (_65 * _65)) * (1.0f - saturate((kerare_scale * (1.0f / (_57 + 1.0f))) + kerare_offset)));
  }

  float _73 = saturate(_70 + kerare_brightness);
  CustomVignette(_73);
  _73 *= Exposure;

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
          _145 = ((_133 / exp2(log2(exp2(log2(_133 * cbControlRGCParam.InvCyanSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _145 = _121;
        }
        do {
          if (!(!(_122 >= cbControlRGCParam.MagentaThreshold))) {
            float _154 = _122 - cbControlRGCParam.MagentaThreshold;
            _166 = ((_154 / exp2(log2(exp2(log2(_154 * cbControlRGCParam.InvMagentaSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _166 = _122;
          }
          do {
            if (!(!(_123 >= cbControlRGCParam.YellowThreshold))) {
              float _174 = _123 - cbControlRGCParam.YellowThreshold;
              _186 = ((_174 / exp2(log2(exp2(log2(_174 * cbControlRGCParam.InvYellowSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _186 = _123;
            }
            _194 = (_114 - (_120 * _145));
            _195 = (_114 - (_120 * _166));
            _196 = (_114 - (_120 * _186));
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

  float3 lut_output = SampleColorLUTs(
      float3(_194, _195, _196),
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp,
      fTextureBlendRate,
      fTextureBlendRate2,
      fColorMatrix);

  float3 new_color = CustomLUTColor(float3(_194, _195, _196), lut_output);
  float _602 = new_color.r;
  float _603 = new_color.g;
  float _604 = new_color.b;

  bool _607 = isfinite(max(max(_602, _603), _604));
  float _608 = select(_607, _602, 1.0f);
  float _609 = select(_607, _603, 1.0f);
  float _610 = select(_607, _604, 1.0f);
  // if (tonemapParam_isHDRMode == 0.0f) {
  //   float _618 = invLinearBegin * _608;
  //   do {
  //     if (!(_608 >= linearBegin)) {
  //       _626 = ((_618 * _618) * (3.0f - (_618 * 2.0f)));
  //     } else {
  //       _626 = 1.0f;
  //     }
  //     float _627 = invLinearBegin * _609;
  //     do {
  //       if (!(_609 >= linearBegin)) {
  //         _635 = ((_627 * _627) * (3.0f - (_627 * 2.0f)));
  //       } else {
  //         _635 = 1.0f;
  //       }
  //       float _636 = invLinearBegin * _610;
  //       do {
  //         if (!(_610 >= linearBegin)) {
  //           _644 = ((_636 * _636) * (3.0f - (_636 * 2.0f)));
  //         } else {
  //           _644 = 1.0f;
  //         }
  //         float _653 = select((_608 < linearStart), 0.0f, 1.0f);
  //         float _654 = select((_609 < linearStart), 0.0f, 1.0f);
  //         float _655 = select((_610 < linearStart), 0.0f, 1.0f);
  //         _715 = (((((contrast * _608) + madLinearStartContrastFactor) * (_626 - _653)) + (((pow(_618, toe)) * (1.0f - _626)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _608) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _653));
  //         _716 = (((((contrast * _609) + madLinearStartContrastFactor) * (_635 - _654)) + (((pow(_627, toe)) * (1.0f - _635)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _609) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _654));
  //         _717 = (((((contrast * _610) + madLinearStartContrastFactor) * (_644 - _655)) + (((pow(_636, toe)) * (1.0f - _644)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _610) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _655));
  //       } while (false);
  //     } while (false);
  //   } while (false);
  // } else {
  //   _715 = _608;
  //   _716 = _609;
  //   _717 = _610;
  // }
  // SV_Target.x = _715;
  // SV_Target.y = _716;
  // SV_Target.z = _717;

  CustomTonemapParam params;
  params.invLinearBegin = invLinearBegin;
  params.linearBegin = linearBegin;
  params.linearStart = linearStart;
  params.contrast = contrast;
  params.linearLength = linearLength;
  params.toe = toe;
  params.maxNit = maxNit;
  params.displayMaxNitSubContrastFactor = displayMaxNitSubContrastFactor;
  params.contrastFactor = contrastFactor;
  params.mulLinearStartContrastFactor = mulLinearStartContrastFactor;
  params.madLinearStartContrastFactor = madLinearStartContrastFactor;

  SV_Target.xyz = CustomTonemap(float3(_608, _609, _610), params, tonemapParam_isHDRMode == 0.0f);

  SV_Target.w = 0.0f;
  return SV_Target;
}
