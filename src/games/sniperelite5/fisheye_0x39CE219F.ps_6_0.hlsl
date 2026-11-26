#include "./shared.h"
Texture2D<float4> g_xSceneTexture : register(t2);

Texture2D<float4> g_xMaskTexture : register(t3);

cbuffer FishEyePSConstants : register(b11) {
  float4 g_xScale : packoffset(c000.x);
  float g_fFOV : packoffset(c001.x);
  float g_fMult : packoffset(c001.y);
  float g_fOneOverTanFOV : packoffset(c001.z);
  float g_fSinHalfFOV : packoffset(c001.w);
  float g_fTanHalfFOV : packoffset(c002.x);
};

SamplerState g_xBilinearWrap : register(s2);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _13 = g_xScale.x * TEXCOORD.z;
  float _14 = g_xScale.y * TEXCOORD.w;
  float _15 = _13 * _13;
  float _16 = _14 * _14;
  float _17 = _15 + _16;
  float _18 = sqrt(_17);
  float _21 = g_fSinHalfFOV * _18;
  float _22 = asin(RENODX_TONE_MAP_TYPE == 0.f ? _21 : clamp(_21, -1.f, 1.f));
  float _23 = _22 * 2.0f;
  float _24 = tan(_23);
  float _26 = g_fOneOverTanFOV * _24;
  float _27 = _26 / (RENODX_TONE_MAP_TYPE == 0.f ? _18 : max(_18, 1e-6f));
  float _28 = _27 * _13;
  float _29 = _27 * _14;
  float4 _32 = g_xMaskTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _34 = _32.w * g_fMult;
  float _35 = _28 - _13;
  float _36 = _29 - _14;
  float _37 = _34 * _35;
  float _38 = _34 * _36;
  float _39 = _37 + _13;
  float _40 = _38 + _14;
  float _44 = g_xScale.z * 0.7071067690849304f;
  float _45 = _44 * _39;
  float _46 = g_xScale.w * 0.7071067690849304f;
  float _47 = _46 * _40;
  float _48 = _45 + 0.5f;
  float _49 = _47 + 0.5f;
  float4 _50 = g_xSceneTexture.Sample(g_xBilinearWrap, float2(_48, _49));
  SV_Target.x = _50.x;
  SV_Target.y = _50.y;
  SV_Target.z = _50.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
