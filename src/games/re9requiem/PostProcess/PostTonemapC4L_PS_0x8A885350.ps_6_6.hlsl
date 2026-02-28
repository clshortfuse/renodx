#include "./PostProcess.hlsli"

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
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
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
  float _254;
  float _287;
  float _298;
  float _309;
  float _310;
  float _311;
  if (!(rgcParam.EnableReferenceGamutCompress == 0)) {
    float _52 = max(max(_40, _43), _46);
    if (!(_52 == 0.0f)) {
      float _58 = abs(_52);
      float _59 = (_52 - _40) / _58;
      float _60 = (_52 - _43) / _58;
      float _61 = (_52 - _46) / _58;
      do {
        if (!(!(_59 >= rgcParam.CyanThreshold))) {
          float _71 = _59 - rgcParam.CyanThreshold;
          _83 = ((_71 / exp2(log2(exp2(log2(rgcParam.InvCyanSTerm * _71) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.CyanThreshold);
        } else {
          _83 = _59;
        }
        do {
          if (!(!(_60 >= rgcParam.MagentaThreshold))) {
            float _92 = _60 - rgcParam.MagentaThreshold;
            _104 = ((_92 / exp2(log2(exp2(log2(rgcParam.InvMagentaSTerm * _92) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.MagentaThreshold);
          } else {
            _104 = _60;
          }
          do {
            if (!(!(_61 >= rgcParam.YellowThreshold))) {
              float _112 = _61 - rgcParam.YellowThreshold;
              _124 = ((_112 / exp2(log2(exp2(log2(rgcParam.InvYellowSTerm * _112) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.YellowThreshold);
            } else {
              _124 = _61;
            }
            _132 = (_52 - (_83 * _58));
            _133 = (_52 - (_104 * _58));
            _134 = (_52 - (_124 * _58));
          } while (false);
        } while (false);
      } while (false);
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
    _181 = ((_153 * _153) * (1.0f - saturate((_148 * kerare_scale) + kerare_offset)));
  } else {
    float _164 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _166 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _168 = sqrt(dot(float2(_166, _164), float2(_166, _164)));
    float _176 = (_168 * _168) + 1.0f;
    _181 = ((1.0f / (_176 * _176)) * (1.0f - saturate(((1.0f / (_168 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _184 = saturate(_181 + kerare_brightness) * Exposure;
  float _185 = _184 * _132;
  float _186 = _184 * _133;
  float _187 = _184 * _134;
  bool _190 = isfinite(max(max(_185, _186), _187));
  float _191 = select(_190, _185, 1.0f);
  float _192 = select(_190, _186, 1.0f);
  float _193 = select(_190, _187, 1.0f);
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _233 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _193, mad((RGBToXYZViaCrosstalkMatrix[0].y), _192, ((RGBToXYZViaCrosstalkMatrix[0].x) * _191)));
      float _236 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _193, mad((RGBToXYZViaCrosstalkMatrix[1].y), _192, ((RGBToXYZViaCrosstalkMatrix[1].x) * _191)));
      float _241 = (_236 + _233) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _193, mad((RGBToXYZViaCrosstalkMatrix[2].y), _192, ((RGBToXYZViaCrosstalkMatrix[2].x) * _191)));
      float _242 = _233 / _241;
      float _243 = _236 / _241;
      do {
        if (_236 < curve_HDRip) {
          _254 = (_236 * exposureScale);
        } else {
          _254 = ((log2((_236 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _256 = (_242 / _243) * _254;
        float _260 = (((1.0f - _242) - _243) / _243) * _254;
        _309 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _260, mad((XYZToRGBViaCrosstalkMatrix[0].y), _254, (_256 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _310 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _260, mad((XYZToRGBViaCrosstalkMatrix[1].y), _254, (_256 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _311 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _260, mad((XYZToRGBViaCrosstalkMatrix[2].y), _254, (_256 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_191 < curve_HDRip) {
          _287 = (exposureScale * _191);
        } else {
          _287 = ((log2((_191 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_192 < curve_HDRip) {
            _298 = (exposureScale * _192);
          } else {
            _298 = ((log2((_192 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_193 < curve_HDRip) {
            _309 = _287;
            _310 = _298;
            _311 = (exposureScale * _193);
          } else {
            _309 = _287;
            _310 = _298;
            _311 = ((log2((_193 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _309 = _191;
    _310 = _192;
    _311 = _193;
  }
  SV_Target.x = _309;
  SV_Target.y = _310;
  SV_Target.z = _311;
  SV_Target.w = 1.0f;
  return SV_Target;
}
