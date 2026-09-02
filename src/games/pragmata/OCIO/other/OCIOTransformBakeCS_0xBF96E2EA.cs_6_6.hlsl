#include "../OCIO.hlsli"

RWTexture3D<float4> OutLUT : register(u0);

cbuffer OutputColorAdjustment : register(b0) {
  float fGamma : packoffset(c000.x);
  float fLowerLimit : packoffset(c000.y);
  float fUpperLimit : packoffset(c000.z);
  float fConvertToLimit : packoffset(c000.w);
  float4 fConfigDrawRect : packoffset(c001.x);
  float4 fSecondaryConfigDrawRect : packoffset(c002.x);
  float2 fConfigDrawRectSize : packoffset(c003.x);
  float2 fSecondaryConfigDrawRectSize : packoffset(c003.z);
  uint uConfigMode : packoffset(c004.x);
  float fConfigImageIntensity : packoffset(c004.y);
  float fSecondaryConfigImageIntensity : packoffset(c004.z);
  float fConfigImageAlphaScale : packoffset(c004.w);
  float fGammaForOverlay : packoffset(c005.x);
  float fLowerLimitForOverlay : packoffset(c005.y);
  float fConvertToLimitForOverlay : packoffset(c005.z);
};

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

  // _54 = 9999.f;
  OutLUT[SV_DispatchThreadID] = float4(((exp2(log2(mad(_54, 0.047374799847602844f, mad(_40, 0.33951008319854736f, (_26 * 0.6131157279014587f)))) * fGamma) * fConvertToLimit) + fLowerLimit),
                                       ((exp2(log2(mad(_54, 0.013449129648506641f, mad(_40, 0.9163550138473511f, (_26 * 0.07019715756177902f)))) * fGamma) * fConvertToLimit) + fLowerLimit),
                                       ((exp2(log2(mad(_54, 0.8698007464408875f, mad(_40, 0.10957999527454376f, (_26 * 0.020619075745344162f)))) * fGamma) * fConvertToLimit) + fLowerLimit), 1.0f);
}

