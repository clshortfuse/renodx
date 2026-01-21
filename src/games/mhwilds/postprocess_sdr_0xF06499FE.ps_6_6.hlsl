#define USE_CBUFFER_SLOT_B2

#include "./postprocess.hlsl"
#include "./tonemapper.hlsl"



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
  float _620;
  float _629;
  float _638;
  float _709;
  float _710;
  float _711;
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
  // float _73 = saturate(_70 + kerare_brightness) * Exposure;

  float _73 = saturate(_70 + kerare_brightness);
  CustomVignette(_73);
  _73 = _73 * Exposure;

  float4 _81 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _85 = _81.x * _73;
  float _86 = _81.y * _73;
  float _87 = _81.z * _73;
  float _102 = mad(_87, (fOCIOTransformMatrix[2].x), mad(_86, (fOCIOTransformMatrix[1].x), (_85 * (fOCIOTransformMatrix[0].x))));
  float _105 = mad(_87, (fOCIOTransformMatrix[2].y), mad(_86, (fOCIOTransformMatrix[1].y), (_85 * (fOCIOTransformMatrix[0].y))));
  float _108 = mad(_87, (fOCIOTransformMatrix[2].z), mad(_86, (fOCIOTransformMatrix[1].z), (_85 * (fOCIOTransformMatrix[0].z))));
  if (!((uint)(cbControlRGCParam.EnableReferenceGamutCompress) == 0)) {
    float _114 = max(max(_102, _105), _108);
    if (!(_114 == 0.0f)) {
      float _120 = abs(_114);
      float _121 = (_114 - _102) / _120;
      float _122 = (_114 - _105) / _120;
      float _123 = (_114 - _108) / _120;
      if (!(!(_121 >= cbControlRGCParam.CyanThreshold))) {
        float _133 = _121 - cbControlRGCParam.CyanThreshold;
        _145 = ((_133 / exp2(log2(exp2(log2(_133 * cbControlRGCParam.InvCyanSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
      } else {
        _145 = _121;
      }
      if (!(!(_122 >= cbControlRGCParam.MagentaThreshold))) {
        float _154 = _122 - cbControlRGCParam.MagentaThreshold;
        _166 = ((_154 / exp2(log2(exp2(log2(_154 * cbControlRGCParam.InvMagentaSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
      } else {
        _166 = _122;
      }
      if (!(!(_123 >= cbControlRGCParam.YellowThreshold))) {
        float _174 = _123 - cbControlRGCParam.YellowThreshold;
        _186 = ((_174 / exp2(log2(exp2(log2(_174 * cbControlRGCParam.InvYellowSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
      } else {
        _186 = _123;
      }
      _194 = (_114 - (_120 * _145));
      _195 = (_114 - (_120 * _166));
      _196 = (_114 - (_120 * _186));
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
  [branch]
  if (fTextureBlendRate > 0.0f) {
    if (!_219) {
      _313 = ((_194 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _313 = ((log2(_194) + 9.720000267028809f) * 0.05707762390375137f);
    }
    if (!_229) {
      _322 = ((_195 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _322 = ((log2(_195) + 9.720000267028809f) * 0.05707762390375137f);
    }
    if (!_239) {
      _331 = ((_196 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _331 = ((log2(_196) + 9.720000267028809f) * 0.05707762390375137f);
    }
    float4 _339 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_313 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_322 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_331 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
    if (_339.x < 0.155251145362854f) {
      _356 = ((_339.x + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_339.x >= 0.155251145362854f) && (bool)(_339.x < 1.4679962396621704f)) {
        _356 = exp2((_339.x * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _356 = 65504.0f;
      }
    }
    if (_339.y < 0.155251145362854f) {
      _370 = ((_339.y + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_339.y >= 0.155251145362854f) && (bool)(_339.y < 1.4679962396621704f)) {
        _370 = exp2((_339.y * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _370 = 65504.0f;
      }
    }
    if (_339.z < 0.155251145362854f) {
      _384 = ((_339.z + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_339.z >= 0.155251145362854f) && (bool)(_339.z < 1.4679962396621704f)) {
        _384 = exp2((_339.z * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _384 = 65504.0f;
      }
    }
    float _391 = ((_356 - _274) * fTextureBlendRate) + _274;
    float _392 = ((_370 - _288) * fTextureBlendRate) + _288;
    float _393 = ((_384 - _302) * fTextureBlendRate) + _302;
    if (fTextureBlendRate2 > 0.0f) {
      if (!(!(_391 <= 0.0078125f))) {
        _405 = ((_391 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _405 = ((log2(_391) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!(!(_392 <= 0.0078125f))) {
        _415 = ((_392 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _415 = ((log2(_392) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!(!(_393 <= 0.0078125f))) {
        _425 = ((_393 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _425 = ((log2(_393) + 9.720000267028809f) * 0.05707762390375137f);
      }
      float4 _433 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_405 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_415 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_425 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
      if (_433.x < 0.155251145362854f) {
        _450 = ((_433.x + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_433.x >= 0.155251145362854f) && (bool)(_433.x < 1.4679962396621704f)) {
          _450 = exp2((_433.x * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _450 = 65504.0f;
        }
      }
      if (_433.y < 0.155251145362854f) {
        _464 = ((_433.y + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_433.y >= 0.155251145362854f) && (bool)(_433.y < 1.4679962396621704f)) {
          _464 = exp2((_433.y * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _464 = 65504.0f;
        }
      }
      if (_433.z < 0.155251145362854f) {
        _478 = ((_433.z + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_433.z >= 0.155251145362854f) && (bool)(_433.z < 1.4679962396621704f)) {
          _478 = exp2((_433.z * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _478 = 65504.0f;
        }
      }
      _584 = (lerp(_391, _450, fTextureBlendRate2));
      _585 = (lerp(_392, _464, fTextureBlendRate2));
      _586 = (lerp(_393, _478, fTextureBlendRate2));
    } else {
      _584 = _391;
      _585 = _392;
      _586 = _393;
    }
  } else {
    if (fTextureBlendRate2 > 0.0f) {
      if (!(!(_274 <= 0.0078125f))) {
        _500 = ((_274 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _500 = ((log2(_274) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!(!(_288 <= 0.0078125f))) {
        _510 = ((_288 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _510 = ((log2(_288) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!(!(_302 <= 0.0078125f))) {
        _520 = ((_302 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _520 = ((log2(_302) + 9.720000267028809f) * 0.05707762390375137f);
      }
      float4 _528 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_500 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_510 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_520 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
      if (_528.x < 0.155251145362854f) {
        _545 = ((_528.x + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_528.x >= 0.155251145362854f) && (bool)(_528.x < 1.4679962396621704f)) {
          _545 = exp2((_528.x * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _545 = 65504.0f;
        }
      }
      if (_528.y < 0.155251145362854f) {
        _559 = ((_528.y + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_528.y >= 0.155251145362854f) && (bool)(_528.y < 1.4679962396621704f)) {
          _559 = exp2((_528.y * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _559 = 65504.0f;
        }
      }
      if (_528.z < 0.155251145362854f) {
        _573 = ((_528.z + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_528.z >= 0.155251145362854f) && (bool)(_528.z < 1.4679962396621704f)) {
          _573 = exp2((_528.z * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _573 = 65504.0f;
        }
      }
      _584 = (lerp(_274, _545, fTextureBlendRate2));
      _585 = (lerp(_288, _559, fTextureBlendRate2));
      _586 = (lerp(_302, _573, fTextureBlendRate2));
    } else {
      _584 = _274;
      _585 = _288;
      _586 = _302;
    }
  }
  float _590 = mad(_586, (fColorMatrix[2].x), mad(_585, (fColorMatrix[1].x), (_584 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
  float _594 = mad(_586, (fColorMatrix[2].y), mad(_585, (fColorMatrix[1].y), (_584 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
  float _598 = mad(_586, (fColorMatrix[2].z), mad(_585, (fColorMatrix[1].z), (_584 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);

  float3 new_color = CustomLUTColor(float3(_194, _195, _196), float3(_590, _594, _598));
  _590 = new_color.r;
  _594 = new_color.g;
  _598 = new_color.b;

  bool _601 = isfinite(max((max(_590, _594)), _598));
  float _602 = select(_601, _590, 1.0f);
  float _603 = select(_601, _594, 1.0f);
  float _604 = select(_601, _598, 1.0f);
  // if ((tonemapParam_isHDRMode == 0.0f) && ProcessSDRVanilla()) {
  //   float _612 = invLinearBegin * _602;
  //   if (!(_602 >= linearBegin)) {
  //     _620 = ((_612 * _612) * (3.0f - (_612 * 2.0f)));
  //   } else {
  //     _620 = 1.0f;
  //   }
  //   float _621 = invLinearBegin * _603;
  //   if (!(_603 >= linearBegin)) {
  //     _629 = ((_621 * _621) * (3.0f - (_621 * 2.0f)));
  //   } else {
  //     _629 = 1.0f;
  //   }
  //   float _630 = invLinearBegin * _604;
  //   if (!(_604 >= linearBegin)) {
  //     _638 = ((_630 * _630) * (3.0f - (_630 * 2.0f)));
  //   } else {
  //     _638 = 1.0f;
  //   }
  //   float _647 = select((_602 < linearStart), 0.0f, 1.0f);
  //   float _648 = select((_603 < linearStart), 0.0f, 1.0f);
  //   float _649 = select((_604 < linearStart), 0.0f, 1.0f);
  //   _709 = (((((contrast * _602) + madLinearStartContrastFactor) * (_620 - _647)) + (((pow(_612, toe)) * (1.0f - _620)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _602) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _647));
  //   _710 = (((((contrast * _603) + madLinearStartContrastFactor) * (_629 - _648)) + (((pow(_621, toe)) * (1.0f - _629)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _603) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _648));
  //   _711 = (((((contrast * _604) + madLinearStartContrastFactor) * (_638 - _649)) + (((pow(_630, toe)) * (1.0f - _638)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _604) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _649));
  // } else {
  //   _709 = _602;
  //   _710 = _603;
  //   _711 = _604;
  // }
  // SV_Target.x = _709;
  // SV_Target.y = _710;
  // SV_Target.z = _711;

  SV_Target.xyz = CustomTonemap(float3(_602, _603, _604));

  SV_Target.w = 0.0f;
  return SV_Target;
}
