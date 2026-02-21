
#define USE_DISABLEDEXPOSURE
#include "./postprocess.hlsl"



Texture2D<float4> HDRImage : register(t0);

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

cbuffer OCIOTransformMatrix : register(b1) {
  row_major float4x4 OCIO_TransformMatrix : packoffset(c000.x);
};

cbuffer RGCParamCB : register(b2) {
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
  } rgcParam : packoffset(c000.x);
};

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b4) {
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

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float4 _22 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _40 = mad(_22.z, (OCIO_TransformMatrix[2].x), mad(_22.y, (OCIO_TransformMatrix[1].x), ((OCIO_TransformMatrix[0].x) * _22.x)));
  float _43 = mad(_22.z, (OCIO_TransformMatrix[2].y), mad(_22.y, (OCIO_TransformMatrix[1].y), ((OCIO_TransformMatrix[0].y) * _22.x)));
  float _46 = mad(_22.z, (OCIO_TransformMatrix[2].z), mad(_22.y, (OCIO_TransformMatrix[1].z), ((OCIO_TransformMatrix[0].z) * _22.x)));
  float _83;
  float _104;
  float _124;
  float _132;
  float _133;
  float _134;
  float _181;
  float _211;
  float _220;
  float _229;
  float _300;
  float _301;
  float _302;
  if (!((uint)(rgcParam.EnableReferenceGamutCompress) == 0)) {
    float _52 = max(max(_40, _43), _46);
    if (!(_52 == 0.0f)) {
      float _58 = abs(_52);
      float _59 = (_52 - _40) / _58;
      float _60 = (_52 - _43) / _58;
      float _61 = (_52 - _46) / _58;
      if (!(!(_59 >= rgcParam.CyanThreshold))) {
        float _71 = _59 - rgcParam.CyanThreshold;
        _83 = ((_71 / exp2(log2(exp2(log2(_71 * rgcParam.InvCyanSTerm) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.CyanThreshold);
      } else {
        _83 = _59;
      }
      if (!(!(_60 >= rgcParam.MagentaThreshold))) {
        float _92 = _60 - rgcParam.MagentaThreshold;
        _104 = ((_92 / exp2(log2(exp2(log2(_92 * rgcParam.InvMagentaSTerm) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.MagentaThreshold);
      } else {
        _104 = _60;
      }
      if (!(!(_61 >= rgcParam.YellowThreshold))) {
        float _112 = _61 - rgcParam.YellowThreshold;
        _124 = ((_112 / exp2(log2(exp2(log2(_112 * rgcParam.InvYellowSTerm) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.YellowThreshold);
      } else {
        _124 = _61;
      }
      _132 = (_52 - (_58 * _83));
      _133 = (_52 - (_58 * _104));
      _134 = (_52 - (_58 * _124));
    } else {
      _132 = _40;
      _133 = _43;
      _134 = _46;
    }
  } else {
    _132 = _40;
    _133 = _43;
    _134 = _46;
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _142 = Kerare.x / Kerare.w;
    float _143 = Kerare.y / Kerare.w;
    float _144 = Kerare.z / Kerare.w;
    float _148 = abs(rsqrt(dot(float3(_142, _143, _144), float3(_142, _143, _144))) * _144);
    float _153 = _148 * _148;
    _181 = ((_153 * _153) * (1.0f - saturate((kerare_scale * _148) + kerare_offset)));
  } else {
    float _164 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _166 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _168 = sqrt(dot(float2(_166, _164), float2(_166, _164)));
    float _176 = (_168 * _168) + 1.0f;
    _181 = ((1.0f / (_176 * _176)) * (1.0f - saturate((kerare_scale * (1.0f / (_168 + 1.0f))) + kerare_offset)));
  }
  float _183 = saturate(_181 + kerare_brightness);

  CustomVignette(_183);

  float _185 = (_132 * Exposure) * _183;
  float _187 = (_133 * Exposure) * _183;
  float _189 = (_134 * Exposure) * _183;
  bool _192 = isfinite(max(max(_185, _187), _189));
  float _193 = select(_192, _185, 1.0f);
  float _194 = select(_192, _187, 1.0f);
  float _195 = select(_192, _189, 1.0f);
  // if (tonemapParam_isHDRMode == 0.0f && ProcessSDRVanilla()) {
  //   float _203 = invLinearBegin * _193;
  //   if (!(_193 >= linearBegin)) {
  //     _211 = ((_203 * _203) * (3.0f - (_203 * 2.0f)));
  //   } else {
  //     _211 = 1.0f;
  //   }
  //   float _212 = invLinearBegin * _194;
  //   if (!(_194 >= linearBegin)) {
  //     _220 = ((_212 * _212) * (3.0f - (_212 * 2.0f)));
  //   } else {
  //     _220 = 1.0f;
  //   }
  //   float _221 = invLinearBegin * _195;
  //   if (!(_195 >= linearBegin)) {
  //     _229 = ((_221 * _221) * (3.0f - (_221 * 2.0f)));
  //   } else {
  //     _229 = 1.0f;
  //   }
  //   float _238 = select((_193 < linearStart), 0.0f, 1.0f);
  //   float _239 = select((_194 < linearStart), 0.0f, 1.0f);
  //   float _240 = select((_195 < linearStart), 0.0f, 1.0f);
  //   _300 = (((((contrast * _193) + madLinearStartContrastFactor) * (_211 - _238)) + (((pow(_203, toe)) * (1.0f - _211)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _193) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _238));
  //   _301 = (((((contrast * _194) + madLinearStartContrastFactor) * (_220 - _239)) + (((pow(_212, toe)) * (1.0f - _220)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _194) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _239));
  //   _302 = (((((contrast * _195) + madLinearStartContrastFactor) * (_229 - _240)) + (((pow(_221, toe)) * (1.0f - _229)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _195) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _240));
  // } else {
  //   _300 = _193;
  //   _301 = _194;
  //   _302 = _195;
  // }
  // SV_Target.x = _300;
  // SV_Target.y = _301;
  // SV_Target.z = _302;

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

  SV_Target.xyz = CustomTonemap(float3(_193, _194, _195), params, tonemapParam_isHDRMode == 0.0f);

  SV_Target.w = 1.0f;
  return SV_Target;
}
