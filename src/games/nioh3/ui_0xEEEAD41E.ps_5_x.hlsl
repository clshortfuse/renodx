#include "./common.hlsl"

// UI shader (1)
// Removing the sliders and tonemapping to 1 with smoothclamp
// Todo: Add slider to game to allow color grading on UI

Texture2D<float4> sStage0 : register(t0);

cbuffer Globals : register(b0) {
  float SaturationScale : packoffset(c000.x);
  float Gamma : packoffset(c000.y);
  int ContrastValuesOfTexture[3] : packoffset(c001.x);
  float vATest : packoffset(c003.y);
};

SamplerState __smpsStage0 : register(s0);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float4 TEXCOORD: TEXCOORD,
            linear float2 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _10 = sStage0.Sample(__smpsStage0, float2(TEXCOORD_1.x, TEXCOORD_1.y));

  float _32;
  float _33;
  float _34;
  float _79;
  float _80;
  float _81;
  float _100;
  float _101;
  float _102;
  if (!(Gamma == 1.0f) && false) {
    _32 = exp2(log2(abs(_10.x)) * Gamma);
    _33 = exp2(log2(abs(_10.y)) * Gamma);
    _34 = exp2(log2(abs(_10.z)) * Gamma);
  } else {
    _32 = _10.x;
    _33 = _10.y;
    _34 = _10.z;
  }
  if (!(((uint)(ContrastValuesOfTexture[0])) == 0) && false) {
    if ((int)((uint)(ContrastValuesOfTexture[0])) > (int)0) {
      float _48 = (exp2(log2(abs(float((uint)(ContrastValuesOfTexture[0])) * 0.007874015718698502f)) * 3.0303030014038086f) * 7.0f) + 1.0f;
      _79 = saturate((_48 * (_32 + -0.5f)) + 0.5f);
      _80 = saturate((_48 * (_33 + -0.5f)) + 0.5f);
      _81 = saturate((_48 * (_34 + -0.5f)) + 0.5f);
    } else {
      float _65 = 1.0f - (abs(float((uint)(ContrastValuesOfTexture[0]))) * 0.007874015718698502f);
      _79 = saturate((_65 * (_32 + -0.5f)) + 0.5f);
      _80 = saturate((_65 * (_33 + -0.5f)) + 0.5f);
      _81 = saturate((_65 * (_34 + -0.5f)) + 0.5f);
    }
  } else {
    _79 = _32;
    _80 = _33;
    _81 = _34;
  }
  float _82 = _79 * TEXCOORD.x;
  float _83 = _80 * TEXCOORD.y;
  float _84 = _81 * TEXCOORD.z;
  float _85 = _10.w * TEXCOORD.w;
  if (!(SaturationScale == 1.0f) && false) {
    float _89 = dot(
        float3(_82, _83, _84),
        float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f));
    _100 = (lerp(_89, _82, SaturationScale));
    _101 = (lerp(_89, _83, SaturationScale));
    _102 = (lerp(_89, _84, SaturationScale));
  } else {
    _100 = _82;
    _101 = _83;
    _102 = _84;
  }
  if (_85 < vATest) {
    if (true)
      discard;
  }
  SV_Target.x = _100;
  SV_Target.y = _101;
  SV_Target.z = _102;
  SV_Target.w = _85;

  return SV_Target;
}
