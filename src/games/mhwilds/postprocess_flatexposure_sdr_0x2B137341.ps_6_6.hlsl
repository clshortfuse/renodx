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
  float _623;
  float _632;
  float _641;
  float _712;
  float _713;
  float _714;
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

  // // This should be 1 if 0x4905680A is loaded, since that one handles exposure
  // float custom_flat_exposure = 1.f;

  // // We check if 0x4905680A has loaded
  // if (CUSTOM_EXPOSURE_SHADER_DRAW == 0.f) {
  //   // In case of vanilla
  //   custom_flat_exposure = 1.f * NormalizeExposure();
  //   if (CUSTOM_EXPOSURE_TYPE >= 1.f) {
  //     custom_flat_exposure = FlatExposure();
  //   }
  // }
  
  float4 _81 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));

  //_81 *= custom_flat_exposure;

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
  // Use RenoDX LUT sampling helper with log-encoded AP1 space
  float3 lut_output = SampleColorLUTs(
      float3(_194, _195, _196),
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp,
      fTextureBlendRate,
      fTextureBlendRate2,
      fColorMatrix);
  
  // Apply CustomLUTColor blending
  float3 new_color = CustomLUTColor(float3(_194, _195, _196), lut_output);
  float _599 = min(new_color.r, 65000.0f);
  float _600 = min(new_color.g, 65000.0f);
  float _601 = min(new_color.b, 65000.0f);
  _601 = new_color.b;

  bool _604 = isfinite(max(max(_599, _600), _601));
  float _605 = select(_604, _599, 1.0f);
  float _606 = select(_604, _600, 1.0f);
  float _607 = select(_604, _601, 1.0f);
  // if (tonemapParam_isHDRMode == 0.0f && ProcessSDRVanilla()) {
  //   float _615 = invLinearBegin * _605;
  //   do {
  //     if (!(_605 >= linearBegin)) {
  //       _623 = ((_615 * _615) * (3.0f - (_615 * 2.0f)));
  //     } else {
  //       _623 = 1.0f;
  //     }
  //     float _624 = invLinearBegin * _606;
  //     do {
  //       if (!(_606 >= linearBegin)) {
  //         _632 = ((_624 * _624) * (3.0f - (_624 * 2.0f)));
  //       } else {
  //         _632 = 1.0f;
  //       }
  //       float _633 = invLinearBegin * _607;
  //       do {
  //         if (!(_607 >= linearBegin)) {
  //           _641 = ((_633 * _633) * (3.0f - (_633 * 2.0f)));
  //         } else {
  //           _641 = 1.0f;
  //         }
  //         float _650 = select((_605 < linearStart), 0.0f, 1.0f);
  //         float _651 = select((_606 < linearStart), 0.0f, 1.0f);
  //         float _652 = select((_607 < linearStart), 0.0f, 1.0f);
  //         _712 = (((((contrast * _605) + madLinearStartContrastFactor) * (_623 - _650)) + (((pow(_615, toe)) * (1.0f - _623)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _605) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _650));
  //         _713 = (((((contrast * _606) + madLinearStartContrastFactor) * (_632 - _651)) + (((pow(_624, toe)) * (1.0f - _632)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _606) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _651));
  //         _714 = (((((contrast * _607) + madLinearStartContrastFactor) * (_641 - _652)) + (((pow(_633, toe)) * (1.0f - _641)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _607) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _652));
  //       } while (false);
  //     } while (false);
  //   } while (false);
  // } else {
  //   _712 = _605;
  //   _713 = _606;
  //   _714 = _607;
  // }
  // SV_Target.x = _712;
  // SV_Target.y = _713;
  // SV_Target.z = _714;

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

  SV_Target.xyz = CustomTonemap(float3(_605, _606, _607), params, tonemapParam_isHDRMode == 0.0f);

  SV_Target.w = 0.0f;
  return SV_Target;
}
