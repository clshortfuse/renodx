#include "../../shaders/filmgrain.hlsl"
#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

cbuffer GFD_PSCONST_CORRECT : register(b12) {
  float3 colorBalance : packoffset(c0);  // 0,0,0
  float _reserve00 : packoffset(c0.w);   // 0
  float2 colorBlend : packoffset(c1);    // 0.8, 0.9
}

cbuffer GFD_PSCONST_HDR : register(b11) {
  float middleGray : packoffset(c0.x);  // 0.06
  float adaptedLum : packoffset(c0.y);  // 0.0003
  float bloomScale : packoffset(c0.z);  // 1.15
  float starScale : packoffset(c0.w);   // 0
}

SamplerState opaueSampler_s : register(s0);
SamplerState bloomSampler_s : register(s1);
SamplerState brightSampler_s : register(s2);
Texture2D<float4> opaueTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> brightTexture : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;

  // r0.xyz = bloomTexture.Sample(bloomSampler_s, v1.xy).xyz;
  // r0.xyz = bloomScale * r0.xyz;
  r0.rgb = bloomTexture.Sample(bloomSampler_s, v1).rgb * bloomScale * injectedData.fxBloom;

  // r1.xyz = brightTexture.Sample(brightSampler_s, v1.xy).xyz;
  // r1.xyz = bloomScale * r1.xyz;
  r1.rgb = brightTexture.Sample(brightSampler_s, v1).rgb * bloomScale * injectedData.fxBloom;

  // r2.xyz = opaueTexture.Sample(opaueSampler_s, v1.xy).xyz;
  r2.rgb = opaueTexture.Sample(opaueSampler_s, v1).rgb;

  // r3.xyz = r1.xyz + r0.xyz;

  // r0.xyz = r1.xyz * r0.xyz;
  // r0.xyz = -r0.xyz;
  // r0.xyz = r3.xyz + r0.xyz;
  r0.xyz = (r1.xyz + r0.xyz) - (r1.xyz * r0.xyz);

  // r1.xyz = -r1.xyz;
  // r1.xyz = r2.xyz + r1.xyz;
  r1.rgb = r2.rgb - r1.rgb;

  r1.rgb = max(0, r1.rgb);  // Clamp

  // r3.xyz = r1.xyz + r0.xyz;
  // r0.xyz = r1.xyz * r0.xyz;
  // r0.xyz = -r0.xyz;
  // r0.xyz = r3.xyz + r0.xyz;
  r0.rgb = (r1.xyz + r0.xyz) - (r1.xyz + r0.xyz);

  r0.xyz = max(r2.xyz, r0.xyz);  // Only apply if lighter than input

  float3 untonemapped = r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    // r1.w = 1;
    // r0.w = max(r0.x, r0.y);
    // r0.w = max(r0.w, r0.z);
    r0.w = max(r0.x, max(r0.y, r0.z));  // max channel
    float maxChannel = r0.w;

    // r2.x = -r0.w;
    // r2.x = 1 + r2.x;
    r2.x = 1 - r0.w;  // 1-maxchannel

    // r0.xyz = -r0.xyz;
    // r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = 1 - r0.xyz;  //

    // r2.yzw = -r2.xxx;
    // r0.xyz = r2.yzw + r0.xyz;
    r0.xyz = r0.xyz - r2.x;  // remove maxchannel
    r0.xyz = r0.xyz / r0.www;

    float3 vanillaToneMapped = ((1 - untonemapped) - (1 - maxChannel)) / maxChannel;

    r0.xyz = colorBalance.xyz + r0.xyz; // Add to tonemapped
    // r0.xyz = r0.xyz * r0.www; // scale up by max channel
    // r0.xyz = r0.xyz + r2.xxx; // add (1 )
    // r0.xyz = -r0.xyz;
    // r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = 1 - (r0.xyz * r0.w + r2.x);

    // r0.xyz = r0.xyz / colorBlend.x;
    // r0.xyz = -r0.xyz;
    // r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = 1 - (r0.xyz / colorBlend.x);

    // r0.xyz = r0.xyz / colorBlend.y;
    // r0.xyz = -r0.xyz;
    // r1.xyz = float3(1, 1, 1) + r0.xyz;
    r1.xyz = 1 - (r0.xyz / colorBlend.y);

    // r1.xyz = r1.xyz;
    r1.xyz = lerp(untonemapped, r1.xyz, injectedData.colorGradeLUTStrength);

    // Fix Vanilla NaNs
    if (maxChannel == 0) {
      r1.xyz = 0;
    }
    r0.xyz = r1.xyz;
  } else {
    r0.xyz = max(0, untonemapped.xyz);
  }

  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 1.f;
  float renoDRTFlare = 0;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.f;
  float renoDRTSaturation = 1.f;
  float renoDRTHighlights = 1.f;

  ToneMapParams tmParams = buildToneMapParams(
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    injectedData.toneMapGammaCorrection - 1,
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

  o0.rgb = sign(r0.xyz) * pow(abs(r0.xyz), 2.2f);

  o0.rgb = toneMap(o0.rgb, tmParams);

  if (injectedData.colorGradeColorSpace == COLOR_SPACE__BT709) {
    o0.rgb = clampBT709ToBT709(o0.rgb);
  } else if (injectedData.colorGradeColorSpace == COLOR_SPACE__BT2020) {
    o0.rgb = clampBT709ToBT2020(o0.rgb);
  } else if (injectedData.colorGradeColorSpace == COLOR_SPACE__AP1) {
    o0.rgb = clampBT709ToAP1(o0.rgb);
  }

  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 1.f / 2.2f);

  o0.a = 1.f;

  return;
}
