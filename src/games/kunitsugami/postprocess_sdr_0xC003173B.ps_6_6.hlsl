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
};

cbuffer ColorCorrectTexture : register(b3) {
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

  float4 _24 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  float _28 = _24.x * Exposure;
  float _29 = _24.y * Exposure;
  float _30 = _24.z * Exposure;
  untonemapped = float3(_28, _29, _30);

  float _32 = max(max(_28, _29), _30);
  float _44;
  float _45;
  float _46;
  float _84;
  float _95;
  float _106;
  float _148;
  float _159;
  float _170;
  float _221;
  float _232;
  float _243;
  float _264;
  float _265;
  float _266;
  float _339;
  float _372;
  float _383;
  float _394;
  float _395;
  float _396;
  if (isfinite(_32)) {
    float _39 = (tonemapRange * _32) + 1.0f;
    _44 = (_28 / _39);
    _45 = (_29 / _39);
    _46 = (_30 / _39);
  } else {
    _44 = 1.0f;
    _45 = 1.0f;
    _46 = 1.0f;
  }
  float _70 = saturate(saturate(_44));
  float _71 = saturate(saturate(_45));
  float _72 = saturate(saturate(_46));
  float _73 = fTextureInverseSize * 0.5f;
  [branch]
  if (!(!(_70 <= 0.0031308000907301903f))) {
    _84 = (_70 * 12.920000076293945f);
  } else {
    _84 = (((pow(_70, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_71 <= 0.0031308000907301903f))) {
    _95 = (_71 * 12.920000076293945f);
  } else {
    _95 = (((pow(_71, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  [branch]
  if (!(!(_72 <= 0.0031308000907301903f))) {
    _106 = (_72 * 12.920000076293945f);
  } else {
    _106 = (((pow(_72, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _107 = 1.0f - fTextureInverseSize;
  float _111 = (_84 * _107) + _73;
  float _112 = (_95 * _107) + _73;
  float _113 = (_106 * _107) + _73;
  bool _114 = (fTextureBlendRate > 0.0f);
  bool _115 = (fTextureBlendRate2 > 0.0f);
  if (_114 && _115) {
    float4 _120 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
    float4 _125 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
    float _135 = ((_125.x - _120.x) * fTextureBlendRate) + _120.x;
    float _136 = ((_125.y - _120.y) * fTextureBlendRate) + _120.y;
    float _137 = ((_125.z - _120.z) * fTextureBlendRate) + _120.z;
    [branch]
    if (!(!(_135 <= 0.0031308000907301903f))) {
      _148 = (_135 * 12.920000076293945f);
    } else {
      _148 = (((pow(_135, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_136 <= 0.0031308000907301903f))) {
      _159 = (_136 * 12.920000076293945f);
    } else {
      _159 = (((pow(_136, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    [branch]
    if (!(!(_137 <= 0.0031308000907301903f))) {
      _170 = (_137 * 12.920000076293945f);
    } else {
      _170 = (((pow(_137, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    float4 _172 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_148, _159, _170), 0.0f);
    _264 = (lerp(_135, _172.x, fTextureBlendRate2));
    _265 = (lerp(_136, _172.y, fTextureBlendRate2));
    _266 = (lerp(_137, _172.z, fTextureBlendRate2));
  } else {
    if (_114) {
      float4 _187 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
      float4 _192 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
      _264 = (lerp(_187.x, _192.x, fTextureBlendRate));
      _265 = (lerp(_187.y, _192.y, fTextureBlendRate));
      _266 = (lerp(_187.z, _192.z, fTextureBlendRate));
    } else {
      if (_115) {
        float4 _207 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
        [branch]
        if (!(!(_207.x <= 0.0031308000907301903f))) {
          _221 = (_207.x * 12.920000076293945f);
        } else {
          _221 = (((pow(_207.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_207.y <= 0.0031308000907301903f))) {
          _232 = (_207.y * 12.920000076293945f);
        } else {
          _232 = (((pow(_207.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        [branch]
        if (!(!(_207.z <= 0.0031308000907301903f))) {
          _243 = (_207.z * 12.920000076293945f);
        } else {
          _243 = (((pow(_207.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        float4 _245 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_221, _232, _243), 0.0f);
        _264 = (lerp(_207.x, _245.x, fTextureBlendRate2));
        _265 = (lerp(_207.y, _245.y, fTextureBlendRate2));
        _266 = (lerp(_207.z, _245.z, fTextureBlendRate2));
      } else {
        float4 _259 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_111, _112, _113), 0.0f);
        _264 = _259.x;
        _265 = _259.y;
        _266 = _259.z;
      }
    }
  }
  float _270 = mad(_266, (fColorMatrix[2].x), mad(_265, (fColorMatrix[1].x), (_264 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
  float _274 = mad(_266, (fColorMatrix[2].y), mad(_265, (fColorMatrix[1].y), (_264 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
  float _278 = mad(_266, (fColorMatrix[2].z), mad(_265, (fColorMatrix[1].z), (_264 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _318 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _278, mad((RGBToXYZViaCrosstalkMatrix[0].y), _274, ((RGBToXYZViaCrosstalkMatrix[0].x) * _270)));
      float _321 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _278, mad((RGBToXYZViaCrosstalkMatrix[1].y), _274, ((RGBToXYZViaCrosstalkMatrix[1].x) * _270)));
      float _326 = (_321 + _318) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _278, mad((RGBToXYZViaCrosstalkMatrix[2].y), _274, ((RGBToXYZViaCrosstalkMatrix[2].x) * _270)));
      float _327 = _318 / _326;
      float _328 = _321 / _326;
      if (_321 < curve_HDRip) {
        _339 = (_321 * exposureScale);
      } else {
        _339 = ((log2((_321 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      float _341 = (_327 / _328) * _339;
      float _345 = (((1.0f - _327) - _328) / _328) * _339;
      _394 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _345, mad((XYZToRGBViaCrosstalkMatrix[0].y), _339, (_341 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
      _395 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _345, mad((XYZToRGBViaCrosstalkMatrix[1].y), _339, (_341 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
      _396 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _345, mad((XYZToRGBViaCrosstalkMatrix[2].y), _339, (_341 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
    } else {
      if (_270 < curve_HDRip) {
        _372 = (exposureScale * _270);
      } else {
        _372 = ((log2((_270 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      if (_274 < curve_HDRip) {
        _383 = (exposureScale * _274);
      } else {
        _383 = ((log2((_274 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
      if (_278 < curve_HDRip) {
        _394 = _372;
        _395 = _383;
        _396 = (exposureScale * _278);
      } else {
        _394 = _372;
        _395 = _383;
        _396 = ((log2((_278 / curve_HDRip) - knee) * curve_k2) + curve_k4);
      }
    }
  } else {
    _394 = _270;
    _395 = _274;
    _396 = _278;
  }
  SV_Target.x = _394;
  SV_Target.y = _395;
  SV_Target.z = _396;

  SV_Target.rgb = Tonemap(untonemapped, SV_Target.rgb);

  SV_Target.w = 0.0f;
  return SV_Target;
}
