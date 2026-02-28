#include "./PostProcess.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer OCIOTransformMatrix : register(b0) {
  row_major float4x4 OCIO_TransformMatrix : packoffset(c000.x);
};

cbuffer RGCParamCB : register(b1) {
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

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float4 _14 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _32 = mad(_14.z, (OCIO_TransformMatrix[2].x), mad(_14.y, (OCIO_TransformMatrix[1].x), ((OCIO_TransformMatrix[0].x) * _14.x)));
  float _35 = mad(_14.z, (OCIO_TransformMatrix[2].y), mad(_14.y, (OCIO_TransformMatrix[1].y), ((OCIO_TransformMatrix[0].y) * _14.x)));
  float _38 = mad(_14.z, (OCIO_TransformMatrix[2].z), mad(_14.y, (OCIO_TransformMatrix[1].z), ((OCIO_TransformMatrix[0].z) * _14.x)));
  float _75;
  float _96;
  float _116;
  float _124;
  float _125;
  float _126;
  float _196;
  float _229;
  float _240;
  float _251;
  float _252;
  float _253;
  if (!(rgcParam.EnableReferenceGamutCompress == 0)) {
    float _44 = max(max(_32, _35), _38);
    if (!(_44 == 0.0f)) {
      float _50 = abs(_44);
      float _51 = (_44 - _32) / _50;
      float _52 = (_44 - _35) / _50;
      float _53 = (_44 - _38) / _50;
      do {
        if (!(!(_51 >= rgcParam.CyanThreshold))) {
          float _63 = _51 - rgcParam.CyanThreshold;
          _75 = ((_63 / exp2(log2(exp2(log2(rgcParam.InvCyanSTerm * _63) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.CyanThreshold);
        } else {
          _75 = _51;
        }
        do {
          if (!(!(_52 >= rgcParam.MagentaThreshold))) {
            float _84 = _52 - rgcParam.MagentaThreshold;
            _96 = ((_84 / exp2(log2(exp2(log2(rgcParam.InvMagentaSTerm * _84) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.MagentaThreshold);
          } else {
            _96 = _52;
          }
          do {
            if (!(!(_53 >= rgcParam.YellowThreshold))) {
              float _104 = _53 - rgcParam.YellowThreshold;
              _116 = ((_104 / exp2(log2(exp2(log2(rgcParam.InvYellowSTerm * _104) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.YellowThreshold);
            } else {
              _116 = _53;
            }
            _124 = (_44 - (_75 * _50));
            _125 = (_44 - (_96 * _50));
            _126 = (_44 - (_116 * _50));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _124 = _32;
      _125 = _35;
      _126 = _38;
    }
  } else {
    _124 = _32;
    _125 = _35;
    _126 = _38;
  }
  float _127 = _124 * Exposure;
  float _128 = _125 * Exposure;
  float _129 = _126 * Exposure;
  bool _132 = isfinite(max(max(_127, _128), _129));
  float _133 = select(_132, _127, 1.0f);
  float _134 = select(_132, _128, 1.0f);
  float _135 = select(_132, _129, 1.0f);
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _175 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _135, mad((RGBToXYZViaCrosstalkMatrix[0].y), _134, ((RGBToXYZViaCrosstalkMatrix[0].x) * _133)));
      float _178 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _135, mad((RGBToXYZViaCrosstalkMatrix[1].y), _134, ((RGBToXYZViaCrosstalkMatrix[1].x) * _133)));
      float _183 = (_178 + _175) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _135, mad((RGBToXYZViaCrosstalkMatrix[2].y), _134, ((RGBToXYZViaCrosstalkMatrix[2].x) * _133)));
      float _184 = _175 / _183;
      float _185 = _178 / _183;
      do {
        if (_178 < curve_HDRip) {
          _196 = (_178 * exposureScale);
        } else {
          _196 = ((log2((_178 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _198 = (_184 / _185) * _196;
        float _202 = (((1.0f - _184) - _185) / _185) * _196;
        _251 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _202, mad((XYZToRGBViaCrosstalkMatrix[0].y), _196, (_198 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _252 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _202, mad((XYZToRGBViaCrosstalkMatrix[1].y), _196, (_198 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _253 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _202, mad((XYZToRGBViaCrosstalkMatrix[2].y), _196, (_198 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_133 < curve_HDRip) {
          _229 = (exposureScale * _133);
        } else {
          _229 = ((log2((_133 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_134 < curve_HDRip) {
            _240 = (exposureScale * _134);
          } else {
            _240 = ((log2((_134 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_135 < curve_HDRip) {
            _251 = _229;
            _252 = _240;
            _253 = (exposureScale * _135);
          } else {
            _251 = _229;
            _252 = _240;
            _253 = ((log2((_135 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _251 = _133;
    _252 = _134;
    _253 = _135;
  }
  SV_Target.x = _251;
  SV_Target.y = _252;
  SV_Target.z = _253;
  SV_Target.w = 1.0f;
  return SV_Target;
}
