#include "../../shaders/tonemap.hlsl"
#include "../../shaders/filmgrain.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:50 2024
Texture3D<float4> t6 : register(t6);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t4 : register(t4);

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;


  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  //r0.xyz = log2(r0.xyz);

  float vanillaMidGray = toneMapCurve(0.18, 0.30f, 0.50f, 0.10f, 0.20f, 0.02f, 0.30f)
                       / toneMapCurve(5.6f, 0.30f, 0.50f, 0.10f, 0.20f, 0.02f, 0.30f);
  float renoDRTContrast = 1.5f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.2f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.1f;
  float renoDRTHighlights = 1.0f;

  ToneMapParams tmParams = {
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    injectedData.toneMapGammaCorrection,  // LUT output was in 2.2
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

  ToneMapLUTParams lutParams = buildLUTParams(
    s3_s,
    injectedData.colorGradeLUTStrength,
    injectedData.colorGradeLUTScaling,  // Cleans up raised black floor
    TONE_MAP_LUT_TYPE__LINEAR
    TONE_MAP_LUT_TYPE__2_2,
    16
  );

  float3 outputColor = r0.rgb;
  if (injectedData.colorGradeLUTStrength == 0.f || tmParams.type == 1.f) {
    outputColor = toneMap(outputColor, tmParams);
  } else {
    float3 hdrColor;
    float3 sdrColor;
    if (tmParams.type == 3.f) {
      tmParams.renoDRTSaturation *= tmParams.saturation;

      sdrColor = renoDRTToneMap(outputColor, tmParams, true);

      tmParams.renoDRTHighlights *= tmParams.highlights;
      tmParams.renoDRTShadows *= tmParams.shadows;
      tmParams.renoDRTContrast *= tmParams.contrast;

      hdrColor = renoDRTToneMap(outputColor, tmParams);

    } else {
      outputColor = applyUserColorGrading(
        outputColor,
        tmParams.exposure,
        tmParams.highlights,
        tmParams.shadows,
        tmParams.contrast,
        tmParams.saturation
      );

      if (tmParams.type == 2.f) {
        hdrColor = acesToneMap(outputColor, tmParams);
        sdrColor = acesToneMap(outputColor, tmParams, true);
      } else {
        hdrColor = saturate(outputColor);
        sdrColor = saturate(outputColor);
      }
    }

    //r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
    //r0.xyz = exp2(r0.xyz);
    r1.xyz = r0.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);

    r0.xyz = sdrColor;    
    //r2.xyz = t3.Sample(s3_s, r1.xyz).xyz;
    r2.xyz = sampleLUT(r1.xyz, lutParams, t3);

    r2.xyz = cb2[0].xxx * r2.xyz;
    r0.xyz = r0.xyz * cb2[1].xxx + r2.xyz;
    o0.w = r0.w;

    //r2.xyz = t4.Sample(s4_s, r1.xyz).xyz;
    lutParams.lutSampler = s4_s;
    r2.xyz = sampleLUT(r0.xyz, lutParams, t4);

    r0.xyz = r2.xyz * cb2[0].yyy + r0.xyz;
    
    //r2.xyz = t5.Sample(s5_s, r1.xyz).xyz;
    lutParams.lutSampler = s5_s;
    r2.xyz = sampleLUT(r1.xyz, lutParams, t5);
    
    //r1.xyz = t6.Sample(s6_s, r1.xyz).xyz;
    lutParams.lutSampler = s6_s;
    r1.xyz = sampleLUT(r1.xyz, lutParams, t6);

    r0.xyz = r2.xyz * cb2[0].zzz + r0.xyz;
    float3 lutColor = r1.xyz * cb2[0].www + r0.xyz;


    if (tmParams.type == 0.f) {
      outputColor = lerp(outputColor, lutColor, lutParams.strength);
    } else {
      outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, lutParams.strength);
    }
  }
  o0.rgb = outputColor;
  if (injectedData.fxFilmGrain) {
    float3 grainedColor = computeFilmGrain(
      o0.rgb,
      v1.xy,
      frac(injectedData.elapsedTime / 1000.f),
      injectedData.fxFilmGrain * 0.03f,
      1.f
    );
    o0.xyz = grainedColor;
  }

  if (injectedData.toneMapGammaCorrection) {
    o0.rgb = gammaCorrectSafe(o0.rgb);
  }

  o0.rgb *= injectedData.toneMapGameNits / 80.f;
  return;
}