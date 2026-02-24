#include "../../common.hlsli"
#include "../CBuffers/HDRMapping.hlsli"

RWTexture3D<float4> OutLUT : register(u0);

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _7 = float((uint)SV_DispatchThreadID.x);
  float _8 = float((uint)SV_DispatchThreadID.y);
  float _9 = float((uint)SV_DispatchThreadID.z);
  float _10 = _7 * 0.01587301678955555f;
  float _11 = _8 * 0.01587301678955555f;
  float _12 = _9 * 0.01587301678955555f;
  float _26;
  float _40;
  float _54;
  float _129;
  float _130;
  float _131;
  if (!(!(_10 <= -0.3013699948787689f))) {
    _26 = (exp2((_7 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_10 < 1.468000054359436f) {
      _26 = exp2((_7 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _26 = 65504.0f;
    }
  }
  if (!(!(_11 <= -0.3013699948787689f))) {
    _40 = (exp2((_8 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_11 < 1.468000054359436f) {
      _40 = exp2((_8 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _40 = 65504.0f;
    }
  }
  if (!(!(_12 <= -0.3013699948787689f))) {
    _54 = (exp2((_9 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_12 < 1.468000054359436f) {
      _54 = exp2((_9 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _54 = 65504.0f;
    }
  }
  float _57 = mad(_54, 0.047374799847602844f, mad(_40, 0.33951008319854736f, (_26 * 0.6131157279014587f)));
  float _60 = mad(_54, 0.013449129648506641f, mad(_40, 0.9163550138473511f, (_26 * 0.07019715756177902f)));
  float _63 = mad(_54, 0.8698007464408875f, mad(_40, 0.10957999527454376f, (_26 * 0.020619075745344162f)));
  if (!((drawMode & 2) == 0)) {
    float _75 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _84 = saturate(exp2(log2(((_75 * 18.8515625f) + 0.8359375f) / ((_75 * 18.6875f) + 1.0f)) * 78.84375f));
    float _90 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _100 = _84 - saturate(exp2(log2(((_90 * 18.8515625f) + 0.8359375f) / ((_90 * 18.6875f) + 1.0f)) * 78.84375f));
    float _104 = saturate(_57 / _84);
    float _105 = saturate(_60 / _84);
    float _106 = saturate(_63 / _84);
    _129 = min((((((_104 * -2.0f) + 2.0f) * _100) + (_104 * _84)) * _104), _57);
    _130 = min((((((_105 * -2.0f) + 2.0f) * _100) + (_105 * _84)) * _105), _60);
    _131 = min((((((_106 * -2.0f) + 2.0f) * _100) + (_106 * _84)) * _106), _63);
  } else {
    _129 = _57;
    _130 = _60;
    _131 = _63;
  }

  // _131 = 99999.f;

  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(_129, _130, _131, 1.0f);
}

