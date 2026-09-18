#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 19:34:09 2026
// RenoDX HDR-safe fog/composite pass feeding LUT t0
// Uses common.hlsl gamma functions.
// SDR path keeps vanilla clamp behavior.
// HDR path preserves values above 1.0.

cbuffer VolumetricFogConstantscb : register(b2)
{
  struct
  {
    float4x4 m_ViewToWorldMatrix;
    float4 m_ReverseProjectionParams1;
    float4 m_ReverseProjectionParams2;
    float m_CurrentTime;
    float m_DeltaTime;
    float m_StartDistance;
    float3 m_EyePosition;
    float3 m_EyeXAxis;
    float3 m_EyeYAxis;
    float3 m_EyeZAxis;
    float m_Distance;
    float ScatteringDistribution;
    float m_VerticalFalloffHeight;
    float m_NoiseFrequency;
    float m_NoiseIntensity;
    float m_ApplyExponent;
    float m_Falloff;
    float m_FogValue;
    float3 m_FogColor;
    float3 m_FogColorSunOpposite;
    float3 m_FogColorAmbient;
    float3 m_SunDirection;
    float3 m_FogReferenceTranslation;
    int m_PointLightsNum;
    float4 m_WorldLightmapParameters;
    float4 m_WorldLightmapParameters2;
    float4 m_WorldLightmapParameters3;
    float4 m_WorldLightmapUVParameters;
    float4 m_PointLightsPositions[16];
    float4 m_PointLightsColors[16];
    float4 m_LinearZConstants;
  } g_VolumetricFogConstants : packoffset(c0);
}

SamplerState pointSampler_s : register(s0);
SamplerState linearSampler_s : register(s1);

Texture2D<float4> InputTexture2D : register(t1);
Texture2D<float4> FogMaskTexture : register(t3);

#define cmp -

#ifndef RENODX_HDR_FOG_STRENGTH
#define RENODX_HDR_FOG_STRENGTH 1.0f
#endif

float3 ApplyFogCompositeLinear(float3 inputLinear, float3 fogLinear, float fogAmount)
{
  fogAmount = saturate(fogAmount) * RENODX_HDR_FOG_STRENGTH;
  fogAmount = saturate(fogAmount);

  float3 color = lerp(inputLinear, fogLinear, fogAmount);

  return max(color, 0.0f);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float3 inputGamma = InputTexture2D.SampleLevel(pointSampler_s, v1.xy, 0).xyz;
  float3 fogLinear = FogMaskTexture.SampleLevel(linearSampler_s, v1.xy, 0).xyz;
  float fogAmount = saturate(g_VolumetricFogConstants.m_FogValue);

  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    float3 inputSDRGamma = saturate(inputGamma);

    float3 inputLinear = renodx::color::gamma::DecodeSafe(inputSDRGamma);
    float3 fogSDRLinear = saturate(fogLinear);

    float3 outputLinear = saturate(lerp(inputLinear, fogSDRLinear, fogAmount));

    o0.xyz = renodx::color::gamma::EncodeSafe(outputLinear);
    o0.w = 1.0f;
    return;
  }

  float3 inputLinearHDR = renodx::color::gamma::DecodeSafe(max(inputGamma, 0.0f));
  float3 fogLinearHDR = max(fogLinear, 0.0f);

  float3 outputLinearHDR = ApplyFogCompositeLinear(
    inputLinearHDR,
    fogLinearHDR,
    fogAmount
  );

  o0.xyz = renodx::color::gamma::EncodeSafe(max(outputLinearHDR, 0.0f));
  o0.w = 1.0f;
  return;
}