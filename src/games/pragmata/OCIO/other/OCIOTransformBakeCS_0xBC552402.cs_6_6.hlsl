#include "../OCIO.hlsli"

RWTexture3D<float4> OutLUT : register(u0);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _5 = float((uint)SV_DispatchThreadID.x);
  float _6 = float((uint)SV_DispatchThreadID.y);
  float _7 = float((uint)SV_DispatchThreadID.z);
  float _8 = _5 * 0.01587301678955555f;
  float _9 = _6 * 0.01587301678955555f;
  float _10 = _7 * 0.01587301678955555f;
  float _24;
  float _38;
  float _52;
  if (!(!(_8 <= -0.3013699948787689f))) {
    _24 = (exp2((_5 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_8 < 1.468000054359436f) {
      _24 = exp2((_5 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _24 = 65504.0f;
    }
  }
  if (!(!(_9 <= -0.3013699948787689f))) {
    _38 = (exp2((_6 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_9 < 1.468000054359436f) {
      _38 = exp2((_6 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _38 = 65504.0f;
    }
  }
  if (!(!(_10 <= -0.3013699948787689f))) {
    _52 = (exp2((_7 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_10 < 1.468000054359436f) {
      _52 = exp2((_7 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _52 = 65504.0f;
    }
  }

  // _52 = 999.f;
  OutLUT[SV_DispatchThreadID] = float4(mad(_52, 0.047374799847602844f, mad(_38, 0.33951008319854736f, (_24 * 0.6131157279014587f))),
                                       mad(_52, 0.013449129648506641f, mad(_38, 0.9163550138473511f, (_24 * 0.07019715756177902f))),
                                       mad(_52, 0.8698007464408875f, mad(_38, 0.10957999527454376f, (_24 * 0.020619075745344162f))), 1.0f);
}

