#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

cbuffer RGCParamCB : register(b0) {
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

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _15 = mad(_9.z, 0.047374799847602844f, mad(_9.y, 0.33951008319854736f, (_9.x * 0.6131157279014587f)));
  float _18 = mad(_9.z, 0.013449129648506641f, mad(_9.y, 0.9163550138473511f, (_9.x * 0.07019715756177902f)));
  float _21 = mad(_9.z, 0.8698007464408875f, mad(_9.y, 0.10957999527454376f, (_9.x * 0.020619075745344162f)));
  float _58;
  float _79;
  float _99;
  float _107;
  float _108;
  float _109;
  if (!(rgcParam.EnableReferenceGamutCompress == 0)) {
    float _27 = max(max(_15, _18), _21);
    if (!(_27 == 0.0f)) {
      float _33 = abs(_27);
      float _34 = (_27 - _15) / _33;
      float _35 = (_27 - _18) / _33;
      float _36 = (_27 - _21) / _33;
      do {
        if (!(!(_34 >= rgcParam.CyanThreshold))) {
          float _46 = _34 - rgcParam.CyanThreshold;
          _58 = ((_46 / exp2(log2(exp2(log2(rgcParam.InvCyanSTerm * _46) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.CyanThreshold);
        } else {
          _58 = _34;
        }
        do {
          if (!(!(_35 >= rgcParam.MagentaThreshold))) {
            float _67 = _35 - rgcParam.MagentaThreshold;
            _79 = ((_67 / exp2(log2(exp2(log2(rgcParam.InvMagentaSTerm * _67) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.MagentaThreshold);
          } else {
            _79 = _35;
          }
          do {
            if (!(!(_36 >= rgcParam.YellowThreshold))) {
              float _87 = _36 - rgcParam.YellowThreshold;
              _99 = ((_87 / exp2(log2(exp2(log2(rgcParam.InvYellowSTerm * _87) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.YellowThreshold);
            } else {
              _99 = _36;
            }
            _107 = (_27 - (_58 * _33));
            _108 = (_27 - (_79 * _33));
            _109 = (_27 - (_99 * _33));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _107 = _15;
      _108 = _18;
      _109 = _21;
    }
  } else {
    _107 = _15;
    _108 = _18;
    _109 = _21;
  }
  SV_Target.x = _107;
  SV_Target.y = _108;
  SV_Target.z = _109;
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


