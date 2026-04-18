#include "../../common.hlsli"
#include "../CBuffers/HDRMapping.hlsli"

Texture2D<float4> SrcTexture : register(t0);

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

SamplerState PointBorder : register(s2, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _15 = whitePaperNits * 0.009999999776482582f;
  float _16 = _15 * _9.x;
  float _17 = _15 * _9.y;
  float _18 = _15 * _9.z;
  float _21 = mad(_18, 0.047374799847602844f, mad(_17, 0.33951008319854736f, (_16 * 0.6131157279014587f)));
  float _24 = mad(_18, 0.013449129648506641f, mad(_17, 0.9163550138473511f, (_16 * 0.07019715756177902f)));
  float _27 = mad(_18, 0.8698007464408875f, mad(_17, 0.10957999527454376f, (_16 * 0.020619075745344162f)));
  float _92;
  float _93;
  float _94;
  if (!((drawMode & 2) == 0)) {
    float _38 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _47 = saturate(exp2(log2(((_38 * 18.8515625f) + 0.8359375f) / ((_38 * 18.6875f) + 1.0f)) * 78.84375f));
    float _53 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _63 = _47 - saturate(exp2(log2(((_53 * 18.8515625f) + 0.8359375f) / ((_53 * 18.6875f) + 1.0f)) * 78.84375f));
    float _67 = saturate(_21 / _47);
    float _68 = saturate(_24 / _47);
    float _69 = saturate(_27 / _47);
    _92 = min((((((_67 * -2.0f) + 2.0f) * _63) + (_67 * _47)) * _67), _21);
    _93 = min((((((_68 * -2.0f) + 2.0f) * _63) + (_68 * _47)) * _68), _24);
    _94 = min((((((_69 * -2.0f) + 2.0f) * _63) + (_69 * _47)) * _69), _27);
  } else {
    _92 = _21;
    _93 = _24;
    _94 = _27;
  }
  SV_Target.x = _92;
  SV_Target.y = _93;
  SV_Target.z = _94;
  SV_Target.w = 1.0f;

  // SV_Target = 0;

  return SV_Target;
}

