#include "./common.hlsl"

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
  float2 projectionSpaceJitterOffset : packoffset(c037.x);
  float2 SceneInfo_Reserve2 : packoffset(c037.z);
};

cbuffer Tonemap : register(b1) {
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
};

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b3) {
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
};

cbuffer ColorCorrectTexture : register(b4) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float fHalfTextureInverseSize : packoffset(c001.x);
  float fOneMinusTextureInverseSize : packoffset(c001.y);
  float fColorCorrectTextureReserve : packoffset(c001.z);
  float fColorCorrectTextureReserve2 : packoffset(c001.w);
  row_major float4x4 fColorMatrix : packoffset(c002.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float3 untonemapped;
  float3 test = float3(0.0f, 0.0f, 0.0f);

  float _70;
  float _100;
  float _101;
  float _102;
  float _140;
  float _151;
  float _162;
  float _204;
  float _215;
  float _226;
  float _277;
  float _288;
  float _299;
  float _320;
  float _321;
  float _322;
  float _395;
  float _428;
  float _439;
  float _450;
  float _451;
  float _452;
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
  float _73 = saturate(_70 + kerare_brightness) * Exposure;
  float4 _81 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _85 = _81.x * _73;
  float _86 = _81.y * _73;
  float _87 = _81.z * _73;
  untonemapped = float3(_85, _86, _87);

  float _89 = max(max(_85, _86), _87);
  if (isfinite(_89)) {
    float _95 = (tonemapRange * _89) + 1.0f;
    _100 = (_85 / _95);
    _101 = (_86 / _95);
    _102 = (_87 / _95);
  } else {
    _100 = 1.0f;
    _101 = 1.0f;
    _102 = 1.0f;
  }
  float _126 = saturate(saturate(_100));
  float _127 = saturate(saturate(_101));
  float _128 = saturate(saturate(_102));
  float _129 = fTextureInverseSize * 0.5f;
  [branch]
  if (!(!(_126 <= 0.0031308000907301903f))) {
    _140 = (_126 * 12.920000076293945f);
  } else {
    _140 = (((pow(_126, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_127 <= 0.0031308000907301903f))) {
    _151 = (_127 * 12.920000076293945f);
  } else {
    _151 = (((pow(_127, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_128 <= 0.0031308000907301903f))) {
    _162 = (_128 * 12.920000076293945f);
  } else {
    _162 = (((pow(_128, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _163 = 1.0f - fTextureInverseSize;
  float _167 = (_140 * _163) + _129;
  float _168 = (_151 * _163) + _129;
  float _169 = (_162 * _163) + _129;
  bool _170 = (fTextureBlendRate > 0.0f);
  bool _171 = (fTextureBlendRate2 > 0.0f);
  if (_170 && _171) {
    float4 _176 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
    float4 _181 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
    float _191 = ((_181.x - _176.x) * fTextureBlendRate) + _176.x;
    float _192 = ((_181.y - _176.y) * fTextureBlendRate) + _176.y;
    float _193 = ((_181.z - _176.z) * fTextureBlendRate) + _176.z;
    [branch]
    if (!(!(_191 <= 0.0031308000907301903f))) {
      _204 = (_191 * 12.920000076293945f);
    } else {
      _204 = (((pow(_191, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_192 <= 0.0031308000907301903f))) {
      _215 = (_192 * 12.920000076293945f);
    } else {
      _215 = (((pow(_192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_193 <= 0.0031308000907301903f))) {
      _226 = (_193 * 12.920000076293945f);
    } else {
      _226 = (((pow(_193, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    float4 _228 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_204, _215, _226), 0.0f);
    _320 = (lerp(_191, _228.x, fTextureBlendRate2));
    _321 = (lerp(_192, _228.y, fTextureBlendRate2));
    _322 = (lerp(_193, _228.z, fTextureBlendRate2));
  } else {
    if (_170) {
      float4 _243 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
      float4 _248 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
      _320 = (lerp(_243.x, _248.x, fTextureBlendRate));
      _321 = (lerp(_243.y, _248.y, fTextureBlendRate));
      _322 = (lerp(_243.z, _248.z, fTextureBlendRate));
    } else {
      if (_171) {
        float4 _263 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
        [branch]
        if (!(!(_263.x <= 0.0031308000907301903f))) {
          _277 = (_263.x * 12.920000076293945f);
        } else {
          _277 = (((pow(_263.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_263.y <= 0.0031308000907301903f))) {
          _288 = (_263.y * 12.920000076293945f);
        } else {
          _288 = (((pow(_263.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_263.z <= 0.0031308000907301903f))) {
          _299 = (_263.z * 12.920000076293945f);
        } else {
          _299 = (((pow(_263.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _301 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_277, _288, _299), 0.0f);
        _320 = (lerp(_263.x, _301.x, fTextureBlendRate2));
        _321 = (lerp(_263.y, _301.y, fTextureBlendRate2));
        _322 = (lerp(_263.z, _301.z, fTextureBlendRate2));
      } else {
        float4 _315 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_167, _168, _169), 0.0f);
        _320 = _315.x;
        _321 = _315.y;
        _322 = _315.z;
      }
    }
  }
  float _326 = mad(_322, (fColorMatrix[2].x), mad(_321, (fColorMatrix[1].x), (_320 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
  float _330 = mad(_322, (fColorMatrix[2].y), mad(_321, (fColorMatrix[1].y), (_320 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
  float _334 = mad(_322, (fColorMatrix[2].z), mad(_321, (fColorMatrix[1].z), (_320 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _374 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _334, mad((RGBToXYZViaCrosstalkMatrix[0].y), _330, ((RGBToXYZViaCrosstalkMatrix[0].x) * _326)));
      float _377 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _334, mad((RGBToXYZViaCrosstalkMatrix[1].y), _330, ((RGBToXYZViaCrosstalkMatrix[1].x) * _326)));
      float _382 = (_377 + _374) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _334, mad((RGBToXYZViaCrosstalkMatrix[2].y), _330, ((RGBToXYZViaCrosstalkMatrix[2].x) * _326)));
      float _383 = _374 / _382;
      float _384 = _377 / _382;
      if (_377 < curve_HDRip) {
        _395 = (_377 * exposureScale);
      } else {
        _395 = ((log2((_377 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      float _397 = (_383 / _384) * _395;
      float _401 = (((1.0f - _383) - _384) / _384) * _395;
      _450 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _401, mad((XYZToRGBViaCrosstalkMatrix[0].y), _395, (_397 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
      _451 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _401, mad((XYZToRGBViaCrosstalkMatrix[1].y), _395, (_397 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
      _452 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _401, mad((XYZToRGBViaCrosstalkMatrix[2].y), _395, (_397 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
    } else {
      if (_326 < curve_HDRip) {
        _428 = (exposureScale * _326);
      } else {
        _428 = ((log2((_326 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      if (_330 < curve_HDRip) {
        _439 = (exposureScale * _330);
      } else {
        _439 = ((log2((_330 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      if (_334 < curve_HDRip) {
        _450 = _428;
        _451 = _439;
        _452 = (exposureScale * _334);
      } else {
        _450 = _428;
        _451 = _439;
        _452 = ((log2((_334 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
    }
  } else {
    _450 = _326;
    _451 = _330;
    _452 = _334;
  }
  SV_Target.x = _450;
  SV_Target.y = _451;
  SV_Target.z = _452;

  SV_Target.rgb = Tonemap(untonemapped, SV_Target.rgb);

  SV_Target.w = 0.0f;
  return SV_Target;
}
