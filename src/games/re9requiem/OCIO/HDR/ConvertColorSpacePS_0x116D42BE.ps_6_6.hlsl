#include "../CBuffers/HDRMapping.hlsli"
#include "../OCIO.hlsli"

Texture2D<float4> inputTexture : register(t0);

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
//   float4 standardMinNitsRect : packoffset(c006.x);
//   float4 secondaryStandardMinNitsRect : packoffset(c007.x);
//   float4 displayMinNitsRect : packoffset(c008.x);
//   float4 secondaryDisplayMinNitsRect : packoffset(c009.x);
//   float4 mdrOutRangeRect : packoffset(c010.x);
//   uint drawMode : packoffset(c011.x);
//   float gammaForHDR : packoffset(c011.y);
//   float displayMaxNitsST2084 : packoffset(c011.z);
//   float displayMinNitsST2084 : packoffset(c011.w);
//   uint drawModeOnMDRPass : packoffset(c012.x);
//   float saturationForHDR : packoffset(c012.y);
//   float2 targetInvSize : packoffset(c012.z);
//   float toeEnd : packoffset(c013.x);
//   float toeStrength : packoffset(c013.y);
//   float blackPoint : packoffset(c013.z);
//   float shoulderStartPoint : packoffset(c013.w);
//   float shoulderStrength : packoffset(c014.x);
//   float whitePaperNitsForOverlay : packoffset(c014.y);
//   float saturationOnDisplayMapping : packoffset(c014.z);
//   float graphScale : packoffset(c014.w);
//   float4 hdrImageRect : packoffset(c015.x);
//   float2 hdrImageRectSize : packoffset(c016.x);
//   float secondaryDisplayMaxNits : packoffset(c016.z);
//   float secondaryDisplayMinNits : packoffset(c016.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c017.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c017.z);
//   float shoulderAngle : packoffset(c018.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c018.y);
//   float brightnessAdjustmentForOverlay : packoffset(c018.z);
//   float saturateAdjustmentForOverlay : packoffset(c018.w);
// };

float4 main(
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float4 _9 = inputTexture.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));

  if (TONE_MAP_TYPE != 0.f) {
    if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
      _9.rgb = renodx::color::correct::GammaSafe(_9.rgb);
    }
  }
  float _18 = mad(0.04331360012292862f, _9.z, mad(0.3292819857597351f, _9.y, (_9.x * 0.627403974533081f)));
  float _21 = mad(0.011361200362443924f, _9.z, mad(0.9195399880409241f, _9.y, (_9.x * 0.06909699738025665f)));
  float _24 = mad(0.8955950140953064f, _9.z, mad(0.08801320195198059f, _9.y, (_9.x * 0.01639159955084324f)));
  float _47 = 10000.0f / whitePaperNitsForOverlay;
  float _56 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.x - _18)) + _18) * gammaForHDR) / _47)) * 0.1593017578125f);
  float _65 = saturate(exp2(log2(((_56 * 18.8515625f) + 0.8359375f) / ((_56 * 18.6875f) + 1.0f)) * 78.84375f));
  float _68 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.y - _21)) + _21) * gammaForHDR) / _47)) * 0.1593017578125f);
  float _77 = saturate(exp2(log2(((_68 * 18.8515625f) + 0.8359375f) / ((_68 * 18.6875f) + 1.0f)) * 78.84375f));
  float _80 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_9.z - _24)) + _24) * gammaForHDR) / _47)) * 0.1593017578125f);
  float _89 = saturate(exp2(log2(((_80 * 18.8515625f) + 0.8359375f) / ((_80 * 18.6875f) + 1.0f)) * 78.84375f));
  float _155;
  float _156;
  float _157;
  if (!((drawMode & 2) == 0)) {
    float _101 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _110 = saturate(exp2(log2(((_101 * 18.8515625f) + 0.8359375f) / ((_101 * 18.6875f) + 1.0f)) * 78.84375f));
    float _116 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _126 = _110 - saturate(exp2(log2(((_116 * 18.8515625f) + 0.8359375f) / ((_116 * 18.6875f) + 1.0f)) * 78.84375f));
    float _130 = saturate(_65 / _110);
    float _131 = saturate(_77 / _110);
    float _132 = saturate(_89 / _110);
    _155 = min((((((_130 * -2.0f) + 2.0f) * _126) + (_130 * _110)) * _130), _65);
    _156 = min((((((_131 * -2.0f) + 2.0f) * _126) + (_131 * _110)) * _131), _77);
    _157 = min((((((_132 * -2.0f) + 2.0f) * _126) + (_132 * _110)) * _132), _89);
  } else {
    _155 = _65;
    _156 = _77;
    _157 = _89;
  }
  SV_Target.x = _155;
  SV_Target.y = _156;
  SV_Target.z = _157;
  SV_Target.w = _9.w;
  return SV_Target;
}
