// Game Render + LUT + Noise

#include "../../shaders/color.hlsl"
#include "../../shaders/colorgrade.hlsl"
#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, float4 v3 : TEXCOORD2, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].zw * v1.xy;
  r0.x = dot(float2(171, 231), r0.xy);
  r0.xyz = float3(0.00970873795, 0.0140845068, 0.010309278) * r0.xxx;
  r0.xyz = frac(r0.xyz);
  r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
  r0.xyz = float3(0.00392156886, 0.00392156886, 0.00392156886) * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  // r0.xyz = saturate(r1.xyz * cb0[6].yyy + r0.xyz);
  r0.xyz = (r1.xyz * cb0[6].yyy + r0.xyz * injectedData.fxNoise);

  float3 untonemapped = r0.rgb;

  float vanillaMidGray = 0.18f;

  float renoDRTContrast = 1.1f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.05f;
  float renoDRTHighlights = 1.f;

  ToneMapParams tmParams = buildToneMapParams(
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    0,
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
    renoDRTFlare
  );

  LUTParams lutParams = buildLUTParams(
    s1_s,
    injectedData.colorGradeLUTStrength,
    injectedData.colorGradeLUTScaling,
    TONE_MAP_LUT_TYPE__SRGB,
    TONE_MAP_LUT_TYPE__SRGB,
    32.f
  );

  if (injectedData.toneMapType == 0.f) {
    untonemapped = saturate(untonemapped);
  }

  untonemapped = max(0, linearFromSRGB(untonemapped));

  float3 outputColor = toneMap(untonemapped, tmParams, lutParams, t1);

  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);

  o0.rgb = outputColor.rgb;
  return;
}
