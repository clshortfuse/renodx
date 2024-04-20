// Film Grain

#include "../common/filmgrain.hlsl"
#include "../common/tonemap.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // Render
Texture2D<float4> t1 : register(t1);  // Grain

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb11 : register(b11) {
  float4 cb11[122];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : TEXCOORD0, float4 v2 : COLOR0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1, -1, -0.5, -0.5) + v1.xyyx;
  r0.xy = v1.yx * r0.yx;
  r0.xy = r0.xy * r0.wz;
  r0.xy = r0.xy * cb11[121].xy + v1.xy;  // Distortion?
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r1.x = dot(r0.xyz, float3(0.298038989, 0.588235974, 0.113724999));
  r1.x = -cb11[84].y + r1.x;
  r1.y = cb11[84].z + -cb11[84].y;
  r1.x = saturate(r1.x / r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb11[84].x * r1.x;
  // r1.y = t1.Sample(s0_s, v1.zw).x;
  if (injectedData.toneMapType == 0.f && injectedData.fxFilmGrain) {
    r1.y = t1.Sample(s0_s, v1.zw).x * injectedData.fxFilmGrain;
  } else {
    r1.y = 0;
  }
  r1.x = saturate(-r1.y * r1.x + 1);
  r1.x = 0.5 * r1.x;
  r0.xyz = sqrt(r0.xyz);
  float3 inputColor = r0.xyz;
  // o0.w = r0.w;
  r0.xyz = r0.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r1.yzw = float3(1, 1, 1) + -abs(r0.xyz);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.xyz = v2.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = lerp(inputColor, r0.xyz, injectedData.fxVignette);

  float3 signs = sign(r0.xyz);
  r0.xyz = max(0, cb11[95].xyz * v2.www + abs(r0.xyz));
  r0.rgb = injectedData.toneMapGammaCorrection ? pow(r0.rgb, 2.2f) : linearFromSRGB(r0.rgb);
  r0.rgb *= signs;

  if (injectedData.toneMapType == 0.f) {
    o0.xyz = applyUserColorGrading(
      r0.xyz,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation
    );
  } else {
    float3 outputColor = r0.rgb;

    float vanillaMidGray = 0.18f;
    float renoDRTHighlights = 1.f;
    float renoDRTShadows = 1.f;
    float renoDRTContrast = 1.05f;
    float renoDRTSaturation = 1.05f;
    float renoDRTDechroma = 0.5f;
    float renoDRTFlare = 0.f;

    ToneMapParams tmParams = {
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
    };

    outputColor = toneMap(outputColor, tmParams);

    float3 grainedColor = computeFilmGrain(
      outputColor,
      v1.xy,
      frac(t1.Sample(s0_s, v1.zw).x / 1000.f),
      injectedData.fxFilmGrain * 0.03f,
      1.f
    );
    o0.xyz = grainedColor;
  }

  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  signs = sign(o0.rgb);
  o0.rgb = abs(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 1.f / 2.2f) : srgbFromLinear(o0.rgb);
  o0.rgb *= signs;

  o0.w = r0.w;
  return;
}
