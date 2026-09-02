#include "../CBuffers/HDRMapping.hlsli"
#include "../OCIO.hlsli"

Texture2D<float4> tConfigImage : register(t0);

cbuffer RootConstant : register(b0, space32) {
  uint constant32Bits : packoffset(c000.x);
};

// cbuffer HDRMapping : register(b0) {
//   float whitePaperNits : packoffset(c000.x);
//   float configImageAlphaScale : packoffset(c000.y);
//   float displayMaxNits : packoffset(c000.z);
//   float displayMinNits : packoffset(c000.w);
//   float4 displayMaxNitsRect : packoffset(c001.x);
//   float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
//   float4 standardMaxNitsRect : packoffset(c003.x);
//   float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
//   float2 displayMaxNitsRectSize : packoffset(c005.x);
//   float2 standardMaxNitsRectSize : packoffset(c005.z);
//   float4 mdrOutRangeRect : packoffset(c006.x);
//   uint drawMode : packoffset(c007.x);
//   float gammaForHDR : packoffset(c007.y);
//   float displayMaxNitsST2084 : packoffset(c007.z);
//   float displayMinNitsST2084 : packoffset(c007.w);
//   uint drawModeOnMDRPass : packoffset(c008.x);
//   float saturationForHDR : packoffset(c008.y);
//   float2 targetInvSize : packoffset(c008.z);
//   float toeEnd : packoffset(c009.x);
//   float toeStrength : packoffset(c009.y);
//   float blackPoint : packoffset(c009.z);
//   float shoulderStartPoint : packoffset(c009.w);
//   float shoulderStrength : packoffset(c010.x);
//   float whitePaperNitsForOverlay : packoffset(c010.y);
//   float saturationOnDisplayMapping : packoffset(c010.z);
//   float graphScale : packoffset(c010.w);
//   float4 hdrImageRect : packoffset(c011.x);
//   float2 hdrImageRectSize : packoffset(c012.x);
//   float secondaryDisplayMaxNits : packoffset(c012.z);
//   float secondaryDisplayMinNits : packoffset(c012.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
//   float shoulderAngle : packoffset(c014.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
//   float brightnessAdjustmentForOverlay : packoffset(c014.z);
//   float saturateAdjustmentForOverlay : packoffset(c014.w);
// };

SamplerState PointClamp : register(s1, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _11 = tConfigImage.SampleLevel(PointClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  int _22 = constant32Bits & 4;
  float _117;
  float _193;
  float _194;
  float _195;
  if (!((constant32Bits & 2) == 0)) {
    bool _24 = (_22 != 0);
    float _28 = select(_24, (_11.x * 100.0f), 0.0f);
    float _29 = select(_24, (_11.y * 100.0f), 0.0f);
    float _30 = select(_24, (_11.z * 100.0f), 0.0f);
    // BT.709 -> BT.2020
    float _33 = mad(0.04331360012292862f, _30, mad(0.3292819857597351f, _29, (_28 * 0.627403974533081f)));
    float _36 = mad(0.011361200362443924f, _30, mad(0.9195399880409241f, _29, (_28 * 0.06909699738025665f)));
    float _39 = mad(0.8955950140953064f, _30, mad(0.08801320195198059f, _29, (_28 * 0.01639159955084324f)));
    float _62 = 10000.0f / whitePaperNits;
    float _71 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_28 - _33)) + _33) * gammaForHDR) / _62)) * 0.1593017578125f);
    float _83 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_29 - _36)) + _36) * gammaForHDR) / _62)) * 0.1593017578125f);
    float _95 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_30 - _39)) + _39) * gammaForHDR) / _62)) * 0.1593017578125f);
    _193 = (((_95 * 18.8515625f) + 0.8359375f) / ((_95 * 18.6875f) + 1.0f));
    _194 = saturate(exp2(log2(((_71 * 18.8515625f) + 0.8359375f) / ((_71 * 18.6875f) + 1.0f)) * 78.84375f));
    _195 = saturate(exp2(log2(((_83 * 18.8515625f) + 0.8359375f) / ((_83 * 18.6875f) + 1.0f)) * 78.84375f));
  } else {
    bool _104 = (_22 == 0);
    do {
      if (!((constant32Bits & 1) == 0)) {
        if (!_104) {
          _117 = secondaryDisplayMaxNits;
        } else {
          _117 = secondaryDisplayMinNits;
        }
      } else {
        if (!_104) {
          _117 = displayMaxNits;
        } else {
          _117 = displayMinNits;
        }
      }
      float _118 = _117 / whitePaperNits;
      float _119 = _118 * _11.x;
      float _120 = _118 * _11.y;
      float _121 = _118 * _11.z;
      float _124 = mad(0.04331360012292862f, _121, mad(0.3292819857597351f, _120, (_119 * 0.627403974533081f)));
      float _127 = mad(0.011361200362443924f, _121, mad(0.9195399880409241f, _120, (_119 * 0.06909699738025665f)));
      float _130 = mad(0.8955950140953064f, _121, mad(0.08801320195198059f, _120, (_119 * 0.01639159955084324f)));
      float _153 = 10000.0f / whitePaperNits;
      float _162 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_119 - _124)) + _124) * gammaForHDR) / _153)) * 0.1593017578125f);
      float _174 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_120 - _127)) + _127) * gammaForHDR) / _153)) * 0.1593017578125f);
      float _186 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_121 - _130)) + _130) * gammaForHDR) / _153)) * 0.1593017578125f);
      _193 = (((_186 * 18.8515625f) + 0.8359375f) / ((_186 * 18.6875f) + 1.0f));
      _194 = saturate(exp2(log2(((_162 * 18.8515625f) + 0.8359375f) / ((_162 * 18.6875f) + 1.0f)) * 78.84375f));
      _195 = saturate(exp2(log2(((_174 * 18.8515625f) + 0.8359375f) / ((_174 * 18.6875f) + 1.0f)) * 78.84375f));
    } while (false);
  }
  bool _201 = ((_11.w + -9.999999747378752e-05f) < 0.0f);
  if (_201) discard;
  SV_Target.x = _194;
  SV_Target.y = _195;
  SV_Target.z = saturate(pow(_193, 78.84375f));
  SV_Target.w = _11.w;
  return SV_Target;
}
