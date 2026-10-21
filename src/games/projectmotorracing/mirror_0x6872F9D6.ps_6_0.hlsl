#include "./common.hlsl"

Texture2D<float4> overlayTexture : register(t0);

SamplerState overlaySampler : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _9 = TEXCOORD_1.x * 1.5f;
  float _10 = TEXCOORD_1.y * 1.5f;
  uint2 _11; overlayTexture.GetDimensions(_11.x, _11.y);
  float _16 = 1.5f / float((uint)_11.x);
  float _17 = 1.5f / float((uint)_11.y);
  float4 _18 = overlayTexture.SampleLevel(overlaySampler, float2(_9, _10), 0.0f);
  float _22 = _16 * 0.5f;
  float _23 = _17 * 0.5f;
  float _24 = _9 - _22;
  float _25 = _10 - _23;
  float4 _26 = overlayTexture.SampleLevel(overlaySampler, float2(_24, _25), 0.0f);
  float _30 = _22 + _9;
  float4 _31 = overlayTexture.SampleLevel(overlaySampler, float2(_30, _25), 0.0f);
  float _35 = _23 + _10;
  float4 _36 = overlayTexture.SampleLevel(overlaySampler, float2(_24, _35), 0.0f);
  float4 _40 = overlayTexture.SampleLevel(overlaySampler, float2(_30, _35), 0.0f);
  float _44 = dot(float3(_18.x, _18.y, _18.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _45 = dot(float3(_26.x, _26.y, _26.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _46 = dot(float3(_31.x, _31.y, _31.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _47 = dot(float3(_36.x, _36.y, _36.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _48 = dot(float3(_40.x, _40.y, _40.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _49 = _46 + _45;
  float _51 = (_47 - _49) + _48;
  float _54 = ((_45 - _46) + _47) - _48;
  float _63 = 1.0f / (min(abs(_51), abs(_54)) + max((((_49 + _47) + _48) * 0.0625f), 0.0026041667442768812f));
  float _70 = min(max((_63 * _51), -12.0f), 12.0f) * _16;
  float _71 = min(max((_63 * _54), -12.0f), 12.0f) * _17;
  float _72 = _70 * 0.1666666716337204f;
  float _73 = _71 * 0.1666666716337204f;
  float4 _76 = overlayTexture.SampleLevel(overlaySampler, float2((_9 - _72), (_10 - _73)), 0.0f);
  float4 _83 = overlayTexture.SampleLevel(overlaySampler, float2((_72 + _9), (_73 + _10)), 0.0f);
  float _88 = _83.x + _76.x;
  float _89 = _83.y + _76.y;
  float _90 = _83.z + _76.z;
  float _91 = _83.w + _76.w;
  float _96 = _70 * 0.5f;
  float _97 = _71 * 0.5f;
  float4 _100 = overlayTexture.SampleLevel(overlaySampler, float2((_9 - _96), (_10 - _97)), 0.0f);
  float4 _107 = overlayTexture.SampleLevel(overlaySampler, float2((_96 + _9), (_97 + _10)), 0.0f);
  float _114 = ((_100.x + _88) + _107.x) * 0.25f;
  float _117 = ((_100.y + _89) + _107.y) * 0.25f;
  float _120 = ((_100.z + _90) + _107.z) * 0.25f;
  float _132 = dot(float3(_114, _117, _120), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _135 = (bool)(_132 < min(_44, min(min(_45, _46), min(_47, _48)))) || (bool)(_132 > max(_44, max(max(_45, _46), max(_47, _48))));
  SV_Target.x = (select(_135, (_88 * 0.5f), _114) * TEXCOORD.x);
  SV_Target.y = (select(_135, (_89 * 0.5f), _117) * TEXCOORD.y);
  SV_Target.z = (select(_135, (_90 * 0.5f), _120) * TEXCOORD.z);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    SV_Target.rgb = ApplyCustomGrade1(SV_Target.rgb);
    SV_Target.rgb = ApplyCustomGrade2(SV_Target.rgb);
    SV_Target.rgb = N2PerChannelLMS(SV_Target.rgb);
  } else {
    SV_Target.rgb = saturate(SV_Target.rgb);
  }
  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);

  // SV_Target.w = (select(_135, (_91 * 0.5f), (((_100.w + _91) + _107.w) * 0.25f)) * TEXCOORD.w);
  SV_Target.w = 1.f;
  
  return SV_Target;
}
