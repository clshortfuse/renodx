#include "./shared.h"

cbuffer cbGlobalsShared : register(b1) {
  uint g_Booleans : packoffset(c0);
  uint g_Flags : packoffset(c0.y);
  float g_AlphaThreshold : packoffset(c0.z);
}

SamplerState s0_s_s : register(s0);
Texture2D<float4> s0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD8,
  float4 v10 : TEXCOORD9,
  float4 v11 : TEXCOORD10,
  float4 v12 : TEXCOORD11,
  float4 v13 : TEXCOORD12,
  float4 v14 : TEXCOORD13,
  float4 v15 : TEXCOORD14,
  float4 v16 : TEXCOORD15,
  float4 v17 : COLOR0,
  float4 v18 : COLOR1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float4 o3 : SV_Target3) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_Flags & 1;
  r0.x = cmp((int)r0.x != 0);
  r1.xyzw = s0.Sample(s0_s_s, v1.xy).xyzw;
  r0.y = -g_AlphaThreshold + r1.w;
  o0.xyzw = r1.xyzw;
  r0.y = cmp(r0.y < 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) discard;

  float vanillaMidGray = 0.18f;

  float renoDRTContrast = 1.00f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.0f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.0f;
  float renoDRTHighlights = 1.0f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      injectedData.toneMapGammaCorrection,  // -1 == srgb
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare);

  o0 = max(0, o0);
  o0 = injectedData.toneMapGammaCorrection
           ? pow(o0, 2.2f)
           : renodx::color::bt709::from::SRGBA(o0);
  o0.rgb = renodx::tonemap::config::Apply(o0.rgb, config);
  o0 = max(0, o0);
  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  o0 = injectedData.toneMapGammaCorrection
           ? pow(o0, 1.f / 2.2f)
           : renodx::color::srgba::from::BT709(o0);

  return;
}